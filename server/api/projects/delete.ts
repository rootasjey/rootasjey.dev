// Delete a project from Firestore
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid
  
  const db = getFirestore()
  const body = await readBody(event)
  
  const { id } = body
  const project = await db.collection("projects").doc(id).get()
  const projectData = project.data()

  if (projectData?.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this project",
    })
  }

  await db.collection("projects").doc(id).delete()
  return {
    message: "Project deleted successfully",
    id,
  }
})