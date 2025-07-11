// GET /api/home/how-many-items
// ----------------------------------------
// File system is not yet supported: https://developers.cloudflare.com/workers/runtime-apis/nodejs/
// ----------------------------------------
// import fs from 'fs'
// import path from 'path'
import experimentData from "~/server/api/experiments/data.json"

export default defineEventHandler(async (event) => {
  const db = hubDatabase()

  const posts = await db.prepare(`
    SELECT COUNT(*) AS count 
    FROM posts 
    WHERE visibility = 'public' OR visibility = 'project:public'
  `).first("count")

  const projects = await db.prepare(`
    SELECT COUNT(*) AS count 
    FROM projects 
    WHERE visibility = 'public'
  `).first("count")

  // Count the number of experiments
  // NOTE: Unlike posts and projects, experiments are not stored in the database.
  // Instead, they are stored in the filesystem.
  //  const experimentsDir = path.join(process.cwd(), 'pages/experiments')

  //   // Get all directories inside the experiments folder
  //   const items = fs.readdirSync(experimentsDir, { withFileTypes: true })

  //   // Filter out the index.vue file and only keep directories
  //   const experimentFolders = items
  //     .filter(item => item.isDirectory())
  //     .map(dir => dir.name)

  return {
    posts,
    projects,
    experiments: experimentData.length,
  }
})