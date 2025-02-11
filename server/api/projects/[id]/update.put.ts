// PUT /api/projects/[id]/update
import { RecordId } from 'surrealdb'
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { db, connect, decodeJWT } = useSurrealDB()
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

  const projectId = event.context.params?.id
  if (!projectId) {
    throw createError({
      statusCode: 400,
      message: 'Project ID is required',
    })
  }

  const body = await readBody(event)
  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: 'Project name is required',
    })
  }

  await connect()
  await db.authenticate(token)

  const projectRecordParts = projectId.split(":")
  const projectRecordId = new RecordId(projectRecordParts[0], projectRecordParts[1])
  const project = await db.select(projectRecordId)

  if (!userRecordId.equals(project.author)) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to update this project",
    })
  }

  const updatedProject = await db.merge(projectRecordId, {
    name: body.name,
    description: body.description ?? "",
    category: body.category ?? "default",
    company: body.company ?? "",
    slug: body.slug ?? body.name.toLowerCase().replaceAll(" ", "-"),
    visibility: body.visibility ?? "private",
    updated_at: new Date().toISOString(),
  })

  return {
    success: true,
    message: 'Project updated successfully',
    project: updatedProject,
  }
})
