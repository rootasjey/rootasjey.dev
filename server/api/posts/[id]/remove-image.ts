// DELETE /api/posts/[id]/remove-image
import { RecordId } from "surrealdb"
import { useSurrealDB } from "~/composables/useSurrealDB"


export default defineEventHandler(async (event) => {
  const { db, connect } = useSurrealDB()
  const postId = event.context.params?.id
  const body = await readBody(event)

  if (!postId) {
    throw createError({
      statusCode: 400,
      message: 'Post ID (`id`) is required',
    })
  }

  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: 'Post name is required',
    })
  }

  await connect()
  const rawToken = getHeader(event, "Authorization")
  if (rawToken) {
    const token = rawToken.replace('Bearer ', '').replace('token=', '')
    await db.authenticate(token)
  }

  const postRecordParts = postId.split(":")
  const postRecordId = new RecordId(postRecordParts[0], postRecordParts[1])
  const post = await db.merge(postRecordId, {
    image: {
      name: "",
      url: "",
    },
  })

  return { success: true }
})
