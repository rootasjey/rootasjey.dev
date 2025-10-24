import { eventHandler, getRouterParam, getRequestURL, setHeader, createError } from 'h3'
// hubBrowser is provided by @nuxthub/core when hub.browser is enabled
declare const hubBrowser: (opts?: any) => Promise<{ page: any, browser: any }>

// Generate a PDF for a cover letter page using NuxtHub's Browser (Cloudflare)
export default eventHandler(async (event) => {
  const slug = getRouterParam(event, 'slug')
  if (!slug) {
    throw createError({ statusCode: 400, statusMessage: 'Missing slug' })
  }

  const origin = getRequestURL(event).origin
  // Render the dynamic letter page
  const url = `${origin}/documents/letters/${encodeURIComponent(slug)}?print=1`

  const { page } = await hubBrowser()
  await page.setViewport({ width: 1200, height: 1800 })
  await page.emulateMediaType('print')
  await page.goto(url, { waitUntil: 'networkidle0' })
  await page.waitForTimeout(300)

  const pdf = await page.pdf({
    format: 'A4',
    printBackground: true,
    margin: { top: '12mm', right: '12mm', bottom: '12mm', left: '12mm' },
    preferCSSPageSize: true,
    displayHeaderFooter: false,
  })

  const safeName = `${slug}-cover-letter`.replace(/[^a-z0-9-_]/gi, '_')
  setHeader(event, 'Content-Type', 'application/pdf')
  setHeader(event, 'Content-Disposition', `attachment; filename="${safeName}.pdf"`)
  return pdf
})
