import fs from 'fs'
import path from 'path'

export default defineEventHandler(async (event) => {
  const experimentsDir = path.join(process.cwd(), 'pages/experiments')
  
  // Get all directories inside the experiments folder
  const items = fs.readdirSync(experimentsDir, { withFileTypes: true })
  
  // Filter out the index.vue file and only keep directories
  const experimentFolders = items
    .filter(item => item.isDirectory())
    .map(dir => dir.name)
  
  // Create experiment objects with metadata
  const experiments = experimentFolders.map(folder => {
    // Convert folder name to title (e.g., "game-of-life" -> "Game of Life")
    const title = folder
      .split('-')
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ')
    
    // Try to extract description from the file if possible
    let description = ""
    try {
      const filePath = path.join(experimentsDir, folder, 'index.vue')
      const fileContent = fs.readFileSync(filePath, 'utf-8')
      
      // Simple regex to try to extract description from PageHeader subtitle
      const subtitleMatch = fileContent.match(/subtitle="([^"]+)"/)
      if (subtitleMatch && subtitleMatch[1]) {
        description = subtitleMatch[1]
      }
    } catch (error) {
      console.error(`Error reading experiment file: ${folder}`, error)
    }
    
    return {
      title,
      slug: folder,
      description: description || `Explore the ${title} experiment`
    }
  })
  
  return experiments
})
