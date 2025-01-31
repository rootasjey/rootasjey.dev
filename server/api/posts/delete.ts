// Delete a post from Firestore
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'
import { getStorage } from 'firebase-admin/storage'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid
  
  const db = getFirestore()
  const body = await readBody(event)
  
  const { id } = body
  const post = await db.collection("posts").doc(id).get()

  if (post.data()?.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: "You are not authorized to delete this post",
    })
  }

  const storage = getStorage()
  const bucket = storage.bucket()
  const file = bucket.file(`posts/${id}/post.json`)
  await file.delete()

  await db.collection("posts").doc(id).delete()
  return {
    message: "Post deleted successfully",
    id,
  }
})