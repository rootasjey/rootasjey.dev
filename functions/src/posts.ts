import * as functions from 'firebase-functions';
import { adminApp } from './adminApp';

const storage = adminApp.storage();

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
