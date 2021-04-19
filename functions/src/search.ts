import * as functions from 'firebase-functions';
import algolia from 'algoliasearch';

const env = functions.config();

const client = algolia(env.algolia.appid, env.algolia.apikey);
const postsIndex = client.initIndex('posts');
const projectsIndex = client.initIndex('projects');

// Post index
// ----------
export const onIndexPost = functions
  .region('europe-west3')
  .firestore
  .document('posts/{postId}')
  .onCreate(async (snapshot) => {
    const data = snapshot.data();
    const objectID = snapshot.id;

    const published = data['published'];
    const referenced = data['referenced'];

    if (!published || !referenced) {
      return;
    }

    return postsIndex.saveObject({
      objectID,
      ...data,
    })
  });

export const onReIndexPost = functions
  .region('europe-west3')
  .firestore
  .document('posts/{postId}')
  .onUpdate(async (snapshot) => {
    const beforeData = snapshot.before.data();
    const afterData = snapshot.after.data();
    const objectID = snapshot.after.id;

    const beforePublished = beforeData['published'];
    const beforeReferenced = beforeData['referenced'];

    const afterPublished = afterData['published'];
    const afterReferenced = afterData['referenced'];

    if (((beforePublished !== afterPublished) && !afterPublished) || 
      ((beforeReferenced !== afterReferenced) && !afterReferenced)) {
      return postsIndex.deleteObject(objectID);
    }

    return postsIndex.saveObject({
      objectID,
      ...afterData,
    })
  });

export const onUnIndexPost = functions
  .region('europe-west3')
  .firestore
  .document('posts/{postId}')
  .onDelete(async (snapshot) => {
    const objectID = snapshot.id;
    return postsIndex.deleteObject(objectID);
  });

// Projects index
// --------------
export const onIndexProject = functions
  .region('europe-west3')
  .firestore
  .document('projects/{projectId}')
  .onCreate(async (snapshot) => {
    const data = snapshot.data();
    const objectID = snapshot.id;

    const published = data['published'];
    const referenced = data['referenced'];

    if (!published || !referenced) {
      return;
    }

    return projectsIndex.saveObject({
      objectID,
      ...data,
    })
  });

export const onReIndexProject = functions
  .region('europe-west3')
  .firestore
  .document('projects/{projectId}')
  .onUpdate(async (snapshot) => {
    const beforeData = snapshot.before.data();
    const afterData = snapshot.after.data();
    const objectID = snapshot.after.id;

    // Prevent update index on stats changes
    let statsChanged = false;

    if ((beforeData.stats && afterData.stats)
      && (beforeData.stats.likes !== afterData.stats.likes
        || beforeData.stats.shares !== afterData.stats.shares)) {
      statsChanged = true;
    }

    if (statsChanged) {
      return;
    }

    const beforePublished = beforeData['published'];
    const beforeReferenced = beforeData['referenced'];

    const afterPublished = afterData['published'];
    const afterReferenced = afterData['referenced'];

    if (((beforePublished !== afterPublished) && !afterPublished) ||
      ((beforeReferenced !== afterReferenced) && !afterReferenced)) {
      return postsIndex.deleteObject(objectID);
    }


    return projectsIndex.saveObject({
      objectID,
      ...afterData,
    })
  });

export const onUnIndexProject = functions
  .region('europe-west3')
  .firestore
  .document('projects/{projectId}')
  .onDelete(async (snapshot) => {
    const objectID = snapshot.id;
    return projectsIndex.deleteObject(objectID);
  });
