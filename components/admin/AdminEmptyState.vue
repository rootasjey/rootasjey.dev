<template>
  <div class="text-center py-12">
    <div :class="[icon, 'text-4xl text-gray-400 mb-4']"></div>
    <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
      {{ title }}
    </h3>
    <p class="text-gray-500 dark:text-gray-400 mb-6">
      {{ description }}
    </p>
    
    <UButton
      v-if="actionText"
      @click="$emit('action')"
      :btn="actionVariant"
      size="sm"
      class="hover:scale-102 active:scale-99 transition"
    >
      <span v-if="actionIcon" :class="[actionIcon, 'mr-2']"></span>
      {{ actionText }}
    </UButton>
  </div>
</template>

<script setup lang="ts">
interface Props {
  icon: string
  title: string
  description: string
  actionText?: string
  actionIcon?: string
  actionVariant?: string
}

interface Emits {
  (e: 'action'): void
}

const props = withDefaults(defineProps<Props>(), {
  actionText: undefined,
  actionIcon: undefined,
  actionVariant: 'soft-blue'
})

const emit = defineEmits<Emits>()
</script>
