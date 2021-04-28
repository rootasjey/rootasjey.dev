import * as functions from 'firebase-functions';

const firebaseTools = require('firebase-tools');

import { adminApp } from './adminApp';
import { checkUserIsSignedIn } from './utils';

const firestore = adminApp.firestore();

export const checkEmailAvailability = functions
  .region('europe-west3')
  .https
  .onCall(async (data) => {
    const email: string = data.email;

    if (typeof email !== 'string' || email.length === 0) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `The function must be called with one (string)
         argument [email] which is the email to check.`,
      );
    }

    if (!validateEmailFormat(email)) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `The function must be called with a valid email address.`,
      );
    }

    const exists = await isUserExistsByEmail(email);
    const isAvailable = !exists;

    return {
      email,
      isAvailable,
    };
  });

export const checkUsernameAvailability = functions
  .region('europe-west3')
  .https
  .onCall(async (data) => {
    const name: string = data.name;

    if (typeof name !== 'string' || name.length === 0) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `The function must be called with one (string)
         argument "name" which is the name to check.`,
      );
    }

    if (!validateNameFormat(name)) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `The function must be called with a valid [name]
         with at least 3 alpha-numeric characters (underscore is allowed) (A-Z, 0-9, _).`,
      );
    }

    const nameSnap = await firestore
      .collection('users')
      .where('nameLowerCase', '==', name.toLowerCase())
      .limit(1)
      .get();

    return {
      name: name,
      isAvailable: nameSnap.empty,
    };
  });

/**
 * Create an user with Firebase auth then with Firestore.
 * Check user's provided arguments and exit if wrong.
 */
export const createAccount = functions
  .region('europe-west3')
  .https
  .onCall(async (data: CreateUserAccountParams) => {
    if (!checkCreateAccountData(data)) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `The function must be called with 3 string 
        arguments [username], [email] and [password].`,
      );
    }

    const { username, password, email } = data;

    const userRecord = await adminApp
      .auth()
      .createUser({
        displayName: username,
        password: password,
        email: email,
        emailVerified: false,
      });

    await adminApp.firestore()
      .collection('users')
      .doc(userRecord.uid)
      .set({
        developer: {
          apps: {
            current: 0,
            limit: 5,
          },
          isProgramActive: false,
          payment: {
            isActive: false,
            plan: 'free',
            stripeId: '',
          }
        },
        email: email,
        lang: 'en',
        name: username,
        nameLowerCase: username.toLowerCase(),
        pricing: 'free',
        quota: {
          current: 0,
          date: new Date(),
          limit: 20,
        },
        rights: {
          'user:managedata': false,
          'user:manageauthor': false,
          'user:managequote': false,
          'user:managequotidian': false,
          'user:managereference': false,
          'user:proposequote': true,
          'user:readquote': true,
          'user:validatequote': false,
        },
        settings: {
          notifications: {
            email: {
              tempQuotes: true,
              quotidians: false,
            },
            push: {
              quotidians: true,
              tempQuotes: true,
            }
          },
        },
        stats: {
          notifications: {
            total: 0,
            unread: 0,
          },
          posts: {
            contributed: 0,
            drafts: 0,
            published: 0,
          },
          projects: {
            contributed: 0,
            drafts: 0,
            published: 0,
          },
        },
        urls: {
          image: '',
          twitter: '',
          facebook: '',
          instagram: '',
          twitch: '',
          website: '',
          wikipedia: '',
          youtube: '',
        },
        uid: userRecord.uid,
      });

    return {
      user: {
        id: userRecord.uid,
        email,
      },
    };
  });

function checkCreateAccountData(data: any) {
  if (Object.keys(data).length !== 3) {
    return false;
  }

  const keys = Object.keys(data);

  if (!keys.includes('username')
    || !keys.includes('email')
    || !keys.includes('password')) {
    return false;
  }

  if (typeof data['username'] !== 'string' ||
    typeof data['email'] !== 'string' ||
    typeof data['password'] !== 'string') {
    return false;
  }

  return true;
}

/**
 * Delete user's document from Firebase auth & Firestore.
 */
export const deleteAccount = functions
  .region('europe-west3')
  .https
  .onCall(async (data: DeleteAccountParams, context) => {
    const userAuth = context.auth;
    const { idToken } = data;

    if (!userAuth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        `The function must be called from an authenticated user.`,
      );
    }

    await checkUserIsSignedIn(context, idToken);

    const userSnap = await firestore
      .collection('users')
      .doc(userAuth.uid)
      .get();

    const userData = userSnap.data();

    if (!userSnap.exists || !userData) {
      throw new functions.https.HttpsError(
        'not-found',
        `This user document doesn't exist. It may have been deleted.`,
      );
    }

    await adminApp
      .auth()
      .deleteUser(userAuth.uid);

    await firebaseTools.firestore
      .delete(userSnap.ref.path, {
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
   * Return user's data.
   */
export const fetchUser = functions
  .region('europe-west3')
  .https
  .onCall(async (data) => {
    const userId: string = data.userId;

    if (!userId) {
      throw new functions.https.HttpsError(
        'invalid-argument', 
        `'fetchUserData' must be called with one (1) argument representing the author's id to fetch.`,
      );
    }

    const userSnap = await firestore
      .collection('users')
      .doc(userId)
      .get();

    const userData = userSnap.data();

    if (!userSnap.exists || ! userData) {
      throw new functions.https.HttpsError(
        'not-found',
        `The specified user does not exist. It may have been deleted.`,
      );
    }

    return {
      createdAt: userData.createdAt,
      email: userData.email,
      id: userSnap.id,
      job: userData.job,
      location: userData.location,
      name: userData.name,
      role: userData.role,
      stats: {
        posts: {
          contributed: userData.stats.contributed,
          drafts: userData.stats.drafts,
          published: userData.stats.published,
        },
        projects: {
          contributed: userData.stats.contributed,
          drafts: userData.stats.drafts,
          published: userData.stats.published,
        },
      },
      summary: userData.summary,
      updatedAt: userData.updatedAt,
      urls: {
        artbooking: userData.urls.artbooking,
        behance: userData.urls.behance,
        dribbble: userData.urls.dribbble,
        facebook: userData.urls.facebook,
        github: userData.urls.github,
        gitlab: userData.urls.gitlab,
        image: userData.urls.image,
        instagram: userData.urls.instagram,
        linkedin: userData.urls.linkedin,
        other: userData.urls.other,
        tiktok: userData.urls.tiktok,
        twitch: userData.urls.twitch,
        twitter: userData.urls.twitter,
        website: userData.urls.website,
        wikipedia: userData.urls.wikipedia,
        youtube: userData.urls.youtube,
      },
    };
  });

  /**
   * Update an user's data with the specified payload.
   */
export const updateUser = functions
  .region('europe-west3')
  .https
  .onCall(async (data, context) => {
    const userAuth = context.auth;
    const userId: string = data.userId;
    const updatePayload: any = data.updatePayload;

    if (!userAuth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        `The function must be called from an authenticated user.`,
      );
    }

    if (!userId) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `'updateUserData' must be called with a valid user's id to update.`,
      );
    }

    if (!updatePayload) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `'updateUserData' must be called with a valid "updatePayload" argument reprensenting new data.`,
      );
    }

    if (userAuth.uid !== userId) {
      throw new functions.https.HttpsError(
        'permission-denied',
        `You do not have the permission to update this user.`,
      );
    }

    const userSnap = await firestore
      .collection('users')
      .doc(userId)
      .get();

    if (!userSnap.exists) {
      throw new functions.https.HttpsError(
        'not-found',
        `The specified user does not exist. It may have been deleted.`,
      );
    }

    // Use specific function to update user's name & email.
    delete updatePayload.name;
    delete updatePayload.email;

    await userSnap.ref.update(updatePayload);

    const userData = userSnap.data();

    if (!userData) {
      throw new functions.https.HttpsError(
        'data-loss',
        `Something went wrong while fetching updated user's data. Please try again.`,
      );
    }

    return {
      createdAt: userData.createdAt,
      email: userData.email,
      id: userSnap.id,
      job: userData.job,
      location: userData.location,
      name: userData.name,
      role: userData.role,
      stats: {
        posts: {
          contributed: userData.stats.contributed,
          drafts: userData.stats.drafts,
          published: userData.stats.published,
        },
        projects: {
          contributed: userData.stats.contributed,
          drafts: userData.stats.drafts,
          published: userData.stats.published,
        },
      },
      summary: userData.summary,
      updatedAt: userData.updatedAt,
      urls: {
        artbooking: userData.urls.artbooking,
        behance: userData.urls.behance,
        dribbble: userData.urls.dribbble,
        facebook: userData.urls.facebook,
        github: userData.urls.github,
        gitlab: userData.urls.gitlab,
        image: userData.urls.image,
        instagram: userData.urls.instagram,
        linkedin: userData.urls.linkedin,
        other: userData.urls.other,
        tiktok: userData.urls.tiktok,
        twitch: userData.urls.twitch,
        twitter: userData.urls.twitter,
        website: userData.urls.website,
        wikipedia: userData.urls.wikipedia,
        youtube: userData.urls.youtube,
      },
    };
  });

/**
 * Update an user's email in Firebase auth and in Firestore.
 * Several security checks are made (email format, password, email unicity)
 * before validating the new email.
 */
export const updateEmail = functions
  .region('europe-west3')
  .https
  .onCall(async (data: UpdateEmailParams, context) => {
    const userAuth = context.auth;
    const { idToken, newEmail } = data;

    if (!userAuth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        `The function must be called from an authenticated user (1).`,
      );
    }

    await checkUserIsSignedIn(context, idToken);
    const isFormatOk = validateEmailFormat(newEmail);

    if (!newEmail || !isFormatOk) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `The function must be called with a valid [newEmail] argument. 
        The value you specified is not in a correct email format.`,
      );
    }

    const isEmailTaken = await isUserExistsByEmail(newEmail);

    if (isEmailTaken) {
      throw new functions.https.HttpsError(
        'invalid-argument',
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
      .collection('users')
      .doc(userAuth.uid)
      .update({
        email: newEmail,
      });

    return {
      success: true,
      user: { id: userAuth.uid },
    };
  });

/**
 * Update a new username in Firebase auth and in Firestore.
 * Several security checks are made (name format & unicity, password)
 * before validating the new username.
 */
export const updateUsername = functions
  .region('europe-west3')
  .https
  .onCall(async (data: UpdateUsernameParams, context) => {
    const userAuth = context.auth;

    if (!userAuth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        `The function must be called from an authenticated user.`,
      );
    }

    const { newUsername } = data;
    const isFormatOk = validateNameFormat(newUsername);

    if (!newUsername || !isFormatOk) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        `The function must be called with a valid [newUsername].
         The value you specified is not in a correct format.`,
      );
    }

    const isUsernameTaken = await isUserExistsByUsername(newUsername.toLowerCase());

    if (isUsernameTaken) {
      throw new functions.https.HttpsError(
        'invalid-argument',
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
      .collection('users')
      .doc(userAuth.uid)
      .update({
        name: newUsername,
        nameLowerCase: newUsername.toLowerCase(),
      });

    return {
      success: true,
      user: { id: userAuth.uid },
    };
  });

// ----------------
// HELPER FUNCTIONS
// ----------------

async function isUserExistsByEmail(email: string) {
  const emailSnapshot = await firestore
    .collection('users')
    .where('email', '==', email)
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

async function isUserExistsByUsername(nameLowerCase: string) {
  const nameSnapshot = await firestore
    .collection('users')
    .where('nameLowerCase', '==', nameLowerCase)
    .limit(1)
    .get();

  if (nameSnapshot.empty) {
    return false;
  }

  return true;
}

function validateEmailFormat(email: string) {
  const re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
}

function validateNameFormat(name: string) {
  const re = /[a-zA-Z0-9_]{3,}/;
  const matches = re.exec(name);

  if (!matches) { return false; }
  if (matches.length < 1) { return false; }

  const firstMatch = matches[0];
  return firstMatch === name;
}