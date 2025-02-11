import Surreal from 'surrealdb'

export const useSurrealDB = () => {
  const db = new Surreal()

  const connect = async () => {
    const res = await db.connect(process.env.SURREAL_DB_URL ?? "", {
      namespace: process.env.SURREAL_DB_NAMESPACE ?? "",
      database: process.env.SURREAL_DB_DATABASE ?? "",
      auth: {
        username: process.env.SURREAL_DB_USER ?? "",
        password: process.env.SURREAL_DB_PASS ?? "",
        namespace: process.env.SURREAL_DB_NAMESPACE ?? "",
        database: process.env.SURREAL_DB_DATABASE ?? "",
      },
    })
    return res
  }

  const decodeJWT = (token: string) => {
    const base64Payload = token.split('.')[1]
    const payload = Buffer.from(base64Payload, 'base64').toString('ascii')
    return JSON.parse(payload)
  }

  const signin = async ({ email, password }: {email: string, password: string}) => {
    const token = await db.signin({
      namespace: process.env.SURREAL_DB_NAMESPACE ?? "",
      database: process.env.SURREAL_DB_DATABASE ?? "",
      access: process.env.SURREAL_DB_ACCESS ?? "",
      variables: {
        email: email,
        password: password,
      },
    })
    return token
  }

  const signup = async ({ username, email, password }: {username: string, email: string, password: string}) => {
    const token = await db.signup({
      namespace: process.env.SURREAL_DB_NAMESPACE ?? "",
      database: process.env.SURREAL_DB_DATABASE ?? "",
      access: process.env.SURREAL_DB_ACCESS ?? "",
      variables: {
        username: username,
        email: email,
        password: password,
      },
    })
    return token
  }

  return {
    connect,
    db,
    decodeJWT,
    signin,
    signup,
  }
}
