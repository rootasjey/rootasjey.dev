import * as functions from "firebase-functions";
import algolia from "algoliasearch";
import {cloudRegions, USER_PUBLIC_FIELDS_BASE_DOC} from "./utils";

const env = functions.config();

const client = algolia(env.algolia.appid, env.algolia.apikey);
const postsIndex = client.initIndex("posts");
const projectsIndex = client.initIndex("projects");
const usersIndex = client.initIndex("users");

// Post index
// ----------
export const onIndexPost = functions
    .region(cloudRegions.eu)
    .firestore
    .document("posts/{postId}")
    .onCreate(async (snapshot) => {
      const data = snapshot.data();
      const objectID = snapshot.id;

      if (!data.visibility || data.visibility !== "public") {
        return;
      }

      return postsIndex.saveObject({
        objectID,
        ...data,
      });
    });

export const onReIndexPost = functions
    .region(cloudRegions.eu)
    .firestore
    .document("posts/{postId}")
    .onUpdate(async (snapshot) => {
      const beforeData = snapshot.before.data();
      const afterData = snapshot.after.data();
      const objectID = snapshot.after.id;

      const beforeVisibility = beforeData.visibility;
      const afterVisibility = afterData.visibility;

      if (beforeVisibility !== afterVisibility &&
          afterVisibility !== "public") {
        return postsIndex.deleteObject(objectID);
      }

      return postsIndex.saveObject({
        objectID,
        ...afterData,
      });
    });

export const onUnIndexPost = functions
    .region(cloudRegions.eu)
    .firestore
    .document("posts/{postId}")
    .onDelete(async (snapshot) => {
      const objectID = snapshot.id;
      return postsIndex.deleteObject(objectID);
    });

// Projects index
// --------------
export const onIndexProject = functions
    .region(cloudRegions.eu)
    .firestore
    .document("projects/{projectId}")
    .onCreate(async (snapshot) => {
      const data = snapshot.data();
      const objectID = snapshot.id;

      if (!data.visibility || data.visibility !== "public") {
        return;
      }

      return projectsIndex.saveObject({
        objectID,
        ...data,
      });
    });

export const onReIndexProject = functions
    .region(cloudRegions.eu)
    .firestore
    .document("projects/{projectId}")
    .onUpdate(async (snapshot) => {
      const beforeData = snapshot.before.data();
      const afterData = snapshot.after.data();
      const objectID = snapshot.after.id;

      const beforeVisibility = beforeData.visibility;
      const afterVisibility = afterData.visibility;

      if (beforeVisibility !== afterVisibility &&
          afterVisibility !== "public") {
        return postsIndex.deleteObject(objectID);
      }

      return projectsIndex.saveObject({
        objectID,
        ...afterData,
      });
    });

export const onUnIndexProject = functions
    .region(cloudRegions.eu)
    .firestore
    .document("projects/{projectId}")
    .onDelete(async (snapshot) => {
      const objectID = snapshot.id;
      return projectsIndex.deleteObject(objectID);
    });

// Users index
// --------------
export const onIndexUser = functions
    .region(cloudRegions.eu)
    .firestore
    .document(USER_PUBLIC_FIELDS_BASE_DOC)
    .onCreate(async (snapshot) => {
      const data = snapshot.data();
      const objectID = snapshot.id;

      return usersIndex.saveObject({
        objectID,
        ...data,
      });
    });

export const onReIndexUser = functions
    .region(cloudRegions.eu)
    .firestore
    .document(USER_PUBLIC_FIELDS_BASE_DOC)
    .onUpdate(async (snapshot) => {
      const afterData = snapshot.after.data();
      const objectID = snapshot.after.id;

      return usersIndex.saveObject({
        objectID,
        ...afterData,
      });
    });

export const onUnIndexUser = functions
    .region(cloudRegions.eu)
    .firestore
    .document(USER_PUBLIC_FIELDS_BASE_DOC)
    .onDelete(async (snapshot) => {
      const objectID = snapshot.id;
      return usersIndex.deleteObject(objectID);
    });
