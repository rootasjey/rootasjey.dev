<template>
  <div class="rounded-2 transition-shadow overflow-hidden">
    <!-- Project Image -->
    <div class="rounded-2 aspect-video bg-gray-100 dark:bg-gray-700 relative overflow-hidden">
      <ULink v-if="project.image.src" :to="`/projects/${project.slug}`" 
        class="w-full h-32 overflow-hidden">
        <NuxtImg 
          provider="hubblob"
          :src="`/${project.image.src}/xs.${project.image.ext}`" 
          :alt="project.image.alt || project.name" 
          class="w-full h-full object-cover group-hover:scale-105 transition-transform"
        />
      </ULink>
      <div v-else class="w-full h-full flex items-center justify-center">
        <div class="text-gray-400 dark:text-gray-500">
          <svg class="w-12 h-12" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-8 3 6 2-4 3 6z" clip-rule="evenodd" />
          </svg>
        </div>
      </div>
    </div>

    <!-- Project Content -->
    <div class="p-6">
      <!-- Project Title -->
      <h3 class="font-body text-8 font-600 mb-2 text-gray-900 dark:text-gray-100 line-clamp-2">
        <NuxtLink 
          :to="`/projects/${project.slug}`"
          class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors"
        >
          {{ project.name }}
        </NuxtLink>
      </h3>

      <!-- Description -->
      <p class="text-gray-700 dark:text-gray-300 text-sm mb-4 line-clamp-3">
        {{ project.description || 'No description available.' }}
      </p>

      <!-- Tags -->
      <div v-if="project.tags && project.tags.length > 0" class="flex flex-wrap gap-2 mb-4">
        <span 
          v-for="tag in project.tags.slice(0, 3)" 
          :key="tag"
          class="px-2 py-1 text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200 rounded-full"
        >
          {{ tag }}
        </span>
        <span 
          v-if="project.tags.length > 3"
          class="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-600 dark:bg-gray-700 dark:text-gray-400 rounded-full"
        >
          +{{ project.tags.length - 3 }}
        </span>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { NuxtImg } from '#components';
import type { ProjectType } from '~/types/project';

interface Props {
  project: ProjectType
}

defineProps<Props>()

// Helper function to format dates
const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
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

.line-clamp-3 {
  display: -webkit-box;
  line-clamp: 3;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>