import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'
import { getStorage } from 'firebase-admin/storage'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid

  if (!userId) {
    throw createError({
      statusCode: 401,
      message: 'Unauthorized',
    })
  }

  const postId = event.context.params?.id
  const body = await readBody(event)

  if (!postId) {
    throw createError({
      statusCode: 400,
      message: 'Post ID (`id`) is required',
    })
  }

  const db = getFirestore()
  const postDoc = await db.collection("posts").doc(postId).get()
  if (!postDoc.exists) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }
  if (postDoc.data()?.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this post',
    })
  }

  const storage = getStorage()
  const bucket = storage.bucket()
  const file = bucket.file(`posts/${postId}/post.json`)
  await file.save(body.content)

  await db.collection("posts")
  .doc(postId)
  .update({
    updatedAt: new Date(),
  })

  return {
    success: true,
    message: 'Post content updated successfully',
  }
})
