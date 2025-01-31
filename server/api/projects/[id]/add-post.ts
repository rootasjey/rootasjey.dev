// POST /api/projects/[id]/add-post
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'
import { getStorage } from 'firebase-admin/storage'
import { createPostData } from '~/server/utils/server.post'

/**
 * Handles the creation of a new post for a specific project. 
 * This function is the event handler for the POST /api/projects/[id]/add-post endpoint. 
 * It performs the following steps:
 * 1. Verifies the user's authentication token to ensure they are authorized to create a post.
 * 2. Reads the request body to extract the post data.
 * 3. Creates a new post document in the Firestore database.
 * 4. Uploads the post data to the Firebase Storage bucket.
 * 5. Returns the newly created post data.
 */
export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid
  const projectId = event.context.params?.id

  if (!projectId) {
    throw createError({
      statusCode: 400,
      message: "Project ID is required",
    })
  }

  const db = getFirestore()
  const projectDoc = await db
  .collection("projects")
  .doc(projectId)
  .get()

  if (!projectDoc.exists) {
    throw createError({
      statusCode: 404,
      message: "Project not found",
    })
  }

  if (projectDoc.data()?.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to create a post for this project",
    })
  }

  if (projectDoc.data()?.has_post) {
    throw createError({
      statusCode: 400,
      message: "This project already has a post",
    })
  }

  const body = await readBody(event)
  const postData = createPostData(body, userId)

  const postDoc = await db
  .collection("posts")
    .add({ 
      ...postData,
      ...{ 
        project_id: projectId,
        visibility: "project:private",
      },
    })

  const storage = getStorage()
  const bucket = storage.bucket()
  const file = bucket.file(`posts/${postDoc.id}/post.json`)
  await file.save(createPostFileContent(), {
    ...createPostFileMetadata({ 
      postId: postDoc.id, 
      projectId, 
      userId, 
    }),
  })

  await projectDoc.ref
  .update({
    has_post: true,
    post_id: postDoc.id,
    updated_at: new Date(),
  })

  return {
    ...postData,
    id: postDoc.id,
    canEdit: userId === postData.user_id,
    content: JSON.stringify(postData),
    created_at: new Date(postData.created_at),
    updated_at: new Date(postData.updated_at),
  }
})
