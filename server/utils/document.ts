import type { ApiResume, Resume, ApiCoverLetter, CoverLetter } from '~/types/document'

/**
 * Parse JSON field safely
 */
function parseJsonField<T>(jsonString: string | null | undefined): T | undefined {
  if (!jsonString) return undefined
  try {
    return JSON.parse(jsonString) as T
  } catch (error) {
    console.error('Failed to parse JSON field:', error)
    return undefined
  }
}

/**
 * Convert API resume (snake_case, JSON strings) to client format (camelCase, parsed objects)
 */
export function apiResumeToResume(apiResume: ApiResume): Resume {
  return {
    id: apiResume.id,
    slug: apiResume.slug,
    title: apiResume.title,
    subtitle: apiResume.subtitle,
    type: apiResume.type,
    language: apiResume.language,
    templateName: apiResume.template_name,
    
    name: apiResume.name,
    tagline: apiResume.tagline,
    location: apiResume.location,
    
    profile: parseJsonField(apiResume.profile),
    skills: parseJsonField(apiResume.skills),
    experiences: parseJsonField(apiResume.experiences),
    education: parseJsonField(apiResume.education),
    projects: parseJsonField(apiResume.projects),
    interests: parseJsonField(apiResume.interests),
    contact: parseJsonField(apiResume.contact),
    
    published: apiResume.published,
    createdAt: apiResume.created_at,
    updatedAt: apiResume.updated_at,
    userId: apiResume.user_id,
  }
}

/**
 * Convert client resume to API format for database insertion/update
 */
export function resumeToApiResume(resume: Partial<Resume> & { userId: number }): Partial<ApiResume> {
  const apiResume: Partial<ApiResume> = {
    slug: resume.slug,
    title: resume.title,
    subtitle: resume.subtitle,
    type: resume.type,
    language: resume.language,
    template_name: resume.templateName,
    
    name: resume.name,
    tagline: resume.tagline,
    location: resume.location,
    
    published: resume.published,
    user_id: resume.userId,
  }
  
  // Convert objects to JSON strings
  if (resume.profile !== undefined) {
    apiResume.profile = JSON.stringify(resume.profile)
  }
  if (resume.skills !== undefined) {
    apiResume.skills = JSON.stringify(resume.skills)
  }
  if (resume.experiences !== undefined) {
    apiResume.experiences = JSON.stringify(resume.experiences)
  }
  if (resume.education !== undefined) {
    apiResume.education = JSON.stringify(resume.education)
  }
  if (resume.projects !== undefined) {
    apiResume.projects = JSON.stringify(resume.projects)
  }
  if (resume.interests !== undefined) {
    apiResume.interests = JSON.stringify(resume.interests)
  }
  if (resume.contact !== undefined) {
    apiResume.contact = JSON.stringify(resume.contact)
  }
  
  return apiResume
}

/**
 * Convert API cover letter (snake_case) to client format (camelCase)
 */
export function apiCoverLetterToCoverLetter(apiLetter: ApiCoverLetter): CoverLetter {
  return {
    id: apiLetter.id,
    slug: apiLetter.slug,
    title: apiLetter.title,
    companyName: apiLetter.company_name,
    position: apiLetter.position,
    language: apiLetter.language,
    templateName: apiLetter.template_name,
    
    greeting: apiLetter.greeting,
    body: apiLetter.body,
    closing: apiLetter.closing,
    signature: apiLetter.signature,
    
    published: apiLetter.published,
    createdAt: apiLetter.created_at,
    updatedAt: apiLetter.updated_at,
    
    resumeId: apiLetter.resume_id,
    userId: apiLetter.user_id,
  }
}

/**
 * Convert client cover letter to API format for database insertion/update
 */
export function coverLetterToApiCoverLetter(letter: Partial<CoverLetter> & { userId: number }): Partial<ApiCoverLetter> {
  return {
    slug: letter.slug,
    title: letter.title,
    company_name: letter.companyName,
    position: letter.position,
    language: letter.language,
    template_name: letter.templateName,
    
    greeting: letter.greeting,
    body: letter.body,
    closing: letter.closing,
    signature: letter.signature,
    
    published: letter.published,
    resume_id: letter.resumeId,
    user_id: letter.userId,
  }
}

/**
 * Fetch all resumes from database
 */
export async function getAllResumes(db: any, options?: { published?: boolean }): Promise<Resume[]> {
  let query = 'SELECT * FROM resumes'
  const conditions: string[] = []
  
  if (options?.published !== undefined) {
    conditions.push(`published = ${options.published ? 1 : 0}`)
  }
  
  if (conditions.length > 0) {
    query += ' WHERE ' + conditions.join(' AND ')
  }
  
  query += ' ORDER BY updated_at DESC'
  
  const result = await db.prepare(query).all()
  return result.results.map(apiResumeToResume)
}

/**
 * Fetch a single resume by slug
 */
export async function getResumeBySlug(db: any, slug: string): Promise<Resume | null> {
  const result = await db
    .prepare('SELECT * FROM resumes WHERE slug = ?')
    .bind(slug)
    .first()
  
  return result ? apiResumeToResume(result) : null
}

/**
 * Fetch all cover letters from database
 */
export async function getAllCoverLetters(db: any, options?: { published?: boolean }): Promise<CoverLetter[]> {
  let query = 'SELECT * FROM cover_letters'
  const conditions: string[] = []
  
  if (options?.published !== undefined) {
    conditions.push(`published = ${options.published ? 1 : 0}`)
  }
  
  if (conditions.length > 0) {
    query += ' WHERE ' + conditions.join(' AND ')
  }
  
  query += ' ORDER BY updated_at DESC'
  
  const result = await db.prepare(query).all()
  return result.results.map(apiCoverLetterToCoverLetter)
}

/**
 * Fetch a single cover letter by slug
 */
export async function getCoverLetterBySlug(db: any, slug: string): Promise<CoverLetter | null> {
  const result = await db
    .prepare('SELECT * FROM cover_letters WHERE slug = ?')
    .bind(slug)
    .first()
  
  return result ? apiCoverLetterToCoverLetter(result) : null
}

/**
 * Fetch cover letters linked to a resume
 */
export async function getCoverLettersByResumeId(db: any, resumeId: number): Promise<CoverLetter[]> {
  const result = await db
    .prepare('SELECT * FROM cover_letters WHERE resume_id = ? ORDER BY updated_at DESC')
    .bind(resumeId)
    .all()
  
  return result.results.map(apiCoverLetterToCoverLetter)
}
