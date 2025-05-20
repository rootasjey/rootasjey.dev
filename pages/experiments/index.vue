<template>
  <div class="container mx-auto px-4 py-8">
    <ULink class="flex flex-col items-center justify-center" to="/">
      <span class="i-ph-house-simple-duotone mx-auto text-center text-xl text-gray-600 dark:text-gray-400" />
    </ULink>

    <PageHeader 
      title="Experiments" 
      subtitle="Unleash your curiosity and explore a new world"
    />

    <div v-if="status === 'pending'" class="text-center py-12">
      <p>Loading experiments...</p>
    </div>
    
    <div v-else-if="experiments && experiments.length === 0" 
      class="flex flex-col items-center justify-center mt-20 text-center">
      <h4 class="text-gray-600 max-w-lg mb-12 text-size-6">
        This <b class="color-yellow">space</b> is currently <b class="color-pink">empty</b> but will be dedicated to innovative coding experiments 
        and creative explorations. 
        Check back soon!
      </h4>
    </div>

    <div v-else class="flex flex-wrap justify-center gap-4">
      <ULink 
        v-for="experiment in experiments" 
        :key="experiment.slug" 
        :to="`/experiments/${experiment.slug}`" 
        class="experiment-card bg-white dark:bg-black 
          py-2 px-6 rounded-lg border b-dashed border-gray-200 dark:border-blue-300
        hover:shadow-sm hover:b-solid transition-all duration-300"
      >
        <h3 class="text-xl font-bold">{{ experiment.name }}</h3>
        <p class="text-gray-600 dark:text-gray-200 text-size-2">{{ experiment.description }}</p>
      </ULink>
    </div>
  </div>
</template>

<script lang="ts" setup>

useHead({
  title: "rootasjey • experiments",
  meta: [
    {
      name: 'description',
      content: "A space for thoughts and insights",
    },
  ],
})

const { data: experiments, status } = await useFetch('/api/experiments')
</script>
