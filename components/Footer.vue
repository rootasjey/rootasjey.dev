<template>
    <!-- Footer -->
    <footer class="mt-16 text-size-3">
      <div class="footer-buttons flex gap-4">
        <ULink to="/" class="footer-button flex items-center gap-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
          <span class="i-ph-arrow-arc-left-duotone text-size-4 mr-2"></span>
          <span class="font-500">Back to home</span>
        </ULink>
        <UButton btn="~" @click="scrollToTop"
          class="footer-button p-0 w-auto h-auto block items-center gap-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
          <span class="i-ph-arrow-up-duotone text-size-3 -mt-1 mr-2"></span>
          <span class="font-500 text-size-3 relative -top-0.5">Back to top</span>
        </UButton>

        <slot name="links" />
      </div>

      <p class="text-gray-500 dark:text-gray-400 mt-2">
        © <span class="font-600">Jérémie Corpinot</span>
        <span class="mx-1">&middot;</span>
        <span class="font-600">{{ new Date().getFullYear() }}</span>
      </p>
    </footer>
</template>

<script lang="ts" setup>
const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}
</script>

<style scoped>
.footer-button, .footer-buttons > a {
  display: block;
  color: rgba(var(--una-gray-500), 1);
  transition: all;
  
  &:hover {
    color: rgba(var(--una-gray-600), 1);
    text-decoration: underline;
    text-underline-offset: 4px;
    transform: scale(1.01);
  }
  
  &:active {
    transform: scale(0.99);
  }
}

.dark .footer-button {
  color: rgba(var(--una-gray-400), 1);

  &:hover {
    color: rgba(var(--una-gray-300), 1);
  }
}
</style>
