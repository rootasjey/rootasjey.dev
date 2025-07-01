import { ProjectType } from "~/types/project"

/**
 * Retrieve a project by numeric ID or slug.
 * @param db - The database instance.
 * @param identifier - The project ID (number or numeric string) or slug (string).
 * @returns The project object or null if not found.
 */
export async function getProjectByIdentifier(db: any, identifier: string | number) {
  const isNumericId = typeof identifier === "number" || /^\d+$/.test(String(identifier))
  const query = `
    SELECT * FROM projects
    WHERE ${isNumericId ? "id = ?" : "slug = ?"}
    LIMIT 1
  `
  const value = isNumericId ? Number(identifier) : identifier
  return await db.prepare(query).bind(value).first() as ProjectType | null
}
