import {Storage} from "@google-cloud/storage";
import * as functions from "firebase-functions";

import * as fs from "fs-extra";
import sizeOf = require("image-size");
import {tmpdir} from "os";
import {join, dirname} from "path";
import * as sharp from "sharp";

import {
  cloudRegions, createPersistentDownloadUrl, USERS_COLLECTION_NAME,
} from "./utils";

import {adminApp} from "./adminApp";
import {ISizeCalculationResult} from "image-size/dist/types/interface";
const firestore = adminApp.firestore();

const gcs = new Storage();

/**
 * Handle image file creation.
 * On storage file creation, generate thumbnails.
 * Then populate Firestore document with various data as thumbnail links,
 * storage path, extension.
 */
export const onCreate = functions
    .runWith({
      memory: "2GB",
      timeoutSeconds: 180,
    })
    .region(cloudRegions.eu)
    .storage
    .object()
    .onFinalize(async (objectMetadata) => {
      const customMetadata = objectMetadata.metadata;
      if (!customMetadata) {
        return;
      }

      const {
        character_count,
        document_id: documentId,
        document_type: documentType,
        related_document_type: relatedDocumentType,
        visibility,
        word_count,
      } = customMetadata;

      // If this a post, update metrics in firestore.
      if (documentType === "post") {
        const documentSnapshot = await firestore
            .collection(`${relatedDocumentType}s`)
            .doc(documentId)
            .get();

        if (!documentSnapshot.exists) {
          return;
        }

        await documentSnapshot.ref.update({
          character_count,
          size: parseFloat(objectMetadata.size),
          updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
          word_count,
        });

        return true;
      }

      if (documentType === "user_profile_picture") {
        return await setUserProfilePicture(objectMetadata);
      }

      // We only handle cover here or illustration upload
      // -> thumbnail generation.
      if ((documentType !== "cover" && documentType !== "illustration") ||
          !documentId) {
        return;
      }

      const filePath = objectMetadata.name || "";
      const fileName = filePath.split("/").pop() || "";
      const storagePath = filePath;

      // Exit if already a thumbnail or is not an image file.
      const contentType = objectMetadata.contentType || "";
      if (fileName.includes("thumb@") || !contentType.includes("image")) {
        return;
      }

      const documentSnapshot = await firestore
          .collection(`${relatedDocumentType}s`)
          .doc(documentId)
          .get();

      if (!documentSnapshot.exists) {
        functions.logger.error(`
          Firestore document ${relatedDocumentType}s/${documentId} 
          does not exist`
        );

        throw new functions.https.HttpsError(
            "not-found",
            `Firestore document ${relatedDocumentType}s/${documentId} 
            does not exist.`
        );
      }

      const imageFile = adminApp.storage()
          .bucket()
          .file(storagePath);

      if (!await imageFile.exists()) {
        functions.logger.error(`File ${filePath} does not exist`);
        return;
      }

      // -> Start to process the image file.
      if (visibility === "public") {
        await imageFile.makePublic();
      }

      const extension = objectMetadata.metadata?.extension ||
        fileName.substring(fileName.lastIndexOf("."));

      // Generate thumbnails
      // -------------------
      const {dimensions, thumbnails} = await generateImageThumbs({
        documentId,
        extension,
        fileName,
        filePath,
        objectMeta: objectMetadata,
        visibility,
      });
      functions.logger.info(
          "Generated thumbnails for: ",
          documentId
      );

      const {height, width} = dimensions;

      const downloadToken = objectMetadata.metadata
        ?.firebaseStorageDownloadTokens ?? "";

      const firebaseDownloadUrl = createPersistentDownloadUrl(
          objectMetadata.bucket,
          filePath,
          downloadToken,
      );

      // Set original file dimensions.
      imageFile.setMetadata({
        metadata: {
          ...objectMetadata.metadata,
          ...{
            height,
            width,
          },
        },
      });

      let payload = {};

      if (documentType === "illustration") {
        functions.logger.info(
            "Will set illusttration thumbnails for: ",
            documentId
        );

        payload = {
          dimensions: {
            height,
            width,
          },
          extension,
          links: {
            illustration_id: documentId,
            original_url: firebaseDownloadUrl,
            storage_path: storagePath,
            thumbnails,
          },
          size: parseFloat(objectMetadata.size),
          updated_at: adminApp.firestore.Timestamp.now(),
        };
      } else if (documentType === "cover") {
        payload = {
          cover: {
            dimensions: {
              width,
              height,
            },
            extension,
            original_url: firebaseDownloadUrl,
            size: parseFloat(objectMetadata.size),
            storage_path: storagePath,
            thumbnails,
          },
          updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
        };
      }

      await documentSnapshot.ref.update(payload);
      functions.logger.info(
          "Did set illusttration thumbnails for: ",
          documentId
      );
      functions.logger.info(
          "info for: ",
          documentId,
          JSON.stringify(payload)
      );
      return true;
    });

/**
 * Create several thumbnails from an original file.
 * @param {Object} params Object conaining file's metadata.
 */
async function generateImageThumbs(
    params: GenerateImageThumbsParams
): Promise<GenerateImageThumbsResult> {
  const {
    documentId,
    extension,
    fileName,
    filePath,
    objectMeta,
    visibility,
  } = params;

  const thumbnails: ThumbnailLinks = {
    xs: "",
    s: "",
    m: "",
    l: "",
    xl: "",
    xxl: "",
  };

  const thumbnailSizes = {
    xs: 360,
    s: 480,
    m: 720,
    l: 1024,
    xl: 1920,
    xxl: 2400,
  };

  const allowedExt = ["jpg", "jpeg", "png", "webp", "tiff"];

  if (!allowedExt.includes(extension)) {
    return {
      dimensions: {
        height: 0,
        width: 0,
      },
      thumbnails,
    };
  }

  const bucket = gcs.bucket(objectMeta.bucket);
  const bucketDir = dirname(filePath);

  const workingDir = join(tmpdir(), documentId, "thumbs");
  const tmpFilePath = join(workingDir, fileName);

  // 1. Ensure thumbnail directory exists.
  await fs.ensureDir(workingDir);

  // 2. Download source file.
  await bucket.file(filePath).download({
    destination: tmpFilePath,
  });

  // 2.1. Try calculate dimensions.
  let dimensions: ISizeCalculationResult = {height: 0, width: 0};

  try {
    dimensions = sizeOf.imageSize(tmpFilePath);
  } catch (error) {
    console.error(error);
  }

  // 3. Resize the images and define an array of upload promises.
  const uploadPromises = Object.entries(thumbnailSizes)
      .map(async ([sizeName, size]) => {
        const thumbName = `thumb@${sizeName}.${extension}`;
        const thumbPath = join(workingDir, thumbName);

        // Resize source image.
        const outputInfo = await sharp(tmpFilePath)
            .resize(size, undefined, {withoutEnlargement: true, fit: "inside"})
            .toFile(thumbPath);

        return bucket.upload(thumbPath, {
          destination: join(bucketDir, thumbName),
          metadata: {
            metadata: {...objectMeta.metadata, ...{
              height: outputInfo.height,
              width: outputInfo.width,
            }},
          },
          public: visibility === "public",
        });
      });

  // 4. Run the upload operations.
  const uploadResponses = await Promise.all(uploadPromises);

  // 5. Clean up the tmp/thumbs from file system.
  await fs.emptyDir(workingDir);
  await fs.remove(workingDir);

  // 6. Retrieve thumbnail urls.
  for await (const upResp of uploadResponses) {
    const upFile = upResp[0];
    let key = upFile.name.split("/").pop() || "";
    key = key.substring(0, key.lastIndexOf(".")).replace("thumb@", "");

    const metadataResponse = await upFile.getMetadata();
    const metadata = metadataResponse[0];

    const downloadToken = metadata.metadata
      ?.firebaseStorageDownloadTokens ?? "";

    const firebaseDownloadUrl = createPersistentDownloadUrl(
        objectMeta.bucket,
        upFile.name,
        downloadToken,
    );

    thumbnails[key] = firebaseDownloadUrl;
  }

  return {dimensions, thumbnails};
}

/**
 * Update user's `profilePicture` field with newly upload image.
 * @param {functions.storage.ObjectMetadata} objectMeta
 * @return {Promise} Promise
 */
async function setUserProfilePicture(
    objectMeta: functions.storage.ObjectMetadata
) {
  const filepath = objectMeta.name || "";
  const filename = filepath.split("/").pop() || "";
  const storageUrl = filepath;

  const endIndex: number = filepath.indexOf("/profile");
  const userId = filepath.substring(6, endIndex);

  if (!userId) {
    throw new functions.https.HttpsError(
        "not-found",
        `We didn't find the target user: ${userId}.`
    );
  }

  // Exit if not an image file.
  const contentType = objectMeta.contentType || "";
  if (!contentType.includes("image")) {
    functions.logger.info(
        `Exiting function => existing image or non-file image: ${filepath}`
    );

    return;
  }

  const imageFile = adminApp.storage()
      .bucket()
      .file(storageUrl);

  if (!await imageFile.exists()) {
    throw new functions.https.HttpsError(
        "not-found",
        `This file doesn't not exist. 
        filename: ${filename} | filepath: ${filepath}.`
    );
  }

  await imageFile.makePublic();
  const extension = objectMeta.metadata?.extension ||
    filename.substring(filename.lastIndexOf(".")).replace(".", "");

  const downloadToken =
    objectMeta.metadata?.firebaseStorageDownloadTokens ?? "";

  const firebaseDownloadUrl = createPersistentDownloadUrl(
      objectMeta.bucket,
      filepath,
      downloadToken,
  );

  const dimensions: ISizeCalculationResult = await getDimensionsFromStorage(
      objectMeta,
      filename,
      filepath,
  );

  const directoryPath = `users/${userId}/profile/picture/`;
  await cleanProfilePictureDir(directoryPath, filepath);

  return await adminApp.firestore()
      .collection(USERS_COLLECTION_NAME)
      .doc(userId)
      .update({
        profile_picture: {
          dimensions: {
            height: dimensions.height ?? 0,
            width: dimensions.width ?? 0,
          },
          extension,
          links: {
            edited: "",
            original: firebaseDownloadUrl,
            storage: storageUrl,
          },
          size: parseFloat(objectMeta.size),
          type: dimensions.type ?? "",
          updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
        },
      });
}

/**
 * Clean profile picture directory (from Cloud Storage).
 * @param {string} directoryPath Directory to clean.
 * @param {string} filePathToKeep File's path to NOT delete.
 */
/**
 * Remove all files in a directory except for a specified file.
 * @param {string} directoryPath - Directory to clean.
 * @param {string} filePathToKeep - File's path to NOT delete.
 */
async function cleanProfilePictureDir(
    directoryPath: string,
    filePathToKeep: string) {
  const files = await adminApp.storage().bucket().getFiles({
    prefix: directoryPath,
  });

  for await (const file of files[0]) {
    if (file.name !== filePathToKeep) {
      await file.delete();
    }
  }
}

/**
 * Calculate image dimensions.
 * @param {functions.storage.ObjectMetadata} objectMeta Storage object uploaded.
 * @param {qtring} filename File's name.
 * @param {qtring} filepath File's path.
 * @return {ISizeCalculationResult} Return image dimensions.
 */
async function getDimensionsFromStorage(
    objectMeta: functions.storage.ObjectMetadata,
    filename: string,
    filepath: string,
) {
  const bucket = gcs.bucket(objectMeta.bucket);

  const workingDir = join(tmpdir(), "thumbs");
  const tmpFilePath = join(workingDir, filename);

  // 1. Ensure directory exists.
  await fs.ensureDir(workingDir);

  // 2. Download source file.
  await bucket.file(filepath).download({
    destination: tmpFilePath,
  });

  // 2.1. Try calculate dimensions.
  let dimensions: ISizeCalculationResult = {height: 0, width: 0};

  try {
    dimensions = sizeOf.imageSize(tmpFilePath);
  } catch (error) {
    console.error(error);
  }

  // 5. Clean up the tmp/thumbs from file system.
  await fs.emptyDir(workingDir);
  await fs.remove(workingDir);

  return dimensions;
}
