<template>
  <div class="letter-wrapper w-[600px] mt-24 rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <section class="mb-0">
      <h1 class="font-600 mb-4">{{ letter.title }}</h1>
      <h2 v-if="letter.companyName || letter.position" class="color-gray-600 font-500 dark:color-gray-500 mb-8">
        <template v-if="letter.position">Candidature au poste de {{ letter.position }}</template>
        <template v-if="letter.companyName"> – {{ letter.companyName }}</template>
      </h2>
      
      <p v-if="letter.greeting" class="mb-6">
        {{ letter.greeting }}
      </p>
      
      <!-- Letter body (HTML from TipTap) -->
      <div class="letter-body" v-html="letter.body" />
      
      <p v-if="letter.closing" class="mt-6">
        {{ letter.closing }}
      </p>
      
      <p v-if="letter.signature" class="mt-8 font-500">
        {{ letter.signature }}
      </p>
    </section>

    <!-- Footer -->
    <footer class="no-print mt-16 text-size-3">
      <div class="flex gap-4">
        <ULink to="/" class="footer-button">
          <span class="i-ph-house-simple text-size-3 mr-2"></span>
          <span class="font-500">Back to home</span>
        </ULink>
        <UButton btn="~"
          @click="scrollToTop"
          class="footer-button p-0 w-auto h-auto">
          <span class="i-ph-arrow-up-duotone text-size-3 mr-2 -mt-1"></span>
          <span class="font-500 text-size-3 relative -top-0.5">Back to top</span>
        </UButton>
        <ULink v-if="letter.resume" :to="`/documents/cv/${letter.resume.slug}`" class="footer-button">
          <span class="font-500">View linked CV: {{ letter.resume.title }}</span>
        </ULink>
      </div>

      <p class="text-gray-500 dark:text-gray-400">
        © <span class="font-600">{{ letter.signature || 'Jérémie Corpinot' }}</span>
        <span class="mx-1">&middot;</span>
        <span class="font-600">{{ new Date().getFullYear() }}</span>
      </p>
    </footer>
  </div>
</template>

<script setup lang="ts">
import type { CoverLetter } from '~/types/document'

const props = defineProps<{
  letter: CoverLetter
}>()

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}
</script>

<style scoped>
:deep(.letter-body) {
  /* Professional letter styling */
  font-size: 1rem;
  line-height: 1.8;
  color: rgba(var(--una-gray-700), 1);
  
  /* Style paragraphs */
  p {
    margin-bottom: 2rem;
  }
  
  /* Allow basic formatting */
  :deep(strong) {
    font-weight: 600;
    color: rgba(var(--una-gray-800), 1);
  }
  
  :deep(em) {
    font-style: italic;
  }
  
  :deep(u) {
    text-decoration: underline;
  }
  
  /* Lists */
  :deep(ul), :deep(ol) {
    margin-left: 1.5rem;
    margin-bottom: 1rem;
  }
  
  :deep(li) {
    margin-bottom: 0.5rem;
  }
  
  /* Links */
  :deep(a) {
    color: rgba(var(--una-primary-500), 1);
    text-decoration: underline;
    
    &:hover {
      color: rgba(var(--una-primary-600), 1);
    }
  }
  
  /* Remove elements that don't belong in letters */
  /* :deep(h1), :deep(h2), :deep(h3), 
  :deep(img), :deep(video), 
  :deep(pre), :deep(code) {
    display: none;
  } */
}

.dark .letter-body {
  color: rgba(var(--una-gray-300), 1);
  
  :deep(strong) {
    color: rgba(var(--una-gray-200), 1);
  }
}

.footer-button {
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
