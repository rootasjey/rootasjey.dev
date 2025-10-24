import { getResumeBySlug, getCoverLettersByResumeId } from '~/server/utils/document'

export default defineEventHandler(async (event) => {
  const { slug } = getRouterParams(event)
  const db = hubDatabase()
  
  try {
    const resume = await getResumeBySlug(db, slug)
    
    if (!resume) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Resume not found',
      })
    }
    
    // If not published, only allow owner to view
    if (!resume.published) {
      const { user } = await getUserSession(event)
      if (!user || user.id !== resume.userId) {
        throw createError({
          statusCode: 403,
          statusMessage: 'This resume is not published',
        })
      }
    }
    
    // Optionally fetch linked cover letters
    const linkedLetters = await getCoverLettersByResumeId(db, resume.id)
    resume.linkedLetters = linkedLetters
    
    return resume
  } catch (error: any) {
    if (error.statusCode) {
      throw error
    }
    
    console.error('Error fetching resume:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch resume',
    })
  }
})
