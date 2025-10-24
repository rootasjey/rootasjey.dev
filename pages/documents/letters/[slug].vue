<template>
  <div class="cv-viewer">
    <!-- Tiny fixed progress bar -->
    <UProgress
      v-if="isGenerating"
      :indeterminate="true"
      size="sm"
      color="primary"
      class="no-print fixed left-0 right-0 top-0 z-50"
    />

    <!-- Floating actions -->
    <div v-if="letter" class="no-print flex justify-end gap-3 mb-4 fixed bottom-8 right-8">
      <UButton :disabled="isGenerating" btn="solid-black" @click="downloadPdf" class="shadow-md">
        <span v-if="!isGenerating" class="i-ph-file-pdf-duotone mr-2"></span>
        <span v-else class="i-ph-spinner-gap-duotone mr-2 animate-spin"></span>
        <span>{{ isGenerating ? 'Generating…' : 'Download PDF' }}</span>
      </UButton>
    </div>

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
import { nextTick, ref } from 'vue'

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

// Download via server-side PDF; fall back to window.print
const isGenerating = ref(false)
const downloadPdf = async () => {
  isGenerating.value = true
  const titleBase = letter.value?.title || slug || 'cover-letter'
  try {
    const res = await fetch(`/api/documents/letters/${encodeURIComponent(slug)}/pdf`)
    if (!res.ok) throw new Error(`PDF generation failed with status ${res.status}`)

    const blob = await res.blob()
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `${titleBase}.pdf`
    document.body.appendChild(a)
    a.click()
    a.remove()
    URL.revokeObjectURL(url)
  } catch (e) {
    const oldTitle = document.title
    document.title = `${titleBase}`
    await nextTick()
    window.print()
    setTimeout(() => { document.title = oldTitle }, 500)
  } finally {
    isGenerating.value = false
  }
}
</script>
