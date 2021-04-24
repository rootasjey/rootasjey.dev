import * as functions from 'firebase-functions';
import { adminApp } from './adminApp';

const firestore = adminApp.firestore();

// -------
// Authors
// -------
export const onCreateAuthors = functions
  .region('europe-west3')
  .firestore
  .document('authors/{authorId}')
  .onCreate(async () => {
    const statsSnap = await firestore
      .collection('stats')
      .doc('authors')
      .get();

    const statsData = statsSnap.data();

    if (!statsSnap.exists || !statsData) {
      return false;
    }

    const total: number = statsData.total + 1;
    const payload: Record<string, number> = { total };

    await statsSnap.ref.update(payload);
    return true;
  });

export const onDeleteAuthor = functions
  .region('europe-west3')
  .firestore
  .document('authors/{authorId}')
  .onDelete(async () => {
    const statsSnap = await firestore
      .collection('stats')
      .doc('authors')
      .get();

    const statsData = statsSnap.data();

    if (!statsSnap.exists || !statsData) {
      return false;
    }

    const total = Math.max(0, statsData.total - 1);
    const payload: Record<string, number> = { total };

    await statsSnap.ref.update(payload);
    return true;
  });

// -----
// Posts
// -----
export const onCreatePost = functions
  .region('europe-west3')
  .firestore
  .document('posts/{postId}')
  .onCreate(async (snapshot) => {
    const postData = snapshot.data();
    const lang: string = postData.lang ?? 'en';

    const statsSnap = await firestore
      .collection('stats')
      .doc('posts')
      .get();

    const statsData = statsSnap.data();

    if (!statsSnap.exists || !statsData) {
      return false;
    }

    const total: number = statsData.total + 1;
    const payload: Record<string, number> = { total };

    if (lang && statsData[lang]) {
      payload[lang] = statsData[lang] + 1;
    }

    await statsSnap.ref.update(payload);
    await updateAuthorPostStats(postData);
    return true;
  });

export const onDeletePost = functions
  .region('europe-west3')
  .firestore
  .document('posts/{postId}')
  .onDelete(async (snapshot) => {
    const postData = snapshot.data();
    const lang: string = postData.lang ?? 'en';

    const statsSnap = await firestore
      .collection('stats')
      .doc('posts')
      .get();

    const statsData = statsSnap.data();

    if (!statsSnap.exists || !statsData) {
      return false;
    }

    const total = Math.max(0, statsData.total - 1);
    const payload: Record<string, number> = { total };

    if (lang && statsData[lang]) {
      payload[lang] = Math.max(0, statsData[lang] - 1);
    }

    await statsSnap.ref.update(payload);
    await updateAuthorPostStats(postData, false);
    return true;
  });

export const onUpdatePost = functions
  .region('europe-west3')
  .firestore
  .document('posts/{postId}')
  .onUpdate(async (snapshot) => {
    const beforePostData = snapshot.before.data();
    const afterPostData = snapshot.after.data();

    if (beforePostData.published === afterPostData.published) {
      return true;
    }

    const authorSnap = await firestore
      .collection('users')
      .doc(afterPostData.author.id)
      .get();

    const authorData = authorSnap.data();

    if (!authorSnap.exists || !authorData) {
      return true;
    }

    const payload = {
      'stats.posts.drafts': authorData.stats.posts ?? 0,
      'stats.posts.published': authorData.stats.posts ?? 0,
    };

    if (!beforePostData.published && afterPostData.published) {
      payload['stats.posts.drafts'] = Math.max(0, payload['stats.posts.drafts'] - 1);
      payload['stats.posts.published'] = payload['stats.posts.published'] + 1;

    } else if (beforePostData.published && !afterPostData.published) {
      payload['stats.posts.published'] = Math.max(0, payload['stats.posts.published'] - 1);
      payload['stats.posts.drafts'] = payload['stats.posts.drafts'] + 1;
    }

    await authorSnap.ref.update(payload);
    return true;
  });

// --------
// Projects
// --------
export const onCreateProject = functions
  .region('europe-west3')
  .firestore
  .document('projects/{projectId}')
  .onCreate(async (snapshot) => {
    const projectData = snapshot.data();
    const lang: string = projectData.lang ?? 'en';

    const statsSnap = await firestore
      .collection('stats')
      .doc('projects')
      .get();

    const statsData = statsSnap.data();

    if (!statsSnap.exists || !statsData) {
      return false;
    }

    const total: number = statsData.total + 1;
    const payload: Record<string, number> = { total };

    if (lang && statsData[lang]) {
      payload[lang] = statsData[lang] + 1;
    }

    await statsSnap.ref.update(payload);
    await updateAuthorProjectStats(projectData);
    return true;
  });

export const onDeleteProject = functions
  .region('europe-west3')
  .firestore
  .document('projects/{projectId}')
  .onDelete(async (snapshot) => {
    const projectData = snapshot.data();
    const lang: string = projectData.lang ?? 'en';

    const statsSnap = await firestore
      .collection('stats')
      .doc('projects')
      .get();

    const statsData = statsSnap.data();

    if (!statsSnap.exists || !statsData) {
      return false;
    }

    const total = Math.max(0, statsData.total - 1);
    const payload: Record<string, number> = { total };

    if (lang && statsData[lang]) {
      payload[lang] = Math.max(0, statsData[lang] - 1);
    }

    await statsSnap.ref.update(payload);
    await updateAuthorProjectStats(projectData, false);
    return true;
  });

/**
 * Update user's projects stats.
 */
export const onUpdateProject = functions
  .region('europe-west3')
  .firestore
  .document('projects/{projectId}')
  .onUpdate(async (snapshot) => {
    const beforePostData = snapshot.before.data();
    const afterPostData = snapshot.after.data();

    if (beforePostData.published === afterPostData.published) {
      return true;
    }

    const authorSnap = await firestore
      .collection('users')
      .doc(afterPostData.author.id)
      .get();

    const authorData = authorSnap.data();

    if (!authorSnap.exists || !authorData) {
      return true;
    }

    const payload = {
      'stats.projects.drafts': authorData.stats.projects ?? 0,
      'stats.projects.published': authorData.stats.projects ?? 0,
    };

    if (!beforePostData.published && afterPostData.published) {
      payload['stats.projects.drafts'] = Math.max(0, payload['stats.projects.drafts'] - 1);
      payload['stats.projects.published'] = payload['stats.projects.published'] + 1;

    } else if (beforePostData.published && !afterPostData.published) {
      payload['stats.projects.published'] = Math.max(0, payload['stats.projects.published'] - 1);
      payload['stats.projects.drafts'] = payload['stats.projects.drafts'] + 1;
    }

    await authorSnap.ref.update(payload);
    return true;
  });

// -----
// Users
// -----
export const onCreateUser = functions
  .region('europe-west3')
  .firestore
  .document('users/{userId}')
  .onCreate(async (snapshot) => {
    const data = snapshot.data();
    const userRole: string = data.role ?? 'user';

    const statsSnap = await firestore
      .collection('stats')
      .doc('users')
      .get();

    const statsData = statsSnap.data();

    if (!statsSnap.exists || !statsData) {
      return false;
    }

    const total: number = statsData.total + 1;
    const payload: Record<string, number> = { total };

    const role = getStatsRole(userRole);

    if (role && statsData[role]) {
      payload[role] = Math.max(0, statsData[role] - 1);
    }

    await statsSnap.ref.update(payload);
    return true;
  });

export const onDeleteUser = functions
  .region('europe-west3')
  .firestore
  .document('users/{userId}')
  .onDelete(async (snapshot) => {
    const data = snapshot.data();
    const userRole: string = data.role;

    const statsSnap = await firestore
      .collection('stats')
      .doc('users')
      .get();

    const statsData = statsSnap.data();

    if (!statsSnap.exists || !statsData) {
      return false;
    }

    const total = Math.max(0, statsData.total - 1);
    const payload: Record<string, number> = { total };

    const role = getStatsRole(userRole);

    if (role && statsData[role]) {
      payload[role] = Math.max(0, statsData[role] - 1);
    }
    
    await statsSnap.ref.update(payload);
    return true;
  });

/**
 * 
 * @param role - User's role to convert.
 * @returns Return the corresponding stats' doc key.
 */
function getStatsRole(role: string) {
  switch (role) {
    case 'admin':
      return 'administrators';
    case 'author':
      return 'authors';
    case 'contributor':
      return 'contributors';
    case 'editor':
      return 'editors';
    case 'owner':
      return 'owners';
    case 'user':
      return 'users';
    default:
      return 'users';
  }
}

/**
 * Update author's post stats.
 * @param postData Firestore document which triggered the cloud function.
 * @param add True if stats should be incremented (+1). False if stats should be decremented (-1).
 * @returns True if the update succeded. False otherwise.
 */
async function updateAuthorPostStats(postData: any, add: boolean = true) {
  const authorId: string = postData.author.id;

  const authorSnap = await firestore
    .collection('users')
    .doc(authorId)
    .get();

  const authorData = authorSnap.data();

  if (!authorSnap.exists || !authorData) {
    return false;
  }

  if (postData.published) {
    let published: number = authorData.stats.posts.published ?? 0;
    published = add ? published + 1 : Math.max(0, published - 1);

    await authorSnap.ref.update({
      'stats.posts.published': published,
    });

    return true;
  }

  let drafts: number = authorData.stats.posts.drafts ?? 0;
  drafts = add ? drafts + 1 : Math.max(0, drafts - 1);

  await authorSnap.ref.update({
    'stats.posts.drafts': drafts,
  });

  return true;
}

/**
 * Update author's projects stats.
 * @param postData Firestore document which triggered the cloud function.
 * @param add True if stats should be incremented (+1). False if stats should be decremented (-1).
 * @returns True if the update succeded. False otherwise.
 */
async function updateAuthorProjectStats(postData: any, add: boolean = true) {
  const authorId: string = postData.author.id;

  const authorSnap = await firestore
    .collection('users')
    .doc(authorId)
    .get();

  const authorData = authorSnap.data();

  if (!authorSnap.exists || !authorData) {
    return false;
  }

  if (postData.published) {
    let published: number = authorData.stats.projects.published ?? 0;
    published = add ? published + 1 : Math.max(0, published - 1);

    await authorSnap.ref.update({
      'stats.projects.published': published,
    });

    return true;
  }

  let drafts: number = authorData.stats.projects.drafts ?? 0;
  drafts = add ? drafts + 1 : Math.max(0, drafts - 1);

  await authorSnap.ref.update({
    'stats.projects.drafts': drafts,
  });

  return true;
}
