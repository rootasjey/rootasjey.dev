// PUT /api/posts/[slug]/article

import { getPostByIdentifier } from "~/server/utils/post"
import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const body = await readBody(event)
  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')

  if (!identifier) {
    throw createError({
      statusCode: 400,
      message: 'Post identifier is required',
    })
  }

  if (!body.article) {
    throw createError({
      statusCode: 400,
      message: 'Post article is required',
    })
  }

  const userId = session.user.id
  const post: PostType | null = await getPostByIdentifier(db, identifier)

  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }

  // Check if the user is the author of the post
  if (post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this post',
    })
  }

  try {
    const articleBlob = new Blob([JSON.stringify(body.article)], { 
      type: 'application/json' 
    })
    
    await hubBlob().put(post.blob_path as string, articleBlob)
    
    await db
    .prepare(`
      UPDATE posts 
      SET updated_at = CURRENT_TIMESTAMP
      WHERE id = ?
    `)
    .bind(post.id)
    .run()

    const updatedPost = await db
    .prepare(`SELECT * FROM posts WHERE id = ? LIMIT 1`)
    .bind(post.id)
    .first()

    return {
      message: 'Post article updated successfully',
      post: updatedPost,
      success: true,
    }
  } catch (error) {
    console.error('Error updating post article:', error)
    throw createError({
      statusCode: 500,
      message: 'Failed to update post article',
    })
  }
})
