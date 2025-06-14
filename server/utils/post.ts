/**
 * Creates a new post data object with default values for SQLite storage.
 *
 * @param body - The request body containing the post data.
 * @param userId - The ID of the user creating the post.
 * @returns A new post data object with default values.
 */
export const createPostData = (body: any, userId: string | number) => {
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
    tags: JSON.stringify([]),
    user_id: userId,
    visibility: "private",
  }
}

/**
 * Creates a new post file content object in JSON format.
 *
 * @returns A JSON string representing the post content.
 */
export const createPostFileContent = () => {
  return JSON.stringify({
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
  })
}
