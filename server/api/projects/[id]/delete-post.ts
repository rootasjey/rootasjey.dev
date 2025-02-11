// DELETE /api/projects/[id]/delete-post.ts
import { RecordId } from 'surrealdb'
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { db, connect, decodeJWT } = useSurrealDB()
  const projectId = event.context.params?.id
  if (!projectId) {
    throw createError({
      statusCode: 400,
      message: "Project ID is required",
    })
  }

  const rawToken = getHeader(event, "Authorization")
  if (!rawToken) {
    throw createError({
      statusCode: 401,
      message: "Unauthorized",
    })
  }

  const token = rawToken.replace('Bearer ', '').replace('token=', '')
  const decoded = decodeJWT(token)
  const idParts = decoded.ID.split(":")
  const userRecordId = new RecordId(idParts[0], idParts[1])

  await connect()
  await db.authenticate(token)

  const projectRecordParts = projectId.split(":")
  const projectRecordId = new RecordId(projectRecordParts[0], projectRecordParts[1])
  const project = await db.select(projectRecordId)

  if (!project) {
    throw createError({
      statusCode: 404,
      message: "Project not found",
    })
  }

  if (!userRecordId.equals(project.author)) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this post",
    })
  }

  if (!project.post) {
    throw createError({
      statusCode: 400,
      message: "Project does not have a post",
    })
  }

  await db.delete(project.post as RecordId)

  await db.merge(projectRecordId, {
    post: null,
  })

  return {
    success: true,
    message: "Post deleted successfully"
  }
})
