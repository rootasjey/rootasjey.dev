import { z } from 'zod'

const bodySchema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
})

export default defineEventHandler(async (event) => {
  const { email, password } = await readValidatedBody(event, bodySchema.parse)

  const userData = await hubDatabase()
    .prepare('SELECT * FROM users WHERE email = ?1 LIMIT 1')
    .bind(email)
    .first()

  if (!userData) {
    throw createError({
      statusCode: 401,
      message: 'Bad credentials'
    })
  }

  const isValidPassword = await verifyPassword(userData.password as string, password)
  
  if (!isValidPassword) {
    throw createError({
      statusCode: 401,
      message: 'Bad credentials'
    })
  }

  const user = {
    createdAt: userData.created_at,
    email: userData.email,
    id: userData.id,
    name: userData.name,
    role: userData.role,
  }

  await setUserSession(event, { user })
  return { user }
})
