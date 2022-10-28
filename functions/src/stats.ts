import * as functions from "firebase-functions";
import {adminApp} from "./adminApp";
import {
  cloudRegions,
  ILLUSTRATIONS_DOCUMENT_NAME,
  POSTS_COLLECTION_NAME,
  PROJECTS_COLLECTION_NAME,
  STATISTICS_COLLECTION_NAME,
  USERS_COLLECTION_NAME,
  USER_DOCUMENT_NAME,
  USER_STATISTICS_COLLECTION_NAME,
} from "./utils";

const firestore = adminApp.firestore();

const ILLUSTRATION_DOC_PATH = "illustrations/{illustration_id}";
const POST_DOC_PATH = "posts/{postId}";

// --------------
// Illustrations
// --------------
export const onCreateIllustrations = functions
    .region(cloudRegions.eu)
    .firestore
    .document(ILLUSTRATION_DOC_PATH)
    .onCreate(async (snapshot) => {
      const statsSnapshot = await firestore
          .collection(STATISTICS_COLLECTION_NAME)
          .doc(ILLUSTRATIONS_DOCUMENT_NAME)
          .get();


      const data = snapshot.data();
      if (!snapshot.exists || !data) {
        return;
      }

      let created: number = data.created ?? 0;
      created = typeof created === "number" ? created + 1 : 1;

      statsSnapshot.ref.update({
        created,
      });
    });

export const onDeleteIllustrations = functions
    .region(cloudRegions.eu)
    .firestore
    .document(ILLUSTRATION_DOC_PATH)
    .onDelete(async (snapshot) => {
      const statsSnapshot = await firestore
          .collection(STATISTICS_COLLECTION_NAME)
          .doc(ILLUSTRATIONS_DOCUMENT_NAME)
          .get();


      const data = snapshot.data();
      if (!snapshot.exists || !data) {
        return;
      }

      let deleted: number = data.created ?? 0;
      deleted = typeof deleted === "number" ? deleted + 1 : 1;

      statsSnapshot.ref.update({
        deleted,
      });
    });

// -----
// Posts
// -----
export const onCreatePost = functions
    .region(cloudRegions.eu)
    .firestore
    .document(POST_DOC_PATH)
    .onCreate(
        async (postSnapshot: functions.firestore.QueryDocumentSnapshot) => {
          const postData = postSnapshot.data();
          const language: "en" | "fr" = postData.language ?? "en";

          await _updateStats({
            language,
            documentName: POSTS_COLLECTION_NAME,
            operationType: "create",
          });

          await _updateUserStats({
            language,
            userId: postData.user_id,
            documentName: POSTS_COLLECTION_NAME,
            operationType: "create",
          });

          return true;
        });

export const onDeletePost = functions
    .region(cloudRegions.eu)
    .firestore
    .document(POST_DOC_PATH)
    .onDelete(
        async (postSnapshot: functions.firestore.QueryDocumentSnapshot) => {
          const postData = postSnapshot.data();
          const language: "en" | "fr" = postData.language ?? "en";

          await _updateStats({
            language,
            documentName: POSTS_COLLECTION_NAME,
            operationType: "delete",
          });

          await _updateUserStats({
            language,
            userId: postData.user_id,
            documentName: POSTS_COLLECTION_NAME,
            operationType: "delete",
          });

          return true;
        });

export const onUpdatePost = functions
    .region(cloudRegions.eu)
    .firestore
    .document(POST_DOC_PATH)
    .onUpdate(async (postSnapshot) => {
      const beforePostData = postSnapshot.before.data();
      const afterPostData = postSnapshot.after.data();

      if (beforePostData.visibility !== afterPostData.visibility) {
        const language: "en" | "fr" = afterPostData.language ?? "en";

        await _updateStats({
          language,
          documentName: POSTS_COLLECTION_NAME,
          operationType: "update",
          updateType: "visibility",
          visibility: afterPostData.visibility,
        });

        await _updateUserStats({
          language,
          userId: afterPostData.user_id,
          documentName: POSTS_COLLECTION_NAME,
          operationType: "update",
          updateType: "visibility",
          visibility: afterPostData.visibility,
        });
      }

      if (beforePostData.language !== afterPostData.language) {
        const prevLanguage: "en" | "fr" = beforePostData.language ?? "en";
        const language: "en" | "fr" = afterPostData.language ?? "en";

        await _updateStats({
          language,
          documentName: POSTS_COLLECTION_NAME,
          operationType: "update",
          prevLanguage,
          updateType: "language",
          visibility: afterPostData.visibility,
        });

        await _updateUserStats({
          language,
          userId: afterPostData.user_id,
          documentName: POSTS_COLLECTION_NAME,
          operationType: "update",
          updateType: "language",
          visibility: afterPostData.visibility,
        });
      }

      return true;
    });

// --------
// Projects
// --------
export const onCreateProject = functions
    .region(cloudRegions.eu)
    .firestore
    .document("projects/{projectId}")
    .onCreate(async (snapshot) => {
      const projectData = snapshot.data();
      const language: "en" | "fr" = projectData.lang ?? "en";

      await _updateStats({
        language,
        documentName: PROJECTS_COLLECTION_NAME,
        operationType: "create",
      });

      await _updateUserStats({
        language,
        userId: projectData.user_id,
        documentName: PROJECTS_COLLECTION_NAME,
        operationType: "create",
      });

      return true;
    });

export const onDeleteProject = functions
    .region(cloudRegions.eu)
    .firestore
    .document("projects/{projectId}")
    .onDelete(
        async (projectSnapshot: functions.firestore.QueryDocumentSnapshot) => {
          const postData = projectSnapshot.data();
          const language: "en" | "fr" = postData.language ?? "en";

          await _updateStats({
            language,
            documentName: PROJECTS_COLLECTION_NAME,
            operationType: "delete",
          });

          await _updateUserStats({
            language,
            userId: postData.user_id,
            documentName: PROJECTS_COLLECTION_NAME,
            operationType: "delete",
          });

          return true;
        });

/**
 * Update user's projects stats.
 */
export const onUpdateProject = functions
    .region(cloudRegions.eu)
    .firestore
    .document("projects/{projectId}")
    .onUpdate(async (projectSnapshot) => {
      const beforeProjectData = projectSnapshot.before.data();
      const afterProjectData = projectSnapshot.after.data();

      if (beforeProjectData.visibility !== afterProjectData.visibility) {
        const language: "en" | "fr" = afterProjectData.language ?? "en";

        await _updateStats({
          language,
          documentName: PROJECTS_COLLECTION_NAME,
          operationType: "update",
          updateType: "visibility",
          visibility: afterProjectData.visibility,
        });

        await _updateUserStats({
          language,
          userId: afterProjectData.user_id,
          documentName: PROJECTS_COLLECTION_NAME,
          operationType: "update",
          updateType: "visibility",
          visibility: afterProjectData.visibility,
        });
      }

      if (beforeProjectData.language !== afterProjectData.language) {
        const prevLanguage: "en" | "fr" = beforeProjectData.language ?? "en";
        const language: "en" | "fr" = afterProjectData.language ?? "en";

        await _updateStats({
          language,
          documentName: PROJECTS_COLLECTION_NAME,
          operationType: "update",
          prevLanguage,
          updateType: "language",
          visibility: afterProjectData.visibility,
        });

        await _updateUserStats({
          language,
          userId: afterProjectData.user_id,
          documentName: PROJECTS_COLLECTION_NAME,
          operationType: "update",
          updateType: "language",
          visibility: afterProjectData.visibility,
        });
      }

      return true;
    });

// -----
// Users
// -----
export const onCreateUser = functions
    .region(cloudRegions.eu)
    .firestore
    .document("users/{userId}")
    .onCreate(async () => {
      const documentSnapshot = await firestore
          .collection(STATISTICS_COLLECTION_NAME)
          .doc(USER_DOCUMENT_NAME)
          .get();

      const documentData = documentSnapshot.data();
      if (!documentSnapshot.exists || !documentData) {
        return false;
      }

      let created: number = documentData.created ?? 0;
      let current: number = documentData.current ?? 0;

      const isCreatedNumber = typeof created === "number";
      const isCurrentNumber = typeof current === "number";

      created = isCreatedNumber ? created + 1 : 1;
      current = isCurrentNumber ? current + 1 : 1;

      await documentSnapshot.ref.update({
        created,
        current,
        updated_at: adminApp.firestore.Timestamp.now(),
      });

      return true;
    });

export const onDeleteUser = functions
    .region(cloudRegions.eu)
    .firestore
    .document("users/{userId}")
    .onDelete(async () => {
      const documentSnapshot = await firestore
          .collection(STATISTICS_COLLECTION_NAME)
          .doc(USER_DOCUMENT_NAME)
          .get();

      const documentData = documentSnapshot.data();
      if (!documentSnapshot.exists || !documentData) {
        return false;
      }

      let deleted: number = documentData.deleted ?? 0;
      let current: number = documentData.current ?? 0;

      const isDeletedNumber = typeof deleted === "number";
      const isCurrentNumber = typeof current === "number";

      deleted = isDeletedNumber ? deleted + 1 : 1;
      current = isCurrentNumber ? current - 1 : 1;

      current = Math.max(0, current);

      await documentSnapshot.ref.update({
        deleted,
        current,
        updated_at: adminApp.firestore.Timestamp.now(),
      });

      return true;
    });


// --------
// HELPERS
// --------

/**
 * Update global statistics about a post or a project.
 * @param {Object} params Firestore collection & document names.
 * @return {boolean} True if the request succeeded.
 */
async function _updateStats(params: UpdateGlobalDocStatsParams) {
  const {documentName} = params;

  const documentSnapshot = await firestore
      .collection(STATISTICS_COLLECTION_NAME)
      .doc(documentName) // e.g. POSTS_COLLECTION_NAME, PROJECTS_COLLECTION_NAME
      .get();

  const documentData = documentSnapshot.data();
  if (!documentSnapshot.exists || !documentData) {
    return false;
  }

  const payload = _getStatsPayload({
    ...params,
    ...{documentData},
  });

  await documentSnapshot.ref.update(payload);
  return true;
}

/**
 * Return a payload for the appropriate operation.
 * @param {Object} params Firestore document, language, operation type.
 * @return {Object} A payload.
 */
function _getStatsPayload(params: GetOpPayloadParams) {
  const {operationType, updateType} = params;

  switch (operationType) {
    case "create":
      return _getCreateOpPayload(params);
    case "delete":
      return _getDeleteOpPayload(params);
    case "update":
      if (updateType === "visibility") {
        return _getVisibilityUpdateOpPayload(params);
      }

      if (updateType === "language") {
        return _getLanguageUpdateOpPayload(params);
      }

      return {};
    default:
      return {};
  }
}

/**
 * Return an object containing fields to update.
 * @param {Object} params Firestore document, language.
 * @return {Object} Payload.
 */
function _getCreateOpPayload(params: GetOpPayloadParams) {
  const {documentData, language} = params;

  /** Global document (eg. post | project) created for all languages. */
  let globalCreated: number = documentData.created ?? 0;
  /** Current number of document (eg. post | project) for all languages. */
  let globalCurrent: number = documentData.current ?? 0;

  const keyLangCreated = `created:${language}`;
  const keyLangCurrent = `current:${language}`;

  /** Global document (eg. post) created for the specified language. */
  let globalLangCreated: number = documentData[keyLangCreated] ?? 0;
  /** Current number of document (eg. post) for the specified language. */
  let globalLangCurrent: number = documentData[keyLangCurrent] ?? 0;

  const isCreatedNumber = typeof globalCreated === "number";
  const isCurrentNumber = typeof globalCurrent === "number";

  const isCreatedLangNumber = typeof globalLangCreated === "number";
  const isCurrentLangNumber = typeof globalLangCurrent === "number";

  globalCreated = isCreatedNumber ? globalCreated + 1 : 1;
  globalCurrent = isCurrentNumber ? globalCurrent + 1 : 1;

  globalLangCreated = isCreatedLangNumber ? globalLangCreated + 1 : 1;
  globalLangCurrent = isCurrentLangNumber ? globalLangCurrent + 1 : 1;

  return {
    created: globalCreated,
    current: globalCurrent,
    [keyLangCreated]: globalLangCreated,
    [keyLangCurrent]: globalLangCurrent,
    updated_at: adminApp.firestore.Timestamp.now(),
  };
}

/**
 * Return an object containing fields to update.
 * @param {Object} params Firestore document, language.
 * @return {Object} Payload.
 */
function _getDeleteOpPayload(params: GetOpPayloadParams) {
  const {documentData, language} = params;

  /** Current number of document (eg. post | project) for all languages. */
  let globalCurrent: number = documentData.current ?? 0;
  let globalDeleted: number = documentData.deleted ?? 0;

  const keyLangCurrent = `current:${language}`;
  const keyLangDeleted = `deleted:${language}`;

  /** Current number of document (eg. post) for the specified language. */
  let globalLangCurrent: number = documentData[keyLangCurrent] ?? 0;
  /** Number of deleted document (eg. post) for the specified language. */
  let globalLangDeleted: number = documentData[keyLangDeleted] ?? 0;

  const isCurrentNumber = typeof globalCurrent === "number";
  const isDeletedNumber = typeof globalDeleted === "number";

  const isCurrentLangNumber = typeof globalLangCurrent === "number";
  const isDeletedLangNumber = typeof globalLangDeleted === "number";

  globalCurrent = isCurrentNumber ? globalCurrent - 1 : 0;
  globalDeleted = isDeletedNumber ? globalDeleted + 1 : 1;

  globalLangCurrent = isCurrentLangNumber ? globalLangCurrent - 1 : 0;
  globalLangDeleted = isDeletedLangNumber ? globalLangDeleted + 1 : 1;

  globalCurrent = Math.max(0, globalCurrent);
  globalLangCurrent = Math.max(0, globalLangCurrent);

  return {
    current: globalCurrent,
    deleted: globalDeleted,
    [keyLangCurrent]: globalLangCurrent,
    [keyLangDeleted]: globalLangDeleted,
    updated_at: adminApp.firestore.Timestamp.now(),
  };
}

/**
 * Return an object containing fields to update
 * related to a change of `visibility` fields in a document.
 * @param {Object} params Firestore document, language.
 * @return {Object} Payload.
 */
function _getLanguageUpdateOpPayload(params: GetOpPayloadParams) {
  const {documentData, language, prevLanguage} = params;
  if (typeof prevLanguage === "undefined") {
    return {};
  }

  /** String key for previous document language */
  const keyLangPrev = `current:${prevLanguage}`;
  /** String key for new document language */
  const keyLangNew = `current:${language}`;

  /** Global document (eg. post) created for the specified language. */
  let langPrevCount: number = documentData[keyLangPrev] ?? 0;
  /** Current number of document (eg. post) for the specified language. */
  let langNewCount: number = documentData[keyLangNew] ?? 0;

  const isPrevNumber = typeof langPrevCount === "number";
  const isNewNumber = typeof langNewCount === "number";

  langPrevCount = isPrevNumber ? langPrevCount - 1 : 1;
  langNewCount = isNewNumber ? langNewCount + 1 : 1;

  langPrevCount = Math.max(0, langPrevCount);

  return {
    [keyLangPrev]: langPrevCount,
    [keyLangNew]: langNewCount,
    updated_at: adminApp.firestore.Timestamp.now(),
  };
}
/**
 * Return an object containing fields to update
 * related to a change of `visibility` fields in a document.
 * @param {Object} params Firestore document, language.
 * @return {Object} Payload.
 */
function _getVisibilityUpdateOpPayload(params: GetOpPayloadParams) {
  const {documentData, language, visibility} = params;
  if (typeof visibility === "undefined") {
    return {};
  }

  /** Number of published document (eg. post | project) for all languages. */
  let globalPublished: number = documentData.published ?? 0;

  const keyLangPublished = `published:${language}`;
  /** Published number of document (eg. post) for the specified language. */
  let globalLangPublished: number = documentData[keyLangPublished] ?? 0;

  const isPublishedNumber = typeof globalPublished === "number";
  const isPublishedLangNumber = typeof globalLangPublished === "number";

  if (visibility === "public") {
    globalPublished = isPublishedNumber ? globalPublished + 1 : 1;
    globalLangPublished = isPublishedLangNumber ? globalLangPublished + 1 : 1;
  } else {
    globalPublished = isPublishedNumber ? globalPublished - 1 : 0;
    globalLangPublished = isPublishedLangNumber ? globalLangPublished - 1 : 0;

    globalPublished = Math.max(0, globalPublished);
    globalLangPublished = Math.max(0, globalLangPublished);
  }

  return {
    published: globalPublished,
    [keyLangPublished]: globalLangPublished,
    updated_at: adminApp.firestore.Timestamp.now(),
  };
}

/**
 * Update user statistics about their number of post or project.
 * @param {Object} params Collection & document name in Firestore, and language.
 * @return {boolean} True if the request succeeded.
 */
async function _updateUserStats(params: UpdateUserStatsParams) {
  const {documentName, userId} = params;

  const documentSnapshot = await firestore
      .collection(USERS_COLLECTION_NAME)
      .doc(userId)
      .collection(USER_STATISTICS_COLLECTION_NAME)
      .doc(documentName) // e.g. POSTS_COLLECTION_NAME, PROJECTS_COLLECTION_NAME
      .get();

  const documentData = documentSnapshot.data();
  if (!documentSnapshot.exists || !documentData) {
    return false;
  }

  const payload = _getStatsPayload({
    ...params,
    ...{documentData},
  });

  await documentSnapshot.ref.update(payload);
  return true;
}
