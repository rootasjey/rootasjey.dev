import { eventHandler, getRouterParam, getRequestURL, setHeader, createError } from 'h3'
// hubBrowser is auto-injected by @nuxthub/core when hub.browser is enabled

// Generate a PDF using NuxtHub's Browser (Cloudflare Browser Rendering API)
export default eventHandler(async (event) => {
  const slug = getRouterParam(event, 'slug')
  if (!slug) {
    throw createError({ statusCode: 400, statusMessage: 'Missing slug' })
  }

  const origin = getRequestURL(event).origin
  const url = `${origin}/documents/cv/${encodeURIComponent(slug)}?print=1`

  // Acquire a headless browser page via NuxtHub
  const { page } = await hubBrowser()

  // Emulate print media for accurate PDF rendering
  await page.setViewport({ width: 1200, height: 1800 })
  await page.emulateMediaType('print')

  // Navigate and wait for the page to be fully loaded/hydrated
  await page.goto(url, { waitUntil: 'networkidle0' })
  // await page.waitForTimeout(300)

  // Generate PDF (A4, background colors, margins)
  const pdf = await page.pdf({
    format: 'A4',
    printBackground: true,
    margin: { top: '12mm', right: '12mm', bottom: '12mm', left: '12mm' },
    preferCSSPageSize: true,
    displayHeaderFooter: false,
  })

  const safeName = `${slug}-resume`.replace(/[^a-z0-9-_]/gi, '_')
  setHeader(event, 'Content-Type', 'application/pdf')
  setHeader(event, 'Content-Disposition', `attachment; filename="${safeName}.pdf"`)
  return pdf
})
