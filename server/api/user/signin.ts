// POST /api/user/signin
import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  const { connect, signin } = useSurrealDB()
  const body = await readBody(event)
  checkBody(body, ['email', 'password'])

  await connect()
  const token = await signin({
    email: body.email,
    password: body.password,
  })

  return {
    token,
  }
})

function checkBody(body: any, arg1: string[]) {
  if (!body) {
    throw createError({
      statusCode: 400,
      message: 'Body is required',
    })
  }

  if (typeof body !== 'object') {
    throw createError({
      statusCode: 400,
      message: 'Body must be an object',
    })
  }

  for (const arg of arg1) {
    if (!body[arg]) {
      throw createError({
        statusCode: 400,
        message: `${arg} is required`,
      })
    }
  }
}
