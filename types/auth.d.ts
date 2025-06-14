// auth.d.ts
declare module '#auth-utils' {
  interface User {
    biography: string
    created_at: string;
    id: number
    job: string
    language: string
    location: string
    email: string
    name: string
    role: string
    socials: string
    updated_at: string
  }

  interface UserSession {
    // Add your own fields
  }

  interface SecureSessionData {
    // Add your own fields
  }
}

export {}