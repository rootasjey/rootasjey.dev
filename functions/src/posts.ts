import * as functions from "firebase-functions";
import {adminApp} from "./adminApp";
import {
  BASE_DOCUMENT_NAME,
  cloudRegions,
  getNewPostFirestorePayload,
  POSTS_COLLECTION_NAME,
  POST_STATISTICS_COLLECTION_NAME,
} from "./utils";

// eslint-disable-next-line @typescript-eslint/no-var-requires
const firebaseTools = require("firebase-tools");

const firestore = adminApp.firestore();
const storage = adminApp.storage();

/**
 * Event triggered when a post document is created in Firestore.
 * Create associated storage file (post.md)
 * and populate the Firestore document with all properties.
 * Create collection statistics too.
 */
export const onCreate = functions
    .region(cloudRegions.eu)
    .firestore
    .document("posts/{postId}")
    .onCreate(async (snapshot) => {
      const data = snapshot.data();
      const userId: string = data.user_id;

      const storagePath = `posts/${snapshot.id}/post.md`;

      const postFile = storage
          .bucket()
          .file(storagePath);

      const initialContent = "Once upon a time...";

      // Save new file to firebase storage.
      await postFile.save(initialContent, {
        metadata: {
          contentType: "text/markdown; charset=UTF-8",
          metadata: {
            character_count: "0",
            document_id: snapshot.id,
            document_type: "post",
            extension: "md",
            related_document_type: "post",
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
 * Event triggered when a post document is deleted from Firestore.
 * Delete associated storage files (e.g. post.md, covver images).
 */
export const onDelete = functions
    .region(cloudRegions.eu)
    .firestore
    .document("posts/{postId}")
    .onDelete(async (snapshot) => {
      // Try to clean firestore subcollections if any.
      await firebaseTools.firestore
          .delete(`posts/${snapshot.id}`, {
            force: true,
            project: process.env.GCLOUD_PROJECT,
            recursive: true,
            yes: true,
          });

      // Delete files from Cloud Storage
      await deletePostFiles({
        documentId: snapshot.id,
        includePost: true,
      });

      return true;
    });

/**
 * Event triggered when a document is updated in "post" collection.
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
    .document("posts/{postId}")
    .onUpdate(async (snapshot) => {
      const beforePostData = snapshot.before.data();
      const afterPostData = snapshot.after.data();

      const beforeUpdateAt: FirebaseFirestore.Timestamp =
          beforePostData.updated_at;

      const afterUpdateAt: FirebaseFirestore.Timestamp =
          afterPostData.updated_at;

      if (!beforeUpdateAt.isEqual(afterUpdateAt)) {
        return true;
      }

      let updatePayload = {
        updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
      };

      if (beforePostData.visibility !== afterPostData.visibility) {
        const postStoragePath: string = afterPostData.storage_path;
        const postFile = storage
            .bucket()
            .file(postStoragePath);

        const exists = await postFile.exists();
        if (exists) {
          const [metadata] = await postFile.getMetadata();
          if (metadata && metadata.metadata) {
            metadata.metadata.visibility = afterPostData.visibility;
            await postFile.setMetadata(metadata);
          }
        }
      }

      const beforeStoragePath = beforePostData.cover.storage_path;
      const afterStoragePath = afterPostData.cover.storage_path;

      // Handle remove post cover.
      if (beforeStoragePath !== afterStoragePath && !afterStoragePath) {
        await deletePostFiles({
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

      await firestore.collection("posts")
          .doc(snapshot.after.id)
          .update(updatePayload);

      return true;
    });

// -----------------
// HELPER FUNCTIONS
// -----------------

/**
 * Create post's stats sub-collection
 * @param {string} postId Post's id.
 * @param {string} userId User's id.
 * @return {void} void.
 */
async function createStatsCollection(postId: string, userId: string) {
  const snapshot = await firestore
      .collection(POSTS_COLLECTION_NAME)
      .doc(postId)
      .get();

  if (!snapshot.exists) {
    return;
  }

  await snapshot.ref
      .collection(POST_STATISTICS_COLLECTION_NAME)
      .doc(BASE_DOCUMENT_NAME)
      .create({
        created_at: adminApp.firestore.FieldValue.serverTimestamp(),
        post_id: postId,
        likes: 0,
        shares: 0,
        views: 0,
        user_id: userId,
        updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
      });
}

/**
 * Helper to delete a post's files from Storage (eg. cover, post).
 * @param {string} param0 Id of the document.
 * @return {boolean} Return true if everything went well.
 */
async function deletePostFiles({
  documentId,
  includePost,
}: DeleteCoverFilesParams) {
  // Delete files from Cloud Storage
  const bucket = adminApp.storage().bucket();

  // Delete /post/cover folder first if any.
  await bucket.deleteFiles({
    force: true,
    prefix: `posts/${documentId}/cover`,
  });

  // Delete /post/images folder first if any.
  await bucket.deleteFiles({
    force: true,
    prefix: `posts/${documentId}/images`,
  });

  if (includePost) {
    // Delete post's files (eg. posts).
    await bucket.deleteFiles({
      force: true,
      prefix: `posts/${documentId}`,
    });
  }

  return true;
}
