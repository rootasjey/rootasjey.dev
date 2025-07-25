import data from '~/server/api/experiments/data.json'
import { Experiment } from "~/types/experiment"
import { ApiSearchResult } from "~/types/search"

export default defineEventHandler(async (event) => {
  const { q } = getQuery(event) as { q?: string }
  const search = (q || "").trim()

  if (!search) {
    return { results: [], total: 0 }
  }

  const like = `%${search}%`
  const db = await hubDatabase()

  // Search posts
  const postsQuery = await db
  .prepare(`
    SELECT * FROM posts
    WHERE status = 'published'
      AND (name LIKE ? OR description LIKE ? OR tags LIKE ?)
    ORDER BY created_at DESC
    LIMIT 25
  `)
  .bind(like, like, like)
  .run()

  // Search projects
  const projectsQuery = await db
  .prepare(`
    SELECT * FROM projects
    WHERE status IN ('active', 'completed')
      AND (name LIKE ? OR description LIKE ? OR tags LIKE ?)
    ORDER BY created_at DESC
    LIMIT 25
  `)
  .bind(like, like, like)
  .run()

  // Normalize posts
  const posts: ApiSearchResult[] = (postsQuery.results || []).map((post: any) => {
    if (typeof post.links   === 'string') { post.links  = JSON.parse(post.links) }

    post.image = {
      alt: post.image_alt || "",
      ext: post.image_ext || "",
      src: post.image_src || "",
    }

    post.metrics = {
      comments: post.metrics_comments || 0,
      likes: post.metrics_likes || 0,
      views: post.metrics_views || 0,
    }

    // Remove redundant fields
    delete post.image_alt
    delete post.image_ext
    delete post.image_src
    delete post.metrics_comments
    delete post.metrics_likes
    delete post.metrics_views

    return { ...post, type: "post" }
  })

  // Normalize projects
  const projects: ApiSearchResult[] = (projectsQuery.results || []).map((project: any) => {
    if (typeof project.tags === "string") {
      project.tags = JSON.parse(project.tags)
    }
    if (typeof project.links === "string") {
      project.links = JSON.parse(project.links)
    }
    if (typeof project.image === "string") {
      project.image = JSON.parse(project.image)
    }
    return {
      id: project.id,
      user_id: project.user_id,
      name: project.name,
      description: project.description,
      tags: project.tags || [],
      slug: project.slug,
      created_at: project.created_at,
      updated_at: project.updated_at,
      blob_path: project.blob_path,
      company: project.company,
      image: project.image,
      links: project.links || [],
      status: project.status,
      type: "project",
    }
  })

  // Search experiments (in-memory, case-insensitive substring match)
  const qLower = search.toLowerCase()
  const experiments: ApiSearchResult[] = (Array.isArray(data) ? data : []).filter((exp: Experiment) => {
    return (
      (exp.name && exp.name.toLowerCase().includes(qLower)) ||
      (exp.description && exp.description.toLowerCase().includes(qLower))
    )
  }).map((exp: any) => ({
    id: exp.id,
    name: exp.name,
    description: exp.description,
    tags: [], // No tags in data.json, can be extended if needed
    slug: exp.slug,
    created_at: '', // Not available in data.json
    updated_at: '', // Not available in data.json
    type: 'experiment',
  }))

  const results = [...posts, ...projects, ...experiments]
  return {
    results,
    total: results.length,
  }
})
