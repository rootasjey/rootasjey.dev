// POST /api/posts/[id]/upload-image
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'
import { getStorage } from 'firebase-admin/storage'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid
  const postId = event.context.params?.id

  if (!postId) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Missing post id',
    })
  }

  const postDoc = await getFirestore()
    .collection('posts')
    .doc(postId)
    .get()

  if (postDoc.data()?.user_id !== userId) {
    throw createError({
      statusCode: 403,
      statusMessage: 'You are not the author of this post',
    })
  }

  const body = await readBody(event)
  const base64Data = body.file.split(';base64,').pop()
  const fileExtension = body.fileName.split('.').pop()
  const placement = body.placement || 'cover'
  const bucket = getStorage().bucket()

  if (placement === 'cover') {
    const storagePath = `posts/${postId}/cover`
    
    // Delete old files in the cover directory
    await bucket.deleteFiles({
      prefix: storagePath
    })

    const filePath = `posts/${postId}/cover/cover.${fileExtension}`
    const file = bucket.file(filePath)

    await file.save(Buffer.from(base64Data, 'base64'), {
      contentType: body.type,
    })

    const [url] = await file.getSignedUrl({
      action: 'read',
      expires: '03-01-2500',
    })

    await postDoc.ref.update({
      image: {
        alt: `${postDoc.data()?.name} cover image`,
        src: url,
      },
      updated_at: new Date(),
    })

    return { 
      image: {
        alt: `${postDoc.data()?.name} cover image`,
        src: url,
      }
    }
  }

  // Handle post content image
  const fileName: string = body.fileName.split('.')[0]
  const filePath: string = `posts/${postId}/images/${fileName}.${fileExtension}`
  const file = bucket.file(filePath)

  await file.save(Buffer.from(base64Data, 'base64'), {
    contentType: body.type,
  })

  const [url] = await file.getSignedUrl({
    action: 'read',
    expires: '03-01-2500',
  })

  return {
    image: {
      alt: fileName,
      src: url,
    }
  }
})
