// DELETE /api/posts/:id
// Delete a post from SurrealDB
import { RecordId } from 'surrealdb'
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { db, connect, decodeJWT } = useSurrealDB()
  const id = event.context.params?.id
  if (!id) {
    throw createError({
      statusCode: 400,
      message: 'Post ID (`id`) is required.',
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
  const postRecordParts = id.split(":")
  const postRecordId = new RecordId(postRecordParts[0], postRecordParts[1])
  const post = await db.select(postRecordId)
  
  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found.',
    })
  }

  if (!userRecordId.equals(post.author)) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this post",
    })
  }
  await db.delete(postRecordId)

  return {
    message: "Post deleted successfully",
    id,
  }
})