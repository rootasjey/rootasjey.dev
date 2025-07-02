import { ApiProject, Project } from "~/types/project"
import type { ApiTag } from "~/types/tag"

/**
 * Retrieve a project by numeric ID or slug.
 * @param db - The database instance.
 * @param identifier - The project ID (number or numeric string) or slug (string).
 * @returns The project object or null if not found.
 */
export async function getProjectByIdentifier(db: any, identifier: string | number) {
  const isNumericId = typeof identifier === "number" || /^\d+$/.test(String(identifier))
  const query = `
    SELECT * FROM projects
    WHERE ${isNumericId ? "id = ?" : "slug = ?"}
    LIMIT 1
  `
  const value = isNumericId ? Number(identifier) : identifier
  return await db.prepare(query).bind(value).first() as ApiProject | null
}

/**
 * Converts a project from the API format to the application format.
 * @param apiProject - The project object from the API.
 * @param tags - An array of tags associated with the project.
 * @returns The project object in the application format.
 */
export function convertApiProjectToProject(
  apiProject: ApiProject, 
  options?: {
    tags?: Record<string, unknown>[]
    article?: string
    userName?: string
    userAvatar?: string
  }
): Project {
  const tags = options?.tags || []
  const primaryTag = tags.length > 0 ? {
    id: Number(tags[0].id),
    name: String(tags[0].name),
    category: typeof tags[0].category === 'string' ? tags[0].category : '',
    created_at: tags[0].created_at ? String(tags[0].created_at) : '',
    updated_at: tags[0].updated_at ? String(tags[0].updated_at) : ''
  } : undefined
  
  const secondaryTags = (tags.length > 1 ? tags.slice(1) : []) as ApiTag[]

  return {
    article: JSON.parse(options?.article ?? JSON.stringify(createArticle())),
    blobPath: apiProject.blob_path ?? '',
    company: apiProject.company ?? '',
    createdAt: apiProject.created_at,
    description: apiProject.description ?? '',
    endDate: apiProject.end_date,
    id: apiProject.id,
    image: {
      alt: apiProject.image_alt ?? '',
      ext: apiProject.image_ext ?? '',
      src: apiProject.image_src ?? '',
    },
    links: apiProject.links ? JSON.parse(apiProject.links) : [],
    metrics: {
      comments: apiProject.metrics_comments,
      likes: apiProject.metrics_likes,
      views: apiProject.metrics_views,
    },
    name: apiProject.name,
    primaryTag,
    secondaryTags,
    slug: apiProject.slug,
    startDate: apiProject.start_date,
    status: apiProject.status,
    tags:tags.map(t => ({
      id: Number(t.id),
      name: String(t.name),
      category: typeof t.category === 'string' ? t.category : '',
      created_at: t.created_at ? String(t.created_at) : '',
      updated_at: t.updated_at ? String(t.updated_at) : ''
    })),
    updated_at: apiProject.updated_at,
    user: {
      id: apiProject.user_id,
      avatar: apiProject.user_avatar,
      name: apiProject.user_name,
    },
  }
}
