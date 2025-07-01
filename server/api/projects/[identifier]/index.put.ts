// PUT /api/projects/[identifier]/index.put.ts

import { z } from 'zod'
import { ProjectType } from "~/types/project"
import type { ApiTag } from "~/types/post"
import { upsertProjectTags } from '~/server/utils/tags'
import { getProjectByIdentifier } from '~/server/utils/project'

const updateProjectSchema = z.object({
  name: z.string().min(1).max(255),
  description: z.string().max(1000).optional(),
  company: z.string().max(255).optional(),
  status: z.enum(['active', 'completed', 'archived', 'on-hold']).optional(),
  slug: z.string().min(1).max(255),
  newSlug: z.string().min(1).max(255).optional(),
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

  if (!identifier) {
    throw createError({
      statusCode: 400,
      message: 'Project identifier is required',
    })
  }

  const validatedBody = await readValidatedBody(event, updateProjectSchema.parse)
  let project: ProjectType | null = await getProjectByIdentifier(db, identifier)

  handleProjectErrors(project, userId)
  project = project as ProjectType

  // Check for slug uniqueness if slug is being updated
  if (validatedBody.newSlug && validatedBody.newSlug !== project.slug) {
    const slugExists = await db.prepare(`
      SELECT id FROM projects WHERE slug = ? AND id != ?
    `)
    .bind(validatedBody.newSlug, project.id)
    .first()

    if (slugExists) {
      throw createError({
        statusCode: 409,
        statusMessage: `Slug "${validatedBody.newSlug}" already exists for another project.`,
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
  if (validatedBody.newSlug !== undefined) {
    updateFields.push('slug = ?')
    updateValues.push(validatedBody.newSlug)
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
      project,
    }
  }

  // Add updated_at timestamp
  updateFields.push('updated_at = ?')
  updateValues.push(new Date().toISOString())

  // Add WHERE clause values
  updateValues.push(project.id, userId)

  // Execute update
  const updateQuery = `
    UPDATE projects
    SET ${updateFields.join(', ')}
    WHERE id = ? AND user_id = ?
  `

  const updateResult = await db
    .prepare(updateQuery)
    .bind(...updateValues)
    .run()

  if (!updateResult.success) {
    throw createError({
      statusCode: 500,
      statusMessage: updateResult.error,
    })
  }

  // --- TAGS: Process tags after project update ---
  let updatedTags: ApiTag[] = []
  if (validatedBody.tags !== undefined) {
    updatedTags = await upsertProjectTags(db, project.id, validatedBody.tags)
  }

  const updatedProject = await db
    .prepare(`SELECT * FROM projects WHERE id = ? LIMIT 1`)
    .bind(project.id)
    .first()

  if (!updatedProject) {
    throw createError({
      statusCode: 500,
      message: 'Failed to retrieve updated project',
    })
  }

  const formattedProject: Partial<ProjectType> = {
    ...updatedProject,
    links: typeof updatedProject.links === 'string' ? JSON.parse(updatedProject.links || '[]') : updatedProject.links,
    tags: updatedTags,
    image: {
      alt: updatedProject.image_alt as string || "",
      ext:  updatedProject.image_ext as string || "",
      src: updatedProject.image_src as string || "",
    }
  }

  // Remove redundant fields
  delete formattedProject.image_alt
  delete formattedProject.image_ext
  delete formattedProject.image_src

  return {
    success: true,
    message: 'Project updated successfully',
    project: formattedProject,
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
