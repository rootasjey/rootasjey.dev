<template>
  <footer class="text-size-3">
    <div class="footer-buttons flex gap-4 flex-wrap">
      <UButton btn="~" @click="scrollToTop"
        class="footer-button p-0 w-auto h-auto block items-center gap-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
        <span class="i-ph-arrow-up-duotone text-size-4 -mt-1 mr-2"></span>
        <span class="font-500 text-size-3 relative -top-0.5">Back to top</span>
      </UButton>
      <ULink to="/" class="footer-button flex items-center text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
        <span class="i-ph-house-simple-duotone text-size-4 mr-2"></span>
        <span class="font-500">Back to home</span>
      </ULink>
      <ULink v-if="route.path !== '/reflexions'" to="/reflexions" class="footer-button flex items-center text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
        <span class="i-ph-brain text-size-4 mr-2"></span>
        <span class="font-500">Reflexions</span>
      </ULink>
      <ULink v-if="route.path !== '/projects'" to="/projects" class="footer-button flex items-center text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
        <span class="i-ph-app-window text-size-4 mr-2"></span>
        <span class="font-500">Projects</span>
      </ULink>
      <ULink v-if="route.path !== '/contact'" to="/contact" class="footer-button flex items-center text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
        <span class="i-ph-envelope-open text-size-4 mr-2"></span>
        <span class="font-500">Contact</span>
      </ULink>
      <ULink v-if="route.path !== '/about'" to="/about" class="footer-button flex items-center text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
        <span class="i-ph-question text-size-4 mr-2"></span>
        <span class="font-500">About</span>
      </ULink>

      <slot name="links" />
    </div>

    <div class="flex gap-2 mt-2">
      <p class="font-600 text-gray-500 dark:text-gray-400 mr-5">
        A personal space to share passions, projects, and knowledge.
      </p>
    </div>

    <div class="flex gap-2 font-600 text-gray-500 dark:text-gray-400 ">
      <p>Socials : </p>
      <ULink to="https://github.com/jeremcorpinot" target="_blank">
        <span>GitHub</span>
      </ULink>
      <span>•</span>
      <ULink to="https://www.linkedin.com/in/jeremie-corpinot/" target="_blank">
        <span class="ml-1">LinkedIn</span>
      </ULink>
      <span>•</span>
      <ULink to="https://www.instagram.com/rootasjey" target="_blank">
        <span class="ml-1">Instagram</span>
      </ULink>
    </div>

    <p class="text-gray-500 dark:text-gray-400 mt-2">
      © <span class="font-600">Jérémie Corpinot</span>
      <span class="mx-1">&middot;</span>
      <span class="font-600">{{ new Date().getFullYear() }}</span>
    </p>
  </footer>
</template>

<script lang="ts" setup>
const route = useRoute()

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
