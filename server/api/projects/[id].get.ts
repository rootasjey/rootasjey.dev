// GET /api/projects/[id]
import { RecordId } from 'surrealdb'
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { db, connect, decodeJWT } = useSurrealDB()
  const projectId = event.context.params?.id
  if (!projectId) {
    throw createError({
      statusCode: 400,
      message: 'Project ID is required',
    })
  }

  await connect()
  let userRecordId = null

  const rawToken = getHeader(event, "Authorization")
  if (rawToken) {
    const token = rawToken.replace('Bearer ', '').replace('token=', '')
    const decoded = decodeJWT(token)
    const idParts = decoded.ID.split(":")
    userRecordId = new RecordId(idParts[0], idParts[1])
    await db.authenticate(token)
  }

  const projectRecordParts = projectId.split(":")
  const projectRecordId = new RecordId(projectRecordParts[0], projectRecordParts[1])
  const project = await db.select(projectRecordId)

  if (!project) {
    throw createError({
      statusCode: 404,
      message: 'Project not found',
    })
  }

  if (project.visibility !== "public" && !userRecordId?.equals(project.author)) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to view this project',
    })
  }

  return project
})
