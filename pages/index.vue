<template>
  <!-- pages/index.vue -->
  <div class="p-2 md:p-8 flex flex-col items-center min-h-screen">
    <!-- Hero Section -->
    <section class="w-[820px] mt-24 md:mt-42 mb-8 text-center">
      <h1 class="font-body text-6xl font-600 mb-6 text-gray-800 dark:text-gray-200">
        ...at the intersection of code, art, and the motivation to build something meaningful.
      </h1>
      <h4 class="text-size-5 font-300 mb-4 text-gray-800 dark:text-gray-200">
        Drawing inspiration from the world around us, I'm on a journey to create meaningful experiences through code.
        I'm passionate about building fun things, and I'm always looking for new ways to learn and grow.
      </h4>
      <h5 class="text-size-5 font-300 mb-4 text-gray-800 dark:text-gray-200">
        I like deconstructive thinking, self-reflexion and thought experiments. 
        I prefer collaboration over hierarchy, sharing over locking, incitation over coercion. 
        Life is like a movie which we take on course and won't see the end, and I'll try to share as much love as I can.
      </h5>
    </section>

    <!-- Latest Posts Grid -->
    <section class="w-[860px] mt-24 mb-12">
      <h2 class="font-title text-4 font-600 mb-6 text-gray-800 dark:text-gray-200">
        Latest Posts
      </h2>
      
      <div v-if="posts.isLoading.value" class="text-center py-8">
        <div class="text-gray-600 dark:text-gray-400">Loading posts...</div>
      </div>
      
      <div v-else-if="posts.error.value" class="text-center py-8">
        <div class="text-red-600 dark:text-red-400">Error loading posts</div>
      </div>
      
      <div v-else-if="posts.list.value.length > 0" 
           class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3">
        <PostCard v-for="post in posts.list.value.slice(2)" :key="post.id" :post="post" />
      </div>
      
      <div v-else class="text-center py-8">
        <div class="text-gray-600 dark:text-gray-400">No posts available</div>
      </div>
      
      <!-- View All Posts Link -->
      <div v-if="posts.data && posts.data.length > 6" class="text-center mt-8">
        <NuxtLink 
          to="/posts"
          class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-500 transition-colors"
        >
          View All Posts
        </NuxtLink>
      </div>
    </section>
  </div>
</template>

<script setup>

// Fetch '/api/how-many-items' to get the number of items in the database
const { data } = await useFetch("/api/home/how-many-items")
const posts = usePosts()
const navigation = useNavigation(data.value ?? fallbackData)
const fallbackData = { projects: 0, posts: 0, experiments: 0 }

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

// Helper function to format dates
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

</script>
