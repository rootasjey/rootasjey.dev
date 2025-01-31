import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const db = getFirestore()

  const snapshot = await db.collection("projects").get()
  const projects = snapshot.docs.map((doc) => Object.assign({ id: doc.id }, doc.data()))

  const projectByCategory: { [key: string]: any[] } = {}
  for await (const project of projects) {
    if (!projectByCategory[project.category]) {
      projectByCategory[project.category] = []
    }
    projectByCategory[project.category].push(project)
  }

  return projectByCategory
})