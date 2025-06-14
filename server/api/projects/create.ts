// POST /api/projects/create.ts
export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const body = await readBody(event)
  const blobStorage = hubBlob()

  const userId = session.user.id

  // Create a slug from the project name
  const slug = body.name.toLowerCase().replaceAll(" ", "-")

  // Post content blob
  const postContentBlob = createPostFileContent()
  const blob_path = `projects/${slug}/content.json`

  // Store the content in blob storage
  await blobStorage.put(blob_path, JSON.stringify(postContentBlob))

  // Prepare the project data
  const project = {
    blob_path,
    category: body.category || "Uncategorized",
    company: body.company || "",
    created_at: new Date().toISOString(),
    description: body.description || "",
    image_alt: body.image?.alt || "",
    image_src: body.image?.src || "",
    links: typeof body.links === 'object' ? JSON.stringify(body.links || []) : '[]',
    name: body.name,
    slug,
    technologies: typeof body.technologies === 'object' ? JSON.stringify(body.technologies || []) : '[]',
    updated_at: new Date().toISOString(),
    user_id: userId,
    visibility: body.visibility || "public",
  }

  // Insert the project into the database
  const insertStmt = db.prepare(`
    INSERT INTO projects (
      blob_path, category, company, created_at,
      description, image_alt, image_src, links, name,
      slug, technologies, updated_at, user_id, visibility
    ) VALUES (
      ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13, ?14
    )
  `)

  const result = await insertStmt.bind(...Object.values(project)).run()

  return {
    id: result.meta.last_row_id,
    ...project,
    links: body.links || [],
    technologies: body.technologies || [],
  }
})
