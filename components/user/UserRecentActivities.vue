<template>
  <section class="mb-12">
    <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
      <span class="i-ph-clock-clockwise mr-2"></span>
      Recent Activity
    </h2>
    
    <div class="space-y-3">
      <div 
        v-for="activity in recentActivity" 
        :key="activity.id"
        class="flex items-center gap-3 p-3 bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700"
      >
        <div :class="activity.icon" class="text-lg" :style="`color: ${activity.color}`"></div>
        <div class="flex-1">
          <p class="text-sm text-gray-800 dark:text-gray-200">{{ activity.description }}</p>
          <p class="text-xs text-gray-500 dark:text-gray-400">{{ formatDate(activity.timestamp) }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts" setup>
defineProps<{
  recentActivity: {
    id: number;
    icon: string;
    description: string;
    timestamp: string;
    color: string;
  }[];
}>()

// Format date helper
const formatDate = (date: string | Date) => {
  if (!date) return 'Unknown'
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

</script>