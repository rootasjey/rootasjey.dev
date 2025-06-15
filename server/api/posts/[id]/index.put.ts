// PUT /api/posts/[id]/update-meta

import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const postIdOrSlug = getRouterParam(event, 'id')
  const db = hubDatabase()
  const body = await readBody(event)

  if (!postIdOrSlug) {
    throw createError({
      statusCode: 400,
      message: 'Post ID or slug is required',
    })
  }

  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: 'Post name is required',
    })
  }

  const userId = session.user.id

  const post = await db
  .prepare(`SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(postIdOrSlug, postIdOrSlug)
  .first()

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

  // Generate slug if not provided
  const slug = body.slug ?? body.name.toLowerCase().replaceAll(" ", "-")

  const oldBlobPath = post.blob_path as string ?? ""
  const newBlobPath = `posts/${slug}/article.json`

  if (oldBlobPath !== newBlobPath) {
    // Move the article blob to the new path if different
    const blobStorage = hubBlob()
    const oldBlobArticle = await blobStorage.get(oldBlobPath)
    
    if (oldBlobArticle) {
      await blobStorage.put(newBlobPath, oldBlobArticle)
      await blobStorage.delete(oldBlobPath)
      post.blob_path = newBlobPath
      body.blob_path = newBlobPath
    }
  }

  let category = body.category ?? ""
  category = category === "no category" ? "" : category.toLowerCase()

  await db.prepare(`
    UPDATE posts 
    SET 
      category = ?,
      description = ?,
      language = ?,
      name = ?,
      visibility = ?,
      slug = ?,
      updated_at = CURRENT_TIMESTAMP
    WHERE id = ?
  `)
  .bind(
    category,
    body.description ?? "",
    body.language ?? "en",
    body.name,
    body.visibility ?? "public",
    body.slug ?? "",
    post.id
  )
  .run()

  const updatedPost = await db
  .prepare(`SELECT * FROM posts WHERE id = ? LIMIT 1`)
  .bind(post.id)
  .first()

  if (!updatedPost) {
    throw createError({
      statusCode: 500,
      message: 'Failed to update post',
    })
  }

  const formattedPost: Partial<PostType> = {
    ...updatedPost,
    links:  typeof updatedPost.links  === 'string' ? JSON.parse(updatedPost.links || '[]') : updatedPost.links,
    tags:   typeof updatedPost.tags   === 'string' ? JSON.parse(updatedPost.tags || '[]') : updatedPost.tags,
    styles: typeof updatedPost.styles === 'string' ? JSON.parse(updatedPost.styles || '{}') : updatedPost.styles,
    image: {
      alt: updatedPost.image_alt as string || "",
      src: updatedPost.image_src as string || ""
    }
  }

  // Remove redundant fields
  delete formattedPost.image_alt
  delete formattedPost.image_src

  return {
    message: 'Post updated successfully',
    post: formattedPost,
    success: true,
  }
})
