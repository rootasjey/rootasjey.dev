import { getCoverLetterBySlug, apiResumeToResume } from '~/server/utils/document'
import type { ApiResume } from '~/types/document'

export default defineEventHandler(async (event) => {
  const { slug } = getRouterParams(event)
  const db = hubDatabase()
  
  try {
    const letter = await getCoverLetterBySlug(db, slug)
    
    if (!letter) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Cover letter not found',
      })
    }
    
    // If not published, only allow owner to view
    if (!letter.published) {
      const { user } = await getUserSession(event)
      if (!user || user.id !== letter.userId) {
        throw createError({
          statusCode: 403,
          statusMessage: 'This cover letter is not published',
        })
      }
    }
    
    // Optionally fetch linked resume
    if (letter.resumeId) {
      const result = await db
        .prepare('SELECT * FROM resumes WHERE id = ?')
        .bind(letter.resumeId)
        .first<ApiResume>()
      
      if (result) {
        letter.resume = apiResumeToResume(result)
      }
    }
    
    return letter
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    
    console.error('Error fetching cover letter:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch cover letter',
    })
  }
})
