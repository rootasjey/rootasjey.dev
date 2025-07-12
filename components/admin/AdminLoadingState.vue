<template>
  <div class="space-y-4">
    <!-- Grid Loading -->
    <div v-if="variant === 'grid'" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="i in count" :key="i" class="animate-pulse">
        <div class="h-48 bg-gray-200 dark:bg-gray-700 rounded-lg"></div>
      </div>
    </div>
    
    <!-- List Loading -->
    <div v-else-if="variant === 'list'" class="space-y-4">
      <div v-for="i in count" :key="i" class="animate-pulse flex items-center gap-4">
        <div class="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-full"></div>
        <div class="flex-1 space-y-2">
          <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-3/4"></div>
          <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded w-1/2"></div>
        </div>
        <div class="h-6 w-16 bg-gray-200 dark:bg-gray-700 rounded"></div>
      </div>
    </div>
    
    <!-- Table Loading -->
    <div v-else-if="variant === 'table'" class="space-y-3">
      <div v-for="i in count" :key="i" class="animate-pulse">
        <div class="h-16 bg-gray-200 dark:bg-gray-700 rounded-lg"></div>
      </div>
    </div>
    
    <!-- Card Loading -->
    <div v-else class="space-y-4">
      <div v-for="i in count" :key="i" class="animate-pulse">
        <div class="h-24 bg-gray-200 dark:bg-gray-700 rounded-lg"></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  variant?: 'grid' | 'list' | 'table' | 'card'
  count?: number
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'card',
  count: 5
})
</script>
