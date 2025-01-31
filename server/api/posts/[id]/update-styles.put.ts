// PUT /api/posts/[id]/update-styles
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid

  const postId = event.context.params?.id
  const body = await readBody(event)
  const db = getFirestore()

  if (!postId) {
    throw createError({
      statusCode: 400,
      message: 'Post ID (`id`) is required',
    })
  }

  const postToUpdate = await db.collection("posts")
    .doc(postId)
    .get()

  if (!postToUpdate.exists) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }

  if (postToUpdate.data()?.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this post',
    })
  }

  const docIds = Object.keys(body)

  for await (const docId of docIds) {
    await postToUpdate.ref
      .collection("post_styles")
      .doc(docId)
      .update(body[docId])
  }

  return {
    message: 'Post updated successfully',
    success: true,
  }
})

