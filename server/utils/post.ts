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
    category: body?.category ?? "",
    description: body?.description ?? "",
    image_src: body?.image?.src ?? "",
    image_alt: body?.image?.alt ?? "",
    language: "en",
    links: JSON.stringify([]),
    metrics_comments: 0,
    metrics_likes: 0,
    metrics_views: 0,
    name,
    slug: name.toLowerCase().replaceAll(" ", "-"),
    styles: JSON.stringify({
      meta: {
        align: null,
      },
    }),
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
  return await db.prepare(query).bind(value).first()
}
