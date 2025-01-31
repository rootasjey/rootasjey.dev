// PUT /api/posts/[id]/update-meta
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid

  const postId = event.context.params?.id
  const body = await readBody(event)
  const db = getFirestore()

  if (!postId) {
    throw createError({
      statusCode: 400,
      message: 'Post ID (`id`) is required',
    })
  }

  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: 'Post name is required',
    })
  }

  const postToUpdate = await db.collection("posts")
    .doc(postId)
    .get()
  
  if (!postToUpdate.exists) {
    throw createError({
      statusCode: 404,
      message: 'Post not found',
    })
  }

  if (postToUpdate.data()?.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this post',
    })
  }

  let category = body.category ?? ""
  category = category === "no category" ? "" : category.toLowerCase()

  await postToUpdate.ref
    .update({
      category,
      description: body.description ?? "",
      language: body.language ?? "en",
      name: body.name,
      visibility: body.visibility ?? "public",
      slug: body.slug ?? "",
      updated_at: new Date(),
    })

  const updatedPost = await postToUpdate.ref.get()

  const postData  = updatedPost.data()
  const post = {
    ...postData,
    id: updatedPost.id,
    created_at: new Date(postData?.created_at.toDate()),
    updated_at: new Date(postData?.updated_at.toDate()),
  }

  return {
    message: 'Post updated successfully',
    post,
    success: true,
  }
})
