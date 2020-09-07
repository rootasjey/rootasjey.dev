import * as functions from 'firebase-functions';
import { adminApp } from './adminApp';

const storage = adminApp.storage();

/**
 * Retrieve a project's content in markdown format.
 * (With accessibility check).
 */
export const fetch = functions
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
