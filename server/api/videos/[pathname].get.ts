// GET /api/videos/:pathname
import { z } from 'zod'

export default eventHandler(async (event) => {
  const { pathname } = await getValidatedRouterParams(event, z.object({
    pathname: z.string().min(1)
  }).parse)

  const prefix = getQuery(event).prefix as string
  const videoPathname = `${prefix}/${pathname}`
  return hubBlob().serve(event, videoPathname)
})
