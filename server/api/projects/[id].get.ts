import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const projectId = event.context.params?.id

  let userId = ""
  if (!projectId) {
    throw createError({
      statusCode: 400,
      message: 'Project ID is required',
    })
  }

  const userIdToken = getHeader(event, "Authorization")
  if (userIdToken) {
    const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
    userId = decodedToken.uid
  }

  const db = getFirestore()

  const projectDoc = await db.collection("projects")
    .doc(projectId)
    .get()

  const projectData = projectDoc.data()
  if (!projectDoc.exists || !projectData) {
    throw createError({
      statusCode: 404,
      message: 'Project not found',
    })
  }

  if (projectData.visibility !== "public" && projectData?.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to view this project',
    })
  }

  return {
    id: projectDoc.id,
    ...projectData,
  }
})
