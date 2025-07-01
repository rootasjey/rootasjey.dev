// PUT /api/posts/[identifier]/index.put.ts
import { z } from 'zod'
import { ApiTag } from '~/types/tag'
import { ApiPost, Post } from "~/types/post"
import { upsertPostTags } from '~/server/utils/tags'
import { convertApiToPost, getPostByIdentifier } from '~/server/utils/post'

const updatePostSchema = z.object({
  name: z.string().min(1).max(255),
  description: z.string().max(1000).optional(),
  tags: z.array(z.object({
    name: z.string().min(1).max(50),
    category: z.string().max(50).optional()
  })).max(20).optional(),
  language: z.enum(['en', 'fr']).optional(),
  slug: z.string().min(1).max(255).optional(),
  status: z.enum(['draft', 'published', 'archived']).optional(),
})

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const userId = session.user.id
  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')
  const db = hubDatabase()

  const isNumericId = typeof identifier === "number" || /^\d+$/.test(String(identifier))

  if (!identifier) {
    throw createError({
      statusCode: 400,
      message: 'Post identifier is required',
    })
  }

  if (!isNumericId) {
    throw createError({
      statusCode: 400,
      message: `Post identifier must be a numeric ID for this endpoint, received: ${identifier}`,
    })
  }

  const validatedBody = await readValidatedBody(event, updatePostSchema.parse)
  let apiPost = await getPostByIdentifier(db, identifier)

  handlePostErrors(apiPost, userId)
  apiPost = apiPost as ApiPost

  // Check for slug uniqueness if slug is being updated
  if (validatedBody.slug && validatedBody.slug !== apiPost.slug) {
    const slugExists = await db.prepare(`
      SELECT id FROM posts WHERE slug = ? AND id != ?
    `)
    .bind(validatedBody.slug, apiPost.id)
    .first()

    if (slugExists) {
      throw createError({
        statusCode: 409,
        statusMessage: `Slug "${validatedBody.slug}" already exists for another post.`,
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
    if (validatedBody.status === 'published' && apiPost.status !== 'published') {
      updateFields.push('published_at = ?')
      updateValues.push(new Date().toISOString())
      updateData.published_at = new Date().toISOString()
    }
    // Clear published_at when changing from published
    else if (validatedBody.status !== 'published' && apiPost.status === 'published') {
      updateFields.push('published_at = ?')
      updateValues.push(null)
      updateData.published_at = null
    }
  }

  // Only proceed if there are fields to update
  if (updateFields.length === 0) {
    return {
      success: true,
      message: 'No changes to update',
      post: apiPost,
    }
  }

   // Add updated_at timestamp
  updateFields.push('updated_at = ?')
  updateValues.push(new Date().toISOString())

  // Add WHERE clause values
  updateValues.push(apiPost.id, userId)

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

  // --- TAGS: Process tags after post update ---
  let createdTags: ApiTag[] = []
  if (validatedBody.tags !== undefined) {
    createdTags = await upsertPostTags(db, apiPost.id, validatedBody.tags)
  }

  const updatedPost: ApiPost | null = await db
  .prepare(`SELECT * FROM posts WHERE id = ? LIMIT 1`)
  .bind(apiPost.id)
  .first()

  if (!updatedPost) {
    throw createError({ statusCode: 500, message: 'Failed to update post' })
  }

  const post = convertApiToPost(updatedPost, {
    tags: createdTags,
    userName: session.user.name,
  })

  return {
    message: 'Post updated successfully',
    post,
    success: true,
  }
})

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
