// @vitest-environment happy-dom
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { mount } from '@vue/test-utils'
import TagManagementModal from '~/components/tag/TagManagementModal.vue'
import type { Post } from '~/types/post'
import type { ApiTag } from '~/types/tag'

// Mock the tagsStore
const mockTagsStore = {
  allTags: [
    { id: 1, name: 'Vue', category: 'technology', created_at: '2024-01-01', updated_at: '2024-01-01' },
    { id: 2, name: 'JavaScript', category: 'technology', created_at: '2024-01-01', updated_at: '2024-01-01' },
    { id: 3, name: 'Unused Tag', category: 'general', created_at: '2024-01-01', updated_at: '2024-01-01' }
  ] as ApiTag[],
  fetchTags: vi.fn(),
  createTag: vi.fn(),
  updateTag: vi.fn(),
  deleteTag: vi.fn()
}

// Mock the useTagStore composable
vi.mock('~/stores/tags', () => ({
  useTagStore: () => mockTagsStore
}))

// Mock the useToast composable
const mockToast = vi.fn()
vi.mock('#app/composables/useToast', () => ({
  useToast: () => mockToast
}))

// Mock post data with tags
const mockPosts: Post[] = [
  {
    id: 1,
    name: 'Vue Tutorial',
    description: 'Learn Vue.js',
    slug: 'vue-tutorial',
    status: 'published',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
    language: 'en',
    links: [],
    metrics: { comments: 0, likes: 0, views: 0 },
    tags: [
      { id: 1, name: 'Vue', category: 'technology', created_at: '2024-01-01', updated_at: '2024-01-01' }
    ],
    image: { alt: '', ext: 'jpg', src: 'test.jpg' }
  },
  {
    id: 2,
    name: 'JavaScript Basics',
    description: 'Learn JavaScript',
    slug: 'js-basics',
    status: 'draft',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
    language: 'en',
    links: [],
    metrics: { comments: 0, likes: 0, views: 0 },
    tags: [
      { id: 1, name: 'Vue', category: 'technology', created_at: '2024-01-01', updated_at: '2024-01-01' },
      { id: 2, name: 'JavaScript', category: 'technology', created_at: '2024-01-01', updated_at: '2024-01-01' }
    ],
    image: { alt: '', ext: 'jpg', src: 'test.jpg' }
  }
]

describe('TagManagementModal', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should render correctly when open', () => {
    const wrapper = mount(TagManagementModal, {
      props: {
        open: true,
        posts: mockPosts
      }
    })

    expect(wrapper.find('[data-testid="tag-management-modal"]').exists()).toBe(true)
  })

  it('should calculate tag statistics correctly', () => {
    const wrapper = mount(TagManagementModal, {
      props: {
        open: true,
        posts: mockPosts
      }
    })

    // Check if tag statistics are calculated correctly
    const vm = wrapper.vm as any
    expect(vm.tagStats.total).toBe(3) // Total tags in mock store
    expect(vm.tagStats.custom).toBe(0) // No custom tags in mock data
  })

  it('should identify popular tags correctly', () => {
    const wrapper = mount(TagManagementModal, {
      props: {
        open: true,
        posts: mockPosts
      }
    })

    const vm = wrapper.vm as any
    const popularTags = vm.popularTags
    
    // Vue tag should be most popular (used in 2 posts)
    expect(popularTags[0].name).toBe('Vue')
    expect(popularTags[0].count).toBe(2)
    
    // JavaScript tag should be second (used in 1 post)
    expect(popularTags[1].name).toBe('JavaScript')
    expect(popularTags[1].count).toBe(1)
  })

  it('should identify unused tags correctly', () => {
    const wrapper = mount(TagManagementModal, {
      props: {
        open: true,
        posts: mockPosts
      }
    })

    const vm = wrapper.vm as any
    const unusedTags = vm.unusedTags
    
    // "Unused Tag" should be identified as unused
    expect(unusedTags).toHaveLength(1)
    expect(unusedTags[0].name).toBe('Unused Tag')
  })

  it('should emit update:open when modal is closed', async () => {
    const wrapper = mount(TagManagementModal, {
      props: {
        open: true,
        posts: mockPosts
      }
    })

    // Simulate closing the modal
    await wrapper.setProps({ open: false })
    
    expect(wrapper.emitted('update:open')).toBeTruthy()
  })

  it('should call createTag when adding a new tag', async () => {
    const wrapper = mount(TagManagementModal, {
      props: {
        open: true,
        posts: mockPosts
      }
    })

    const vm = wrapper.vm as any
    
    // Set new tag data
    vm.newTagName = 'React'
    vm.newTagCategory = 'technology'
    
    // Call the create tag method
    await vm.handleCreateTag()
    
    expect(mockTagsStore.createTag).toHaveBeenCalledWith('React', 'technology')
  })

  it('should call deleteTag when deleting a tag', async () => {
    const wrapper = mount(TagManagementModal, {
      props: {
        open: true,
        posts: mockPosts
      }
    })

    const vm = wrapper.vm as any
    const tagToDelete = mockTagsStore.allTags[2] // "Unused Tag"
    
    // Set up delete state
    vm.deletingTag = tagToDelete
    
    // Call the delete method
    await vm.handleConfirmDelete()
    
    expect(mockTagsStore.deleteTag).toHaveBeenCalledWith(tagToDelete.id)
  })

  it('should emit tags-updated when tags are modified', async () => {
    const wrapper = mount(TagManagementModal, {
      props: {
        open: true,
        posts: mockPosts
      }
    })

    const vm = wrapper.vm as any
    
    // Set new tag data and create
    vm.newTagName = 'React'
    vm.newTagCategory = 'technology'
    await vm.handleCreateTag()
    
    expect(wrapper.emitted('tags-updated')).toBeTruthy()
  })

  it('should calculate tag usage correctly', () => {
    const wrapper = mount(TagManagementModal, {
      props: {
        open: true,
        posts: mockPosts
      }
    })

    const vm = wrapper.vm as any
    const vueTag = mockTagsStore.allTags[0] // Vue tag
    const jsTag = mockTagsStore.allTags[1] // JavaScript tag
    const unusedTag = mockTagsStore.allTags[2] // Unused tag
    
    expect(vm.getTagUsage(vueTag)).toBe(2) // Used in 2 posts
    expect(vm.getTagUsage(jsTag)).toBe(1) // Used in 1 post
    expect(vm.getTagUsage(unusedTag)).toBe(0) // Not used
  })
})
