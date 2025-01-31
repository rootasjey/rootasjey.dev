// Define a new api endpoint to create a new project in Fireestore
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid

  const db = getFirestore()
  const body = await readBody(event)

  const project = {
    ...body,
    company: "",
    created_at: new Date().toISOString(),
    image: {
      alt: "",
      src: "",
    },
    links: [],
    slug: body.name.toLowerCase().replaceAll(" ", "-"),
    updated_at: new Date().toISOString(),
    user_id: userId,
    visibility: "private",
  }

  const addedProject = await db
  .collection("projects")
  .add(project)

  const doc = await addedProject.get()
  return {
    ...project,
    id: doc.id,
  }
})
