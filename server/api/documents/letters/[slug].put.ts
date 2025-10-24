import { getCoverLetterBySlug, coverLetterToApiCoverLetter, apiCoverLetterToCoverLetter } from '~/server/utils/document'
import type { ApiCoverLetter } from '~/types/document'

export default defineEventHandler(async (event) => {
  const { user } = await requireUserSession(event)
  const { slug } = getRouterParams(event)
  const db = hubDatabase()
  
  try {
    // Fetch existing letter
    const existing = await getCoverLetterBySlug(db, slug)
    
    if (!existing) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Cover letter not found',
      })
    }
    
    // Check ownership
    if (existing.userId !== user.id) {
      throw createError({
        statusCode: 403,
        statusMessage: 'You do not have permission to edit this cover letter',
      })
    }
    
    const body = await readBody(event)
    
    // If changing slug, check for conflicts
    if (body.slug && body.slug !== slug) {
      const conflict = await getCoverLetterBySlug(db, body.slug)
      if (conflict) {
        throw createError({
          statusCode: 409,
          statusMessage: 'A cover letter with this slug already exists',
        })
      }
    }
    
    // Convert to API format
    const apiLetter = coverLetterToApiCoverLetter({
      ...body,
      userId: user.id,
    })
    
    // Build UPDATE query
    const updates = Object.keys(apiLetter)
      .map(key => `${key} = ?`)
      .join(', ')
    const values = [...Object.values(apiLetter), existing.id]
    
    const result = await db
      .prepare(`UPDATE cover_letters SET ${updates} WHERE id = ? RETURNING *`)
      .bind(...values)
      .first<ApiCoverLetter>()
    
    if (!result) {
      throw createError({
        statusCode: 500,
        statusMessage: 'Failed to update cover letter',
      })
    }
    
    return apiCoverLetterToCoverLetter(result)
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    
    console.error('Error updating cover letter:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to update cover letter',
    })
  }
})
