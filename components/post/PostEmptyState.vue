<template>
  <section class="mb-12">
    <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
      <span :class="icon" class="mr-2"></span>
      {{ title }}
    </h2>
    <div class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">
      {{ subtitle }}
    </div>
    <div class="text-xl font-300 text-gray-600 dark:text-gray-400 italic">
      {{ quote }}
    </div>
    <div class="text-right text-gray-500 dark:text-gray-500 mt-2">
      {{ attribution }}
    </div>
  </section>
</template>

<script lang="ts" setup>
interface Props {
  title?: string
  subtitle?: string
  quote?: string
  attribution?: string
  icon?: string
}

withDefaults(defineProps<Props>(), {
  title: 'A Thought to Ponder',
  subtitle: 'Because there\'s no published posts yet, here is a quote:',
  quote: '« Without leaps of imagination, or dreaming, we lose the excitement of possibilities. Dreaming, after all, is a form of planning. »',
  attribution: '— Gloria Steinem',
  icon: 'i-ph-quotes'
})
</script>