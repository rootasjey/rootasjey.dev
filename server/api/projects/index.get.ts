// GET /api/projects

import { ProjectType } from "~/types/project"

export default defineEventHandler(async (event) => {
  const query = await hubDatabase()
  .prepare(`SELECT * FROM projects WHERE visibility = 'public'`)
  .all()

  for (const project of query.results) {
    if (typeof project.links === 'string') { project.links = JSON.parse(project.links) }
    if (typeof project.technologies === 'string') { project.technologies = JSON.parse(project.technologies) }

    project.image = {
      alt: project.image_alt || "",
      ext: project.image_ext || "",
      src: project.image_src || "",
    }

    // Remove redundant fields
    delete project.image_alt
    delete project.image_ext
    delete project.image_src
  }

  return query.results as ProjectType[]
})
