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

  if (src.startsWith("/projects/")) {
    const parts = src.split("/")
    const slug = parts[2]
    const filename = parts[parts.length - 1]
    
    url = joinURL(baseURL, `/images/${filename}?relatedTo=projects&slug=${slug}`)
    if (operations) {
      url += '&' + operations
    }
  }

  return {
    url: url,
  }
}
