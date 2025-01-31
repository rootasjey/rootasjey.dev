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

  const bucket = getStorage().bucket()
  const storagePath = `posts/${postId}/cover`
  
  // Delete all files in the cover directory
  await bucket.deleteFiles({
    prefix: storagePath
  })

  // Update post metadata to remove cover URL
  await postDoc.ref.update({
    image: {
      alt: '',
      src: '',
    },
    updated_at: new Date(),
  })

  return { success: true }
})
