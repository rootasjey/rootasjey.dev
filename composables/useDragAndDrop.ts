import type { Post } from '~/types/post'

export interface DragData {
  post: Post
  sourceTab: 'published' | 'drafts' | 'archived'
}

export interface DropZoneConfig {
  targetTab: 'published' | 'drafts' | 'archived'
  onDrop: (data: DragData) => Promise<void>
  isValidDrop?: (data: DragData) => boolean
}

export interface DragAndDropOptions {
  onDragStart?: (data: DragData) => void
  onDragEnd?: (data: DragData) => void
  onDragOver?: (event: DragEvent) => void
  onDrop?: (data: DragData, targetTab: string) => Promise<void>
}

export const useDragAndDrop = (options: DragAndDropOptions = {}) => {
  // Drag state
  const isDragging = ref(false)
  const dragData = ref<DragData | null>(null)
  const dragOverTarget = ref<string | null>(null)

  // Drag source methods
  const startDrag = (post: Post, sourceTab: 'published' | 'drafts' | 'archived', event: DragEvent) => {
    const data: DragData = { post, sourceTab }
    dragData.value = data
    isDragging.value = true

    // Set drag data for HTML5 drag and drop
    if (event.dataTransfer) {
      event.dataTransfer.effectAllowed = 'move'
      event.dataTransfer.setData('application/json', JSON.stringify(data))
      
      // Create a custom drag image (optional)
      const dragImage = createDragImage(post)
      if (dragImage) {
        event.dataTransfer.setDragImage(dragImage, 0, 0)
      }
    }

    options.onDragStart?.(data)
  }

  const endDrag = () => {
    const data = dragData.value
    isDragging.value = false
    dragData.value = null
    dragOverTarget.value = null

    if (data) {
      options.onDragEnd?.(data)
    }
  }

  // Drop zone methods
  const handleDragOver = (event: DragEvent, targetTab: string) => {
    event.preventDefault()
    event.stopPropagation()
    
    if (event.dataTransfer) {
      event.dataTransfer.dropEffect = 'move'
    }

    dragOverTarget.value = targetTab
    options.onDragOver?.(event)
  }

  const handleDragEnter = (event: DragEvent, targetTab: string) => {
    event.preventDefault()
    event.stopPropagation()
    dragOverTarget.value = targetTab
  }

  const handleDragLeave = (event: DragEvent, targetTab: string) => {
    event.preventDefault()
    event.stopPropagation()
    
    // Only clear if we're actually leaving the drop zone
    const rect = (event.currentTarget as HTMLElement).getBoundingClientRect()
    const x = event.clientX
    const y = event.clientY
    
    if (x < rect.left || x > rect.right || y < rect.top || y > rect.bottom) {
      if (dragOverTarget.value === targetTab) {
        dragOverTarget.value = null
      }
    }
  }

  const handleDrop = async (event: DragEvent, targetTab: string) => {
    event.preventDefault()
    event.stopPropagation()

    try {
      let data: DragData | null = null

      // Try to get data from the event first
      if (event.dataTransfer) {
        const jsonData = event.dataTransfer.getData('application/json')
        if (jsonData) {
          try {
            data = JSON.parse(jsonData)
          } catch (parseError) {
            console.error('Failed to parse drag data:', parseError)
          }
        }
      }

      // Fallback to stored drag data
      if (!data && dragData.value) {
        data = dragData.value
      }

      if (!data) {
        console.warn('No drag data available for drop operation')
        // Show user feedback for failed drop
        showDropError('No data available for this operation')
        return
      }

      // Validate the drop
      if (!isValidStatusTransition(data.sourceTab, targetTab)) {
        console.warn(`Invalid status transition from ${data.sourceTab} to ${targetTab}`)
        // Show user feedback for invalid transition
        showDropError(`Cannot move from ${data.sourceTab} to ${targetTab}`)
        return
      }

      // Execute the drop
      await options.onDrop?.(data, targetTab)

    } catch (error) {
      console.error('Error handling drop:', error)
      showDropError('Failed to move post. Please try again.')
    } finally {
      endDrag()
    }
  }

  // User feedback for drop errors
  const showDropError = (message: string) => {
    // This could be enhanced to use a toast notification system
    // For now, we'll use a simple console warning
    console.warn('Drop operation failed:', message)

    // In a real implementation, you might want to:
    // - Show a toast notification
    // - Add a temporary error state to the UI
    // - Provide visual feedback on the drop zone
  }

  // Utility functions
  const createDragImage = (post: Post): HTMLElement | null => {
    try {
      const dragImage = document.createElement('div')
      dragImage.className = 'drag-image'
      dragImage.style.cssText = `
        position: absolute;
        top: -1000px;
        left: -1000px;
        padding: 8px 12px;
        background: rgba(255, 255, 255, 0.95);
        border: 1px solid #e5e7eb;
        border-radius: 8px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        font-size: 14px;
        font-weight: 500;
        color: #374151;
        white-space: nowrap;
        z-index: 1000;
      `
      dragImage.textContent = post.name
      
      document.body.appendChild(dragImage)
      
      // Clean up after a short delay
      setTimeout(() => {
        document.body.removeChild(dragImage)
      }, 100)
      
      return dragImage
    } catch (error) {
      console.warn('Failed to create drag image:', error)
      return null
    }
  }

  const isValidStatusTransition = (sourceTab: string, targetTab: string): boolean => {
    // Same tab - no change needed
    if (sourceTab === targetTab) return false

    // Define valid transitions
    const validTransitions: Record<string, string[]> = {
      'published': ['drafts', 'archived'],
      'drafts': ['published', 'archived'],
      'archived': ['published', 'drafts']
    }

    return validTransitions[sourceTab]?.includes(targetTab) ?? false
  }

  const getTargetStatus = (targetTab: string): 'draft' | 'published' | 'archived' => {
    switch (targetTab) {
      case 'drafts':
        return 'draft'
      case 'published':
        return 'published'
      case 'archived':
        return 'archived'
      default:
        throw new Error(`Invalid target tab: ${targetTab}`)
    }
  }

  // Accessibility helpers
  const getDropZoneAriaLabel = (targetTab: string): string => {
    return `Drop post here to move to ${targetTab}`
  }

  const getDragHandleAriaLabel = (post: Post): string => {
    return `Drag to move "${post.name}" to a different status`
  }

  // Cleanup
  const cleanup = () => {
    endDrag()
  }

  return {
    // State
    isDragging: readonly(isDragging),
    dragData: readonly(dragData),
    dragOverTarget: readonly(dragOverTarget),

    // Drag source methods
    startDrag,
    endDrag,

    // Drop zone methods
    handleDragOver,
    handleDragEnter,
    handleDragLeave,
    handleDrop,

    // Utilities
    isValidStatusTransition,
    getTargetStatus,
    getDropZoneAriaLabel,
    getDragHandleAriaLabel,
    cleanup
  }
}
