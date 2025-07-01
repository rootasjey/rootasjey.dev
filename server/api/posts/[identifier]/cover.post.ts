// POST /api/posts/[slug]/cover

import { Jimp } from "jimp"
import { getPostByIdentifier } from "~/server/utils/post"
import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const userId = session.user.id
  const db = hubDatabase()
  const hb = hubBlob()

  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')
  const formData = await readMultipartFormData(event)
  
  const file = formData?.find(item => item.name === 'file')?.data
  const fileName = formData?.find(item => item.name === 'fileName')?.data.toString()
  const type = formData?.find(item => item.name === 'type')?.data.toString()

  if (!identifier || !file || !fileName || !type) {
    throw createError({
      statusCode: 400,
      message: 'Missing required fields',
    })
  }

  // Check if the file is an image
  if (type !== 'image/jpeg' && type !== 'image/png' && type !== 'image/bmp' 
    && type !== 'image/tiff' && type !== 'image/x-ms-bmp' && type !== 'image/gif') {
    throw createError({
      statusCode: 400,
      message: 'File must be an image',
    })
  }

  const post: PostType | null = await getPostByIdentifier(db, identifier)

  if (!post) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }

  if (post.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this post',
    })
  }

  const extension = type.split('/')[1]
  const coverFolder = `posts/${post.id}/cover`

  // Process the original image with Jimp
  const originalImage = await Jimp.fromBuffer(file)

  const sizes = [
    { width: 160, suffix: 'xxs' },
    { width: 320, suffix: 'xs' },
    { width: 640, suffix: 'sm' },
    { width: 1024, suffix: 'md' },
    { width: 1920, suffix: 'lg' },
    // Original size will be stored as 'original'
  ]
  
  // Store all generated pathnames
  const generatedVariants = []

  // Upload original image
  const blob = new Blob([file], { type })
  const originalBlob = await hb.put(`original.${extension}`, blob, {
    prefix: coverFolder,
  })

  generatedVariants.push({
    size: 'original',
    width: originalImage.width,
    height: originalImage.height,
    pathname: originalBlob.pathname
  })

  // Generate and upload resized versions
  for (const size of sizes) {
    const resized = originalImage.clone().resize({ w: size.width })
    const buffer = await resized.getBuffer(type)
    const blob = new Blob([buffer], { type })
    const response = await hb
      .put(`${coverFolder}/${size.suffix}.${extension}`, blob, {
        addRandomSuffix: false,
      })

    generatedVariants.push({
      size: size.suffix,
      width: resized.width,
      height: resized.height,
      pathname: response.pathname
    })
  }

  await db.prepare(`
    UPDATE posts 
    SET image_src = ?, image_alt = ?, image_ext = ?, updated_at = CURRENT_TIMESTAMP
    WHERE id = ?
  `)
  .bind(coverFolder, fileName, extension, post.id)
  .run()

  return { 
    image: {
      alt: fileName,
      src: coverFolder,
    },
    success: true, 
  }
})
