<template>
  <div class="grid grid-cols-2 gap-4">
    <div class="bg-gray-50 dark:bg-gray-800 p-3 rounded-lg">
      <div class="text-sm font-medium text-gray-700 dark:text-gray-300">Total Tags</div>
      <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ stats.total }}</div>
    </div>
    <div class="bg-gray-50 dark:bg-gray-800 p-3 rounded-lg">
      <div class="text-sm font-medium text-gray-700 dark:text-gray-300">Custom Tags</div>
      <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ stats.custom }}</div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { TagStats } from '~/composables/useTagManagement'

interface Props {
  stats: TagStats
}

defineProps<Props>()
</script>
