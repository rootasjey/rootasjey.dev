// POST /api/posts/create
import { RecordId } from 'surrealdb'
import { useSurrealDB } from '~/composables/useSurrealDB'
import { createPostData } from '~/server/utils/server.post'

export default defineEventHandler(async (event) => {
  const { db, connect, decodeJWT } = useSurrealDB()
  const body = await readBody(event)

  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: "Post name is required",
    })
  }

  await connect()
  let userRecordId: RecordId = new RecordId("", "")
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
  userRecordId = new RecordId(idParts[0], idParts[1])
  await db.authenticate(token)


  const postData = createPostData(body, userRecordId)

  // Create new record in SurrealDB posts table
  const post = await db.create("posts", postData)
  console.log("Created post response:", post)

  return post
})
