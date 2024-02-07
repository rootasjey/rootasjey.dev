import * as functions from "firebase-functions";

// eslint-disable-next-line @typescript-eslint/no-var-requires
const firebaseTools = require("firebase-tools");

import {adminApp} from "./adminApp";
import {
  BASE_DOCUMENT_NAME,
  checkUserIsSignedIn,
  cloudRegions,
  getRandomProfilePictureLink,
  NOTIFICATIONS_DOCUMENT_NAME,
  POSTS_COLLECTION_NAME,
  PROJECTS_COLLECTION_NAME,
  USERS_COLLECTION_NAME,
  USER_PUBLIC_FIELDS_COLLECTION_NAME,
  USER_STATISTICS_COLLECTION_NAME,
} from "./utils";

const firestore = adminApp.firestore();

export const checkEmailAvailability = functions
    .region(cloudRegions.eu)
    .https
    .onCall(async (data) => {
      const email: string = data.email;

      if (typeof email !== "string" || email.length === 0) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The function must be called with one (string)
         argument [email] which is the email to check.`,
        );
      }

      if (!_validateEmailFormat(email)) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "The function must be called with a valid email address.",
        );
      }

      const exists = await _isEmailExists(email);
      const isAvailable = !exists;

      return {
        email,
        isAvailable,
      };
    });

export const checkUsernameAvailability = functions
    .region(cloudRegions.eu)
    .https
    .onCall(async (data) => {
      const name: string = data.name;

      if (typeof name !== "string" || name.length === 0) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The function must be called with one (string)
         argument "name" which is the name to check.`,
        );
      }

      if (!_validateUsernameFormat(name)) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The function must be called with a valid [name]
         with at least 3 alpha-numeric characters 
         (underscore is allowed) (A-Z, 0-9, _).`,
        );
      }

      const nameSnap = await firestore
          .collection("users")
          .where("name_lower_case", "==", name.toLowerCase())
          .limit(1)
          .get();

      return {
        name: name,
        isAvailable: nameSnap.empty,
      };
    });

/**
 * Delete user profile picture files.
 */
export const clearProfilePicture = functions
    .region(cloudRegions.eu)
    .https
    .onCall(async (data, context) => {
      const userAuth = context.auth;
      if (!userAuth) {
        throw new functions.https.HttpsError(
            "permission-denied",
            "The function must be called from an authenticated user.",
        );
      }

      // Delete files from Cloud Storage
      const dir = await adminApp.storage()
          .bucket()
          .getFiles({
            prefix: `images/users/${userAuth.uid}/pp`,
          });

      const files = dir[0];

      for await (const file of files) {
        await file.delete();
      }

      return {
        success: true,
      };
    });

/**
 * Create an user with Firebase auth then with Firestore.
 * Check user's provided arguments and exit if wrong.
 */
export const createAccount = functions
    .region(cloudRegions.eu)
    .https
    .onCall(async (data: CreateUserAccountParams) => {
      if (!checkCreateAccountData(data)) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The function must be called with 3 string 
        arguments [username], [email] and [password].`,
        );
      }

      const {username, password, email} = data;

      const userRecord = await adminApp
          .auth()
          .createUser({
            displayName: username,
            password,
            email,
            emailVerified: false,
          });

      await adminApp.firestore()
          .collection("users")
          .doc(userRecord.uid)
          .set({
            bio: "",
            created_at: adminApp.firestore.FieldValue.serverTimestamp(),
            email,
            language: "en",
            name: username,
            name_lower_case: username.toLowerCase(),
            profile_picture: {
              dimensions: {
                height: 0,
                width: 0,
              },
              extension: "",
              links: {
                edited: "",
                original_url: getRandomProfilePictureLink(),
                storage_path: "",
              },
              size: 0,
              type: "",
              updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
            },
            rights: {
              "user:manage_data": false,
              "user:manage_posts": false,
              "user:manage_projects": false,
            },
            social_links: {
              artbooking: "",
              behance: "",
              bitbucket: "",
              dribbble: "",
              facebook: "",
              github: "",
              gitlab: "",
              instagram: "",
              linkedin: "",
              twitch: "",
              twitter: "",
              website: "",
              wikipedia: "",
              youtube: "",
            },
            updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
            user_id: userRecord.uid,
          });


      await _createUserStatisticsCollection(userRecord.uid);

      return {
        user: {
          id: userRecord.uid,
          email,
        },
      };
    });

/**
 * Delete user's document from Firebase auth & Firestore.
 */
export const deleteAccount = functions
    .region(cloudRegions.eu)
    .https
    .onCall(async (data: DeleteAccountParams, context) => {
      const userAuth = context.auth;
      const {idToken} = data;

      if (!userAuth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "The function must be called from an authenticated user.",
        );
      }

      await checkUserIsSignedIn(context, idToken);

      const userSnap = await firestore
          .collection("users")
          .doc(userAuth.uid)
          .get();

      const userData = userSnap.data();

      if (!userSnap.exists || !userData) {
        throw new functions.https.HttpsError(
            "not-found",
            `This user document doesn't exist. 
        It may have been deleted.`,
        );
      }

      await adminApp
          .auth()
          .deleteUser(userAuth.uid);

      await firebaseTools.firestore
          .delete(userSnap.ref.path, {
            force: true,
            project: process.env.GCLOUD_PROJECT,
            recursive: true,
            yes: true,
          });

      return {
        success: true,
        user: {
          id: userAuth.uid,
        },
      };
    });

/**
 * Create user's public information from private fields.
 */
export const onCreatePublicInfo = functions
    .region(cloudRegions.eu)
    .firestore
    .document("users/{user_id}")
    .onCreate(async (snapshot, context) => {
      const data = snapshot.data();
      const userId: string = context.params.user_id;

      return await adminApp.firestore()
          .collection(USERS_COLLECTION_NAME)
          .doc(userId)
          .collection(USER_PUBLIC_FIELDS_COLLECTION_NAME)
          .doc(BASE_DOCUMENT_NAME)
          .create({
            bio: data.bio ?? "",
            created_at: adminApp.firestore.FieldValue.serverTimestamp(),
            id: userId,
            location: data.location ?? "",
            name: data.name ?? "",
            name_lower_case: data.name_lower_case ??
              data.name.toLowerCase() ?? "",
            profile_picture: data.profile_picture ?? "",
            social_links: data.social_links,
            type: "base",
            updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
          });
    });

/**
* Keep public user's information in-sync with privated fields.
* Fired after document change for an user.
*/
export const onUpdatePublicInfo = functions
    .region(cloudRegions.eu)
    .firestore
    .document("users/{user_id}")
    .onUpdate(async (change, context) => {
      const shouldUpdate = _shouldUpdatePublicInfo(change);
      if (!shouldUpdate) {
        return false;
      }

      const afterData = change.after.data();
      const userId: string = context.params.user_id;

      return await adminApp.firestore()
          .collection(USERS_COLLECTION_NAME)
          .doc(userId)
          .collection(USER_PUBLIC_FIELDS_COLLECTION_NAME)
          .doc(BASE_DOCUMENT_NAME)
          .update({
            bio: afterData.bio ?? "",
            location: afterData.location,
            name: afterData.name,
            profile_picture: afterData.profile_picture,
            social_links: afterData.social_links,
            updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
          });
    });

/**
 * Update an user's email in Firebase auth and in Firestore.
 * Several security checks are made (email format, password, email unicity)
 * before validating the new email.
 */
export const updateEmail = functions
    .region(cloudRegions.eu)
    .https
    .onCall(async (data: UpdateEmailParams, context) => {
      const userAuth = context.auth;
      const {idToken, newEmail} = data;

      if (!userAuth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "The function must be called from an authenticated user (1).",
        );
      }

      await checkUserIsSignedIn(context, idToken);
      const isFormatOk = _validateEmailFormat(newEmail);

      if (!newEmail || !isFormatOk) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The function must be called with a valid [newEmail] argument. 
        The value you specified is not in a correct email format.`,
        );
      }

      const isEmailTaken = await _isEmailExists(newEmail);

      if (isEmailTaken) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The email specified is not available.
         Try specify a new one in the "newEmail" argument.`,
        );
      }

      await adminApp
          .auth()
          .updateUser(userAuth.uid, {
            email: newEmail,
            emailVerified: false,
          });

      await firestore
          .collection("users")
          .doc(userAuth.uid)
          .update({
            email: newEmail,
          });

      return {
        success: true,
        user: {id: userAuth.uid},
      };
    });

/**
 * Update a new username in Firebase auth and in Firestore.
 * Several security checks are made (name format & unicity, password)
 * before validating the new username.
 */
export const updateUsername = functions
    .region(cloudRegions.eu)
    .https
    .onCall(async (data: UpdateUsernameParams, context) => {
      const userAuth = context.auth;

      if (!userAuth) {
        throw new functions.https.HttpsError(
            "unauthenticated",
            "The function must be called from an authenticated user.",
        );
      }

      const {newUsername} = data;
      const isFormatOk = _validateUsernameFormat(newUsername);

      if (!newUsername || !isFormatOk) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The function must be called with a valid [newUsername].
         The value you specified is not in a correct format.`,
        );
      }

      const isUsernameTaken = await _isUsernameExists(
          newUsername.toLowerCase()
      );

      if (isUsernameTaken) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            `The name specified is not available.
         Please try with a new one.`,
        );
      }

      await adminApp
          .auth()
          .updateUser(userAuth.uid, {
            displayName: newUsername,
          });

      await firestore
          .collection("users")
          .doc(userAuth.uid)
          .update({
            name: newUsername,
            name_lower_case: newUsername.toLowerCase(),
          });

      return {
        success: true,
        user: {id: userAuth.uid},
      };
    });

// ----------------
// HELPER FUNCTIONS
// ----------------

/**
 * Return true if the data is correct.
 * @param {FirebaseFirestore.DocumentData} data Data to check.
 * @return {boolean} Return true if the data is correct.
 */
function checkCreateAccountData(data: FirebaseFirestore.DocumentData) {
  if (Object.keys(data).length !== 3) {
    return false;
  }

  const keys = Object.keys(data);

  if (!keys.includes("username") ||
    !keys.includes("email") ||
    !keys.includes("password")) {
    return false;
  }

  if (typeof data["username"] !== "string" ||
    typeof data["email"] !== "string" ||
    typeof data["password"] !== "string") {
    return false;
  }

  return true;
}

/**
 * Create user's statistics sub-collection.
 * @param {string} userId User's id.
 */
async function _createUserStatisticsCollection(userId: string) {
  const userStatsCollection = adminApp.firestore()
      .collection(USERS_COLLECTION_NAME)
      .doc(userId)
      .collection(USER_STATISTICS_COLLECTION_NAME);

  await userStatsCollection
      .doc(POSTS_COLLECTION_NAME)
      .create({
        created: 0,
        deleted: 0,
        drafts: 0,
        liked: 0,
        name: POSTS_COLLECTION_NAME,
        owned: 0,
        published: 0,
        updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
        user_id: userId,
      });

  await userStatsCollection
      .doc(PROJECTS_COLLECTION_NAME)
      .create({
        created: 0,
        deleted: 0,
        drafts: 0,
        liked: 0,
        name: PROJECTS_COLLECTION_NAME,
        owned: 0,
        published: 0,
        updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
        user_id: userId,
      });


  await userStatsCollection
      .doc(NOTIFICATIONS_DOCUMENT_NAME)
      .create({
        name: NOTIFICATIONS_DOCUMENT_NAME,
        total: 0,
        unread: 0,
        updated_at: adminApp.firestore.FieldValue.serverTimestamp(),
        user_id: userId,
      });
}

/**
 * Return true if the email passed is already used. False otherwise.
 * @param {string} email Email to check.
 * @return {boolean} Return true if the email already exists. False othewise.
 */
async function _isEmailExists(email: string) {
  const emailSnapshot = await firestore
      .collection("users")
      .where("email", "==", email)
      .limit(1)
      .get();

  if (!emailSnapshot.empty) {
    return true;
  }

  try {
    const userRecord = await adminApp
        .auth()
        .getUserByEmail(email);

    if (userRecord) {
      return true;
    }

    return false;
  } catch (error) {
    return false;
  }
}

/**
 * Return true if the username passed already exist.
 * @param {string} nameLowerCase name to check.
 * @return {boolean} Return true if the username already exists. False othewise.
 */
async function _isUsernameExists(nameLowerCase: string) {
  const nameSnapshot = await firestore
      .collection("users")
      .where("name_lower_case", "==", nameLowerCase)
      .limit(1)
      .get();

  if (nameSnapshot.empty) {
    return false;
  }

  return true;
}

/**
 * Return true if an user's field value has changed among public information.
 * (e.g. name, profile picture, urls).
 * @param {functions.Change<functions.firestore.QueryDocumentSnapshot>}
 * change Firestore document updated.
 * @return {boolean} True if a public value has changed.
 */
function _shouldUpdatePublicInfo(
    change: functions.Change<functions.firestore.QueryDocumentSnapshot>
): boolean {
  const beforeData = change.before.data();
  const afterData = change.after.data();

  if (beforeData.name !== afterData.name) {
    return true;
  }

  const beforeProfilePicture = beforeData.profile_picture;
  const afterProfilePicture = afterData.profile_picture;

  for (const [key, value] of Object.entries(beforeProfilePicture)) {
    if (value !== afterProfilePicture[key]) {
      return true;
    }
  }

  const beforeSocialLinks = beforeData.social_links;
  const afterSocialLinks = afterData.social_links;

  for (const [key, value] of Object.entries(beforeSocialLinks)) {
    if (value !== afterSocialLinks[key]) {
      return true;
    }
  }

  return false;
}

/**
 * Return true if the email passed is in a correct format. False otherwise.
 * @param {string} email Email to check.
 * @return {boolean} Return true if the email is correctly formed.
 */
function _validateEmailFormat(email: string) {
  // eslint-disable-next-line max-len
  const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
}

/**
 * Return true if the username passed is in a correct format. False otherwise.
 * @param {string} username Username to check.
 * @return {boolean} Return true if the username is correctly formed.
 */
function _validateUsernameFormat(username: string) {
  const re = /[a-zA-Z0-9_]{3,}/;
  const matches = re.exec(username);

  if (!matches) {
    return false;
  }
  if (matches.length < 1) {
    return false;
  }

  const firstMatch = matches[0];
  return firstMatch === username;
}

