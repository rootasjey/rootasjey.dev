import { getAllCoverLetters } from '~/server/utils/document'

export default defineEventHandler(async (event) => {
  const db = hubDatabase()
  const { user } = await getUserSession(event)
  
  try {
    const options: { published?: boolean } = {}
    
    // If not authenticated, only show published letters
    if (!user) {
      options.published = true
    }
    
    const letters = await getAllCoverLetters(db, options)
    
    // If user is authenticated, filter to show only their letters
    const filteredLetters = user 
      ? letters.filter(l => l.userId === user.id || l.published)
      : letters
    
    return filteredLetters
  } catch (error) {
    console.error('Error fetching cover letters:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch cover letters',
    })
  }
})
