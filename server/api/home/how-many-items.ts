// GET /api/home/how-many-items
// Fetch the number of items in the firestore collection
// for "projects", "posts" and "experiments".
import { getFirestore } from "firebase-admin/firestore"

export default defineEventHandler(async (event) => {
  const db = getFirestore()
  const experiments = await db.collection('experiments').count().get()
  const posts = await db.collection('posts').where('visibility', 'in', ['public', 'project:public']).count().get()
  const projects = await db.collection('projects').count().get()

  return {
    projects: projects.data().count,
    posts: posts.data().count,
    experiments: experiments.data().count,
  }
})
