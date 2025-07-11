// PUT /api/projects/[identifier]/index.put.ts

import { z } from 'zod'
import { ApiProject } from "~/types/project"
import type { ApiTag } from '~/types/tag'
import { upsertProjectTags } from '~/server/utils/tags'
import { convertApiProjectToProject, getProjectByIdentifier } from '~/server/utils/project'

const updateProjectSchema = z.object({
  name: z.string().min(1).max(255),
  description: z.string().max(1000).optional(),
  company: z.string().max(255).optional(),
  status: z.enum(['active', 'completed', 'archived', 'on-hold']).optional(),
  slug: z.string().min(1).max(255).optional(),
  image_src: z.string().max(255).optional(),
  image_alt: z.string().max(255).optional(),
  links: z.union([z.string(), z.array(z.any())]).optional(),
  tags: z.array(z.object({
    name: z.string().min(1).max(50),
    category: z.string().max(50).optional()
  })).max(20).optional(),
})

export default defineEventHandler(async (event) => {
  const session = await requireUserSession(event)
  const db = hubDatabase()
  const identifier = decodeURIComponent(getRouterParam(event, 'identifier') ?? '')
  const userId = session.user.id
  const isNumericId = typeof identifier === "number" || /^\d+$/.test(String(identifier))

  if (!identifier) {
    throw createError({ statusCode: 400, message: 'Project identifier is required' })
  }

  if (!isNumericId) {
    throw createError({ statusCode: 400, message: `Project identifier must be a numeric ID (received: ${identifier})` })
  }

  const validatedBody = await readValidatedBody(event, updateProjectSchema.parse)
  let apiProject = await getProjectByIdentifier(db, identifier)

  handleProjectErrors(apiProject, userId)
  apiProject = apiProject as ApiProject

  // Check for slug uniqueness if slug is being updated
  if (validatedBody.slug && validatedBody.slug !== apiProject.slug) {
    const slugExists = await db.prepare(`
      SELECT id FROM projects WHERE slug = ? AND id != ?
    `)
    .bind(validatedBody.slug, apiProject.id)
    .first()

    if (slugExists) {
      throw createError({
        statusCode: 409,
        statusMessage: `Slug "${validatedBody.slug}" already exists for another project.`,
      })
    }
  }

  // Prepare update data
  const updateFields: string[] = []
  const updateValues: any[] = []

  if (validatedBody.name !== undefined) {
    updateFields.push('name = ?')
    updateValues.push(validatedBody.name)
  }
  if (validatedBody.description !== undefined) {
    updateFields.push('description = ?')
    updateValues.push(validatedBody.description)
  }
  if (validatedBody.company !== undefined) {
    updateFields.push('company = ?')
    updateValues.push(validatedBody.company)
  }
  if (validatedBody.status !== undefined) {
    updateFields.push('status = ?')
    updateValues.push(validatedBody.status)
  }
  if (validatedBody.slug !== undefined) {
    updateFields.push('slug = ?')
    updateValues.push(validatedBody.slug)
  }
  if (validatedBody.image_src !== undefined) {
    updateFields.push('image_src = ?')
    updateValues.push(validatedBody.image_src)
  }
  if (validatedBody.image_alt !== undefined) {
    updateFields.push('image_alt = ?')
    updateValues.push(validatedBody.image_alt)
  }
  if (validatedBody.links !== undefined) {
    updateFields.push('links = ?')
    updateValues.push(
      typeof validatedBody.links === 'string'
        ? validatedBody.links
        : JSON.stringify(validatedBody.links)
    )
  }

  // Only proceed if there are fields to update
  if (updateFields.length === 0) {
    return {
      success: true,
      message: 'No changes to update',
      project: apiProject,
    }
  }

  updateFields.push('updated_at = ?')
  updateValues.push(new Date().toISOString())

  // Add WHERE clause values
  updateValues.push(apiProject.id, userId)

  const updateResult = await db
    .prepare(`
      UPDATE projects
      SET ${updateFields.join(', ')}
      WHERE id = ? AND user_id = ?
    `)
    .bind(...updateValues)
    .run()

  if (!updateResult.success) {
    throw createError({ statusCode: 500, statusMessage: updateResult.error })
  }

  // --- TAGS: Process tags after project update ---
  let updatedTags: ApiTag[] = []
  if (validatedBody.tags !== undefined) {
    updatedTags = await upsertProjectTags(db, apiProject.id, validatedBody.tags)
  }

  const updatedProject: ApiProject | null = await db
    .prepare(`SELECT * FROM projects WHERE id = ? LIMIT 1`)
    .bind(apiProject.id)
    .first()

  if (!updatedProject) {
    throw createError({ statusCode: 404, message: 'Failed to retrieve updated project' })
  }

  const project = convertApiProjectToProject(updatedProject, { tags: updatedTags })

  return {
    success: true,
    message: 'Project updated successfully',
    project,
  }
})

function handleProjectErrors(project: any, userId?: number) {
  if (!project) {
    throw createError({
      statusCode: 404,
      message: 'Project not found',
    })
  }

  if (project.user_id !== userId) {
    throw createError({
      statusCode: 403,
      message: 'You are not authorized to update this project',
    })
  }
}
