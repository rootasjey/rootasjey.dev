// POST /api/projects
import type { ApiTag } from '~/types/tag'
import { upsertProjectTags } from '~/server/utils/tags'

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const body = await readBody(event)
  const blobStorage = hubBlob()
  const userId = session.user.id

  // Create a slug from the project name
  const slug = body.name.toLowerCase().replaceAll(" ", "-")

  // Insert project first (without blob_path)
  const project = {
    blob_path: '',
    company: body.company || "",
    created_at: new Date().toISOString(),
    description: body.description || "",
    image_alt: body.image?.alt || "",
    image_src: body.image?.src || "",
    links: typeof body.links === 'object' ? JSON.stringify(body.links || []) : '[]',
    name: body.name,
    slug,
    updated_at: new Date().toISOString(),
    user_id: userId,
    status: body.status || "active",
  }

  const insertStmt = db.prepare(`
    INSERT INTO projects (
      blob_path, company, created_at,
      description, image_alt, image_src, links, name,
      slug, updated_at, user_id, status
    ) VALUES (
      ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12
    )
  `)

  const result = await insertStmt
    .bind(
      project.blob_path,
      project.company,
      project.created_at,
      project.description,
      project.image_alt,
      project.image_src,
      project.links,
      project.name,
      project.slug,
      project.updated_at,
      project.user_id,
      project.status
    )
    .run()

  // Now create the article blob using the project's ID
  const articleBlob = createArticle()
  const blob_path = `projects/${result.meta.last_row_id}/article.json`
  await blobStorage.put(blob_path, JSON.stringify(articleBlob))

  // Update the project with the blob_path
  await db.prepare(`UPDATE projects SET blob_path = ? WHERE id = ?`)
    .bind(blob_path, result.meta.last_row_id)
    .run()

  // --- TAGS: Process tags after project insert ---
  let createdTags: ApiTag[] = []
  if (Array.isArray(body.tags)) {
    createdTags = await upsertProjectTags(db, result.meta.last_row_id, body.tags)
  }

  return {
    id: result.meta.last_row_id,
    ...project,
    blob_path,
    links: body.links || [],
    tags: createdTags,
  }
})
