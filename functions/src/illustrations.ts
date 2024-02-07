import * as functions from "firebase-functions";

import {adminApp} from "./adminApp";
import {
  BASE_DOCUMENT_NAME,
  cloudRegions,
  ILLUSTRATIONS_COLLECTION_NAME,
  ILLUSTRATIONS_DOCUMENT_NAME,
  ILLUSTRATION_STATISTICS_COLLECTION_NAME,
  STATISTICS_COLLECTION_NAME,
  createPersistentDownloadUrl,
} from "./utils";

import {ISizeCalculationResult} from "image-size/dist/types/interface";

// eslint-disable-next-line @typescript-eslint/no-var-requires
const firebaseTools = require("firebase-tools");
const firestore = adminApp.firestore();

const ILLUSTRATION_DOC_PATH = "illustrations/{illustration_id}";

/**
 * Return a signed URL to download an illustration.
 * It expires after 5 min.
 **/
export const getSignedUrl = functions
    .region(cloudRegions.eu)
    .https
    .onCall(async (params: OperationIllustrationParams, context) => {
      const {illustration_id: illustrationId} = params;
      const userAuth = context.auth;

      if (typeof illustrationId !== "string") {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The function must be called with 
         a valid [illustration_id] argument (string)
         which is the illustration's id to delete.`,
        );
      }

      const illustrationSnap = await firestore
          .collection(ILLUSTRATIONS_COLLECTION_NAME)
          .doc(illustrationId)
          .get();

      const illustrationData = illustrationSnap.data();
      if (!illustrationSnap.exists || !illustrationData) {
        throw new functions.https.HttpsError(
            "not-found",
            `The illustration id [${illustrationId}] doesn't exist.`,
        );
      }

      if (illustrationData.visibility !== "public") {
        console.log("illustration not public");
        if (!userAuth) {
          throw new functions.https.HttpsError(
              "unauthenticated",
              "The function must be called from an authenticated user.",
          );
        }

        if (illustrationData.user_id !== userAuth.uid) {
          throw new functions.https.HttpsError(
              "permission-denied",
              "You don't have the permission to edit this illustration.",
          );
        }
      }

      const storagePath: string = illustrationData.links.storage;
      const bucket = adminApp.storage().bucket();

      const [url] = await bucket
          .file(storagePath)
          .getSignedUrl({
            version: "v4",
            action: "read",
            expires: Date.now() + 1000 * 60 * 5, // 5 minutes
          });

      return {
        success: true,
        url,
      };
    });

/**
 * Fix illustration Firestore metadata.
 * Populate firestore document properties:
 * - links
 * - dimensions
 */
export const fixMetadata = functions
    .region(cloudRegions.eu)
    .https
    .onCall(async (params: OperationIllustrationParams, context) => {
      const {illustration_id: illustrationId} = params;
      const userAuth = context.auth;

      if (typeof illustrationId !== "string") {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The function must be called with 
         a valid [illustration_id] argument (string)
         which is the illustration's id to delete.`,
        );
      }

      const illustrationSnap = await firestore
          .collection(ILLUSTRATIONS_COLLECTION_NAME)
          .doc(illustrationId)
          .get();

      const illustrationData = illustrationSnap.data();
      if (!illustrationSnap.exists || !illustrationData) {
        throw new functions.https.HttpsError(
            "not-found",
            `The illustration id [${illustrationId}] doesn't exist.`,
        );
      }

      if (illustrationData.visibility !== "public") {
        console.log("illustration not public");
        if (!userAuth) {
          throw new functions.https.HttpsError(
              "unauthenticated",
              "The function must be called from an authenticated user.",
          );
        }

        if (illustrationData.user_id !== userAuth.uid) {
          throw new functions.https.HttpsError(
              "permission-denied",
              "You don't have the permission to edit this illustration.",
          );
        }
      }

      const bucket = adminApp.storage().bucket();
      const baseStoragePath = `illustrations/${illustrationId}`;
      // eslint-disable-next-line max-len
      const originalStoragePath = `${baseStoragePath}/original.${illustrationData.extension}`;

      const originalFile = bucket.file(originalStoragePath);
      const originalDownloadToken = originalFile.metadata?.metadata
        ?.firebaseStorageDownloadTokens ?? "";

      const originalUrl = createPersistentDownloadUrl(
          bucket.name,
          originalStoragePath,
          originalDownloadToken,
      );

      const thumbnailMap: {[key: string]: string} = {
        l: "",
        m: "",
        s: "",
        xl: "",
        xs: "",
        xxl: "",
      };

      const fileResponse = await bucket.getFiles({
        prefix: baseStoragePath + "/",
      });

      const files = fileResponse[0];
      if (!files || files.length === 0) {
        throw new functions.https.HttpsError(
            "not-found",
            `The illustration id [${illustrationId}] doesn't exist.`,
        );
      }

      for await (const file of files) {
        let key = file.name.split("/").pop() || "";
        key = key.substring(0, key.lastIndexOf(".")).replace("thumb@", "");

        const metadataResponse = await file.getMetadata();
        const metadata = metadataResponse[0];

        const downloadToken = metadata.metadata
          ?.firebaseStorageDownloadTokens ?? "";

        const firebaseDownloadUrl = createPersistentDownloadUrl(
            bucket.name,
            file.name,
            downloadToken,
        );

        thumbnailMap[key] = firebaseDownloadUrl;
      }

      functions.logger.info(
          "(illustration) fix metadata (firestore): ",
          illustrationId,
      );
      let dimensions: ISizeCalculationResult = {height: 0, width: 0};
      const fileMeta = originalFile.metadata.metadata;

      if (fileMeta && fileMeta.width) {
        dimensions = {
          width: parseFloat(fileMeta.width),
          height: parseFloat(fileMeta.height),
        };
      }

      await illustrationSnap.ref
          .update({...illustrationData, ...{
            dimensions,
            links: {
              storage_path: originalStoragePath,
              thumbnails: thumbnailMap,
              original_url: originalUrl,
            },
            size: parseFloat(originalFile.metadata.size?.toString() ?? "0"),
          }});

      return {
        illustrationId,
        success: true,
      };
    });

/**
 * Event triggered when an illustration document is created in Firestore.
 * Populate illustration document after it's been created.
 * Create collection statistics too.
 */
export const onCreate = functions
    .region(cloudRegions.eu)
    .firestore
    .document(ILLUSTRATION_DOC_PATH)
    .onCreate(async (snapshot) => {
      // eslint-disable-next-line camelcase
      const user_custom_index: number = await getNextIllustrationIndex();

      const payload = {
        art_movements: {},
        created_at: adminApp.firestore.Timestamp.now(),
        description: "",
        dimensions: {
          height: 0,
          width: 0,
        },
        license: {
          id: "",
          type: "",
        },
        links: {
          original_url: "",
          share: {
            read: "",
            write: "",
          },
          storage_path: "",
          thumbnails: {
            xs: "",
            s: "",
            m: "",
            l: "",
            xl: "",
            xxl: "",
          },
        },
        lore: "",
        pegi: {
          content_descriptors: {
            bad_language: false,
            discrimination: false,
            drug: false,
            fear: false,
            sex: false,
            violence: false,
          },
          rating: -1,
          updated_at: adminApp.firestore.Timestamp.now(),
          user_id: "",
        },
        size: 0, // File's ize in bytes
        topics: {},
        updated_at: adminApp.firestore.Timestamp.now(),
        user_custom_index,
        version: 0,
      };

      const existingData = snapshot.data();
      functions.logger.info(
          "(illustration) Document creation (initial fields): ",
          snapshot.id,
          JSON.stringify(existingData),
      );
      await firestore
          .collection(ILLUSTRATIONS_COLLECTION_NAME)
          .doc(snapshot.id)
          .update({...payload, ...existingData});

      await createStatsCollection(snapshot.id);
    });

/**
 * Event triggered when an illustration document is deleted from Firestore.
 * Delete associated storage files (e.g. post.md, covver images).
 */
export const onDelete = functions
    .region(cloudRegions.eu)
    .firestore
    .document(ILLUSTRATION_DOC_PATH)
    .onDelete(async (snapshot) => {
      // Delete files from Cloud Storage
      const bucket = adminApp.storage().bucket();

      // Delete /post/cover folder first if any.
      await bucket.deleteFiles({
        force: true,
        prefix: `illustrations/${snapshot.id}/`,
      });


      // Delete firestore doc + sub-collection.
      // Try to clean firestore subcollections if any.
      await firebaseTools.firestore
          .delete(`illustrations/${snapshot.id}`, {
            force: true,
            project: process.env.GCLOUD_PROJECT,
            recursive: true,
            yes: true,
          });
    });

/**
 * Event handler on illustration doc updates.
 * Check if visibility has been updated to a more restricted value
 * (e.g. from another value than `public`).
 * If so, force `firebaseStorageDownloadTokens` regeneration for security issue.
 *
 * (cf.: https://www.sentinelstand.com/article/guide-to-firebase-storage-download-urls-tokens)
 *
 * (cf.: https://github.com/googleapis/nodejs-storage/issues/697#issuecomment-610603232)
 **/
export const onVisibilityUpdate = functions
    .region(cloudRegions.eu)
    .firestore
    .document(ILLUSTRATION_DOC_PATH)
    .onUpdate(async (snapshot) => {
      const beforeData = snapshot.before.data();
      const afterData = snapshot.after.data();

      if (beforeData.visibility === afterData.visibility) {
        return;
      }

      if (afterData.visibility === "public") {
        return;
      }

      // Force Firebase/GCP to regenerate download token.
      const storagePath: string = afterData.links.storage_path;
      const bucket = adminApp.storage().bucket();

      await bucket
          .file(storagePath)
          .setMetadata({
            metadata: {
              // Delete the download token.
              // A new one will be generated
              // when attempting to download the illustration.
              firebaseStorageDownloadTokens: "",
            },
          });
    });

// ----------------
// Helper functions
// ----------------


/**
 * Create illustration's stats sub-collection
 * @param {string} illustrationId Illustration's id.
 * @return {void}.
 */
async function createStatsCollection(illustrationId: string) {
  const snapshot = await firestore
      .collection(ILLUSTRATIONS_COLLECTION_NAME)
      .doc(illustrationId)
      .get();

  if (!snapshot.exists) {
    return;
  }

  await snapshot.ref
      .collection(ILLUSTRATION_STATISTICS_COLLECTION_NAME)
      .doc(BASE_DOCUMENT_NAME)
      .create({
        downloads: 0,
        illustration_id: illustrationId,
        likes: 0,
        shares: 0,
        views: 0,
        user_id: "",
        updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
      });
}

/**
 * Return next usable index order for uploaded illustration.
 * @return {number} Next usable index.
 */
async function getNextIllustrationIndex() {
  const snapshot = await firestore
      .collection(STATISTICS_COLLECTION_NAME)
      .doc(ILLUSTRATIONS_DOCUMENT_NAME)
      .get();

  const data = snapshot.data();
  if (!snapshot.exists || !data) {
    return 0;
  }

  let created: number = data.created ?? 0;
  created = typeof created === "number" ? created + 1 : 0;
  return created;
}
