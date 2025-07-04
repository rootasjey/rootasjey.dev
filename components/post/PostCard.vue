<template>
  <UCard
    :class="[
      'relative rounded-lg border transition-all duration-200 hover:shadow-md',
      cardClasses
    ]"
    class="group"
  >
    <!-- Post Content -->
    <div class="p-4">
      <!-- Status and Menu Row -->
      <div class="flex items-start justify-between mb-3">
        <!-- Status Pills -->
        <div class="flex items-center gap-2">
          <!-- Draft Badge -->
          <UBadge
            v-if="isDraft && showDraftBadge"
            variant="soft"
            color="amber"
            size="xs"
          >
            Draft
          </UBadge>

          <!-- Archived Badge -->
          <UBadge
            v-if="isArchived && showArchivedBadge"
            variant="soft"
            color="gray"
            size="xs"
          >
            Archived
          </UBadge>

          <!-- Status Indicator -->
          <div v-if="showStatusIndicator" class="flex-shrink-0">
            <div
              :class="statusIndicatorClasses"
              class="w-2 h-2 rounded-full"
              :title="statusText"
            />
          </div>
        </div>

        <!-- Action Menu -->
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

      <!-- Primary Tag -->
      <div v-if="primaryTag && showPrimaryTag" class="mb-2">
        <UBadge
          variant="soft"
          color="blue"
          size="xs"
        >
          {{ primaryTag.name }}
        </UBadge>
      </div>

      <!-- Title with Link -->
      <ULink :to="postUrl" :disabled="linkDisabled" class="block">
        <h3 :class="titleClasses" class="line-clamp-2 break-words mb-2">
          {{ post.name }}
        </h3>
      </ULink>

      <!-- Description -->
      <p v-if="post.description"
          class="text-gray-600 dark:text-gray-400 text-sm mb-4 line-clamp-3">
        {{ post.description }}
      </p>

      <!-- Secondary Tags -->
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
      <!-- Post Meta -->
      <div class="px-4 pb-4 flex items-center justify-between text-xs text-gray-500 dark:text-gray-500">
        <div class="flex items-center gap-3">
          <!-- Date -->
          <time
            :datetime="dateFormatted.iso"
            :title="dateFormatted.full"
          >
            {{ dateFormatted.relative }}
          </time>

          <!-- Word Count -->
          <div v-if="wordCount && showWordCount" class="flex items-center gap-1">
            <span class="text-gray-400 dark:text-gray-600">•</span>
            <span>{{ wordCount }} words</span>
          </div>
        </div>

        <!-- Read More Link -->
        <ULink
          :to="postUrl"
          :disabled="linkDisabled"
          class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300 font-500 transition-colors"
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
  menuItems: () => []
})

defineEmits<PostCardEmits>()

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

// Styling based on variant and state
const cardClasses = computed(() => {
  const classes = []

  if (props.variant === 'compact') {
    classes.push('p-2')
  } else if (props.variant === 'detailed') {
    classes.push('p-6')
  }

  if (isDraft.value) {
    classes.push('opacity-75 border-amber-200 dark:border-amber-800')
  } else if (isArchived.value) {
    classes.push('opacity-60 border-gray-300 dark:border-gray-600')
  } else {
    classes.push('border-gray-200 dark:border-gray-700')
  }

  return classes
})

const titleClasses = computed(() => {
  const classes = ['font-body text-lg font-600 text-gray-800 dark:text-gray-200']

  if (props.variant === 'compact') {
    classes.push('text-base')
  } else if (props.variant === 'detailed') {
    classes.push('text-xl')
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


</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  line-clamp: 2;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.line-clamp-3 {
  display: -webkit-box;
  line-clamp: 3;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>