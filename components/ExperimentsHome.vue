<template>
  <section class="w-[860px] mt-24 mb-12">
    <div class="mb-6">
      <ULink to="/experiments" class="font-title text-4 font-600 text-gray-800 dark:text-gray-200">
        <span>Experiments</span>
        <UIcon name="i-ph-arrow-right-duotone" size="4" class="ml-2" />
      </ULink>
    </div>
    
    <div v-if="experimentLoading" class="text-center py-8">
      <div class="text-gray-600 dark:text-gray-400">Loading experiments...</div>
    </div>
    
    <div v-else-if="experimentError" class="text-center py-8">
      <div class="text-red-600 dark:text-red-400">Error loading experiments</div>
    </div>
    
    <div v-else-if="experiments && experiments.length > 0" 
      class="w-full b-red flex flex-col justify-start"
    >
      <ULink v-for="experiment in experiments.slice(0, 3)" :key="experiment.id" 
        :to="`/experiments/${experiment.slug}`"
        class="flex flex-col group"
      >
        <h1 class="text-16 font-body transition-all duration-300 hover:text-shadow-glow">
          {{ experiment.name }}
        </h1>
      </ULink>
    </div>
    
    <div v-else class="text-center py-8">
      <div class="text-gray-600 dark:text-gray-400">No experiment available</div>
    </div>
  </section>
</template>

<script lang="ts" setup>
import type { Experiment } from '~/types/experiment';

interface Props {
  experiments: Experiment[];
  experimentLoading: boolean;
  experimentError: boolean;
}

defineProps<Props>();
</script>

<style scoped>
.hover\:text-shadow-glow:hover {
  text-shadow: 
    2px 2px 0px #FFAAAA,
    4px 4px 0px #FE5D26,
    6px 6px 0px #00CAFF,
    6px 6px 0px #4300FF;
  transform: translateX(-2px) translateY(-2px);
}

.hover\:text-shadow-glow:active {
  text-shadow: none;
}

/* For dark mode */
.dark .hover\:text-shadow-glow:hover {
  text-shadow: 
    2px 2px 0px #093FB4,
    4px 4px 0px #FFFCFB,
    6px 6px 0px #ED3500,
    6px 6px 0px #FFD8D8;
}

.dark .hover\:text-shadow-glow:active {
  text-shadow: none;
}

</style>
