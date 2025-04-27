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
    author_id: userId,
    blob_path,
    category: body.category || "Uncategorized",
    company: body.company || "",
    created_at: new Date().toISOString(),
    description: body.description || "",
    image_alt: body.image?.alt || "",
    image_src: body.image?.src || "",
    links: JSON.stringify(body.links || []),
    name: body.name,
    slug: slug,
    summary: body.summary || "",
    technologies: JSON.stringify(body.technologies || []),
    updated_at: new Date().toISOString(),
    visibility: body.visibility || "public",
  }

  // Insert the project into the database
  const insertStmt = db.prepare(`
    INSERT INTO projects (
      author_id, blob_path, category, company, created_at,
      description, image_alt, image_src, links, name,
      slug, summary, technologies, updated_at, visibility
    ) VALUES (
      @author_id, @blob_path, @category, @company, @created_at,
      @description, @image_alt, @image_src, @links, @name,
      @slug, @summary, @technologies, @updated_at, @visibility
    )
  `)

  const result = await insertStmt.bind(project).run()

  return {
    id: result.meta.last_row_id,
    ...project,
    links: body.links || [],
    technologies: body.technologies || [],
  }
})
