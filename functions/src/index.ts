import * as admin     from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Domain }     from 'domain-check';

admin.initializeApp();

const storage = admin.storage();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

/**
 * Check domain name availability.
 */
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

/**
 * Retrieve a post's content in markdown format.
 * (With accessibility check).
 */
export const fetchPost = functions
.region('europe-west3')
.https
.onCall(async (data, context) => {
  const postId: string = data.postId;

  if (!postId) {
    throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
      'one (string) argument "postId" which is the post to fetch.');
  }

  const postFile = storage.bucket().file(`blog/posts/${postId}/post.md`);
  let postData = '';

  const stream = postFile.createReadStream();

  stream.on('data', (chunck) => {
    postData = postData.concat(chunck.toString());
  });

  await new Promise(fulfill => stream.on('end', fulfill));
  stream.destroy();

  return { post: postData };
});

/**
 * Retrieve a project's content in markdown format.
 * (With accessibility check).
 */
export const fetchProject = functions
.region('europe-west3')
.https
.onCall(async (data, context) => {
  const projectId: string = data.projectId;

  if (!projectId) {
    throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
      'one (string) argument "projectId" which is the project to fetch.');
  }

  const projectFile = storage.bucket().file(`projects/${projectId}/project.md`);
  let projectData = '';

  const stream = projectFile.createReadStream();

  stream.on('data', (chunck) => {
    projectData = projectData.concat(chunck.toString());
  });

  await new Promise(fulfill => stream.on('end', fulfill));
  stream.destroy();

  return { project: projectData };
});
