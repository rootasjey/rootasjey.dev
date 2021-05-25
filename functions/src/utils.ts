import * as functions from 'firebase-functions';
import { adminApp } from './adminApp';

export const cloudRegions = {
  eu: 'europe-west3'
};

export async function checkUserIsSignedIn(
  context: functions.https.CallableContext,
  idToken: string,
) {
  const userAuth = context.auth;

  if (!userAuth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      `The function must be called from an authenticated user (2).`,
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
      'unauthenticated',
      `Your session has expired. Please (sign out and) sign in again.`,
    );
  }
}
