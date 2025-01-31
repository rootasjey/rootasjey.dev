// GET /api/posts/:id
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'
import { getStorage } from 'firebase-admin/storage'

export default defineEventHandler(async (event) => {
  const postId = event.context.params?.id

  let userId = ""
  if (!postId) {
    throw createError({
      statusCode: 400,
      message: 'Post ID (`id`) is required.',
    })
  }

  const userIdToken = getHeader(event, "Authorization")
  if (userIdToken) {
    const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
    userId = decodedToken.uid
  }

  const db = getFirestore()
  const storage = getStorage()

  const postDoc = await db.collection("posts")
    .doc(postId)
    .get()

  const postData = postDoc.data()
  if (!postDoc.exists || !postData) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }

  if (postData.visibility !== "public" && postData?.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to view this post',
    })
  }

  const bucket = storage.bucket()
  const file = bucket.file(`posts/${postId}/post.json`)
  const [content] = await file.download()

  // Retrieve post's styles
  const styles: Record<string, any> = {}
  const docids = await postDoc.ref.collection("post_styles").listDocuments()
  for await (const docid of docids) {
    const doc = await docid.get()
    styles[doc.id] = doc.data()
  }

  return {
    id: postDoc.id,
    ...postData,
    canEdit: userId === postData.user_id,
    content: content.toString('utf-8'),
    created_at: new Date(postData.created_at.toDate()),
    updated_at: new Date(postData.updated_at.toDate()),
    styles,
  }
})