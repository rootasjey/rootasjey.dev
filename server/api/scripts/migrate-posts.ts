import { useSurrealDB } from '~/composables/useSurrealDB'

export default defineEventHandler(async (event) => {
  // Connect to SurrealDB
  const { db: surrealDb, connect } = useSurrealDB()
  await connect()

  // Get NuxtHub SQLite database and Blob storage
  const sqliteDb = hubDatabase()
  const blobStorage = hubBlob()

  // Fetch all posts from SurrealDB
  const [posts]: any[] = await surrealDb.query(`
    SELECT * FROM posts WHERE visibility = 'public' OR visibility = 'project:public'
  `)

  console.log(`Found ${posts.length} posts to migrate`)

  // Prepare SQLite statement for insertion
  const stmt = sqliteDb.prepare(`
    INSERT INTO posts (
      author_id,
      blob_path,
      category,
      description,
      image_src,
      image_alt,
      language,
      links,
      metrics_comments,
      metrics_likes,
      metrics_views,
      name,
      published_at,
      slug,
      styles,
      tags,
      visibility
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `)

  // Process each post
  let migratedCount = 0
  for (const post of posts) {
    try {
      // For the first migration, we'll set a default author_id of 1
      const authorId = 0
      
      // Store the content in blob storage
      let contentBlobKey = null
      if (post.content) {
        // Create a unique path for the content blob
        // Content is a JSON object with a 'content' field
        const blobPath = `posts/${post.slug}/content.json`
        
        // Store the content in blob storage
        await blobStorage.put(blobPath, JSON.stringify(post.content))
        
        // Use the blob path as the content reference in the database
        contentBlobKey = blobPath
      }
      
      // Convert SurrealDB data format to SQLite format
      await stmt.bind(
        authorId,
        contentBlobKey,  // Store the blob reference instead of the content
        post.category || null,
        post.description || null,
        post.image_src || null,
        post.image_alt || null,
        post.language || null,
        JSON.stringify(post.links || {}),
        post.metrics_comments || 0,
        post.metrics_likes || 0,
        post.metrics_views || 0,
        post.name,
        post.published_at || null,
        post.slug,
        JSON.stringify(post.styles || {}),
        JSON.stringify(post.tags || []),
        post.visibility || 'private'
      ).run()
      
      migratedCount++
    } catch (error) {
      console.error(`Failed to migrate post ${post.name}:`, error)
    }
  }

  return {
    success: true,
    total: posts.length,
    migrated: migratedCount
  }
})
