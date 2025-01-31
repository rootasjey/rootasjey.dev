
/**
 * Creates a new post data object with default values.
 *
 * @param body - The request body containing the post data.
 * @param userId - The ID of the user creating the post.
 * @returns A new post data object with default values.
 */
export const createPostData = (body: any, userId: string) => {
  const name = body?.name || "New Post"
  return {
    authors: [],
    category: body?.category ?? "",
    created_at: new Date(),
    description: body?.description ?? "",
    image: {
      alt: "",
      src: "",
    },
    language: "en",
    links: [],
    metrics: {
      comments: 0,
      likes: 0,
      views: 0,
    },
    name,
    slug: name.toLowerCase().replaceAll(" ", "-"),
    tags: [],
    updated_at: new Date(),
    user_id: userId ?? "",
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
