import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

import { adminApp } from './adminApp';

const firestore = adminApp.firestore();

export const checkEmailAvailability = functions
  .region('europe-west3')
  .https
  .onCall(async (data, context) => {
    const email: string = data.email;

    if (!(typeof email === 'string') || email.length === 0) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'one (string) argument "email" which is the email to check.');
    }

    if (!validateEmailFormat(email)) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'a valid email address.');
    }

    const emailSnap = await firestore
      .collection('users')
      .where('email', '==', email)
      .limit(1)
      .get();

    return {
      email,
      isAvailable: emailSnap.empty,
    };
  });

export const checkNameAvailability = functions
  .region('europe-west3')
  .https
  .onCall(async (data, context) => {
    const name: string = data.name;

    if (!(typeof name === 'string') || name.length === 0) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'one (string) argument "name" which is the name to check.');
    }

    if (!validateNameFormat(name)) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'a valid name with at least 3 alpha-numeric characters (underscore is allowed) (A-Z, 0-9, _).');
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

async function checkNameUpdate(params: DataUpdateParams) {
  const { beforeData, afterData, payload, docId } = params;

  if (beforeData.name === afterData.name) { return payload; }

  if (!afterData.name) {
    payload['name'] = beforeData.name || `user_${Date.now()}`;
    return payload;
  }

  const nameLowerCase = (afterData.name as string).toLowerCase();

  if (!validateNameFormat(nameLowerCase)) {
    const sampleName = `user_${Date.now()}`;
    payload.name = sampleName;
    payload.nameLowerCase = sampleName;

    return payload;
  }

  const userNamesSnap = await firestore
    .collection('users')
    .where('nameLowerCase', '==', nameLowerCase)
    .limit(2)
    .get();

  // Remove possible duplicate.
  // Can happen on rollback.
  const exactMatch = userNamesSnap.docs
    .filter((doc) => doc.id !== docId);

  // There're more than 1 result with the same nameLowerCase
  // so the user cannot take this name.
  if (exactMatch.length > 0) {
    payload['name'] = beforeData.name; // rollback
  }
  // Check if we're not updating the same prop. with the same value.
  // (Infinite loop check)
  else if (beforeData.nameLowerCase !== nameLowerCase) {
    payload['nameLowerCase'] = (afterData.name as string).toLowerCase(); // validate
  }

  return payload;
}

async function checkRole(params: DataUpdateParams) {
  const { beforeData, afterData, payload, docId } = params;

  if (beforeData.role === afterData.role) { return payload; }

  const rollbackPayload = { ...payload, ...{ 'role': beforeData.role } };

  const snapshot = await firestore
    .collection('roles')
    .doc(docId)
    .get();

  if (!snapshot || !snapshot.exists) {
    return rollbackPayload;
  }

  const data = snapshot.data();

  if (!data || !canEditRole(data.role)) {
    return rollbackPayload;
  }

  return payload;
}

function canEditRole(role: string): boolean {
  return role === 'admin' || role === 'owner' || role === 'editor';
}

async function checkUserName(
  data: FirebaseFirestore.DocumentData,
  payload: any,
) {

  if (!data) { return payload; }

  let nameLowerCase = '';

  if (data.name) { nameLowerCase = (data.name as string).toLowerCase(); }
  else { nameLowerCase = payload.nameLowerCase; }

  const userNamesSnap = await firestore
    .collection('users')
    .where('nameLowerCase', '==', nameLowerCase)
    .limit(1)
    .get();

  if (userNamesSnap.empty) {
    payload.nameLowerCase = nameLowerCase;
    return payload;
  }

  const suffix = Date.now();

  return {
    ...payload, ...{
      name: `${payload.name}-${suffix}`,
      nameLowerCase: `${payload.name}-${suffix}`
    }
  };
}

// Check that the new created doc is well-formatted.
export const newAccountCheck = functions
  .region('europe-west3')
  .firestore
  .document('users/{userId}')
  .onCreate(async (snapshot, context) => {
    const data = snapshot.data();
    let payload: any = {};

    payload = await populateUserData(snapshot);

    if (!data.name) {
      payload = populateUserNameIfEmpty(data, payload);
    }

    payload = await checkUserName(data, payload);

    if (!validateNameFormat(payload.name)) {
      const sampleName = `user_${Date.now()}`;
      payload.name = sampleName;
      payload.nameLowerCase = sampleName;
    }

    if (Object.keys(payload).length === 0) { return; }

    return await snapshot.ref.update(payload);
  });

// Add all missing props.
async function populateUserData(snapshot: functions.firestore.DocumentSnapshot) {
  const user = await admin.auth().getUser(snapshot.id);
  const email = typeof user !== 'undefined' ?
    user.email : '';

  const data = snapshot.data() ?? {} ;

  const suffix = Date.now();
  const name: string = data.name ?? `user_${suffix}`;

  return {
    'createdAt': adminApp.firestore.FieldValue.serverTimestamp(),
    'email': email,
    'flag': '',
    'job': data.job ?? '',
    'lang': 'en',
    'location': data.location ?? '',
    'name': name,
    'nameLowerCase': name.toLowerCase(),
    'pricing': 'free',
    'role': 'member',
    'stats': {
      'contributed': 0,
      'drafts': 0,
      'published': 0,
    },
    'summary': '',
    'tokens': {},
    'urls': {
      'image': '',
    },
    'uid': snapshot.id,
    'updatedAt': adminApp.firestore.FieldValue.serverTimestamp(),
  };
}

function populateUserNameIfEmpty(
  data: FirebaseFirestore.DocumentData,
  payload: any,
): FirebaseFirestore.DocumentData {

  if (!data) { return payload; }
  if (data.name) { return payload; }

  let name = data.name || data.nameLowerCase;
  name = name || `user_${Date.now()}`;

  return {
    ...payload, ...{
      name: name,
      nameLowerCase: name,
    }
  };
}

// Prevent user's rights update
// and user name conflicts.
// TODO: Allow admins to update user's rights.
export const updateUserCheck = functions
  .region('europe-west3')
  .firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();

    if (!beforeData || !afterData) { return; }

    let payload: any = {};

    const params: DataUpdateParams = {
      beforeData,
      afterData,
      payload,
      docId: change.after.id,
    };

    payload = await checkRole(params);
    payload = await checkNameUpdate(params);

    if (Object.keys(payload).length === 0) { return; }

    if (payload.nameLowerCase) { // auto-update auth user's displayName
      const displayName = payload.name ?? afterData.name;

      await admin
        .auth()
        .updateUser(change.after.id, {
          displayName: displayName,
        });
    }

    return await change.after.ref
      .update(payload);
  });

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
