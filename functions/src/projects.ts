import * as functions from "firebase-functions";

// eslint-disable-next-line @typescript-eslint/no-var-requires
const firebaseTools = require("firebase-tools");

import {adminApp} from "./adminApp";

import {
  BASE_DOCUMENT_NAME,
  cloudRegions,
  getNewPostFirestorePayload,
  PROJECTS_COLLECTION_NAME,
  PROJECT_STATISTICS_COLLECTION_NAME,
} from "./utils";

const firestore = adminApp.firestore();
const storage = adminApp.storage();

/**
 * Event triggered when a project document is created in Firestore.
 * Create associated storage file (post.md)
 * and populate the Firestore document with all properties.
 * Create collection statistics too.
 */
export const onCreate = functions
    .region(cloudRegions.eu)
    .firestore
    .document("projects/{projectId}")
    .onCreate(async (snapshot) => {
      const data = snapshot.data();
      const userId: string = data.user_id;

      const storagePath = `projects/${snapshot.id}/post.md`;

      const projectFile = storage
          .bucket()
          .file(storagePath);

      const initialContent = "This is my awesome project...";

      // Save new file to firebase storage.
      await projectFile.save(initialContent, {
        metadata: {
          contentType: "text/markdown; charset=UTF-8",
          metadata: {
            character_count: "0",
            document_id: snapshot.id,
            document_type: "post",
            extension: "md",
            related_document_type: "project",
            user_id: userId,
            visibility: "private",
            word_count: "0",
          },
        },
      });

      // Update firestore document.
      await snapshot.ref.update(getNewPostFirestorePayload({
        initialContent,
        storagePath,
      }));

      await createStatsCollection(snapshot.id, userId);
    });

/**
 * Event triggered when a project document is deleted from Firestore.
 * Delete associated storage files (e.g. post.md, covver images).
 */
export const onDelete = functions
    .region(cloudRegions.eu)
    .firestore
    .document("projects/{projectId}")
    .onDelete(async (snapshot) => {
      // Try to clean firestore subcollections if any.
      await firebaseTools.firestore
          .delete(`projects/${snapshot.id}`, {
            force: true,
            project: process.env.GCLOUD_PROJECT,
            recursive: true,
            yes: true,
          });

      // Delete files from Cloud Storage
      await deleteProjectFiles({
        documentId: snapshot.id,
        includePost: true,
      });

      return true;
    });

/**
 * Event triggered when a document is updated in "projects" collection.
 *
 * • If the `updated_at` field has been updated,
 * we exit the function as we probably just updated it (recursive call).
 *
 * • If `visibility` field has changed, update the associated
 * file storage (post.md).
 *
 * • If `cover.storage_path` has changed and is empty, we deleted the cover.
 * Thus, delete the associated storage images.
 *
 * Update `updated_at` field at least, and other cover fields if applicable.
 */
export const onUpdate = functions
    .region(cloudRegions.eu)
    .firestore
    .document("projects/{projectId}")
    .onUpdate(async (snapshot) => {
      const beforeProjectData = snapshot.before.data();
      const afterProjectData = snapshot.after.data();

      const beforeUpdateAt: FirebaseFirestore.Timestamp =
        beforeProjectData.updated_at;

      const afterUpdateAt: FirebaseFirestore.Timestamp =
          afterProjectData.updated_at;

      if (!beforeUpdateAt.isEqual(afterUpdateAt)) {
        return true;
      }

      let updatePayload = {
        updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
      };

      if (beforeProjectData.visibility !== afterProjectData.visibility) {
        const postStoragePath: string = afterProjectData.storage_path;
        const projectFile = storage
            .bucket()
            .file(postStoragePath);

        const exists = await projectFile.exists();
        if (exists) {
          const [metadata] = await projectFile.getMetadata();
          if (metadata && metadata.metadata) {
            metadata.metadata.visibility = afterProjectData.visibility;
            await projectFile.setMetadata(metadata);
          }
        }
      }

      const beforeStoragePath = beforeProjectData.cover.storage_path;
      const afterStoragePath = afterProjectData.cover.storage_path;

      // Handle remove project cover.
      if (beforeStoragePath !== afterStoragePath && !afterStoragePath) {
        await deleteProjectFiles({
          documentId: snapshot.after.id,
        });

        updatePayload = {...updatePayload, ...{
          cover: {
            dimensions: {
              width: 0,
              height: 0,
            },
            extension: "",
            original_url: "",
            size: 0,
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
        }};
      }

      await firestore.collection("projects")
          .doc(snapshot.after.id)
          .update(updatePayload);

      return true;
    });

// -----------------
// HELPER FUNCTIONS
// -----------------

/**
 * Create project's stats sub-collection
 * @param {string} projectId Project's id.
 * @param {string} userId User's id.
 * @return {void} void.
 */
async function createStatsCollection(projectId: string, userId: string) {
  const snapshot = await firestore
      .collection(PROJECTS_COLLECTION_NAME)
      .doc(projectId)
      .get();

  if (!snapshot.exists) {
    return;
  }

  await snapshot.ref
      .collection(PROJECT_STATISTICS_COLLECTION_NAME)
      .doc(BASE_DOCUMENT_NAME)
      .create({
        created_at: adminApp.firestore.FieldValue.serverTimestamp(),
        project_id: projectId,
        likes: 0,
        shares: 0,
        views: 0,
        user_id: userId,
        updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
      });
}

/**
 * Helper to delete a project's files from Storage (eg. cover, post).
 * @param {string} param0 Id of the document.
 * @return {boolean} Return true if everything went well.
 */
async function deleteProjectFiles({
  documentId,
  includePost,
}: DeleteCoverFilesParams) {
  // Delete files from Cloud Storage
  const bucket = adminApp.storage().bucket();

  // Delete /project/cover folder first if any.
  await bucket.deleteFiles({
    force: true,
    prefix: `projects/${documentId}/cover`,
  });

  // Delete /project/images folder first if any.
  await bucket.deleteFiles({
    force: true,
    prefix: `projects/${documentId}/images`,
  });

  if (includePost) {
    // Delete project's files (eg. posts).
    await bucket.deleteFiles({
      force: true,
      prefix: `projects/${documentId}`,
    });
  }

  return true;
}
