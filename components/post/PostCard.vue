<template>
  <UCard class="relative rounded-0 px-0 border b-gray-200/40 hover:b-gray-2">
    <!-- Post Content -->
    <div class="py-4">
      <!-- Post Category -->
      <div v-if="post.tags.length" class="flex flex-wrap gap-2 mb-2">
        <span class=" text-xs font-medium text-gray-600 dark:text-gray-400">
          {{ post.tags[0] }}
        </span>
      </div>

      <h3 class="font-body text-size-8 font-700 line-height-tight mb/40-4 text-gray-800 dark:text-gray-200 line-clamp-6">
        {{ post.name }}
      </h3>
      
      <p v-if="post.description" 
          class="text-gray-600 dark:text-gray-400 text-sm mb-3 line-clamp-12">
        {{ post.description }}
      </p>
    </div>

    <template #footer>
      <!-- Post Meta -->
      <div class="p-0 absolute bottom-4">
        <div class="text-xs text-gray-500 dark:text-gray-500">
          <time v-if="post.created_at" :datetime="post.created_at">
            {{ formatDate(post.created_at) }}
          </time>
        </div>
        
        <!-- Read More Link -->
        <NuxtLink 
          :to="`/posts/${post.slug}`"
          class="inline-block hover:text-blue-800 dark:hover:text-blue-300 text-sm font-500 transition-colors"
        >
          Read more →
        </NuxtLink>
      </div>
    </template>
  </UCard>
</template>

<script setup lang="ts">
import type { PostType } from '~/types/post'

interface Props {
  post: PostType
}

defineProps<Props>()

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString()
}
</script>

<style scoped>
/* Base styles */
.post-card {
  transition: all 200ms;
}
.post-card:hover {
  box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
}

.post-header {
  margin-top: 0.75rem;
  margin-bottom: 0.75rem;
}

.post-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 0.875rem;
}

.post-date {
  color: #6b7280;
}

.post-title {
  font-size: 1.125rem;
  font-weight: 600;
}

.post-title a {
  transition: color 200ms;
}
.post-title a:hover {
  color: #2563eb;
}

.post-description {
  color: #4b5563;
  font-size: 0.875rem;
  display: -webkit-box;
  line-clamp: 2;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.dark .post-description {
  color: #9ca3af;
}

.post-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.post-stats {
  display: flex;
  align-items: center;
  gap: 1rem;
  font-size: 0.875rem;
  color: #6b7280;
}

.stat {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.post-tags-summary {
  font-size: 0.75rem;
}
</style>