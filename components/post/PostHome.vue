<template>
  <section class="w-[860px] mt-24 mb-12">
    <div class="mb-6">
      <ULink to="/posts" class="font-title text-4 font-600 text-gray-800 dark:text-gray-200">
        <span>Latest Reflexions</span>
        <UIcon name="i-ph-arrow-right-duotone" size="4" class="ml-2" />
      </ULink>
    </div>
    
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
  </section>
</template>

<script lang="ts" setup>

interface Props {
  posts: PostsComposable
}

defineProps<Props>();

</script>