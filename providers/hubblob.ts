import { joinURL } from 'ufo'
import type { ProviderGetImage } from '@nuxt/image'
import { createOperationsGenerator, createImage } from '#image'

const operationsGenerator = createOperationsGenerator()

export const getImage: ProviderGetImage = (
  src,
  { modifiers = {}, baseURL } = {}
) => {
  if (!baseURL) {
    baseURL = useRuntimeConfig().public.siteUrl
  }

  const operations = operationsGenerator(modifiers).replaceAll(/[/]/g, '&')
  let url = joinURL(baseURL, src + (operations ? '?' + operations : ''))

  if (src.startsWith("/projects/") || src.startsWith("/posts/")) {
    const parts = src.split("/")
    const category = parts[1]
    const filename = parts[parts.length - 1]
    let slug = ""
    for (let i = 2; i < parts.length - 1; i++) {
      slug += parts[i]
      if (i < parts.length - 2) { slug += '/' }
    }
    
    url = joinURL(baseURL, `/images/${filename}?relatedTo=${category}&slug=${slug}`)
    if (operations) {
      url += '&' + operations
    }
  }

  return {
    url: url,
  }
}
