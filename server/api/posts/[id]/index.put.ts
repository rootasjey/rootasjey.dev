// PUT /api/posts/[id]/index.put.ts
import { z } from 'zod'
import { PostType } from "~/types/post"

const updatePostSchema = z.object({
  name: z.string().min(1).max(255).optional(),
  description: z.string().max(1000).optional(),
  tags: z.array(z.string().min(1).max(50)).max(20).optional(),
  language: z.enum(['en', 'fr']).optional(),
  slug: z.string().min(1).max(255).optional(),
  status: z.enum(['draft', 'published', 'archived']).optional(),
})

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const userId = session.user.id
  const postIdOrSlug = getRouterParam(event, 'id')
  const body = await readBody(event)
  const db = hubDatabase()

  handleParamErrors({ postIdOrSlug, body })
  const validatedBody = updatePostSchema.parse(body)

  let post: PostType | null = await db
  .prepare(`SELECT * FROM posts WHERE id = ? OR slug = ? LIMIT 1`)
  .bind(postIdOrSlug, postIdOrSlug)
  .first()

  handlePostErrors(post, userId)
  post = post as PostType

  // Only generate/update slug if explicitly provided in body
  const shouldUpdateSlug = body.slug !== undefined
  const newSlug = shouldUpdateSlug ? body.slug : post.slug

  // Check for slug uniqueness if slug is being updated
  if (validatedBody.slug && validatedBody.slug !== post.slug) {
    const slugExists = await db.prepare(`
      SELECT id FROM posts WHERE slug = ? AND id != ?
    `)
    .bind(validatedBody.slug, post.id)
    .first()

    if (slugExists) {
      throw createError({
        statusCode: 409,
        statusMessage: 'Slug already exists'
      })
    }
  }

  // Prepare update data
  const updateData: Record<string, any> = {}
  const updateFields: string[] = []
  const updateValues: any[] = []

  // Handle each field that might be updated
  if (validatedBody.name !== undefined) {
    updateFields.push('name = ?')
    updateValues.push(validatedBody.name)
    updateData.name = validatedBody.name
  }

  if (validatedBody.description !== undefined) {
    updateFields.push('description = ?')
    updateValues.push(validatedBody.description)
    updateData.description = validatedBody.description
  }

  if (validatedBody.tags !== undefined) {
    // Convert tags array to JSON string for storage
    const tagsJson = JSON.stringify(validatedBody.tags)
    updateFields.push('tags = ?')
    updateValues.push(tagsJson)
    updateData.tags = validatedBody.tags
  }

  if (validatedBody.language !== undefined) {
    updateFields.push('language = ?')
    updateValues.push(validatedBody.language)
    updateData.language = validatedBody.language
  }

  if (validatedBody.slug !== undefined) {
    updateFields.push('slug = ?')
    updateValues.push(validatedBody.slug)
    updateData.slug = validatedBody.slug
  }

  if (validatedBody.status !== undefined) {
    updateFields.push('status = ?')
    updateValues.push(validatedBody.status)
    updateData.status = validatedBody.status

    // Set published_at when changing to published
    if (validatedBody.status === 'published' && post.status !== 'published') {
      updateFields.push('published_at = ?')
      updateValues.push(new Date().toISOString())
      updateData.published_at = new Date().toISOString()
    }
    // Clear published_at when changing from published
    else if (validatedBody.status !== 'published' && post.status === 'published') {
      updateFields.push('published_at = ?')
      updateValues.push(null)
      updateData.published_at = null
    }
  }

  // Only proceed if there are fields to update
  if (updateFields.length === 0) {
    const tags: string[] =  post.tags ? JSON.parse(post.tags as unknown as string) : []
    return {
      success: true,
      message: 'No changes to update',
      post: {
        ...post,
        tags,
        canEdit: true
      }
    }
  }

   // Add updated_at timestamp
  updateFields.push('updated_at = ?')
  updateValues.push(new Date().toISOString())

  // Add WHERE clause values
  updateValues.push(post.id, userId)

  // Execute update
  const updateQuery = `
    UPDATE posts 
    SET ${updateFields.join(', ')} 
    WHERE id = ? AND user_id = ?
  `

  const updateResult = await db
  .prepare(updateQuery)
  .bind(...updateValues)
  .run()

  if (!updateResult.success) {
    throw createError({
      statusCode: 500,
      statusMessage: updateResult.error,
    })
  }


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
