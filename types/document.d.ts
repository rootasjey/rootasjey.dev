/**
 * Document types for resumes and cover letters
 */

// ==================== Resume Types ====================

export type ResumeType = 'general' | 'technical' | 'communication' | 'creative'

export interface ProfileSection {
  text: string
}

export interface SkillCategory {
  title: string
  skills: string[]
}

export interface SkillsSection {
  categories: SkillCategory[]
}

export interface Experience {
  company: string
  position: string
  location?: string
  startDate: string
  endDate?: string | null  // null means "Present"
  description?: string
  highlights: string[]
  tags?: string[]
}

export interface Education {
  institution: string
  degree: string
  field?: string
  location?: string
  startDate: string
  endDate?: string
  description?: string
  courses?: string[]
}

export interface PersonalProject {
  name: string
  url?: string
  description: string
  tags?: string[]
}

export interface Interest {
  icon?: string
  title: string
  description: string
}

export interface ContactInfo {
  email?: string
  phone?: string
  website?: string
  linkedin?: string
  github?: string
  location?: string
}

export interface Resume {
  id: number
  slug: string
  title: string
  subtitle?: string
  type: ResumeType
  language: 'en' | 'fr'
  templateName: string
  
  // Personal info
  name: string
  tagline?: string
  location?: string
  
  // Content sections (JSON fields)
  profile?: ProfileSection
  skills?: SkillsSection
  experiences?: Experience[]
  education?: Education[]
  projects?: PersonalProject[]
  interests?: Interest[]
  contact?: ContactInfo
  
  // Metadata
  published: boolean
  createdAt: string
  updatedAt: string
  
  // Relations
  userId: number
  linkedLetters?: CoverLetter[]
}

// API format (snake_case from database)
export interface ApiResume {
  id: number
  slug: string
  title: string
  subtitle?: string
  type: ResumeType
  language: 'en' | 'fr'
  template_name: string
  
  name: string
  tagline?: string
  location?: string
  
  profile?: string  // JSON string
  skills?: string   // JSON string
  experiences?: string  // JSON string
  education?: string    // JSON string
  projects?: string     // JSON string
  interests?: string    // JSON string
  contact?: string      // JSON string
  
  published: boolean
  created_at: string
  updated_at: string
  user_id: number
}

// ==================== Cover Letter Types ====================

export interface CoverLetter {
  id: number
  slug: string
  title: string
  companyName?: string
  position?: string
  language: 'en' | 'fr'
  templateName: string
  
  // Letter content
  greeting?: string
  body: string  // HTML from TipTap
  closing?: string
  signature?: string
  
  // Metadata
  published: boolean
  createdAt: string
  updatedAt: string
  
  // Relations
  resumeId?: number
  resume?: Resume
  userId: number
}

// API format (snake_case from database)
export interface ApiCoverLetter {
  id: number
  slug: string
  title: string
  company_name?: string
  position?: string
  language: 'en' | 'fr'
  template_name: string
  
  greeting?: string
  body: string
  closing?: string
  signature?: string
  
  published: boolean
  created_at: string
  updated_at: string
  
  resume_id?: number
  user_id: number
}

// ==================== Form/Editor Types ====================

export interface ResumeFormData {
  slug: string
  title: string
  subtitle?: string
  type: ResumeType
  language: 'en' | 'fr'
  templateName: string
  
  name: string
  tagline?: string
  location?: string
  
  profile?: ProfileSection
  skills?: SkillsSection
  experiences?: Experience[]
  education?: Education[]
  projects?: PersonalProject[]
  interests?: Interest[]
  contact?: ContactInfo
  
  published: boolean
}

export interface CoverLetterFormData {
  slug: string
  title: string
  companyName?: string
  position?: string
  language: 'en' | 'fr'
  templateName: string
  
  greeting?: string
  body: string
  closing?: string
  signature?: string
  
  published: boolean
  resumeId?: number
}

// ==================== List/Summary Types ====================

export interface ResumeSummary {
  id: number
  slug: string
  title: string
  subtitle?: string
  type: ResumeType
  language: 'en' | 'fr'
  updatedAt: string
  linkedLettersCount?: number
}

export interface CoverLetterSummary {
  id: number
  slug: string
  title: string
  companyName?: string
  position?: string
  language: 'en' | 'fr'
  updatedAt: string
  linkedResume?: {
    id: number
    slug: string
    title: string
  }
}
