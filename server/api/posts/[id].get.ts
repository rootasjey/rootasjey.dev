// GET /api/posts/:id
import { RecordId } from 'surrealdb'
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { db, connect, decodeJWT } = useSurrealDB()
  const postId = event.context.params?.id
  let userRecordId: RecordId = new RecordId("", "")
  if (!postId) {
    throw createError({
      statusCode: 400,
      message: 'Post ID (`id`) is required.',
    })
  }

  await connect()
  const rawToken = getHeader(event, "Authorization")
  if (rawToken) {
    const token = rawToken.replace('Bearer ', '').replace('token=', '')
    const decoded = decodeJWT(token)
    const idParts = decoded.ID.split(":")
    userRecordId = new RecordId(idParts[0], idParts[1])
    await db.authenticate(token)
  }

  const postRecordParts = postId.split(":")
  const postRecordId = new RecordId(postRecordParts[0], postRecordParts[1])
  const post = await db.select(postRecordId)
  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found.',
    })
  }

  return {
    ...post,
    canEdit: userRecordId.equals(post.author),
  }
})