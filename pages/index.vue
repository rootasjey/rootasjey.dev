<template>
  <!-- pages/index.vue -->
  <div class="w-[600px] rounded-xl p-8 flex flex-col transition-all duration-500 overflow-y-auto">
    <!-- Header -->
    <header class="mb-8 text-center">
      <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
        rootasjey
      </h1>
      <h5 class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
        Exploring the intersection of code & creativity
      </h5>

      <!-- Greeting -->
      <div class="flex justify-center items-center gap-2">
        <div :class="timeIcon" class="cursor-pointer hover:scale-120 hover:accent-rose active:scale-99 transition" @click="$colorMode.preference = $colorMode.value === 'dark' ? 'light' : 'dark'" />

        <h2 class="text-size-3 font-500 text-gray-800 dark:text-gray-200">
          {{ greeting }} • {{ new Date().toLocaleDateString("fr-FR", { 
            weekday: 'long',
            month: 'long',
            day: 'numeric',
            year: 'numeric',
            hour: 'numeric',
            minute: 'numeric',
          }) }}
        </h2>


      <ULink to="/contact" class="text-size-3 font-500 hover:scale-102 active:scale-99 transition">
        <span>• </span>
        <span>contact me</span>
        <span class="i-ph-envelope-simple-open-duotone ml-1"></span>
      </ULink>
      </div>

        <div class="w-40 flex text-center justify-center my-2 mx-auto">
          <div class="w-full h-2">
          <svg viewBox="0 0 300 10" preserveAspectRatio="none">
            <path d="M 0 5 Q 15 0, 30 5 T 60 5 T 90 5 T 120 5 T 150 5 T 180 5 T 210 5 T 240 5 T 270 5 T 300 5"
              stroke="currentColor" fill="none" class="text-gray-300 dark:text-gray-700" stroke-width="1" />
          </svg>
        </div>
      </div>
    </header>

    <!-- Navigation Sections -->
    <nav class="flex-1 flex flex-col gap-2">
      <NavSection 
        v-for="item in navigation"
        :key="item.title"
        v-bind="item"
      />
    </nav>
  </div>
</template>

<script setup>
const fallbackData = { projects: 0, posts: 0, experiments: 0 }

// Fetch '/api/how-many-items' to get the number of items in the database
const { data } = await useFetch("/api/home/how-many-items")
const navigation = useNavigation(data.value ?? fallbackData)

const greeting = computed(() => {
  const hour = new Date().getHours()
  
  if (hour >= 5 && hour < 12) return 'Good morning'
  if (hour >= 12 && hour < 17) return 'Good afternoon'
  if (hour >= 17 && hour < 22) return 'Good evening'
  return 'Good night'
})

const timeIcon = computed(() => {
  const hour = new Date().getHours()
  
  if (hour >= 5 && hour < 12) return 'i-ph-sun-horizon'
  if (hour >= 12 && hour < 17) return 'i-line-md:moon-to-sunny-outline-loop-transition'
  if (hour >= 17 && hour < 22) return 'i-ph:sun-horizon-bold'
  return 'i-line-md:moon-rising-twotone-loop'
})

</script>
