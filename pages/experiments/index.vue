<template>
  <!-- Experiments -->
  <div class="w-[600px] rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <!-- Header -->
    <header class="mt-12 mb-8">
      <div class="flex gap-2">
        <ULink to="/" class="hover:scale-102 active:scale-99 transition">
          <span class="i-ph-house-simple-duotone"></span>
        </ULink>
        <span>•</span>
        <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
          Experiments
        </h1>
      </div>
      <div class="w-40 flex text-center justify-center my-2">
        <div class="w-full h-2">
          <svg viewBox="0 0 300 10" preserveAspectRatio="none">
            <path d="M 0 5 Q 15 0, 30 5 T 60 5 T 90 5 T 120 5 T 150 5 T 180 5 T 210 5 T 240 5 T 270 5 T 300 5"
              stroke="currentColor" fill="none" class="text-gray-300 dark:text-gray-700" stroke-width="1" />
          </svg>
        </div>
      </div>
      <p class="text-gray-700 dark:text-gray-300 mb-4">
        Unleash your curiosity and explore a new world
      </p>
    </header>

    <!-- Loading State -->
    <section v-if="status === 'pending'" class="mb-12">
      <div class="flex flex-col items-center justify-center py-8">
        <span class="i-ph-spinner-gap animate-spin text-3xl text-gray-400 dark:text-gray-600 mb-4"></span>
        <p class="text-gray-600 dark:text-gray-400">Loading experiments...</p>
      </div>
    </section>
    
    <!-- Empty State -->
    <section v-else-if="experiments && experiments.length === 0" class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-flask mr-2"></span>
        Coming Soon
      </h2>
      <div class="text-gray-600 dark:text-gray-400 text-size-4 font-300 mb-4">
        This <span class="font-500 text-yellow-500 dark:text-yellow-400">space</span> is currently 
        <span class="font-500 text-pink-500 dark:text-pink-400">empty</span> but will be dedicated to innovative 
        coding experiments and creative explorations.
      </div>
      <p class="text-gray-500 dark:text-gray-500 text-size-3">
        Check back soon for interactive demos, creative coding projects, and technical explorations!
      </p>
    </section>

    <!-- Experiments List -->
    <section v-else class="my-8">
      <h2 class="text-3 font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-test-tube -mt-1 mr-2"></span>
        Available Experiments
      </h2>
      <div class="flex flex-col gap-4">
        <ULink 
          v-for="experiment in experiments" 
          :key="experiment.slug" 
          :to="`/experiments/${experiment.slug}`" 
          class="experiment-card">
          <h3 class="name">{{ experiment.name }}</h3>
          <p class="description">{{ experiment.description }}</p>
          <!-- <div class="flex justify-end mt-2">
            <span class="text-gray-400 dark:text-gray-600 text-size-2 flex items-center">
              <span class="i-ph-arrow-right mr-1"></span>
              Try it out
            </span>
          </div> -->
        </ULink>
      </div>
    </section>

    <Footer />
  </div>
</template>

<script lang="ts" setup>
useHead({
  title: "root • experiments",
  meta: [
    {
      name: 'description',
      content: "A space for innovative coding experiments and creative explorations",
    },
  ],
})

const { data: experiments, status } = await useFetch('/api/experiments')
</script>

<style scoped>
.experiment-card {
  background-color: white;
  padding: 1rem 1.5rem;
  border-radius: 0.5rem;
  border: 1px dashed rgb(229, 231, 235);
  transition: all 300ms;

  &:hover {
    box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
    border-color: rgb(209, 213, 219);
    border-style: solid;
    transform: translateY(-2px);
  }

  .name {
    font-size: 1rem;
    font-weight: 600;
    color: rgb(55, 65, 81);
  }

  .description {
    font-size: 0.8rem;
    font-weight: 400;
    color: rgb(107, 114, 128);
  }
}

.dark .experiment-card {
  background-color: transparent;
  border: 1px dashed rgb(31, 41, 55);

  &:hover {
    border-style: solid;
    transform: translateY(-2px);

    &:nth-child(1) {
      border-color: #eee;
    }
    &:nth-child(2) {
      border-color: #2ed573;
    }
    &:nth-child(3) {
      border-color: #ff6b81;
    }
    &:nth-child(4) {
      border-color: #0abde3;
    }
    &:nth-child(5) {
      border-color: #1e90ff;
    }
    &:nth-child(6) {
      border-color: #f78fb3;
    }
    &:nth-child(7) {
      border-color: #ffa502;
    }
  }

  .name {
    color: rgb(209, 213, 219);
  }

  .description {
    color: rgb(148, 163, 184);
  }
}
</style>
