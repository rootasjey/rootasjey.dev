<template>
  <article 
    class="pb-4 flex justify-between items-start 
      group border dark:b-gray-900 b-dashed transition 
      hover:scale-101 active:scale-99 
      hover:bg-gray-50/50 dark:hover:bg-transparent 
      dark:hover:border-gray-600 rounded-lg p-4 -m-2"
    :class="itemClasses"
  >
    <!-- Main Content -->
    <ULink :to="postUrl" :disabled="linkDisabled" 
      class="flex flex-col flex-1 min-w-0">
      <!-- Title with Link -->
      <div
        :class="titleLinkClasses"
        class="flex items-start gap-2 mb-1"
      >
        <!-- Status Indicator -->
        <div v-if="showStatusIndicator" class="flex-shrink-0 mt-1.5">
          <div 
            :class="statusIndicatorClasses"
            class="w-2 h-2 rounded-full"
            :title="statusText"
          />
        </div>

        <!-- Title -->
        <h3 :class="titleClasses" class="line-clamp-2 break-words">
          {{ post.name }}
        </h3>

        <!-- Draft Badge -->
        <UBadge 
          v-if="isDraft && showDraftBadge" 
          variant="soft" 
          color="amber" 
          size="xs"
          class="flex-shrink-0 ml-auto"
        >
          Draft
        </UBadge>
      </div>

      <!-- Description -->
      <p 
        v-if="post.description" 
        class="text-size-3 text-gray-700 dark:text-gray-400 mb-2 line-clamp-2 break-words"
      >
        {{ post.description }}
      </p>

      <!-- Metadata Row -->
      <div class="flex items-center justify-between gap-4 text-size-3">
        <!-- Date and Tag Info -->
        <div class="flex items-center gap-3 text-gray-500 dark:text-gray-500 min-w-0">
          <!-- Date -->
          <time 
            :datetime="dateFormatted.iso"
            :title="dateFormatted.full"
            class="flex-shrink-0"
          >
            {{ dateFormatted.relative }}
          </time>

          <!-- Primary Tag -->
          <div v-if="primaryTag && showPrimaryTag" class="flex items-center gap-1 min-w-0">
            <span class="text-gray-400 dark:text-gray-600">•</span>
            <UBadge 
              variant="soft" 
              color="blue" 
              size="xs"
              class="truncate"
            >
              {{ primaryTag.name }}
            </UBadge>
          </div>

          <!-- Word Count (if available) -->
          <div v-if="wordCount && showWordCount" class="flex items-center gap-1">
            <span class="text-gray-400 dark:text-gray-600">•</span>
            <span class="text-xs">{{ wordCount }} words</span>
          </div>
        </div>

        <!-- Action Menu Trigger -->
        <div v-if="showMenu" class="flex-shrink-0">
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

      <!-- Secondary Tags (if any) -->
      <div v-if="secondaryTags.length > 0 && showSecondaryTags" class="flex flex-wrap gap-1 mt-2">
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

      <!-- Custom Footer Slot -->
      <div v-if="$slots.footer" class="mt-2">
        <slot name="footer" :post="post" />
      </div>
    </ULink>
  </article>
</template>

<script setup lang="ts">
import type { Post } from '~/types/post'

interface PostItemProps {
  post: Post
  variant?: 'default' | 'compact' | 'detailed'
  showMenu?: boolean
  showPrimaryTag?: boolean
  showSecondaryTags?: boolean
  showWordCount?: boolean
  showDraftBadge?: boolean
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
}

interface PostItemEmits {
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
}

const props = withDefaults(defineProps<PostItemProps>(), {
  variant: 'default',
  showMenu: true,
  showPrimaryTag: true,
  showSecondaryTags: false,
  showWordCount: false,
  showDraftBadge: true,
  showStatusIndicator: false,
  maxSecondaryTags: 3,
  dateFormat: 'relative',
  linkDisabled: false,
  menuItems: () => []
})

const emit = defineEmits<PostItemEmits>()

// Computed properties
const isDraft = computed(() => props.post.status === 'draft')
const isPublished = computed(() => props.post.status === 'published')

const postUrl = computed(() => {
  if (props.linkDisabled) return undefined
  return `/posts/${props.post.slug}`
})

const primaryTag = computed(() => {
  if (!props.post.tags || props.post.tags.length === 0) return null
  // Return the first tag as primary
  return props.post.tags.length > 0 ? props.post.tags[0] : null
})

const secondaryTags = computed(() => {
  if (!props.post.tags || props.post.tags.length === 0) return []
  // Return all tags except the first one
  if (props.post.tags.length === 1) return []
  // Slice to get secondary tags, excluding the primary tag
  if (props.maxSecondaryTags <= 0) return props.post.tags.slice(1)
  // Limit the number of secondary tags to maxSecondaryTags
  if (props.post.tags.length <= props.maxSecondaryTags) return props.post.tags.slice(1, props.post.tags.length)
  // Otherwise, return all secondary tags
  return props.post.tags.slice(1)
})

const visibleSecondaryTags = computed(() => {
  return secondaryTags.value.slice(0, props.maxSecondaryTags)
})

const hiddenSecondaryTagsCount = computed(() => {
  return Math.max(0, secondaryTags.value.length - props.maxSecondaryTags)
})

// Styling based on variant and state
const itemClasses = computed(() => {
  const classes = []
  
  if (props.variant === 'compact') {
    classes.push('pb-2')
  } else if (props.variant === 'detailed') {
    classes.push('pb-6')
  }
  
  if (isDraft.value) {
    classes.push('opacity-75')
  }
  
  return classes
})

const titleClasses = computed(() => {
  const baseClasses = 'font-500 line-height-4.5 transition-colors'
  
  switch (props.variant) {
    case 'compact':
      return `${baseClasses} text-size-3 text-gray-800 dark:text-gray-300`
    case 'detailed':
      return `${baseClasses} text-size-4 font-600 text-gray-800 dark:text-gray-200`
    default:
      return `${baseClasses} text-size-3.5 font-600 text-gray-800 dark:text-gray-200`
  }
})

const titleLinkClasses = computed(() => {
  if (props.linkDisabled) return ''
  return 'hover:text-blue-600 dark:hover:text-blue-400'
})

const statusIndicatorClasses = computed(() => {
  if (isDraft.value) {
    return 'bg-amber-400 dark:bg-amber-500'
  } else if (isPublished.value) {
    return 'bg-green-400 dark:bg-green-500'
  }
  return 'bg-gray-400 dark:bg-gray-500'
})

const statusText = computed(() => {
  if (isDraft.value) return 'Draft'
  if (isPublished.value) return 'Published'
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

// Handle click events
const handleClick = () => {
  emit('click', props.post)
}
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  line-clamp: 2;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>