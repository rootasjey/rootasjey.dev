<template>
  <div class="text-center py-12">
    <div class="i-ph-warning-circle text-4xl text-red-500 mb-4"></div>
    <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
      {{ title }}
    </h3>
    <p class="text-gray-500 dark:text-gray-400 mb-6">
      {{ message }}
    </p>
    
    <div class="flex items-center justify-center gap-3">
      <UButton
        v-if="showRetry"
        @click="$emit('retry')"
        btn="soft-blue"
        size="sm"
        class="hover:scale-102 active:scale-99 transition"
      >
        <span class="i-ph-arrow-clockwise mr-2"></span>
        Try Again
      </UButton>
      
      <UButton
        v-if="showSupport"
        @click="$emit('support')"
        btn="ghost-gray"
        size="sm"
        class="hover:scale-102 active:scale-99 transition"
      >
        <span class="i-ph-question mr-2"></span>
        Get Help
      </UButton>
    </div>
    
    <!-- Error Details (collapsible) -->
    <div v-if="error && showDetails" class="mt-6">
      <UButton
        @click="showErrorDetails = !showErrorDetails"
        btn="ghost-gray"
        size="xs"
        class="mb-3"
      >
        <span :class="showErrorDetails ? 'i-ph-caret-up' : 'i-ph-caret-down'" class="mr-1"></span>
        {{ showErrorDetails ? 'Hide' : 'Show' }} Error Details
      </UButton>
      
      <div v-if="showErrorDetails" class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4 text-left">
        <pre class="text-xs text-red-700 dark:text-red-300 whitespace-pre-wrap">{{ error }}</pre>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  title?: string
  message?: string
  error?: string | Error
  showRetry?: boolean
  showSupport?: boolean
  showDetails?: boolean
}

interface Emits {
  (e: 'retry'): void
  (e: 'support'): void
}

const props = withDefaults(defineProps<Props>(), {
  title: 'Something went wrong',
  message: 'An error occurred while loading this content. Please try again.',
  error: undefined,
  showRetry: true,
  showSupport: false,
  showDetails: false
})

const emit = defineEmits<Emits>()

const showErrorDetails = ref(false)
</script>
