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
    const data = snapshot.data();
    const lang: string = data.lang ?? 'en';

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
    return true;
  });

export const onDeletePost = functions
  .region('europe-west3')
  .firestore
  .document('posts/{postId}')
  .onDelete(async (snapshot) => {
    const data = snapshot.data();
    const lang: string = data.lang ?? 'en';

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
    const data = snapshot.data();
    const lang: string = data.lang ?? 'en';

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
    return true;
  });

export const onDeleteProject = functions
  .region('europe-west3')
  .firestore
  .document('projects/{projectId}')
  .onDelete(async (snapshot) => {
    const data = snapshot.data();
    const lang: string = data.lang ?? 'en';

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
