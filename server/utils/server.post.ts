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
    author_id: userId,
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

/**
 * Creates a metadata object for a post file.
 *
 * @param postId - The ID of the post.
 * @param userId - The ID of the user who created the post.
 * @returns An object containing the file metadata.
 */
export const createPostFileMetadata = ({
  postId = "", 
  userId = "",
  projectId = "",
}) => {
  return {
    contentType: "application/json",
    metadata: {
      contentType: "application/json",
      post_id: postId,
      project_id: projectId,
      user_id: userId,
    },
  }
}
