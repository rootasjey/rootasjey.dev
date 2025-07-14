// GET /api/experiments/wall-of-code/admin/cache
// Admin endpoint to manage Wall of Code cache

export default defineEventHandler(async (event) => {
  try {
    // Get all cached snippets
    const keys = await hubKV().keys('wall-of-code:snippet:')
    
    const cacheInfo = {
      totalSnippets: keys.length,
      keys: keys.sort(),
      lastUpdated: new Date().toISOString()
    }
    
    // Get sample of cached snippets for preview
    const sampleKeys = keys.slice(0, 5)
    const samples = await Promise.all(
      sampleKeys.map(async (key) => {
        const snippet = await hubKV().get(key)
        return {
          key,
          snippet: snippet ? {
            projectName: (snippet as any).projectName,
            language: (snippet as any).language,
            filePath: (snippet as any).filePath,
            starCount: (snippet as any).starCount,
            codeLength: (snippet as any).code?.length || 0
          } : null
        }
      })
    )
    
    return {
      success: true,
      cache: cacheInfo,
      samples
    }
  } catch (error: any) {
    console.error('Error getting cache info:', error)
    
    return {
      success: false,
      error: error.message || 'Failed to get cache information'
    }
  }
})
