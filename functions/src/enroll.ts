import * as functions from 'firebase-functions';
import { Domain } from 'domain-check';
import { cloudRegions } from './utils';

/**
 * Check domain name availability.
 */
export const domainCheck = functions
  .region(cloudRegions.eu)
  .https
  .onCall(async (data) => {
    const domainName: string = data.domain;

    if (!domainName) {
      throw new functions.https.HttpsError(
        'invalid-argument', 
        `The function must be called with one (string) argument 
        "domain" which is the domain to check.`,
      );
    }

    const isFree = await Domain.isFree(domainName);
    return { isFree };
  });
