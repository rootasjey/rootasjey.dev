// POST /api/posts/[id]/upload-image
import { RecordId } from "surrealdb"
import { useSurrealDB } from "~/composables/useSurrealDB"
import { PostType } from "~/types/post"

export default defineEventHandler(async (event) => {
  const { db, connect } = useSurrealDB()
  const postId = event.context.params?.id
  const formData = await readMultipartFormData(event)
  
  const file = formData?.find(item => item.name === 'file')?.data
  const fileName = formData?.find(item => item.name === 'fileName')?.data.toString()
  const type = formData?.find(item => item.name === 'type')?.data.toString()
  // const placement = formData?.find(item => item.name === 'placement')?.data.toString()

  if (!postId || !file || !fileName || !type) {
    throw createError({
      statusCode: 400,
      message: 'Missing required fields',
    })
  }

  await connect()
  const rawToken = getHeader(event, "Authorization")
  if (rawToken) {
    const token = rawToken.replace('Bearer ', '').replace('token=', '')
    await db.authenticate(token)
  }

  const blob = new Blob([file], { type })
  const uploadedBlob = await hubBlob().put(fileName, blob, {
    addRandomSuffix: true,
    prefix: 'images'
  })

  const imageUrl = `${uploadedBlob.pathname}`

  const postRecordParts = postId.split(":")
  const postRecordId = new RecordId(postRecordParts[0], postRecordParts[1])
  const post: Partial<PostType> = await db.merge(postRecordId, {
    image: {
      name: fileName,
      src: imageUrl,
      alt: fileName,
    },
  })

  return { 
    image: {
      alt: post.image?.alt ?? "",
      src: post.image?.src ?? "",
    },
    success: true, 
  }
})
