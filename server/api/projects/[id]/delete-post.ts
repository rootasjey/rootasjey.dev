// /api/projects/[id]/delete-post.ts
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'
import { getStorage } from 'firebase-admin/storage'

/**
 * Handles the deletion of a post for a specific project.
 * This function is the event handler for the DELETE /api/projects/[id]/delete-post endpoint.
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

  const projectData = projectDoc.data()
  if (!projectDoc.exists || !projectData) {
    throw createError({
      statusCode: 404,
      message: "Project not found",
    })
  }

  if (projectData.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this post",
    })
  }

  if (!projectData.has_post) {
    throw createError({
      statusCode: 400,
      message: "This project does not have a post",
    })
  }

  await db
  .collection("posts")
  .doc(projectData.post_id)
  .delete()

  const storage = getStorage()
  const bucket = storage.bucket()

  // Delete the folder and all its contents located at the path
  const folderPath = `posts/${projectData.post_id}`
  await bucket.deleteFiles({ prefix: folderPath })

  await projectDoc.ref
  .update({
    has_post: false,
    post_id: "",
    updated_at: new Date(),
  })
})
