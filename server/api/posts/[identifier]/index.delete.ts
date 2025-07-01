// DELETE /api/posts/:slug

import { convertApiToPost, getPostByIdentifier } from "~/server/utils/post"
import { ApiPost } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const blobStorage = hubBlob()

  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')
  if (!identifier) { throw createError({ statusCode: 400, message: 'Post identifier is required' }) }

  const userId = session.user.id
  const apiPost: ApiPost | null = await getPostByIdentifier(db, identifier)
  
  if (!apiPost) { throw createError({ statusCode: 404, message: 'Post not found.' })}
  if (apiPost.user_id !== userId) { throw createError({ statusCode: 403, message: "You are not authorized to delete this post" }) }

  if (apiPost.blob_path) { await blobStorage.delete(apiPost.blob_path) }

  if (apiPost.image_src) {
    const prefix = apiPost.image_src as string
    const blobList = await hubBlob().list({ prefix })
    
    for (const blobItem of blobList.blobs) {
      await hubBlob().delete(blobItem.pathname)
    }
  }

  await db
  .prepare(`DELETE FROM posts WHERE slug = ?`)
  .bind(apiPost.slug)
  .run()

  return {
    message: "Post deleted successfully",
    post: convertApiToPost(apiPost, { userName: session.user.name }),
    success: true,
  }
})
