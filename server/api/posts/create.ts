// POST /api/posts/create
import { getAuth } from 'firebase-admin/auth'
import { getFirestore } from 'firebase-admin/firestore'
import { getStorage } from 'firebase-admin/storage'
import { createPostData, createPostFileContent, createPostFileMetadata } from '~/server/utils/server.post'

export default defineEventHandler(async (event) => {
  const userIdToken = getHeader(event, "Authorization")
  const decodedToken = await getAuth().verifyIdToken(userIdToken ?? "")
  const userId = decodedToken.uid

  const db = getFirestore()
  const body = await readBody(event)

  if (!body.name) {
    throw createError({
      statusCode: 400,
      message: "Post name is required",
    })
  }

  const postData = createPostData(body, userId)
  const addedPost = await db
  .collection("posts")
  .add(postData)

  // Create a new post's styles document in Firestore
  await addedPost.collection("post_styles").doc("meta").set({
    align: "",
  })

  const doc = await addedPost.get()

  const storage = getStorage()
  const bucket = storage.bucket()
  const file = bucket.file(`posts/${doc.id}/post.json`)
  await file.save(
    createPostFileContent(),
    createPostFileMetadata({
      postId: doc.id, 
      userId,
    }),
  )

  return {
    ...postData,
    id: doc.id,
  }
})
