// POST /api/contact/submit
// Handles contact form submissions and saves them to the messages table

export default defineEventHandler(async (event) => {
  // Get the form data from the request body
  const body = await readBody(event)
  
  // Validate the required fields
  if (!body.email || !body.message || !body.subject) {
    throw createError({
      statusCode: 400,
      message: 'Email, subject, and message are required'
    })
  }

  try {
    const db = hubDatabase()
    const result = await db.prepare(`
      INSERT INTO messages (sender_email, subject, message)
      VALUES (?, ?, ?)
    `)
    .bind(body.email, body.subject, body.message)
    .run()
    
    if (!result.success) {
      throw new Error('Failed to save message')
    }
    
    return {
      success: true,
      message: 'Your message has been sent successfully!'
    }
  } catch (error) {
    console.error('Error saving message:', error)
    throw createError({
      statusCode: 500,
      message: 'Failed to save your message. Please try again later.'
    })
  }
})