// POST /api/projects/create.ts
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

  await connect()
  await db.authenticate(token)
  const body = await readBody(event)

  const project = {
    ...body,
    author: userRecordId,
    company: "",
    image: {
      alt: "",
      src: "",
    },
    links: [],
    technologies: [],
    slug: body.name.toLowerCase().replaceAll(" ", "-"),
    visibility: "public",
  }

  const createdProject = await db.create("projects", project)
  return createdProject
})
