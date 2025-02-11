// POST /api/projects/[id]/add-post
import { RecordId } from 'surrealdb'
import { useSurrealDB } from '~/composables/useSurrealDB'
import { createPostData } from '~/server/utils/server.post'

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
      message: "You are not authorized to create a post for this project",
    })
  }

  if (project.has_post) {
    throw createError({
      statusCode: 400,
      message: "This project already has a post",
    })
  }

  const body = await readBody(event)
  const postData = createPostData(body, userRecordId)

  const post = await db.create("posts", {
    ...postData,
    project: projectRecordId,
    visibility: "project:private",
  })

  // Update project record to include post ID
  await db.merge(projectRecordId, {
    post: post[0].id,
    updated_at: new Date(),
  })

  return post[0]
})
