// /server/api/scripts/migrate-projects.ts
// This script migrates projects from SurrealDB to SQLite

import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  // Connect to SurrealDB
  const { db: surrealDb, connect } = useSurrealDB()
  await connect()

  // Get NuxtHub SQLite database
  const sqliteDb = hubDatabase()

  // Fetch all projects from SurrealDB
  const [projects]: any[] = await surrealDb.query(`
    SELECT * FROM projects WHERE visibility = 'public'
  `)

  console.log(`Found ${projects.length} projects to migrate`)

  // Prepare SQLite statement for insertion
  const stmt = sqliteDb.prepare(`
    INSERT INTO projects (
      author_id, 
      category, 
      company, 
      description, 
      image_src, 
      image_alt, 
      links, 
      name, 
      slug, 
      technologies, 
      visibility
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `)

  // Process each project
  let migratedCount = 0
  for (const project of projects) {
    try {
      // For the first migration, we'll set a default author_id of 1
      // You may need to adjust this based on your user migration strategy
      const authorId = 0
      
      // Convert SurrealDB data format to SQLite format
      // Note: You may need to adjust these mappings based on your actual data structure
      await stmt.bind(
        authorId,
        project.category || null,
        project.company || null,
        project.description || null,
        project.image_src || null,
        project.image_alt || null,
        JSON.stringify(project.links || {}),
        project.name,
        project.slug,
        JSON.stringify(project.technologies || []),
        project.visibility || 'private'
      ).run()
      
      migratedCount++
    } catch (error) {
      console.error(`Failed to migrate project ${project.name}:`, error)
    }
  }

  return {
    success: true,
    total: projects.length,
    migrated: migratedCount
  }
})
