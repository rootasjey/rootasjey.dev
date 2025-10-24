import { getResumeBySlug, resumeToApiResume, apiResumeToResume } from '~/server/utils/document'
import type { ApiResume } from '~/types/document'

export default defineEventHandler(async (event) => {
  const { user } = await requireUserSession(event)
  const { slug } = getRouterParams(event)
  const db = hubDatabase()
  
  try {
    // Fetch existing resume
    const existing = await getResumeBySlug(db, slug)
    
    if (!existing) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Resume not found',
      })
    }
    
    // Check ownership
    if (existing.userId !== user.id) {
      throw createError({
        statusCode: 403,
        statusMessage: 'You do not have permission to edit this resume',
      })
    }
    
    const body = await readBody(event)
    
    // If changing slug, check for conflicts
    if (body.slug && body.slug !== slug) {
      const conflict = await getResumeBySlug(db, body.slug)
      if (conflict) {
        throw createError({
          statusCode: 409,
          statusMessage: 'A resume with this slug already exists',
        })
      }
    }
    
    // Convert to API format
    const apiResume = resumeToApiResume({
      ...body,
      userId: user.id,
    })
    
    // Build UPDATE query
    const updates = Object.keys(apiResume)
      .map(key => `${key} = ?`)
      .join(', ')
    const values = [...Object.values(apiResume), existing.id]
    
    const result = await db
      .prepare(`UPDATE resumes SET ${updates} WHERE id = ? RETURNING *`)
      .bind(...values)
      .first<ApiResume>()
    
    if (!result) {
      throw createError({
        statusCode: 500,
        statusMessage: 'Failed to update resume',
      })
    }
    
    return apiResumeToResume(result)
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    
    console.error('Error updating resume:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to update resume',
    })
  }
})
