// DELETE /api/experiments/wall-of-code/admin/cache
// Admin endpoint to clear Wall of Code cache

export default defineEventHandler(async (event) => {
  try {
    // Get all cached snippet keys
    const keys = await hubKV().keys('wall-of-code:snippet:')
    
    if (keys.length === 0) {
      return {
        success: true,
        message: 'Cache was already empty',
        deletedCount: 0
      }
    }
    
    // Delete all cached snippets
    await Promise.all(
      keys.map(key => hubKV().del(key))
    )
    
    return {
      success: true,
      message: `Successfully cleared cache`,
      deletedCount: keys.length
    }
  } catch (error: any) {
    console.error('Error clearing cache:', error)
    
    return {
      success: false,
      error: error.message || 'Failed to clear cache'
    }
  }
})
