// DELETE /api/posts/:slug

import { getPostByIdentifier } from "~/server/utils/post"
import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const blobStorage = hubBlob()

  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')
  if (!identifier) {
    throw createError({
      statusCode: 400,
      message: 'Post identifier is required',
    })
  }

  const userId = session.user.id
  const post: PostType | null = await getPostByIdentifier(db, identifier)

  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found.',
    })
  }

  if (post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this post",
    })
  }

  if (post.blob_path) {
    try {
      await blobStorage.delete(post.blob_path as string)
    } catch (error) {
      console.error(`Failed to delete blob file at ${post.blob_path}:`, error)
      // Continue with post deletion even if blob deletion fails
    }
  }

  // Delete images cover if it exists
  if (post.image_src) {
    try {
      const prefix = post.image_src as string
      const blobList = await hubBlob().list({ prefix })
      
      for (const blobItem of blobList.blobs) {
        await hubBlob().delete(blobItem.pathname)
      }
    } catch (error) {
      console.error(`Failed to delete image cover at ${post.image_src}:`, error)
      // Continue with post deletion even if image cover deletion fails
    }
  }

  await db
  .prepare(`DELETE FROM posts WHERE slug = ?`)
  .bind(post.slug)
  .run()

  return {
    message: "Post deleted successfully",
    post,
    success: true,
  }
})
