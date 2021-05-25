import * as functions from 'firebase-functions';
import { adminApp } from './adminApp';
import { cloudRegions } from './utils';

const firestore = adminApp.firestore();
const storage = adminApp.storage();
const auth = adminApp.auth();

export const onCreateFile = functions
  .region(cloudRegions.eu)
  .firestore
  .document('posts/{postId}')
  .onCreate(async (snapshot) => {
    const postFile = storage
      .bucket()
      .file(`blog/posts/${snapshot.id}/post.md`);

    await postFile.save('');
  });

export const onDeleteFile = functions
  .region(cloudRegions.eu)
  .firestore
  .document('posts/{postId}')
  .onDelete(async (snapshot) => {
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
  .region(cloudRegions.eu)
  .https
  .onCall(async (data) => {
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

export const fetchAuthorName = functions
  .region(cloudRegions.eu)
  .https
  .onCall(async (data) => {
    const authorId = data.authorId;

    if (!authorId) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'one (string) argument "authorId" which is the author to fetch.');
    }

    const author = await firestore
      .collection('users')
      .doc(authorId)
      .get();

    const authorData = author.data();

    if (!authorData) {
      throw new functions.https.HttpsError('data-loss', 'No data found for author ' +
        `${authorId}. They may have been an issue while creating or deleting this author.`);
    }

    return { authorName: authorData.name };
  });

  /**
   * Increase/Decrease [post.stats.likes] property by 1.
   * Need a [postId] parameter.
   */
export const statsLike = functions
  .region(cloudRegions.eu)
  .https
  .onCall(async (data) => {
    const postId = data.postId;
    const like: boolean = data.like ?? false;

    if (!postId) {
      throw new functions.https.HttpsError(
        'invalid-argument', 
        `The function must be called with a (string) argument "postId" which is the post to update.`,
      );
    }

    const postSnap = await firestore
      .collection('posts')
      .doc(postId)
      .get();

    const postData = postSnap.data();

    if (!postSnap || !postSnap.exists || !postData) {
      throw new functions.https.HttpsError(
        'not-found', 
        `The post to update doesn't exist anymore. It may have been deleted.`,
      );
    }

    let statsLikes: number = postData.stats?.likes ?? 0;

    statsLikes = like ? statsLikes + 1 : statsLikes - 1;
    statsLikes = statsLikes > 0 ? statsLikes : 0;

    await postSnap.ref.update({
      'stats.likes': statsLikes,
    });

    return {
      post: { id: postId },
      success: true,
      likes: statsLikes,
    }
  });

/**
 * Increase [post.stats.shares] property by 1.
 * Need [postId] parameter.
 */
export const statsShare = functions
  .region(cloudRegions.eu)
  .https
  .onCall(async (data) => {
    const postId = data.postId;

    if (!postId) {
      throw new functions.https.HttpsError(
        'invalid-argument', 
        `The function must be called with a (string) argument "postId" which is the post to update.`,
      );
    }

    const postSnap = await firestore
      .collection('posts')
      .doc(postId)
      .get();

    const postData = postSnap.data();

    if (!postSnap || !postSnap.exists || !postData) {
      throw new functions.https.HttpsError(
        'not-found', 
        `The post to update doesn't exist anymore. It may have been deleted.`,
      );
    }

    let statsShares: number = postData.stats?.shares ?? 0;
    statsShares += 1;

    await postSnap.ref.update({
      'stats.shares': statsShares,
    });

    return {
      post: { id: postId },
      success: true,
      shares: statsShares,
    }
  });

async function checkAccessControl({postId, jwt}: {postId: string, jwt: string}) {
  try {
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
        ' Please contact us.');
    }

    if (!postData['published']) {
      if (!jwt) {
        throw new functions.https.HttpsError('unauthenticated', 'The post asked is a draft' +
          ' and you do not have the right to get its content.');
      }

      const decodedToken = await auth.verifyIdToken(jwt, true);

      let hasAuthorAccess = false;

      if (postData['author']['id'] === decodedToken.uid) {
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
  .region(cloudRegions.eu)
  .https
  .onCall(async (data) => {
    const postId: string = data.postId;
    const jwt: string = data.jwt;
    const content: string = data.content;

    if (!content || !postId) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'two (string) arguments "postId": the post to save, "content": the post\'s content.');
    }

    await checkAccessControl({postId, jwt});

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
