<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 p-6 hover:shadow-md transition-shadow">
    <div class="flex items-center justify-between mb-4">
      <div :class="iconClasses" class="text-2xl"></div>
      <div v-if="loading" class="animate-pulse">
        <div class="h-8 w-16 bg-gray-200 dark:bg-gray-700 rounded"></div>
      </div>
      <div v-else class="text-3xl font-700 font-body text-gray-800 dark:text-gray-200">
        {{ formattedValue }}
      </div>
    </div>
    
    <div class="space-y-2">
      <h3 class="text-sm font-600 text-gray-600 dark:text-gray-400 uppercase tracking-wide">
        {{ title }}
      </h3>
      
      <p v-if="subtitle && !loading" class="text-xs text-gray-500 dark:text-gray-500">
        {{ subtitle }}
      </p>
      
      <div v-else-if="loading" class="animate-pulse">
        <div class="h-3 w-24 bg-gray-200 dark:bg-gray-700 rounded"></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  title: string
  value: number
  loading?: boolean
  icon: string
  color: 'blue' | 'green' | 'purple' | 'orange' | 'red'
  subtitle?: string
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  subtitle: undefined
})

const formattedValue = computed(() => {
  if (props.loading) return '...'
  return props.value.toLocaleString()
})

const iconClasses = computed(() => {
  const baseClasses = [props.icon]
  
  switch (props.color) {
    case 'blue':
      baseClasses.push('text-blue-500')
      break
    case 'green':
      baseClasses.push('text-green-500')
      break
    case 'purple':
      baseClasses.push('text-purple-500')
      break
    case 'orange':
      baseClasses.push('text-orange-500')
      break
    case 'red':
      baseClasses.push('text-red-500')
      break
    default:
      baseClasses.push('text-gray-500')
  }
  
  return baseClasses
})
</script>
