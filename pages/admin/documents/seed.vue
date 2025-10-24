<template>
  <div class="seed-page min-h-screen p-8">
    <div class="max-w-3xl mx-auto">
      <h1 class="text-3xl font-600 text-gray-800 dark:text-gray-200 mb-6">
        Seed Documents Database
      </h1>

      <div class="bg-white dark:bg-gray-800 rounded-lg p-6 shadow-sm border border-gray-200 dark:border-gray-700 mb-6">
        <h2 class="text-xl font-500 text-gray-800 dark:text-gray-200 mb-4">
          About This Seed
        </h2>
        <p class="text-gray-600 dark:text-gray-400 mb-4">
          This will populate your database with:
        </p>
        <ul class="list-disc list-inside text-gray-600 dark:text-gray-400 space-y-2 mb-4">
          <li><strong>3 Resumes:</strong> General/Technical, Communication-focused, Community Manager</li>
          <li><strong>2 Cover Letters:</strong> Maurepas, Montigny-le-Bretonneux</li>
        </ul>
        <p class="text-sm text-gray-500 dark:text-gray-500">
          ⚠️ Note: This will only work once. If slugs already exist in the database, you'll get an error.
        </p>
      </div>

      <!-- Seed Button -->
      <div class="mb-6">
        <UButton
          :disabled="loading || success"
          :loading="loading"
          @click="handleSeed"
          size="lg"
          class="w-full"
        >
          <span v-if="!success">
            {{ loading ? 'Seeding Database...' : 'Seed Database' }}
          </span>
          <span v-else class="flex items-center gap-2">
            <span class="i-ph-check-circle"></span>
            Database Seeded Successfully
          </span>
        </UButton>
      </div>

      <!-- Success Message -->
      <div v-if="success" class="bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-lg p-4 mb-6">
        <div class="flex items-start gap-3">
          <span class="i-ph-check-circle text-green-600 dark:text-green-400 text-xl"></span>
          <div>
            <h3 class="font-500 text-green-800 dark:text-green-200 mb-2">
              Success!
            </h3>
            <p class="text-sm text-green-700 dark:text-green-300 mb-3">
              {{ result?.message }}
            </p>
            <div class="text-sm text-green-600 dark:text-green-400">
              <p>Created {{ result?.data?.resumes }} resumes</p>
              <p>Created {{ result?.data?.coverLetters }} cover letters</p>
            </div>
            <div class="mt-4 pt-4 border-t border-green-200 dark:border-green-800">
              <p class="text-sm text-green-700 dark:text-green-300 mb-2">Next steps:</p>
              <ULink to="/documents" class="inline-flex items-center gap-2 text-green-600 dark:text-green-400 hover:underline">
                <span class="i-ph-arrow-right"></span>
                View your documents
              </ULink>
            </div>
          </div>
        </div>
      </div>

      <!-- Error Message -->
      <div v-if="error" class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4 mb-6">
        <div class="flex items-start gap-3">
          <span class="i-ph-warning-circle text-red-600 dark:text-red-400 text-xl"></span>
          <div>
            <h3 class="font-500 text-red-800 dark:text-red-200 mb-2">
              Error
            </h3>
            <p class="text-sm text-red-700 dark:text-red-300">
              {{ error }}
            </p>
            <p class="text-xs text-red-600 dark:text-red-400 mt-2">
              Tip: This might mean the data already exists. Check your database or try deleting existing records first.
            </p>
          </div>
        </div>
      </div>

      <!-- Back Link -->
      <div class="mt-8">
        <ULink to="/admin" class="inline-flex items-center gap-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300">
          <span class="i-ph-arrow-left"></span>
          <span>Back to admin</span>
        </ULink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: ['admin'],
  title: 'Seed Documents',
})

const loading = ref(false)
const success = ref(false)
const error = ref<string | null>(null)
const result = ref<any>(null)

const handleSeed = async () => {
  loading.value = true
  error.value = null
  success.value = false
  result.value = null

  try {
    const response = await $fetch('/api/documents/seed', {
      method: 'POST',
    })
    
    result.value = response
    success.value = true
  } catch (e: any) {
    console.error('Seed error:', e)
    error.value = e.data?.message || e.message || 'Failed to seed database'
  } finally {
    loading.value = false
  }
}

useHead({
  title: 'Seed Documents Database',
})
</script>

<style scoped>
.seed-page {
  background-color: #F1F1F1;
}

.dark .seed-page {
  background-color: #111;
}
</style>
