// GET /api/posts/drafts
import { getFirestore } from 'firebase-admin/firestore'
import { getAuth } from 'firebase-admin/auth'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid

  const db = getFirestore()
  const snapshot = await db
    .collection("posts")
    .where('user_id', '==', userId)
    .where('visibility', 'in', ['private', 'project:private'])
    .orderBy('updated_at', 'desc')
    .limit(25)
    .get()

  const drafts = snapshot.docs.map((doc) => {
    const data = doc.data()
    return Object.assign(data, { 
      id: doc.id,
      created_at: new Date(data.created_at.toDate()),
      updated_at: new Date(data.updated_at.toDate()),
    })
  })

  return drafts
})
