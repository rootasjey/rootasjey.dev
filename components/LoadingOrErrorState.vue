<template>
  <div>
    <div v-if="loading" class="flex flex-col justify-center items-center h-60vh">
      <svg class="animate-spin mb-4" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="10" stroke-opacity="0.2" />
        <path d="M12 2a10 10 0 0 1 10 10" />
      </svg>
      <span class="loading-dots text-lg font-medium text-gray-600 dark:text-gray-300">Loading</span>
    </div>
    <div v-else-if="error" class="flex flex-col justify-center items-center max-w-lg mx-auto text-center min-h-60vh mt-16">
      <svg class="mb-4 text-amber-500" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="10" stroke-opacity="0.2" />
        <line x1="15" y1="9" x2="9" y2="15" />
        <line x1="9" y1="9" x2="15" y2="15" />
      </svg>
      <span class="text-4xl font-400 font-body">{{ error }}</span>
      <p class="mt-4 text-gray-600 dark:text-gray-300">Please try 
        <ULink class="hover:underline decoration-offset-4 mx-1"><UIcon name="i-ph-arrow-counter-clockwise-bold" />refreshing</ULink> 
        the page or check back later.
      </p>
      <p class="font-text text-lg mt-8 border-t pt-8">
        <span class="font-600 text-gray-400 dark:text-gray-300 ">In the meantime, here is a quote for the day:</span><br/>
        <q class="mt-4 text-4xl italic">The only limit to our realization of tomorrow is our doubts of today.</q>
        <br>
        <span class="text-sm text-gray-500">- Franklin D. Roosevelt</span>
      </p>
    </div>
    <div v-else class="flex justify-center items-center h-60vh">
      <!-- fallback, should not be visible -->
    </div>
  </div>
</template>

<script lang="ts" setup>
const props = defineProps<{
  loading: boolean;
  error: string | null;
}>()
</script>

<style scoped>
.loading-dots::after {
  content: '.';
  animation: dots 1.2s steps(3, end) infinite;
}
@keyframes dots {
  0%, 20% { content: '.'; }
  40% { content: '..'; }
  60%, 100% { content: '...'; }
}
</style>
