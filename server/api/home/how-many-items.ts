// GET /api/home/how-many-items
import { useSurrealDB } from "~/composables/useSurrealDB"

export default defineEventHandler(async (event) => {
  const { db, connect } = useSurrealDB()
  await connect()

  // Count the number of projects in the "projects" collection
  const [postCount]: any = await db.query("SELECT count() AS posts FROM posts WHERE visibility = 'public' OR visibility = 'project:public' GROUP ALL;")
  const [projectCount]: any = await db.query("SELECT count() AS projects FROM projects WHERE visibility = 'public' GROUP ALL;")

  const { projects } = projectCount[0]
  const { posts } = postCount[0]

  return {
    projects,
    posts,
    experiments: 0,
  }
})
