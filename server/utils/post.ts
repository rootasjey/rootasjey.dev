import { ApiPost, Post } from "~/types/post"

/**
 * Creates a new post data object with default values for SQLite storage.
 *
 * @param body - The request body containing the post data.
 * @param userId - The ID of the user creating the post.
 * @returns A new post data object with default values.
 */
export const createPostData = (body: any, userId: number) => {
  const name = body?.name || "New Post"
  return {
    blob_path: "",
    description: body?.description ?? "",
    image_src: "",
    image_alt: "",
    language: "en",
    links: JSON.stringify([]),
    metrics_comments: 0,
    metrics_likes: 0,
    metrics_views: 0,
    name,
    slug: name.toLowerCase().replaceAll(" ", "-"),
    user_id: userId,
    status: body?.status ?? "draft",
  }
}

/**
 * Creates a new article in JSON format.
 *
 * @returns A JSON string representing the post content.
 */
export const createArticle = () => {
  return {
    "type": "doc",
    "content": [
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "«It's your place in the world; it's your life. Go on and do all you can with it, and make it the life you want to live.» — Mae Jemison"
          },
        ],
      },
    ],
  }
}

/**
 * Retrieve a post by numeric ID or slug.
 * @param db - The database instance.
 * @param identifier - The post ID (number or numeric string) or slug (string).
 * @returns The post object or null if not found.
 */
export async function getPostByIdentifier(db: any, identifier: string | number) {
  const isNumericId = typeof identifier === "number" || /^\d+$/.test(String(identifier))
  const query = `
    SELECT p.*, u.avatar as user_avatar, u.name as user_name
    FROM posts p
    JOIN users u ON p.user_id = u.id
    WHERE ${isNumericId ? "p.id = ?" : "p.slug = ?"}
    LIMIT 1
  `
  const value = isNumericId ? Number(identifier) : identifier
  return await db.prepare(query).bind(value).first() as ApiPost | null
}

/**
 * Converts an API post object to a Post type.
 * @param apiPost - The API post object to convert.
 * @param options - Optional parameters for additional data.
 * @param options.tags - Array of tags to associate with the post.
 * @param options.article - JSON string of the article content.
 * @param options.userName - Name of the user who created the post.
 * @param options.userAvatar - Avatar URL of the user who created the post.
 * @returns - A Post object with the converted data.
 */
export function convertApiToPost(
  apiPost: ApiPost,
  options?: {
    tags?: Record<string, unknown>[]
    article?: string
    userName?: string
    userAvatar?: string
  }
): Post {
  return {
    article: JSON.parse(options?.article ?? JSON.stringify(createArticle())),
    blobPath: apiPost.blob_path ?? undefined,
    createdAt: apiPost.created_at,
    description: apiPost.description ?? "",
    id: apiPost.id,
    image: {
      alt: apiPost.image_alt ?? "",
      ext: apiPost.image_ext ?? "",
      src: apiPost.image_src ?? "",
    },
    language: apiPost.language,
    links: apiPost.links ? JSON.parse(apiPost.links) : [],
    metrics: {
      comments: apiPost.metrics_comments,
      likes: apiPost.metrics_likes,
      views: apiPost.metrics_views,
    },
    name: apiPost.name,
    publishedAt: apiPost.published_at ?? undefined,
    slug: apiPost.slug,
    status: apiPost.status,
    tags: (options?.tags || []).map(t => ({
      id: Number(t.id),
      name: String(t.name),
      category: typeof t.category === 'string' ? t.category : '',
      created_at: t.created_at ? String(t.created_at) : '',
      updated_at: t.updated_at ? String(t.updated_at) : ''
    })),
    updatedAt: apiPost.updated_at,
    user: {
      id: apiPost.user_id,
      avatar: options?.userAvatar ?? "",
      name: options?.userName ?? "",
    },
  }
}
