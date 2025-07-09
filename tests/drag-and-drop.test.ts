// @vitest-environment happy-dom
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { useDragAndDrop } from '~/composables/useDragAndDrop'
import type { Post } from '~/types/post'

// Mock post data
const mockPost: Post = {
  id: 1,
  name: 'Test Post',
  description: 'Test Description',
  slug: 'test-post',
  status: 'draft',
  createdAt: '2024-01-01T00:00:00Z',
  updatedAt: '2024-01-01T00:00:00Z',
  language: 'en',
  links: [],
  metrics: { comments: 0, likes: 0, views: 0 },
  tags: [],
  image: { alt: '', ext: 'jpg', src: 'test.jpg' }
}

describe('useDragAndDrop', () => {
  let onDropMock: ReturnType<typeof vi.fn>

  beforeEach(() => {
    onDropMock = vi.fn()
  })

  it('should initialize with correct default state', () => {
    const { isDragging, dragData, dragOverTarget } = useDragAndDrop()
    
    expect(isDragging.value).toBe(false)
    expect(dragData.value).toBe(null)
    expect(dragOverTarget.value).toBe(null)
  })

  it('should validate status transitions correctly', () => {
    const { isValidStatusTransition } = useDragAndDrop()
    
    // Valid transitions
    expect(isValidStatusTransition('published', 'drafts')).toBe(true)
    expect(isValidStatusTransition('published', 'archived')).toBe(true)
    expect(isValidStatusTransition('drafts', 'published')).toBe(true)
    expect(isValidStatusTransition('drafts', 'archived')).toBe(true)
    expect(isValidStatusTransition('archived', 'published')).toBe(true)
    expect(isValidStatusTransition('archived', 'drafts')).toBe(true)
    
    // Invalid transitions (same tab)
    expect(isValidStatusTransition('published', 'published')).toBe(false)
    expect(isValidStatusTransition('drafts', 'drafts')).toBe(false)
    expect(isValidStatusTransition('archived', 'archived')).toBe(false)
  })

  it('should convert target tab to correct status', () => {
    const { getTargetStatus } = useDragAndDrop()
    
    expect(getTargetStatus('published')).toBe('published')
    expect(getTargetStatus('drafts')).toBe('draft')
    expect(getTargetStatus('archived')).toBe('archived')
  })

  it('should generate correct aria labels', () => {
    const { getDropZoneAriaLabel, getDragHandleAriaLabel } = useDragAndDrop()

    expect(getDropZoneAriaLabel('published')).toBe('Drop post here to move to published')
    expect(getDropZoneAriaLabel('drafts')).toBe('Drop post here to move to drafts')
    expect(getDropZoneAriaLabel('archived')).toBe('Drop post here to move to archived')

    expect(getDragHandleAriaLabel(mockPost)).toBe('Drag to move "Test Post" to a different status')
  })

  it('should handle drag start correctly', () => {
    const { startDrag, isDragging, dragData } = useDragAndDrop({
      onDragStart: onDropMock
    })
    
    const mockEvent = new DragEvent('dragstart', {
      dataTransfer: new DataTransfer()
    })
    
    startDrag(mockPost, 'drafts', mockEvent)
    
    expect(isDragging.value).toBe(true)
    expect(dragData.value).toEqual({
      post: mockPost,
      sourceTab: 'drafts'
    })
    expect(onDropMock).toHaveBeenCalledWith({
      post: mockPost,
      sourceTab: 'drafts'
    })
  })

  it('should handle drag end correctly', () => {
    const { startDrag, endDrag, isDragging, dragData } = useDragAndDrop()
    
    const mockEvent = new DragEvent('dragstart', {
      dataTransfer: new DataTransfer()
    })
    
    // Start drag first
    startDrag(mockPost, 'drafts', mockEvent)
    expect(isDragging.value).toBe(true)
    
    // End drag
    endDrag()
    expect(isDragging.value).toBe(false)
    expect(dragData.value).toBe(null)
  })
})

describe('Drag and Drop Integration', () => {
  it('should handle complete drag and drop flow from handle', async () => {
    const onDropMock = vi.fn()
    const { startDrag, handleDrop, isValidStatusTransition } = useDragAndDrop({
      onDrop: onDropMock
    })

    // Start drag from handle
    const dragEvent = new DragEvent('dragstart', {
      dataTransfer: new DataTransfer()
    })

    startDrag(mockPost, 'drafts', dragEvent)

    // Simulate drop
    const dropEvent = new DragEvent('drop', {
      dataTransfer: new DataTransfer()
    })

    // Set the drag data in the drop event
    dropEvent.dataTransfer?.setData('application/json', JSON.stringify({
      post: mockPost,
      sourceTab: 'drafts'
    }))

    // Verify transition is valid
    expect(isValidStatusTransition('drafts', 'published')).toBe(true)

    // Handle drop
    await handleDrop(dropEvent, 'published')

    // Verify onDrop was called with correct parameters
    expect(onDropMock).toHaveBeenCalledWith(
      { post: mockPost, sourceTab: 'drafts' },
      'published'
    )
  })
})
