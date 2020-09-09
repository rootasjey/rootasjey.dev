import * as functions from 'firebase-functions';
import { adminApp } from './adminApp';

const firestore = adminApp.firestore();
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

    await postFile.save('');
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

    /** Used if the post is a draft or restricted to some members. */
    const jwt: string = data.jwt;

    if (!postId) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'one (string) argument "postId" which is the post to fetch.');
    }

    await checkAccessControl({postId, jwt});

    // Retrieve content (access control OK)
    const postFile = storage
      .bucket()
      .file(`blog/posts/${postId}/post.md`);

    let postContent = '';

    const stream = postFile.createReadStream();

    stream.on('data', (chunck) => {
      postContent = postContent.concat(chunck.toString());
    });

    await new Promise(fulfill => stream.on('end', fulfill));
    stream.destroy();

    return { post: postContent };
  });

async function checkAccessControl({postId, jwt}: {postId: string, jwt: string}) {
  try { // Access Control
    const postSnapshot = await firestore
      .collection('posts')
      .doc(postId)
      .get();

    if (!postSnapshot.exists) {
      throw new functions.https.HttpsError('not-found', 'The post asked does not exist anymore.' +
        ' You may be asking a deleted post.');
    }

    const postData = postSnapshot.data();

    if (!postData) {
      throw new functions.https.HttpsError('data-loss', 'The post data is null, which is weird.' +
        ' Please contact us <3.');
    }

    if (!postData['published']) {
      if (!jwt) {
        throw new functions.https.HttpsError('unauthenticated', 'The post asked is a draft' +
          ' and you do not have the right to get its content.');
      }

      const decodedToken = await auth.verifyIdToken(jwt, true);

      let hasAuthorAccess = false;

      if (postData['author'] === decodedToken.uid) {
        hasAuthorAccess = true;

      } else if (postData['coauthors'].indexOf(decodedToken.uid) > -1) {
        hasAuthorAccess = true;
      }

      if (!hasAuthorAccess) {
        throw new functions.https.HttpsError('permission-denied', 'You do not have the right' +
          " to view this post's content.");
      }
    } else if (postData['restrictedTo'].premium) {
      // TODO: Handle premium users.
    }

  } catch (error) {
    throw new functions.https.HttpsError('internal', 'There was an internal error' +
      ' while retrieving the post content. Your JWT may be outdated.');
  }
}

/**
 * Save a post content.
 * (With accessibility check).
 */
export const save = functions
  .region('europe-west3')
  .https
  .onCall(async (data, context) => {
    const postId: string = data.postId;
    // const jwt: string = data.jwt;
    const content: string = data.content;

    if (!content || !postId) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'two (string) arguments "postId": the post to save, "content": the post\'s content.');
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
