<template>
  <section class="mb-12 bg-[#FAFAF9] dark:bg-gray-900 rounded-xl px-6 py-8">
    <h2 class="text-md font-500 text-gray-800 dark:text-gray-200">
      <UIcon :name="icon" class="mr-2" />
      {{ title }}
    </h2>
    <div class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-6">
      {{ subtitle }}
    </div>
    <div class="text-md font-300 text-gray-600 dark:text-gray-400 italic">
      {{ quote }}
    </div>
    <div class="text-xs text-right text-gray-500 dark:text-gray-500">
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