<template>
  <div class="cv-viewer">
    <!-- Tiny fixed progress bar -->
    <UProgress
      v-if="generating"
      :indeterminate="true"
      size="sm"
      color="primary"
      class="no-print fixed left-0 right-0 top-0 z-50"
    />

    <div v-if="cv" class="no-print flex justify-end gap-3 mb-4 fixed bottom-8 right-8">
      <UButton :disabled="generating" btn="solid-black" @click="downloadPdf" class="shadow-md">
        <span v-if="!generating" class="i-ph-file-pdf-duotone mr-2"></span>
        <span v-else class="i-ph-spinner-gap-duotone mr-2 animate-spin"></span>
        <span>{{ generating ? 'Generating…' : 'Download PDF' }}</span>
      </UButton>
    </div>

    <LoadingOrErrorState 
      v-if="pending || error" 
      :loading="pending" 
      :error="error?.message || null" 
    />
    
    <CVTemplate v-else-if="cv" :cv="cv" />
  </div>
</template>

<script setup lang="ts">
import type { Resume } from '~/types/document'
import CVTemplate from '~/components/document/CVTemplate.vue'
import { nextTick, ref } from 'vue'

const route = useRoute()
const slug = route.params.slug as string

// Fetch resume data
const { data: cv, pending, error } = await useFetch<Resume>(`/api/documents/resumes/${slug}`)

// Set page metadata
useHead({
  title: () => cv.value ? `${cv.value.title} - Resume` : 'Resume',
  meta: [
    {
      name: 'description',
      content: () => cv.value?.subtitle || 'Professional resume',
    },
  ],
})

// Optional: Redirect if not found
watch(error, (newError) => {
  if (newError && newError.statusCode === 404) {
    navigateTo('/documents')
  }
})

// Prefer server-side PDF via headless browser; fall back to window.print
const downloadPdf = async () => {
  generating.value = true
  const titleBase = cv.value?.name || cv.value?.title || slug || 'resume'
  try {
    const res = await fetch(`/api/documents/resumes/${encodeURIComponent(slug)}/pdf`, {
      method: 'GET',
    })

    if (!res.ok) {
      throw new Error(`PDF generation failed with status ${res.status}`)
    }

    const blob = await res.blob()
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `${titleBase}-resume.pdf`
    document.body.appendChild(a)
    a.click()
    a.remove()
    URL.revokeObjectURL(url)
  } catch (e) {
    // Fallback to browser print if API is unavailable in the current environment
    const oldTitle = document.title
    document.title = `${titleBase}-resume`
    await nextTick()
    window.print()
    setTimeout(() => { document.title = oldTitle }, 500)
  } finally {
    generating.value = false
  }
}

const generating = ref(false)
</script>
