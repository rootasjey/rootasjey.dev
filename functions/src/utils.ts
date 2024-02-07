import * as functions from "firebase-functions";
import {adminApp} from "./adminApp";

export const BASE_DOCUMENT_NAME = "base";
export const ILLUSTRATIONS_COLLECTION_NAME = "illustrations";
export const ILLUSTRATIONS_DOCUMENT_NAME = "illustrations";
export const ILLUSTRATION_STATISTICS_COLLECTION_NAME =
  "illustrations_statistics";
export const NOTIFICATIONS_DOCUMENT_NAME = "notifications";
export const POSTS_COLLECTION_NAME = "posts";
export const POST_LIKED_BY_COLLECTION_NAME = "post_liked_by";
export const POST_STATISTICS_COLLECTION_NAME = "post_statistics";
export const PROJECT_STATISTICS_COLLECTION_NAME = "project_statistics";
export const PROJECTS_COLLECTION_NAME = "projets";
export const STATISTICS_COLLECTION_NAME = "statistics";
export const USER_PUBLIC_FIELDS_COLLECTION_NAME = "user_public_fields";
export const USER_PUBLIC_FIELDS_BASE_DOC =
  "users/{userId}/user_public_fields/base";
export const USER_SETTINGS_COLLECTION_NAME = "user_settings";
export const USER_STATISTICS_COLLECTION_NAME = "user_statistics";
export const USERS_COLLECTION_NAME = "users";
export const USER_DOCUMENT_NAME = "user";

export const cloudRegions = {
  eu: "europe-west3",
};

/**
 * Throws an error if the user is not authenticated.
 * @param {functions.https.CallableContext} context Firebase context.
 * @param {string} idToken JWT.
 */
export async function checkUserIsSignedIn(
    context: functions.https.CallableContext,
    idToken: string,
): Promise<void> {
  const userAuth = context.auth;

  if (!userAuth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "The function must be called from an authenticated user (2).",
    );
  }

  let isTokenValid = false;

  try {
    await adminApp
        .auth()
        .verifyIdToken(idToken, true);

    isTokenValid = true;
  } catch (error) {
    console.error(error);
    isTokenValid = false;
  }

  if (!isTokenValid) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "Your session has expired. Please (sign out and) sign in again.",
    );
  }
}
/**
 * Return a random profile picture url (pre-defined images).
 * @return {string} A random profile picture url.
 */
export function getRandomProfilePictureLink(): string {
  const sampleAvatars = [
    "https://firebasestorage.googleapis.com/v0/b/artbooking-54d22.appspot.com/o/static%2Fimages%2Favatars%2Favatar_woman_0.png?alt=media&token=d6ab47e3-709f-449a-a6c6-b53f854ec0fb",
    "https://firebasestorage.googleapis.com/v0/b/artbooking-54d22.appspot.com/o/static%2Fimages%2Favatars%2Favatar_man_2.png?alt=media&token=9a4cc0ce-b12f-4095-a49e-9a38ed44d5de",
    "https://firebasestorage.googleapis.com/v0/b/artbooking-54d22.appspot.com/o/static%2Fimages%2Favatars%2Favatar_man_1.png?alt=media&token=1d405ba5-7ec3-4058-ba59-6360c4dfc200",
    "https://firebasestorage.googleapis.com/v0/b/artbooking-54d22.appspot.com/o/static%2Fimages%2Favatars%2Favatar_man_0.png?alt=media&token=2c8edef3-5e6f-4b84-a52b-2c9034951e20",
    "https://firebasestorage.googleapis.com/v0/b/artbooking-54d22.appspot.com/o/static%2Fimages%2Favatars%2Favatar_woman_2.png?alt=media&token=a6f889d9-0ca1-4aa7-8aa5-f137d6fca138",
    "https://firebasestorage.googleapis.com/v0/b/artbooking-54d22.appspot.com/o/static%2Fimages%2Favatars%2Favatar_woman_1.png?alt=media&token=2ef023f4-53c8-466b-93e4-70f58e6067bb",
  ];

  return sampleAvatars[randomIntFromInterval(0, sampleAvatars.length -1)];
}

/**
 * Return a random integer between [min] and [max].
 * @param {number} min Minimum value (included)
 * @param {number} max Maximum value (included)
 * @return {number} A random integer
 */
export function randomIntFromInterval(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1) + min);
}

/**
 * Generate required fields for a new post post document in Firestore.
 * @param {Object} params Data to generate initial document
 * (e.g. content, storage path).
 * @return {Object} Payload.
 */
export function getNewPostFirestorePayload(
    params: GetNewPostFirestorePayloadParams
): Record<string, unknown> {
  const {initialContent, storagePath} = params;

  return {
    character_count: initialContent.length,
    coauthors: {},
    cover: {
      extension: "",
      cover_width: "full",
      cover_corner: "squared",
      dimensions: {
        height: 0,
        width: 0,
      },
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
    created_at: adminApp.firestore.FieldValue.serverTimestamp(),
    featured: false,
    i18n: {},
    language: "en",
    platforms: {
      // android: true
    },
    programming_languages: {
      // Dart: true,
    },
    post_created_at: adminApp.firestore.FieldValue.serverTimestamp(),
    released: false,
    released_at: adminApp.firestore.FieldValue.serverTimestamp(),
    size: 0,
    social_links: {
      android: "",
      artbooking: "",
      behance: "",
      bitbucket: "",
      dribbble: "",
      facebook: "",
      github: "",
      gitlab: "",
      instagram: "",
      ios: "",
      linkedin: "",
      macos: "",
      other: "",
      twitter: "",
      website: "",
      windows: "",
      youtube: "",
    },
    storage_path: storagePath,
    tags: {
      // art: true
    },
    time_to_read: "",
    updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
    visibility: "private",
    word_count: initialContent.split(" ").length,
  };
}


/**
 * Generate a long lived persistant Firebase Storage download URL.
 * @param {String} bucket Bucket name.
 * @param {String} pathToFile File's path.
 * @param {String} downloadToken File's download token.
 * @return {String} Firebase Storage download url.
 */
export const createPersistentDownloadUrl = (
    bucket: string,
    pathToFile: string,
    downloadToken: string,
): string => {
  return `https://firebasestorage.googleapis.com/v0/b/${bucket}/o/${encodeURIComponent(
      pathToFile
  )}?alt=media&token=${downloadToken}`;
};

