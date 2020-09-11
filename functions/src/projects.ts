import * as functions from 'firebase-functions';
import { adminApp } from './adminApp';

const firestore = adminApp.firestore();
const storage = adminApp.storage();
const auth = adminApp.auth();

export const onCreateFile = functions
  .region('europe-west3')
  .firestore
  .document('projects/{projectId}')
  .onCreate(async (snapshot, context) => {
    const projectFile = storage
      .bucket()
      .file(`blog/projects/${snapshot.id}/post.md`);

    await projectFile.save('');
  });

export const onDeleteFile = functions
  .region('europe-west3')
  .firestore
  .document('projects/{projectId}')
  .onDelete(async (snapshot, context) => {
    const projectFile = storage
      .bucket()
      .file(`blog/projects/${snapshot.id}/post.md`);

    await projectFile.delete();
  });

/**
 * Retrieve a project's content in markdown format.
 * (With accessibility check).
 */
export const fetch = functions
  .region('europe-west3')
  .https
  .onCall(async (data, context) => {
    const projectId: string = data.projectId;

    /** Used if the project is a draft or restricted to some members. */
    const jwt: string = data.jwt;

    if (!projectId) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'one (string) argument "projectId" which is the project to fetch.');
    }

    await checkAccessControl({projectId, jwt});

    // Retrieve content (access control OK)
    const projectFile = storage
      .bucket()
      .file(`blog/projects/${projectId}/post.md`);

    let projectContent = '';

    const stream = projectFile.createReadStream();

    stream.on('data', (chunck) => {
      projectContent = projectContent.concat(chunck.toString());
    });

    await new Promise(fulfill => stream.on('end', fulfill));
    stream.destroy();

    return { project: projectContent };
  });

export const fetchAuthorName = functions
  .region('europe-west3')
  .https
  .onCall(async (data, context) => {
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

async function checkAccessControl({ projectId, jwt }: { projectId: string, jwt: string}) {
  try {
    const projectSnapshot = await firestore
      .collection('projects')
      .doc(projectId)
      .get();

    if (!projectSnapshot.exists) {
      throw new functions.https.HttpsError('not-found', 'The project asked does not exist anymore.' +
        ' You may be asking a deleted project.');
    }

    const projectData = projectSnapshot.data();

    if (!projectData) {
      throw new functions.https.HttpsError('data-loss', 'The project data is null, which is weird.' +
        ' Please contact us.');
    }

    if (!projectData['published']) {
      if (!jwt) {
        throw new functions.https.HttpsError('unauthenticated', 'The project asked is a draft' +
          ' and you do not have the right to get its content.');
      }

      const decodedToken = await auth.verifyIdToken(jwt, true);

      let hasAuthorAccess = false;

      if (projectData['author'] === decodedToken.uid) {
        hasAuthorAccess = true;

      } else if (projectData['coauthors'].indexOf(decodedToken.uid) > -1) {
        hasAuthorAccess = true;
      }

      if (!hasAuthorAccess) {
        throw new functions.https.HttpsError('permission-denied', 'You do not have the right' +
          " to view this project's content.");
      }
    } else if (projectData['restrictedTo'].premium) {
      // TODO: Handle premium users.
    }

  } catch (error) {
    throw new functions.https.HttpsError('internal', 'There was an internal error' +
      ' while retrieving the project content. Your JWT may be outdated.');
  }
}

/**
 * Save a project content.
 * (With accessibility check).
 */
export const save = functions
  .region('europe-west3')
  .https
  .onCall(async (data, context) => {
    const projectId: string = data.projectId;
    const jwt: string = data.jwt;
    const content: string = data.content;

    if (!content || !projectId) {
      throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'two (string) arguments "projecId": the project to save, "content": the project\'s content.');
    }

    await checkAccessControl({ projectId, jwt });

    const projectFile = storage
      .bucket()
      .file(`blog/projects/${projectId}/post.md`);

    try {
      await projectFile.save(content);
      return { success: true };

    } catch (error) {
      return { success: false, error: error.toString() };
    }
  });
