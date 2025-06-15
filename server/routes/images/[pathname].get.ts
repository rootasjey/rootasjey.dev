import { z } from 'zod'

export default eventHandler(async (event) => {
  const { pathname } = await getValidatedRouterParams(event, z.object({
    pathname: z.string().min(1)
  }).parse)

  let imagePathname = pathname
  const query = getQuery(event) // Get query parameters for transformations

  if (typeof query.relatedTo === "string") {
    imagePathname = `${query.relatedTo}/${query.slug}/${imagePathname}`
  }

  return hubBlob().serve(event, imagePathname)
})
