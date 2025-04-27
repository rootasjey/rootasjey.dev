import { z } from 'zod'

const bodySchema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
})

export default defineEventHandler(async (event) => {
  const { email, password } = await readValidatedBody(event, bodySchema.parse)

  if (email === process.env.ADMIN_USERNAME && password === process.env.ADMIN_PASSWORD) {
    // Set the user session in the cookie
    // this server util is auto-imported by the auth-utils module
    await setUserSession(event, {
      user: {
        id: 0,
        email,
        name: 'rootasjey',
      }
    })
    return {}
  }

  throw createError({
    statusCode: 401,
    message: 'Bad credentials'
  })
})