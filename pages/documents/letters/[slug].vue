<template>
  <div>
    <LoadingOrErrorState 
      v-if="pending || error" 
      :loading="pending" 
      :error="error?.message || null" 
    />
    
    <LetterTemplate v-else-if="letter" :letter="letter" />
  </div>
</template>

<script setup lang="ts">
import type { CoverLetter } from '~/types/document'
import LetterTemplate from '~/components/document/LetterTemplate.vue'

const route = useRoute()
const slug = route.params.slug as string

// Fetch letter data
const { data: letter, pending, error } = await useFetch<CoverLetter>(`/api/documents/letters/${slug}`)

// Set page metadata
useHead({
  title: () => letter.value ? `${letter.value.title} - Cover Letter` : 'Cover Letter',
  meta: [
    {
      name: 'description',
      content: () => {
        if (!letter.value) return 'Professional cover letter'
        return `Cover letter for ${letter.value.position || 'position'}${letter.value.companyName ? ' at ' + letter.value.companyName : ''}`
      },
    },
  ],
})

// Optional: Redirect if not found
watch(error, (newError) => {
  if (newError && newError.statusCode === 404) {
    navigateTo('/documents')
  }
})
</script>
