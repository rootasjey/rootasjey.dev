import {Storage} from "@google-cloud/storage";
import * as functions from "firebase-functions";

import * as fs from "fs-extra";
import sizeOf = require("image-size");
import {tmpdir} from "os";
import {join, dirname} from "path";
import * as sharp from "sharp";

import {
  cloudRegions,
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

      // We only handle cover here -> thumbnail generation
      if (documentType !== "cover" || !documentId) {
        return;
      }

      const filePath = objectMetadata.name || "";
      const fileName = filePath.split("/").pop() || "";
      const storageUrl = filePath;

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
        return;
      }

      const imageFile = adminApp.storage()
          .bucket()
          .file(storageUrl);

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
        extension,
        fileName,
        filePath,
        objectMeta: objectMetadata,
        visibility,
      });

      const {height, width} = dimensions;

      const downloadToken = objectMetadata.metadata
        ?.firebaseStorageDownloadTokens ?? "";

      const firebaseDownloadUrl = createPersistentDownloadUrl(
          objectMetadata.bucket,
          filePath,
          downloadToken,
      );

      await documentSnapshot.ref
          .update({
            cover: {
              dimensions: {
                width,
                height,
              },
              extension,
              original_url: firebaseDownloadUrl,
              size: parseFloat(objectMetadata.size),
              storage_path: storageUrl,
              thumbnails,
            },
            updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
          });

      return true;
    });

/**
 * Generate a long lived persistant Firebase Storage download URL.
 * @param {String} bucket Bucket name.
 * @param {String} pathToFile File's path.
 * @param {String} downloadToken File's download token.
 * @return {String} Firebase Storage download url.
 */
const createPersistentDownloadUrl = (
    bucket: string,
    pathToFile: string,
    downloadToken: string,
) => {
  return `https://firebasestorage.googleapis.com/v0/b/${bucket}/o/${encodeURIComponent(
      pathToFile
  )}?alt=media&token=${downloadToken}`;
};

/**
 * Create several thumbnails from an original file.
 * @param {Object} params Object conaining file's metadata.
 */
async function generateImageThumbs(
    params: GenerateImageThumbsParams
): Promise<GenerateImageThumbsResult> {
  const {
    objectMeta,
    extension,
    fileName,
    filePath,
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

  const workingDir = join(tmpdir(), "thumbs");
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
        await sharp(tmpFilePath)
            .resize(size, size, {withoutEnlargement: true})
            .toFile(thumbPath);

        return bucket.upload(thumbPath, {
          destination: join(bucketDir, thumbName),
          metadata: {
            metadata: objectMeta.metadata,
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
