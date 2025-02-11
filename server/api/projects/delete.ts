// DELETE /api/projects/:id
// Delete a project from SurrealDB
import { RecordId } from 'surrealdb'
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { db, connect, decodeJWT } = useSurrealDB()
  const id = event.context.params?.id
  if (!id) {
    throw createError({
      statusCode: 400,
      message: 'Project ID (`id`) is required.',
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
  const projectRecordParts = id.split(":")
  const projectRecordId = new RecordId(projectRecordParts[0], projectRecordParts[1])
  const project = await db.select(projectRecordId)

  if (!project) {
    throw createError({
      statusCode: 404,
      message: 'Project not found.',
    })
  }

  if (!userRecordId.equals(project.author)) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this project",
    })
  }
  await db.delete(projectRecordId)

  return {
    message: "Project deleted successfully",
    id,
  }
})
