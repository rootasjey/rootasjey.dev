import * as functions from 'firebase-functions';
import { Domain } from 'domain-check';

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const domainCheck = functions
.region('europe-west3')
.https
.onCall(async (data, context) => {
  const domainName: string = data.domain;

  if (!domainName) {
    throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
      'one (string) argument "domain" which is the domain to check.');
  }

  const isFree = await Domain.isFree(domainName);
  return { isFree };
});
