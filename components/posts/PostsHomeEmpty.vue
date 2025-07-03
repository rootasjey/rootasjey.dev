<template>
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <!-- Sample Card 1 -->
    <UCard class="relative rounded-0 px-0 border b-gray-200/40 opacity-60 hover:opacity-100">
      <div class="py-4">
        <div class="flex flex-wrap gap-2 mb-2">
          <span class="text-xs font-medium text-gray-600 dark:text-gray-400">
            Tutorial
          </span>
        </div>
        <h3 class="font-body text-size-8 font-700 line-height-tight text-gray-800 dark:text-gray-200 line-clamp-6">
          Your First Amazing Post
        </h3>
        <p class="text-gray-600 dark:text-gray-400 text-sm mb-3 line-clamp-12">
          Share your thoughts, ideas, and stories with the world. This could be your first post about anything you're passionate about.
        </p>
      </div>
      <template #footer>
        <div class="p-0 absolute bottom-4">
          <div class="text-xs text-gray-500 dark:text-gray-500">
            <time>Today</time>
          </div>
          <span class="inline-block text-sm font-500 text-gray-400">
            Coming soon →
          </span>
        </div>
      </template>
    </UCard>

    <!-- Sample Card 2 -->
    <UCard class="relative rounded-0 px-0 border b-gray-200/40 opacity-60 hover:opacity-100">
      <div class="py-4">
        <div class="flex flex-wrap gap-2 mb-2">
          <span class="text-xs font-medium text-gray-600 dark:text-gray-400">
            Guide
          </span>
        </div>
        <h3 class="font-body text-size-8 font-700 line-height-tight text-gray-800 dark:text-gray-200 line-clamp-6">
          How to Get Started
        </h3>
        <p class="text-gray-600 dark:text-gray-400 text-sm mb-3 line-clamp-12">
          A comprehensive guide to help you begin your journey. Perfect for documenting your learning process or sharing knowledge.
        </p>
      </div>
      <template #footer>
        <div class="p-0 absolute bottom-4">
          <div class="text-xs text-gray-500 dark:text-gray-500">
            <time>Tomorrow</time>
          </div>
          <span class="inline-block text-sm font-500 text-gray-400">
            Coming soon →
          </span>
        </div>
      </template>
    </UCard>

    <!-- Call to Action Card -->
    <UCard class="relative rounded-0 px-0 border-2 border-dashed border-gray-300 dark:border-gray-600 hover:border-blue-400 dark:hover:border-blue-500 transition-colors">
      <div class="py-4">
        <div class="flex flex-wrap gap-2 mb-2">
          <span class="text-xs font-medium text-gray-600 dark:text-gray-400">
            Create
          </span>
        </div>
        <h3 class="font-body text-size-8 font-700 mb-2 line-height-tight text-gray-800 dark:text-gray-200">
          Create Your First Post
        </h3>
        <p class="text-gray-600 dark:text-gray-400 text-sm mb-3">
          This is it. Your first post. 
          And the beginning of your journey.
        </p>
        <p class="text-gray-600 dark:text-gray-400 text-sm mb-6">
          Write a memory about your latest project, a book you just finished, 
          a trip you took, or anything else that comes to mind.
        </p>
        <UButton
          to="/posts"
          btn="soft-blue"
          class="font-medium mb-6"
        >
          <UIcon name="i-ph-pencil-duotone" size="4" class="mr-2" />
          Write Your First Post
        </UButton>
      </div>
      <template #footer>
        <div class="p-0 absolute bottom-4">
          <div class="text-xs text-gray-500 dark:text-gray-500">
            <time>Now</time>
          </div>
          <ULink to="/posts" class="text-sm font-500 text-gray-400 hover:underline decoration-offset-6">
            Let's start →
          </ULink>
        </div>
      </template>
    </UCard>
  </div>
</template>
