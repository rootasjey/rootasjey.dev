<template>
  <!-- pages/index.vue -->
  <div class="w-full flex flex-col items-center min-h-screen">
    <!-- Hero Section -->
    <section class="w-[820px] mt-24 md:mt-42 mb-8 text-center p-2 md:p-8 ">
      <h1 class="font-body text-6xl font-600 mb-6 text-gray-800 dark:text-gray-200">
        ...at the intersection of code, art, and the motivation to build something meaningful.
      </h1>
      <h4 class="text-size-5 font-300 mb-4 text-gray-800 dark:text-gray-200">
        Drawing inspiration from the world around us, I'm on a journey to create meaningful experiences through code.
        I'm passionate about building fun things, and I'm always looking for new ways to learn and grow.
      </h4>
      <h5 class="text-size-5 font-300 mb-4 text-gray-800 dark:text-gray-200">
        I like deconstructive thinking, reflections and thought experiments. 
        I prefer collaboration over hierarchy, sharing over locking, incitation over coercion. 
        Life is like a movie which we take on course and won't see the end, and I'll try to share as much love as I can.
      </h5>
      <h5 class="text-size-5 font-300 mb-4 text-gray-800 dark:text-gray-200">
        {{ greeting }}, it's {{ formattedTime }}.
      </h5>
    </section>

    <PostsHome :posts="posts" />

    <ProjectsHome 
      :projects="projects" 
      :projectsLoading="projectStatus === 'pending'" 
      :projectsError="projectStatus === 'error'" 
    />

    <ExperimentsHome
      :experiments="experiments"
      :experimentLoading="false"
      :experimentError="experimentStatus === 'error'"
    />

    <HomeFooter class="mt-36" />
  </div>
</template>

<script setup>
useHead({
  title: "root",
  meta: [
    {
      name: 'description',
      content: 'A curated collection of creative endeavors, experiments, and meaningful builds.',
    },
  ],
})

const posts = usePosts()
const { data: experiments, status: experimentStatus } = await useFetch('/api/experiments')
const { data: projectData, status: projectStatus } = await useFetch('/api/projects', {
  query: {
    visibility: 'public',
    limit: 6
  }
})

const projects = projectData.value.projects

const currentTime = ref(new Date())
const formattedTime = computed(() => {
  return formatDate(currentTime.value)
})

const greeting = computed(() => {
  const hour = new Date().getHours()
  
  if (hour >= 5 && hour < 12) return 'Good morning'
  if (hour >= 12 && hour < 17) return 'Good afternoon'
  if (hour >= 17 && hour < 22) return 'Good evening'
  return 'Good night'
})

// Helper function to format dates
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
  })
}

</script>
