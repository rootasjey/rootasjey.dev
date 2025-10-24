<template>
  <ULink 
    :to="to" 
    class="block p-6 rounded-lg border border-gray-200 dark:border-gray-700 hover:border-primary-500 dark:hover:border-primary-500 transition-all"
  >
    <div class="flex items-start justify-between mb-2">
      <h3 class="text-lg font-600 text-gray-800 dark:text-gray-200">
        {{ title }}
      </h3>
    </div>
    
    <p v-if="subtitle" class="text-sm text-gray-600 dark:text-gray-400 mb-3">
      {{ subtitle }}
    </p>
    
    <div class="my-2">
      <span 
        v-if="badge" 
        class="text-xs px-2 py-1 rounded bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400"
      >
        {{ badge }}
      </span>
    </div>

    <div class="flex items-center gap-4 text-xs text-gray-500 dark:text-gray-500">
      <span v-if="language" class="flex items-center gap-1">
        <span class="i-ph-globe"></span>
        {{ language === 'fr' ? 'Français' : 'English' }}
      </span>
      <span v-if="updatedAt" class="flex items-center gap-1">
        <span class="i-ph-clock"></span>
        {{ formatDate(updatedAt) }}
      </span>
      <span v-if="linkedCount !== undefined" class="flex items-center gap-1">
        <span class="i-ph-link"></span>
        {{ linkedCount }} linked
      </span>
    </div>
  </ULink>
</template>

<script setup lang="ts">
const props = defineProps<{
  to: string
  title: string
  subtitle?: string
  badge?: string
  language?: 'en' | 'fr'
  updatedAt?: string
  linkedCount?: number
}>()

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  const now = new Date()
  const diffTime = Math.abs(now.getTime() - date.getTime())
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays < 7) {
    return `${diffDays} day${diffDays > 1 ? 's' : ''} ago`
  } else if (diffDays < 30) {
    const weeks = Math.floor(diffDays / 7)
    return `${weeks} week${weeks > 1 ? 's' : ''} ago`
  } else {
    return date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'short', 
      day: 'numeric' 
    })
  }
}
</script>
