<template>
  <div class="w-full">
    <!-- Header with Actions -->
    <div class="flex items-center justify-between mb-6">
      <div class="flex items-center gap-3">
        <h2 class="text-xl font-600 text-gray-800 dark:text-gray-200">
          {{ title }}
        </h2>
        <UBadge 
          v-if="posts.length > 0"
          variant="soft" 
          color="gray" 
          size="sm"
        >
          {{ posts.length }}
        </UBadge>
      </div>
      
      <slot name="actions" :posts="posts" :is-loading="isLoading" />
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="flex items-center justify-center py-12">
      <div class="flex items-center gap-3 text-gray-600 dark:text-gray-400">
        <UIcon name="i-lucide-loader-2" class="animate-spin" />
        <span>Loading posts...</span>
      </div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
      <div class="flex flex-col items-center gap-4">
        <UIcon name="i-lucide-alert-circle" class="text-red-500 text-2xl" />
        <div class="text-red-600 dark:text-red-400">
          {{ error }}
        </div>
        <UButton
          btn="soft-red"
          size="sm"
          @click="$emit('retry')"
        >
          <UIcon name="i-lucide-refresh-cw" />
          <span>Try Again</span>
        </UButton>
      </div>
    </div>

    <!-- Posts Grid -->
    <div v-else-if="posts.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <PostCard
        v-for="post in posts"
        :key="post.id"
        :post="post"
        :show-menu="true"
        :show-primary-tag="true"
        :show-secondary-tags="true"
        :show-word-count="true"
        :show-draft-badge="false"
        :show-archived-badge="false"
        :show-status-indicator="false"
        :menu-variant="'minimal'"
        :show-drag-handle="true"
        :is-drag-enabled="true"
        variant="default"
        :source-tab="getSourceTabFromTitle(title)"
        @edit="$emit('edit', $event)"
        @delete="$emit('delete', $event)"
        @publish="$emit('publish', $event)"
        @unpublish="$emit('unpublish', $event)"
        @duplicate="$emit('duplicate', $event)"
        @archive="$emit('archive', $event)"
        @unarchive="$emit('unarchive', $event)"
        @share="$emit('share', $event)"
        @export="$emit('export', $event)"
        @view-stats="$emit('view-stats', $event)"
        @drag-start="$emit('drag-start', $event)"
        @drag-end="$emit('drag-end', $event)"
      />
    </div>

    <!-- Empty State -->
    <div v-else class="text-center py-16">
      <div class="flex flex-col items-center gap-6 max-w-md mx-auto">
        <!-- Empty State Icon -->
        <div class="w-16 h-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
          <UIcon :name="emptyActionIcon" class="text-2xl text-gray-400" />
        </div>
        
        <!-- Empty State Content -->
        <div class="text-center">
          <h3 class="text-lg font-600 text-gray-800 dark:text-gray-200 mb-2">
            {{ emptyTitle }}
          </h3>
          <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">
            {{ emptyDescription }}
          </p>
        </div>
        
        <!-- Empty State Action -->
        <UButton
          btn="soft-primary"
          size="sm"
          @click="$emit('empty-action')"
        >
          <UIcon :name="emptyActionIcon" />
          <span>{{ emptyActionText }}</span>
        </UButton>
      </div>
    </div>

    <!-- Footer Slot -->
    <div v-if="$slots.footer && posts.length > 0" class="mt-8 pt-6 border-t border-gray-200 dark:border-gray-700">
      <slot name="footer" :posts="posts" :total-count="posts.length" />
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Post } from '~/types/post'

interface PostsTabContentProps {
  posts: Post[]
  isLoading: boolean
  error: string | null
  title: string
  emptyTitle: string
  emptyDescription: string
  emptyActionText: string
  emptyActionIcon: string
}

interface PostsTabContentEmits {
  // Post actions
  (e: 'edit', post: Post): void
  (e: 'delete', post: Post): void
  (e: 'publish', post: Post): void
  (e: 'unpublish', post: Post): void
  (e: 'archive', post: Post): void
  (e: 'unarchive', post: Post): void
  (e: 'duplicate', post: Post): void
  (e: 'share', post: Post): void
  (e: 'export', post: Post): void
  (e: 'view-stats', post: Post): void

  // Control actions
  (e: 'refresh'): void
  (e: 'retry'): void
  (e: 'empty-action'): void

  // Drag and drop actions
  (e: 'drag-start', post: Post, sourceTab: string): void
  (e: 'drag-end', post: Post): void
}

defineProps<PostsTabContentProps>()
defineEmits<PostsTabContentEmits>()

// Helper function to determine source tab from title
const getSourceTabFromTitle = (title: string): 'published' | 'drafts' | 'archived' => {
  if (title.toLowerCase().includes('draft')) return 'drafts'
  if (title.toLowerCase().includes('archived')) return 'archived'
  return 'published'
}
</script>
