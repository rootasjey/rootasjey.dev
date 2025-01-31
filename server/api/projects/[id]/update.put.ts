import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid

  if (!userId) {
    throw createError({
      statusCode: 401,
      message: 'Unauthorized',
    })
  }

  const projectId = event.context.params?.id
  const body = await readBody(event)
  const db = getFirestore()

  if (!projectId) {
    throw createError({
      statusCode: 400,
      message: 'Project ID is required',
    })
  }

  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: 'Project name is required',
    })
  }
  
  await db.collection('projects')
    .doc(projectId)
    .update({
      name: body.name,
      description: body.description ?? "",
      category: body.category ?? "default",
      company: body.company ?? "",
      slug: body.slug ?? body.name.toLowerCase().replaceAll(" ", "-"),
      visibility: body.visibility ?? "private",
      updatedAt: new Date(),
    })

  return {
    success: true,
    message: 'Project updated successfully',
  }
})
