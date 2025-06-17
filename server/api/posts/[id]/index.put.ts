// PUT /api/posts/[id]/index.put.ts

import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const userId = session.user.id
  const postIdOrSlug = getRouterParam(event, 'id')
  const body = await readBody(event)
  const db = hubDatabase()

  handleParamErrors({ postIdOrSlug, body })

  let post: PostType | null = await db
  .prepare(`SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(postIdOrSlug, postIdOrSlug)
  .first()

  handlePostErrors(post, userId)
  post = post as PostType

  // Only generate/update slug if explicitly provided in body
  const shouldUpdateSlug = body.slug !== undefined
  const newSlug = shouldUpdateSlug ? body.slug : post.slug

  let category = body.category ?? ""
  category = category === "no category" ? "" : category.toLowerCase()

  // Build dynamic SQL query based on whether slug should be updated
  let updateQuery = `
    UPDATE posts 
    SET 
      category = ?,
      description = ?,
      language = ?,
      name = ?,
      visibility = ?`
  
  const updateParams = [
    category,
    body.description ?? "",
    body.language ?? "en",
    body.name,
    body.visibility ?? "public"
  ]

  if (shouldUpdateSlug) {
    updateQuery += `, slug = ?`
    updateParams.push(newSlug)
  }

  updateQuery += `, updated_at = CURRENT_TIMESTAMP WHERE id = ?`
  updateParams.push(post.id)

  await db.prepare(updateQuery)
    .bind(...updateParams)
    .run()

  // Handle blob files relocation only if slug is being updated
  if (shouldUpdateSlug && post.slug !== newSlug) {
    const blobStorage = hubBlob()
    const oldPrefix = `posts/${post.slug}`
    const newPrefix = `posts/${newSlug}`

    try {
      // List all blobs with the old slug prefix
      const blobList = await blobStorage.list({ prefix: oldPrefix })
      
      // Relocate each blob to the new path
      for (const blobItem of blobList.blobs) {
        const oldPath = blobItem.pathname
        const relativePath = oldPath.replace(oldPrefix, '')
        const newPath = `${newPrefix}${relativePath}`
        
        // Get the blob content
        const blobContent = await blobStorage.get(oldPath)
        
        if (blobContent) {
          // Upload to new location
          await blobStorage.put(newPath, blobContent)
          // Delete from old location
          await blobStorage.delete(oldPath)
        }
      }

      // Update blob_path in database if it exists
      if (post.blob_path) {
        const newBlobPath = post.blob_path.replace(oldPrefix, newPrefix)
        await db.prepare(`UPDATE posts SET blob_path = ? WHERE id = ?`)
          .bind(newBlobPath, post.id)
          .run()
      }

      // Update image_src in database if it exists (for cover images)
      if (post.image_src) {
        const newImageSrc = post.image_src.replace(oldPrefix, newPrefix)
        await db.prepare(`UPDATE posts SET image_src = ? WHERE id = ?`)
          .bind(newImageSrc, post.id)
          .run()
      }

    } catch (error) {
      console.error(`Failed to relocate blobs from ${oldPrefix} to ${newPrefix}:`, error)
      // You might want to throw an error here or handle it gracefully
      throw createError({
        statusCode: 500,
        message: 'Failed to relocate post files during slug update',
      })
    }
  }

  const updatedPost: PostType | null = await db
  .prepare(`SELECT * FROM posts WHERE id = ? LIMIT 1`)
  .bind(post.id)
  .first()

  if (!updatedPost) {
    throw createError({
      statusCode: 500,
      message: 'Failed to update post',
    })
  }

  const formattedPost: PostType = {
    ...updatedPost,
    links:  typeof updatedPost.links  === 'string' ? JSON.parse(updatedPost.links || '[]') : updatedPost.links,
    tags:   typeof updatedPost.tags   === 'string' ? JSON.parse(updatedPost.tags || '[]') : updatedPost.tags,
    styles: typeof updatedPost.styles === 'string' ? JSON.parse(updatedPost.styles || '{}') : updatedPost.styles,
    image: {
      alt: updatedPost.image_alt as string || "",
      ext: updatedPost.image_ext as string || "",
      src: updatedPost.image_src as string || ""
    }
  }

  // Remove redundant fields
  delete formattedPost.image_alt
  delete formattedPost.image_ext
  delete formattedPost.image_src

  return {
    message: 'Post updated successfully',
    post: formattedPost,
    success: true,
  }
})

const handleParamErrors = ({ postIdOrSlug, body }: { postIdOrSlug?: string, body: any }) => {
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
}

const handlePostErrors = (post: any, userId?: number) => {
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
}
