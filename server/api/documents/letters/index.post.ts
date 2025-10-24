import { getCoverLetterBySlug, coverLetterToApiCoverLetter, apiCoverLetterToCoverLetter } from '~/server/utils/document'
import type { ApiCoverLetter } from '~/types/document'

export default defineEventHandler(async (event) => {
  const { user } = await requireUserSession(event)
  const db = hubDatabase()
  
  try {
    const body = await readBody(event)
    
    // Validate required fields
    if (!body.slug || !body.title || !body.body) {
      throw createError({
        statusCode: 400,
        statusMessage: 'Missing required fields: slug, title, body',
      })
    }
    
    // Check if slug already exists
    const existing = await getCoverLetterBySlug(db, body.slug)
    if (existing) {
      throw createError({
        statusCode: 409,
        statusMessage: 'A cover letter with this slug already exists',
      })
    }
    
    // Convert to API format
    const apiLetter = coverLetterToApiCoverLetter({
      ...body,
      userId: user.id,
    })
    
    // Build INSERT query
    const fields = Object.keys(apiLetter).join(', ')
    const placeholders = Object.keys(apiLetter).map(() => '?').join(', ')
    const values = Object.values(apiLetter)
    
    const result = await db
      .prepare(`INSERT INTO cover_letters (${fields}) VALUES (${placeholders}) RETURNING *`)
      .bind(...values)
      .first<ApiCoverLetter>()
    
    if (!result) {
      throw createError({
        statusCode: 500,
        statusMessage: 'Failed to insert cover letter',
      })
    }
    
    return apiCoverLetterToCoverLetter(result)
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    
    console.error('Error creating cover letter:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to create cover letter',
    })
  }
})
