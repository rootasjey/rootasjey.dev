<template>
  <section 
    v-if="shouldShowSection"
    :class="sectionClasses"
    class="transition-all duration-300"
  >
    <!-- Section Header -->
    <header class="mb-4">
      <!-- Main Header Button/Title -->
      <component
        :is="headerComponent"
        :class="headerClasses"
        class="p-0 flex items-center gap-3 font-500 text-gray-800 dark:text-gray-200 transition-colors"
        v-bind="headerProps"
        @click="handleHeaderClick"
      >
        <!-- Icon -->
        <span 
          v-if="icon"
          :class="icon" 
          class="text-3 flex-shrink-0"
          :style="iconStyle"
        />

        <!-- Title -->
        <span class="text-3 font-500">{{ title }}</span>

        <!-- Count Badge -->
        <UBadge 
          v-if="showCount && totalCount > 0"
          :variant="countBadgeVariant"
          :color="countBadgeColor"
          size="xs"
          class="ml-1"
        >
          {{ totalCount }}
        </UBadge>

        <!-- Status Text -->
        <span v-if="statusText" class="text-3 text-gray-500 dark:text-gray-400 ml-auto">
          {{ statusText }}
        </span>

        <!-- Toggle Indicator -->
        <span 
          v-if="collapsible"
          class="text-3 text-gray-500 dark:text-gray-400 ml-auto transition-transform duration-200"
          :class="{ 'rotate-180': isExpanded }"
        >
          <span class="i-lucide-chevron-down" />
        </span>
      </component>

      <!-- Action Buttons -->
      <div v-if="$slots.actions || showDefaultActions" class="flex items-center gap-2 mt-2">
        <slot name="actions" :posts="posts" :is-loading="isLoading" :is-expanded="isExpanded">
          <!-- Default actions -->
          <UButton
            v-if="showRefreshAction"
            btn="ghost"
            size="xs"
            :loading="isLoading"
            @click="handleRefresh"
          >
            <UIcon name="i-ph-arrows-counter-clockwise-duotone" />
            <span>Refresh</span>
          </UButton>
          
          <UButton
            v-if="showAddAction"
            btn="ghost"
            size="xs"
            @click="handleAdd"
          >
            <UIcon name="i-ph-plus-duotone" />
            <span>Add {{ sectionType }}</span>
          </UButton>
        </slot>
      </div>

      <!-- Progress Bar -->
      <UProgress 
        v-if="isLoading && showProgress" 
        :indeterminate="true" 
        size="sm" 
        color="primary" 
        class="mt-2"
      />
    </header>

    <!-- Content Area -->
    <div 
      v-if="isExpanded"
      class="transition-all duration-300 ease-in-out"
      :class="contentClasses"
    >
      <!-- Loading State -->
      <div v-if="isLoading && posts.length === 0" class="space-y-4">
        <div 
          v-for="n in skeletonCount" 
          :key="n"
          class="animate-pulse"
        >
          <div class="flex items-start gap-4 p-4 border border-gray-200 dark:border-gray-700 rounded-lg">
            <div class="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-lg flex-shrink-0" />
            <div class="flex-1 space-y-2">
              <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-3/4" />
              <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded w-1/2" />
              <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded w-1/4" />
            </div>
          </div>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="text-center py-8">
        <div class="text-red-500 dark:text-red-400 mb-4">
          <span class="i-lucide-alert-circle text-6xl" />
        </div>
        <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100 mb-2">
          Failed to load {{ sectionType.toLowerCase() }}
        </h3>
        <p class="text-gray-600 dark:text-gray-400 mb-4">
          {{ error }}
        </p>
        <UButton
          btn="outline"
          size="sm"
          icon
          label="i-lucide-refresh-cw"
          @click="handleRetry"
        >
          Try Again
        </UButton>
      </div>

      <!-- Posts Grid -->
      <div v-else-if="posts.length > 0" :class="gridClasses">
        <PostCard
          v-for="post in displayedPosts"
          :key="post.id"
          :post="post"
          :variant="itemVariant"
          :menu-variant="menuVariant"
          :show-primary-tag="showPrimaryTag"
          :show-secondary-tags="showSecondaryTags"
          :show-word-count="showWordCount"
          :show-draft-badge="showDraftBadge"
          :show-archived-badge="true"
          :show-status-indicator="showStatusIndicator"
          v-bind="itemProps"
          @edit="$emit('edit', $event)"
          @delete="$emit('delete', $event)"
          @publish="$emit('publish', $event)"
          @unpublish="$emit('unpublish', $event)"
          @duplicate="$emit('duplicate', $event)"
          @archive="$emit('archive', $event)"
          @share="$emit('share', $event)"
          @export="$emit('export', $event)"
          @view-stats="$emit('view-stats', $event)"
        />

        <!-- Load More Button -->
        <div v-if="hasMore" class="text-center pt-4">
          <UButton
            btn="ghost"
            size="sm"
            :loading="isLoadingMore"
            @click="handleLoadMore"
          >
            Load More {{ sectionType }}
          </UButton>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else>
        <slot name="empty" :section-type="sectionType">
          <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100 mb-1">
            {{ emptyStateTitle }}
          </h3>
          <p class="text-size-3 text-gray-600 dark:text-gray-400 mb-6 max-w-md">
            {{ emptyStateDescription }}
          </p>
          <UButton
            v-if="showEmptyAction"
            btn="solid-gray"
            size="xs"
            @click="handleEmptyAction"
          >
          <span>{{ emptyActionText }}</span>
          <UIcon :name="emptyActionIcon" />
          </UButton>
        </slot>
      </div>
    </div>

    <!-- Custom Footer -->
    <footer v-if="$slots.footer" class="mt-4">
      <slot name="footer" :posts="posts" :total-count="totalCount" :is-expanded="isExpanded" />
    </footer>
  </section>
</template>

<script setup lang="ts">
import type { Post } from '~/types/post'

interface PostSectionProps {
  // Content
  posts: Post[]
  title: string
  sectionType: string
  
  // Behavior
  collapsible?: boolean
  expanded?: boolean
  autoExpand?: boolean
  
  // Display options
  icon?: string
  iconColor?: string
  showCount?: boolean
  showProgress?: boolean
  variant?: 'default' | 'compact' | 'detailed'
  
  // Post item configuration
  itemVariant?: 'default' | 'compact' | 'detailed'
  menuVariant?: 'default' | 'minimal' | 'compact'
  showPrimaryTag?: boolean
  showSecondaryTags?: boolean
  showWordCount?: boolean
  showDraftBadge?: boolean
  showStatusIndicator?: boolean
  itemProps?: Record<string, any>
  
  // Pagination
  pageSize?: number
  hasMore?: boolean
  
  // Actions
  showDefaultActions?: boolean
  showRefreshAction?: boolean
  showAddAction?: boolean
  
  // Empty state
  showEmptyAction?: boolean
  emptyStateTitle?: string
  emptyStateDescription?: string
  emptyActionText?: string
  emptyActionIcon?: string
  
  // State
  isLoading?: boolean
  isLoadingMore?: boolean
  error?: string | null
  
  // Styling
  spacing?: 'tight' | 'normal' | 'loose'
  className?: string
}

interface PostSectionEmits {
  (e: 'toggle', expanded: boolean): void
  (e: 'refresh'): void
  (e: 'add'): void
  (e: 'load-more'): void
  (e: 'retry'): void
  (e: 'empty-action'): void
  (e: 'edit', post: Post): void
  (e: 'delete', post: Post): void
  (e: 'publish', post: Post): void
  (e: 'unpublish', post: Post): void
  (e: 'duplicate', post: Post): void
  (e: 'archive', post: Post): void
  (e: 'share', post: Post): void
  (e: 'export', post: Post): void
  (e: 'view-stats', post: Post): void
}

const props = withDefaults(defineProps<PostSectionProps>(), {
  collapsible: false,
  expanded: true,
  autoExpand: true,
  showCount: true,
  showProgress: true,
  variant: 'default',
  itemVariant: 'default',
  menuVariant: 'default',
  showPrimaryTag: true,
  showSecondaryTags: false,
  showWordCount: false,
  showDraftBadge: true,
  showStatusIndicator: false,
  pageSize: 10,
  hasMore: false,
  showDefaultActions: false,
  showRefreshAction: false,
  showAddAction: false,
  showEmptyAction: true,
  emptyActionText: 'Create New',
  emptyActionIcon: 'i-lucide-plus',
  isLoading: false,
  isLoadingMore: false,
  error: null,
  spacing: 'normal',
  itemProps: () => ({})
})

const emit = defineEmits<PostSectionEmits>()

// Internal state
const isExpanded = ref(props.expanded)

// Computed properties
const totalCount = computed(() => props.posts.length)

const shouldShowSection = computed(() => {
  return props.posts.length > 0 || props.isLoading || props.error || props.autoExpand
})

const displayedPosts = computed(() => {
  if (props.pageSize <= 0) return props.posts
  return props.posts.slice(0, props.pageSize)
})

const skeletonCount = computed(() => Math.min(props.pageSize || 3, 5))

// Header configuration
const headerComponent = computed(() => {
  return props.collapsible ? 'button' : 'div'
})

const headerProps = computed(() => {
  if (!props.collapsible) return {}
  
  return {
    type: 'button',
    'aria-expanded': isExpanded.value,
    'aria-controls': `section-${props.sectionType.toLowerCase()}`,
  }
})

const headerClasses = computed(() => {
  const classes = []
  
  if (props.collapsible) {
    classes.push('hover:text-gray-900 dark:hover:text-gray-100 cursor-pointer')
  }
  
  return classes
})

// Status and badges
const statusText = computed(() => {
  if (props.isLoading) return 'Loading...'
  if (props.error) return 'Error'
  if (totalCount.value === 0) return 'Empty'
  if (props.collapsible && !isExpanded.value) return `${totalCount.value} items`
  return ''
})

const countBadgeVariant = computed(() => {
  if (props.error) return 'solid'
  return 'soft'
})

const countBadgeColor = computed(() => {
  if (props.error) return 'red'
  if (props.sectionType.toLowerCase().includes('draft')) return 'amber'
  return 'blue'
})

// Empty state
const emptyStateIcon = computed(() => {
  if (props.sectionType.toLowerCase().includes('draft')) {
    return 'i-lucide-file-edit'
  }
  return 'i-lucide-file-text'
})

const emptyStateTitle = computed(() => {
  return props.emptyStateTitle || `No ${props.sectionType.toLowerCase()} yet`
})

const emptyStateDescription = computed(() => {
  return props.emptyStateDescription || 
    `You haven't created any ${props.sectionType.toLowerCase()} yet. Start writing to see them here.`
})

// Styling
const iconStyle = computed(() => {
  if (!props.iconColor) return {}
  return { color: props.iconColor }
})

const sectionClasses = computed(() => {
  const classes = ['mb-6']
  
  if (props.className) {
    classes.push(props.className)
  }
  
  switch (props.spacing) {
    case 'tight':
      classes.push('mb-4')
      break
    case 'loose':
      classes.push('mb-8')
      break
  }
  
  return classes
})

const contentClasses = computed(() => {
  const classes = []
  
  if (!isExpanded.value) {
    classes.push('opacity-0', 'max-h-0', 'overflow-hidden')
  } else {
    classes.push('opacity-100', 'max-h-none')
  }
  
  return classes
})

const gridClasses = computed(() => {
  const classes = ['grid gap-6']

  switch (props.variant) {
    case 'compact':
      classes.push('grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4')
      break
    case 'detailed':
      classes.push('grid-cols-1 md:grid-cols-2 gap-8')
      break
    default:
      classes.push('grid-cols-1 md:grid-cols-2 lg:grid-cols-3')
      break
  }

  return classes
})

// Event handlers
const handleHeaderClick = () => {
  if (!props.collapsible) return
  
  isExpanded.value = !isExpanded.value
  emit('toggle', isExpanded.value)
}

const handleRefresh = () => {
  emit('refresh')
}

const handleAdd = () => {
  emit('add')
}

const handleLoadMore = () => {
  emit('load-more')
}

const handleRetry = () => {
  emit('retry')
}

const handleEmptyAction = () => {
  emit('empty-action')
}

// Watch for prop changes
watch(() => props.expanded, (newValue) => {
  isExpanded.value = newValue
})

// Auto-expand when posts are loaded
watch(() => props.posts.length, (newLength, oldLength) => {
  if (props.autoExpand && newLength > 0 && oldLength === 0) {
    isExpanded.value = true
  }
})

// Expose state for parent component
defineExpose({
  isExpanded: readonly(isExpanded),
  totalCount,
  displayedPosts,
  expand: () => { isExpanded.value = true },
  collapse: () => { isExpanded.value = false },
  toggle: () => handleHeaderClick()
})
</script>

<style scoped>
/* Custom animations for smooth expand/collapse */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

/* Ensure proper spacing in different variants */
.space-y-2 > * + * {
  margin-top: 0.5rem;
}

.space-y-4 > * + * {
  margin-top: 1rem;
}

.space-y-6 > * + * {
  margin-top: 1.5rem;
}
</style>
