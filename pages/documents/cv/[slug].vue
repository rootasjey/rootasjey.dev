<template>
  <div class="cv-viewer">
    <div v-if="cv" class="no-print flex justify-end gap-3 mb-4 fixed bottom-8 right-8">
      <UButton btn="soft" @click="downloadPdf" class="shadow-md">
        <span class="i-ph-file-pdf-duotone mr-2"></span>
        <span>Download PDF</span>
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
import { nextTick } from 'vue'

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

// Trigger browser print-to-PDF with a nice default filename
const downloadPdf = async () => {
  const oldTitle = document.title
  const titleBase = cv.value?.name || cv.value?.title || slug || 'resume'
  document.title = `${titleBase}-resume`
  await nextTick()
  window.print()
  // Restore original title shortly after print dialog opens
  setTimeout(() => { document.title = oldTitle }, 500)
}
</script>
