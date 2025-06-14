<template>
  <section class="mb-12">
    <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
      <span class="i-ph-chart-bar mr-2"></span>
      Your Gallery Stats
    </h2>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
      <div class="bg-white dark:bg-gray-800 rounded-lg p-4 border border-gray-200 dark:border-gray-700">
        <div class="flex items-center gap-3">
          <div class="i-ph-image text-blue-500 text-xl"></div>
          <div>
            <p class="text-2xl font-600 text-gray-800 dark:text-gray-200">{{ userStats.totalPosts }}</p>
            <p class="text-sm text-gray-600 dark:text-gray-400">Total Posts</p>
          </div>
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 rounded-lg p-4 border border-gray-200 dark:border-gray-700">
        <div class="flex items-center gap-3">
          <div class="i-ph-folder text-green-500 text-xl"></div>
          <div>
            <p class="text-2xl font-600 text-gray-800 dark:text-gray-200">{{ userStats.totalProjects }}</p>
            <p class="text-sm text-gray-600 dark:text-gray-400">Total Projects</p>
          </div>
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 rounded-lg p-4 border border-gray-200 dark:border-gray-700">
        <div class="flex items-center gap-3">
          <div class="i-ph-upload text-purple-500 text-xl"></div>
          <div>
            <p class="text-2xl font-600 text-gray-800 dark:text-gray-200">{{ userStats.totalExperiments }}</p>
            <p class="text-sm text-gray-600 dark:text-gray-400">Total Experiments</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts" setup>
defineProps<{
  userStats: {
    totalProjects: number;
    totalPosts: number;
    totalExperiments: number;
  };
}>()
</script>