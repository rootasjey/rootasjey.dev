<template>
  <NuxtLink 
    :to="to"
    :class="[
      'group block p-4 rounded-lg transition-all duration-300 hover:translate-x-1 dark:hover:border border-dashed active:scale-99 active:border-solid',
      {
        'hover:bg-[#3D3BF3]/5 hover:text-[#3D3BF3] dark:hover:b-[#A1EEBD]': title === 'projects',
        'hover:bg-[#FAB12F]/5 hover:text-[#FAB12F] dark:hover:b-[#FAB12F]': title === 'reflexions',
        'hover:bg-[#CB9DF0]/5 hover:text-[#CB9DF0] dark:hover:b-[#CB9DF0]': title === 'experiments',
      }
    ]"
  >
    <div class="flex items-center gap-3">
      <div :class="[
        'text-xl text-gray-400 transition-colors duration-300',
        {
          'group-hover:text-[#3D3BF3] dark:group-hover:text-[#A1EEBD]': title === 'projects',
          'group-hover:text-[#FAB12F]': title === 'reflexions',
          'group-hover:text-[#CB9DF0]': title === 'experiments',

          // We need to define the icon class as static values for unocss to get them.
          'i-ph:laptop': title === 'projects',
          'i-ph-brain': title === 'reflexions',
          'i-ph-flask': title === 'experiments',
        }
      ]" />
      <div>
        <h3 class="text-sm font-medium text-gray-700 dark:text-gray-200 mb-0.5 transition-colors duration-300">
          {{ title }} ({{ count }})
        </h3>
        <p class="text-xs text-gray-500 dark:text-gray-400 transition-colors duration-300">
          {{ subtitle }}
        </p>
      </div>
    </div>
  </NuxtLink>
</template>

<script setup>
defineProps({
  color: {
    type: String,
    required: true
  },
  count: {
    type: Number,
    required: false
  },
  icon: {
    type: String,
    required: true
  },
  subtitle: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  },
  to: {
    type: String,
    required: true
  },
})

</script>