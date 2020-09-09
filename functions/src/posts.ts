import * as functions from 'firebase-functions';
import { adminApp } from './adminApp';

const storage = adminApp.storage();
const auth = adminApp.auth();

export const onCreateFile = functions
  .region('europe-west3')
  .firestore
  .document('posts/{postId}')
  .onCreate(async (snapshot, context) => {
    const postFile = storage
      .bucket()
      .file(`blog/posts/${snapshot.id}/post.md`);

    await postFile.save('\n');
  });

export const onDeleteFile = functions
  .region('europe-west3')
  .firestore
  .document('posts/{postId}')
  .onDelete(async (snapshot, context) => {
    const postFile = storage
      .bucket()
      .file(`blog/posts/${snapshot.id}/post.md`);

    await postFile.delete();
  });

/**
 * Retrieve a post's content in markdown format.
 * (With accessibility check).
 */
export const fetch = functions
  .region('europe-west3')
  .https
  .onCall(async (data, context) => {
    const postId: string = data.postId;

    if (!postId) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'one (string) argument "postId" which is the post to fetch.');
    }

    const postFile = storage
      .bucket()
      .file(`blog/posts/${postId}/post.md`);

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
 * Save a post content.
 * (With accessibility check).
 */
export const save = functions
  .region('europe-west3')
  .https
  .onCall(async (data, context) => {
    const postId: string = data.postId;
    const jwt: string = data.jwt;
    const content: string = data.content;

    if (!content || !postId) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'two (string) arguments "postId": the post to save, "content": the post\'s content.');
    }

    try {
      const decodedToken = await auth.verifyIdToken(jwt, true);
      const date = new Date(decodedToken.exp);
      const now = new Date(Date.now());

      const yearDiff  = date.getUTCFullYear() - now.getUTCFullYear();
      const monthDiff = date.getMonth()       - now.getMonth();
      const dayDiff   = date.getDay()         - now.getDay();
      const hourDiff  = date.getHours()       - now.getHours();

      if (yearDiff <= 0 && monthDiff <= 0 && dayDiff <= 0 && hourDiff <= 0) {
        return { success: false, error: 'JWT expired' };
      }

    } catch (error) {
      return { success: false, error: error.toString() };
    }

    const postFile = storage
      .bucket()
      .file(`blog/posts/${postId}/post.md`);

    try {
      await postFile.save(content);
      return { success: true };

    } catch (error) {
      return { success: false, error: error.toString() };
    }
  });
