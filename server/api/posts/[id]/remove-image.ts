// DELETE /api/posts/[id]/remove-image
import { RecordId } from "surrealdb"
import { useSurrealDB } from "~/composables/useSurrealDB"
import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const { db, connect } = useSurrealDB()
  const postId = event.context.params?.id

  if (!postId) {
    throw createError({
      statusCode: 400,
      message: 'Post ID (`id`) is required',
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

  const post: Partial<PostType> = await db.select(postRecordId)
  if (!post.image?.src) {
    throw createError({
      statusCode: 400,
      message: 'Post does not have an image',
    })
  }

  try {
    await hubBlob().delete(post.image.src)
    await db.merge(postRecordId, {
      image: {
        alt: "",
        src: "",
      },
    })
  
    return { success: true }
  } catch (error) {
    console.log(error)
    return { error, success: false, }
  }
  
})
