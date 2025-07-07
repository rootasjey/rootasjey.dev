<template>
  <UCard
    :class="[
      'relative rounded-0 border transition-all duration-200 hover:shadow-md',
      cardClasses,
      cardHoverBorderColor,
      {
        'opacity-50 transform scale-95 shadow-lg': isDragging,
        'border-width-2': isDragging
      }
    ]"
    class="group"
    :draggable="isDragEnabled && showDragHandle && dragHandleActive"
    @dragstart="handleCardDragStart"
    @dragend="handleCardDragEnd"
  >
    <div class="pt-4">
      <div
        v-if="showDragHandle"
        class="absolute left-0 top-0 w-100% flex gap-2 items-center opacity-0 group-hover:opacity-100 transition-opacity cursor-grab active:cursor-grabbing"
        :class="[
          cardDragBgColor,
          { 'opacity-100': isDragging }
        ]"
        :aria-label="dragHandleAriaLabel"
        @mousedown="enableDrag"
      >
        <UIcon
          name="i-ph-dots-six-vertical-light"
          class="w-4 h-4 text-white"
        />
        <span class="text-white text-sm">You can drag this card</span>
      </div>

      <div class="absolute right-4 top-7 flex items-center gap-2">
        <div v-if="showMenu" class="opacity-0 group-hover:opacity-100 transition-opacity">
          <slot name="menu" :post="post">
            <PostMenu
              :post="post"
              :variant="menuVariant"
              :custom-items="menuItems"
              :disabled="isMenuDisabled"
              @edit="$emit('edit', post)"
              @delete="$emit('delete', post)"
              @publish="$emit('publish', post)"
              @unpublish="$emit('unpublish', post)"
              @duplicate="$emit('duplicate', post)"
              @archive="$emit('archive', post)"
              @share="$emit('share', post)"
              @export="$emit('export', post)"
              @view-stats="$emit('view-stats', post)"
            />
          </slot>
        </div>
      </div>

      <div class="flex items-start justify-between mb-3">
        <div class="flex items-center gap-2">
          <UBadge
            v-if="isDraft && showDraftBadge"
            variant="soft"
            color="amber"
            size="xs"
          >
            Draft
          </UBadge>

          <UBadge
            v-if="isArchived && showArchivedBadge"
            variant="soft"
            color="gray"
            size="xs"
          >
            Archived
          </UBadge>

          <div v-if="showStatusIndicator" class="flex-shrink-0">
            <div
              :class="statusIndicatorClasses"
              class="w-2 h-2 rounded-full"
              :title="statusText"
            />
          </div>
        </div>
      </div>

      <div v-if="primaryTag && showPrimaryTag" class="mb-2">
        <span class="text-xs font-medium text-gray-600 dark:text-gray-400">
          {{ primaryTag.name }}
        </span>
      </div>

      <ULink :to="postUrl" :disabled="linkDisabled" class="block">
        <h3 :class="titleClasses" class="mb-2">
          {{ post.name }}
        </h3>
      </ULink>

      <p v-if="post.description"
          class="text-gray-600 dark:text-gray-400 text-sm mb-4">
        {{ post.description }}
      </p>

      <div v-if="secondaryTags.length > 0 && showSecondaryTags" class="flex flex-wrap gap-1 mb-3">
        <UBadge
          v-for="tag in visibleSecondaryTags"
          :key="tag.name"
          variant="outline"
          color="gray"
          size="xs"
        >
          {{ tag.name }}
        </UBadge>
        <UBadge
          v-if="hiddenSecondaryTagsCount > 0"
          variant="soft"
          color="gray"
          size="xs"
        >
          +{{ hiddenSecondaryTagsCount }}
        </UBadge>
      </div>
    </div>

    <template #footer>
      <div class="pb-4 text-xs text-gray-500 dark:text-gray-500">
        <div class="flex items-center gap-3">
          <time
            :datetime="dateFormatted.iso"
            :title="dateFormatted.full"
          >
            {{ dateFormatted.relative }}
          </time>

          <span v-if="wordCount && showWordCount" class="text-gray-400 dark:text-gray-600">•</span>
          <div v-if="wordCount && showWordCount" class="flex items-center gap-1">
            <span>{{ wordCount }} words</span>
          </div>
        </div>

        <ULink
          :to="postUrl"
          :disabled="linkDisabled"
          class="text-sm font-500 hover:underline decoration-offset-4"
        >
          Read more →
        </ULink>
      </div>
    </template>
  </UCard>
</template>

<script setup lang="ts">
import type { Post } from '~/types/post'

interface PostCardProps {
  post: Post
  variant?: 'default' | 'compact' | 'detailed'
  showMenu?: boolean
  showPrimaryTag?: boolean
  showSecondaryTags?: boolean
  showWordCount?: boolean
  showDraftBadge?: boolean
  showArchivedBadge?: boolean
  showStatusIndicator?: boolean
  maxSecondaryTags?: number
  dateFormat?: 'relative' | 'absolute' | 'both'
  linkDisabled?: boolean
  menuVariant?: 'default' | 'minimal' | 'compact'
  isMenuDisabled?: boolean
  menuItems?: Array<{
    label: string
    icon?: string
    onClick: () => void
    disabled?: boolean
    destructive?: boolean
  }>
  // Drag and drop props
  showDragHandle?: boolean
  isDragEnabled?: boolean
  sourceTab?: 'published' | 'drafts' | 'archived'
}

interface PostCardEmits {
  (e: 'click', post: Post): void
  (e: 'edit', post: Post): void
  (e: 'delete', post: Post): void
  (e: 'publish', post: Post): void
  (e: 'duplicate', post: Post): void
  (e: 'unpublish', post: Post): void
  (e: 'archive', post: Post): void
  (e: 'share', post: Post): void
  (e: 'export', post: Post): void
  (e: 'view-stats', post: Post): void
  // Drag and drop events
  (e: 'drag-start', post: Post, sourceTab: string): void
  (e: 'drag-end', post: Post): void
}

const props = withDefaults(defineProps<PostCardProps>(), {
  variant: 'default',
  showMenu: true,
  showPrimaryTag: true,
  showSecondaryTags: false,
  showWordCount: false,
  showDraftBadge: true,
  showArchivedBadge: true,
  showStatusIndicator: false,
  maxSecondaryTags: 3,
  dateFormat: 'relative',
  linkDisabled: false,
  menuItems: () => [],
  showDragHandle: false,
  isDragEnabled: false,
  sourceTab: 'published'
})

const emit = defineEmits<PostCardEmits>()

// Computed properties
const isDraft = computed(() => props.post.status === 'draft')
const isPublished = computed(() => props.post.status === 'published')
const isArchived = computed(() => props.post.status === 'archived')

const postUrl = computed(() => {
  if (props.linkDisabled) return undefined
  return `/posts/${props.post.slug}`
})

const primaryTag = computed(() => {
  if (!props.post.tags || props.post.tags.length === 0) return null
  // Find primary tag by category, fallback to first tag
  return props.post.tags.find(tag => tag.category === 'primary') || props.post.tags[0] || null
})

const secondaryTags = computed(() => {
  if (!props.post.tags || props.post.tags.length === 0) return []
  // Return all tags that are not primary
  return props.post.tags.filter(tag => tag.category !== 'primary')
})

const visibleSecondaryTags = computed(() => {
  return secondaryTags.value.slice(0, props.maxSecondaryTags)
})

const hiddenSecondaryTagsCount = computed(() => {
  return Math.max(0, secondaryTags.value.length - props.maxSecondaryTags)
})

const cardHoverBorderColor = computed(() => {
  if (isDraft.value) return 'hover:border-lime-5 dark:hover:border-amber-200'
  if (isPublished.value) return 'hover:border-blue-500 dark:hover:border-blue-300'
  if (isArchived.value) return 'hover:border-gray-500 dark:hover:border-gray-300'
  return 'hover:border-gray-300 dark:hover:border-gray-600'
})

const cardDragBgColor = computed(() => {
  if (isDraft.value) return 'bg-lime-5 dark:bg-amber-200'
  if (isPublished.value) return 'bg-blue-500 dark:bg-blue-300'
  if (isArchived.value) return 'bg-gray-500 dark:bg-gray-300'
  return 'bg-gray-300 dark:bg-gray-600'
})

// Styling based on variant and state
const cardClasses = computed(() => {
  const classes = []

  if (props.variant === 'compact') {
    classes.push('p-2')
  } else if (props.variant === 'detailed') {
    classes.push('p-6')
  }

  return classes
})

const titleClasses = computed(() => {
  const classes = ['font-body font-700 line-height-tight text-gray-800 dark:text-gray-200']

  if (props.variant === 'compact') {
    classes.push('text-base')
  } else if (props.variant === 'detailed') {
    classes.push('text-xl')
  } else {
    classes.push('text-size-8')
  }

  if (isDraft.value) {
    classes.push('text-gray-600 dark:text-gray-400')
  }

  return classes
})

const statusIndicatorClasses = computed(() => {
  if (isDraft.value) return 'bg-amber-500'
  if (isPublished.value) return 'bg-green-500'
  if (isArchived.value) return 'bg-gray-500'
  return 'bg-gray-300'
})

const statusText = computed(() => {
  if (isDraft.value) return 'Draft'
  if (isPublished.value) return 'Published'
  if (isArchived.value) return 'Archived'
  return 'Unknown status'
})

// Date formatting
const dateFormatted = computed(() => {
  const date = new Date(props.post.updatedAt || props.post.createdAt)
  const now = new Date()
  const diffInHours = (now.getTime() - date.getTime()) / (1000 * 60 * 60)

  const iso = date.toISOString()
  const full = date.toLocaleString('en', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })

  let relative = ''
  if (diffInHours < 1) {
    relative = 'Just now'
  } else if (diffInHours < 24) {
    relative = `${Math.floor(diffInHours)}h ago`
  } else if (diffInHours < 24 * 7) {
    relative = `${Math.floor(diffInHours / 24)}d ago`
  } else {
    relative = date.toLocaleDateString('en', {
      month: 'short',
      day: 'numeric',
      year: date.getFullYear() !== now.getFullYear() ? 'numeric' : undefined
    })
  }

  return { iso, full, relative }
})

// Word count estimation (if article content is available)
const wordCount = computed(() => {
  if (!props.post.article) return null

  // Simple word count estimation from article content
  const content = JSON.stringify(props.post.article)
  const words = content.match(/\b\w+\b/g)
  return words ? words.length : null
})

// Drag and drop functionality
const isDragging = ref(false)

const dragHandleAriaLabel = computed(() => {
  return `Drag to move "${props.post.name}" to a different status`
})

// Drag handle state management
const dragHandleActive = ref(false)

// Enable drag when handle is pressed
const enableDrag = () => {
  if (!props.isDragEnabled || !props.sourceTab) {
    return
  }

  dragHandleActive.value = true

  // Add global mouse up listener to disable drag
  const handleGlobalMouseUp = () => {
    dragHandleActive.value = false
    document.removeEventListener('mouseup', handleGlobalMouseUp)
  }

  document.addEventListener('mouseup', handleGlobalMouseUp)
}

// Handle card drag start
const handleCardDragStart = (event: DragEvent) => {
  // For testing, allow drag without handle activation
  if (!props.isDragEnabled || !props.sourceTab || !dragHandleActive.value) {
    event.preventDefault()
    return false
  }

  isDragging.value = true

  // Set up the drag data
  if (event.dataTransfer) {
    event.dataTransfer.effectAllowed = 'move'
    event.dataTransfer.setData('application/json', JSON.stringify({
      post: props.post,
      sourceTab: props.sourceTab
    }))

    // Create a custom drag image
    const dragImage = createDragImage()
    if (dragImage) {
      event.dataTransfer.setDragImage(dragImage, 0, 0)
    }
  }

  emit('drag-start', props.post, props.sourceTab)
  return true
}

// Handle card drag end
const handleCardDragEnd = () => {
  isDragging.value = false
  dragHandleActive.value = false
  emit('drag-end', props.post)
}

// Create a custom drag image
const createDragImage = (): HTMLElement | null => {
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
      white-space: wrap;
      max-width: 300px;
      z-index: 1000;
    `
    dragImage.textContent = props.post.name

    document.body.appendChild(dragImage)

    // Clean up after a short delay
    setTimeout(() => {
      if (document.body.contains(dragImage)) {
        document.body.removeChild(dragImage)
      }
    }, 100)

    return dragImage
  } catch (error) {
    console.warn('Failed to create drag image:', error)
    return null
  }
}

// Clean up drag state when component unmounts
onUnmounted(() => {
  isDragging.value = false
})

</script>

<style scoped>
/* Custom drag image styling */
.drag-image {
  font-family: system-ui, -apple-system, sans-serif;
  pointer-events: none;
  user-select: none;
}
</style>