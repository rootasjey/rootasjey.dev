// GET /api/experiments/wall-of-code/snippet
// Fetches a random code snippet from GitHub's public repositories

interface GitHubRepository {
  name: string
  full_name: string
  html_url: string
  stargazers_count: number
  language: string
  updated_at: string
  default_branch: string
}

interface GitHubContent {
  name: string
  path: string
  content: string
  encoding: string
  html_url: string
}

interface CodeSnippet {
  code: string
  projectName: string
  filePath: string
  repositoryUrl: string
  language: string
  starCount: number
  lastUpdated: string
  commitHash?: string
}

// Curated list of interesting file patterns to look for
const INTERESTING_FILES = [
  // Algorithms and data structures
  'sort', 'search', 'tree', 'graph', 'hash', 'queue', 'stack',
  // Utilities and helpers
  'util', 'helper', 'tool', 'common', 'shared',
  // Core functionality
  'index', 'main', 'core', 'base', 'lib',
  // Specific algorithms
  'fibonacci', 'factorial', 'prime', 'binary', 'merge',
  // Common patterns
  'parser', 'validator', 'formatter', 'converter'
]

// Programming languages we want to focus on
const PREFERRED_LANGUAGES = [
  'JavaScript', 'TypeScript', 'Python', 'Java', 'Go', 
  'Rust', 'C++', 'C', 'Ruby', 'PHP', 'Swift', 'Kotlin'
]

export default defineEventHandler(async (event) => {
  try {
    // Get query parameters
    const query = getQuery(event)
    const preferredLanguage = query.language as string | undefined

    // Get a cached snippet first (with language preference)
    const cachedSnippet = await getCachedSnippet(preferredLanguage)
    if (cachedSnippet) {
      return {
        success: true,
        snippet: cachedSnippet,
        source: 'cache'
      }
    }

    // Fetch a new snippet from GitHub
    const snippet = await fetchGitHubSnippet(preferredLanguage)

    if (snippet) {
      // Cache the snippet for future requests
      await cacheSnippet(snippet)

      return {
        success: true,
        snippet,
        source: 'github'
      }
    } else {
      throw new Error('No suitable code snippet found')
    }
  } catch (error: any) {
    console.error('Error fetching code snippet:', error)

    return {
      success: false,
      error: error.message || 'Failed to fetch code snippet'
    }
  }
})

async function getCachedSnippet(preferredLanguage?: string): Promise<CodeSnippet | null> {
  try {
    // Get list of cached snippet keys
    const keys = await hubKV().keys('wall-of-code:snippet:')

    if (keys.length === 0) {
      return null
    }

    // If language preference is specified, try to find matching snippets
    if (preferredLanguage) {
      const matchingSnippets: CodeSnippet[] = []

      for (const key of keys) {
        const snippet = await hubKV().get(key) as CodeSnippet | null
        if (snippet && snippet.language === preferredLanguage) {
          matchingSnippets.push(snippet)
        }
      }

      if (matchingSnippets.length > 0) {
        return matchingSnippets[Math.floor(Math.random() * matchingSnippets.length)]
      }
    }

    // Pick a random cached snippet if no language preference or no matches
    const randomKey = keys[Math.floor(Math.random() * keys.length)]
    const snippet = await hubKV().get(randomKey) as CodeSnippet | null

    return snippet
  } catch (error) {
    console.error('Error getting cached snippet:', error)
    return null
  }
}

async function fetchGitHubSnippet(preferredLanguage?: string): Promise<CodeSnippet | null> {
  try {
    // Search for trending repositories
    const searchQuery = buildSearchQuery(preferredLanguage)
    const reposResponse = await fetch(
      `https://api.github.com/search/repositories?q=${encodeURIComponent(searchQuery)}&sort=stars&order=desc&per_page=50`,
      {
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Wall-of-Code-Experiment'
        }
      }
    )
    
    if (!reposResponse.ok) {
      throw new Error(`GitHub API error: ${reposResponse.status}`)
    }
    
    const reposData = await reposResponse.json()
    const repositories: GitHubRepository[] = reposData.items || []
    
    if (repositories.length === 0) {
      throw new Error('No repositories found')
    }
    
    // Try to find a good code snippet from the repositories
    for (let i = 0; i < Math.min(10, repositories.length); i++) {
      const repo = repositories[Math.floor(Math.random() * repositories.length)]
      
      try {
        const snippet = await getCodeFromRepository(repo)
        if (snippet) {
          return snippet
        }
      } catch (error) {
        console.log(`Failed to get code from ${repo.full_name}:`, error)
        continue
      }
    }
    
    throw new Error('No suitable code files found in repositories')
  } catch (error) {
    console.error('Error fetching from GitHub:', error)
    throw error
  }
}

function buildSearchQuery(preferredLanguage?: string): string {
  // Create a search query that focuses on educational and interesting repositories
  const topics = ['algorithm', 'data-structure', 'utility', 'library', 'framework']
  const languages = preferredLanguage ? [preferredLanguage] : PREFERRED_LANGUAGES.slice(0, 3)

  const topicQuery = `topic:${topics[Math.floor(Math.random() * topics.length)]}`
  const languageQuery = `language:${languages[Math.floor(Math.random() * languages.length)]}`
  const sizeQuery = 'size:1000..50000' // Medium-sized repositories
  const starsQuery = 'stars:>100' // Popular repositories

  return `${topicQuery} ${languageQuery} ${sizeQuery} ${starsQuery}`
}

async function getCodeFromRepository(repo: GitHubRepository): Promise<CodeSnippet | null> {
  try {
    // Get repository contents
    const contentsResponse = await fetch(
      `https://api.github.com/repos/${repo.full_name}/contents`,
      {
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'Wall-of-Code-Experiment'
        }
      }
    )
    
    if (!contentsResponse.ok) {
      throw new Error(`Failed to get repository contents: ${contentsResponse.status}`)
    }
    
    const contents = await contentsResponse.json()
    
    // Find interesting files
    const interestingFiles = contents.filter((item: any) => 
      item.type === 'file' && 
      isInterestingFile(item.name) &&
      item.size > 100 && 
      item.size < 10000 // Reasonable file size
    )
    
    if (interestingFiles.length === 0) {
      return null
    }
    
    // Pick a random interesting file
    const file = interestingFiles[Math.floor(Math.random() * interestingFiles.length)]
    
    // Get file content
    const fileResponse = await fetch(file.download_url)
    if (!fileResponse.ok) {
      throw new Error(`Failed to download file: ${fileResponse.status}`)
    }
    
    const code = await fileResponse.text()
    
    // Validate and clean the code
    if (!isValidCode(code)) {
      return null
    }
    
    const cleanedCode = cleanCode(code)
    
    return {
      code: cleanedCode,
      projectName: repo.full_name,
      filePath: file.path,
      repositoryUrl: repo.html_url,
      language: repo.language || getLanguageFromExtension(file.name),
      starCount: repo.stargazers_count,
      lastUpdated: repo.updated_at
    }
  } catch (error) {
    console.error(`Error getting code from repository ${repo.full_name}:`, error)
    return null
  }
}

function isInterestingFile(filename: string): boolean {
  const lowerName = filename.toLowerCase()
  
  // Check for interesting patterns
  const hasInterestingPattern = INTERESTING_FILES.some(pattern => 
    lowerName.includes(pattern)
  )
  
  // Check for supported file extensions
  const supportedExtensions = [
    '.js', '.ts', '.py', '.java', '.go', '.rs', '.cpp', '.c', 
    '.rb', '.php', '.swift', '.kt', '.scala', '.cs', '.dart'
  ]
  
  const hasSupportedExtension = supportedExtensions.some(ext => 
    lowerName.endsWith(ext)
  )
  
  return hasInterestingPattern && hasSupportedExtension
}

function isValidCode(code: string): boolean {
  // Basic validation
  if (!code || code.length < 50 || code.length > 5000) {
    return false
  }
  
  // Check if it looks like actual code (has some programming constructs)
  const codePatterns = [
    /function\s+\w+/i,
    /class\s+\w+/i,
    /def\s+\w+/i,
    /const\s+\w+/i,
    /var\s+\w+/i,
    /let\s+\w+/i,
    /import\s+/i,
    /from\s+.+import/i,
    /\w+\s*\([^)]*\)\s*{/,
    /if\s*\(/i,
    /for\s*\(/i,
    /while\s*\(/i
  ]
  
  return codePatterns.some(pattern => pattern.test(code))
}

function cleanCode(code: string): string {
  // Remove excessive whitespace and limit lines
  const lines = code.split('\n')
  const cleanedLines = lines
    .slice(0, 100) // Limit to 100 lines
    .map(line => line.trimEnd()) // Remove trailing whitespace
  
  return cleanedLines.join('\n').trim()
}

function getLanguageFromExtension(filename: string): string {
  const ext = filename.split('.').pop()?.toLowerCase()
  
  const extensionMap: Record<string, string> = {
    'js': 'JavaScript',
    'ts': 'TypeScript',
    'py': 'Python',
    'java': 'Java',
    'go': 'Go',
    'rs': 'Rust',
    'cpp': 'C++',
    'c': 'C',
    'rb': 'Ruby',
    'php': 'PHP',
    'swift': 'Swift',
    'kt': 'Kotlin',
    'scala': 'Scala',
    'cs': 'C#',
    'dart': 'Dart'
  }
  
  return extensionMap[ext || ''] || 'Unknown'
}

async function cacheSnippet(snippet: CodeSnippet): Promise<void> {
  try {
    const key = `wall-of-code:snippet:${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
    
    // Cache for 1 hour
    await hubKV().set(key, snippet, { ttl: 3600 })
    
    // Clean up old cache entries (keep only last 50)
    const keys = await hubKV().keys('wall-of-code:snippet:')
    if (keys.length > 50) {
      const sortedKeys = keys.sort()
      const keysToDelete = sortedKeys.slice(0, keys.length - 50)
      
      for (const keyToDelete of keysToDelete) {
        await hubKV().del(keyToDelete)
      }
    }
  } catch (error) {
    console.error('Error caching snippet:', error)
    // Don't throw - caching failure shouldn't break the main functionality
  }
}
