// POST /api/projects/:id/tags
// Body: { tagIds: number[] }

export default defineEventHandler(async (event) => {
  const id = event.context.params?.id
  const body = await readBody(event)
  if (!id || !Array.isArray(body?.tagIds)) {
    throw createError({ statusCode: 400, statusMessage: 'Project id and tagIds are required' })
  }
  // Remove all existing tags for this project
  await hubDatabase().prepare('DELETE FROM project_tags WHERE project_id = ?1').bind(id).run()
  // Insert new tags
  for (const tagId of body.tagIds) {
    await hubDatabase().prepare('INSERT INTO project_tags (project_id, tag_id) VALUES (?1, ?2)').bind(id, tagId).run()
  }
  // Return updated tags
  const sql = `SELECT t.* FROM tags t
    INNER JOIN project_tags pt ON pt.tag_id = t.id
    WHERE pt.project_id = ?1
    ORDER BY t.name ASC`
  const stmt = hubDatabase().prepare(sql).bind(id)
  const tags = await stmt.all()
  return tags.results
})
