// DELETE /api/posts/[id]/cover
import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const userId = session.user.id
  const postIdOrSlug = decodeURIComponent(getRouterParam(event, 'id') ?? '')
  const db = hubDatabase()

  let post: PostType | null = await db
  .prepare(`SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(postIdOrSlug, postIdOrSlug)
  .first()

  handleErrors({ post, userId })
  post = post as PostType

  try {
    const prefix = post.image_src as string
    const blobList = await hubBlob().list({ prefix })
    
    for (const blobItem of blobList.blobs) {
      await hubBlob().delete(blobItem.pathname)
    }

    await db
    .prepare(`
      UPDATE posts 
      SET image_src = '', image_alt = '', image_ext = '', updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `)
    .bind(post.id)
    .run()

    return { 
      success: true,
      message: 'Image removed successfully',
      post,
    }
  } catch (error) {
    console.log(error)
    return {
      error,
      success: false,
      message: 'Failed to remove image',
      post,
    }
  }
})

type HandleErrorsProps = {
  post: PostType | null
  userId: number
}

const handleErrors = ({ post, userId }: HandleErrorsProps) => {
  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }

  if (post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this post',
    })
  }

  if (!post.image_src) {
    throw createError({
      statusCode: 400,
      message: 'Post does not have an image',
    })
  }
}
