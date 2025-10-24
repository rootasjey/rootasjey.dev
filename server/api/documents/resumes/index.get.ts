import { getAllResumes } from '~/server/utils/document'

export default defineEventHandler(async (event) => {
  const db = hubDatabase()
  const { user } = await getUserSession(event)
  
  try {
    const options: { published?: boolean } = {}
    
    // If not authenticated, only show published resumes
    if (!user) {
      options.published = true
    }
    // If authenticated, can see all their own resumes
    
    const resumes = await getAllResumes(db, options)
    
    // If user is authenticated, filter to show only their resumes
    // (or implement different logic based on your needs)
    const filteredResumes = user 
      ? resumes.filter(r => r.userId === user.id || r.published)
      : resumes
    
    return filteredResumes
  } catch (error) {
    console.error('Error fetching resumes:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch resumes',
    })
  }
})
