import { getResumeBySlug, resumeToApiResume, apiResumeToResume } from '~/server/utils/document'
import type { ApiResume } from '~/types/document'

export default defineEventHandler(async (event) => {
  const { user } = await requireUserSession(event)
  const db = hubDatabase()
  
  try {
    const body = await readBody(event)
    
    // Validate required fields
    if (!body.slug || !body.title || !body.name) {
      throw createError({
        statusCode: 400,
        statusMessage: 'Missing required fields: slug, title, name',
      })
    }
    
    // Check if slug already exists
    const existing = await getResumeBySlug(db, body.slug)
    if (existing) {
      throw createError({
        statusCode: 409,
        statusMessage: 'A resume with this slug already exists',
      })
    }
    
    // Convert to API format
    const apiResume = resumeToApiResume({
      ...body,
      userId: user.id,
    })
    
    // Build INSERT query
    const fields = Object.keys(apiResume).join(', ')
    const placeholders = Object.keys(apiResume).map(() => '?').join(', ')
    const values = Object.values(apiResume)
    
    const result = await db
      .prepare(`INSERT INTO resumes (${fields}) VALUES (${placeholders}) RETURNING *`)
      .bind(...values)
      .first<ApiResume>()
    
    if (!result) {
      throw createError({
        statusCode: 500,
        statusMessage: 'Failed to insert resume',
      })
    }
    
    return apiResumeToResume(result)
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    
    console.error('Error creating resume:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to create resume',
    })
  }
})
