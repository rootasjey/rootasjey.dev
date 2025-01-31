// GET /api/posts
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const db = getFirestore()

  const snapshot = await db
  .collection("posts")
  .where('visibility', 'in', ['public', 'project:public'])
  .orderBy('created_at', 'desc')
  .limit(25)
  .get()

  const posts = snapshot.docs.map((doc) => {
    const data = doc.data()
    return Object.assign(data, { 
      id: doc.id,
      created_at: new Date(data.created_at.toDate()),
      updated_at: new Date(data.updated_at.toDate()),
    })
  })

  return posts
})