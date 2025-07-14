<template>
  <div class="w-full flex flex-col items-center min-h-screen">
    <!-- Hero Section -->
    <section class="w-full max-w-4xl mt-24 md:mt-32 mb-16 text-center px-4">
      <h1 class="font-body text-4xl md:text-5xl font-600 mb-4 text-gray-800 dark:text-gray-200">
        Wall of Code
      </h1>
      <h4 class="text-size-5 font-300 mb-8 text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
        Discover beautiful code snippets from open-source projects around the world. 
        Each refresh reveals new algorithms, utilities, and creative solutions from the global developer community.
      </h4>
    </section>

    <!-- Action Buttons and Filters -->
    <section class="w-full max-w-4xl mb-8 px-4">
      <div class="flex flex-col gap-4">
        <!-- Main Actions -->
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <UButton
            @click="fetchNewSnippet"
            :loading="isLoading"
            :disabled="isLoading"
            size="xs"
            class="btn-glowing"
          >
            <UIcon name="i-ph-shuffle" class="mr-2" />
            {{ isLoading ? 'Loading...' : 'Discover New Code' }}
          </UButton>

          <UButton
            v-if="currentSnippet"
            :to="currentSnippet.repositoryUrl"
            target="_blank"
            variant="outline"
            size="xs"
          >
            <UIcon name="i-ph-github-logo" class="mr-2" />
            View Repository
          </UButton>

          <UButton
            v-if="currentSnippet"
            @click="copyToClipboard"
            variant="outline"
            size="xs"
            :disabled="copyLoading"
          >
            <UIcon :name="copySuccess ? 'i-ph-check' : 'i-ph-copy'" class="mr-2" />
            {{ copySuccess ? 'Copied!' : 'Copy Code' }}
          </UButton>
        </div>

        <!-- Language Filter -->
        <div class="flex flex-wrap gap-2 justify-center">
          <UBadge
            v-for="lang in popularLanguages"
            :key="lang"
            @click="filterByLanguage(lang)"
            :badge="selectedLanguage === lang ? 'solid' : 'ghost'"
            class="cursor-pointer rounded-full"
          >
            {{ lang }}
          </UBadge>
          <UBadge
            @click="clearLanguageFilter"
            :variant="selectedLanguage === null ? 'solid' : 'ghost'"
            class="cusor-pointer"
          >
            All Languages
          </UBadge>
        </div>
      </div>
    </section>

    <!-- Code Display Section -->
    <section class="w-full max-w-6xl mb-16 px-4">
      <!-- Loading State -->
      <div v-if="isLoading && !currentSnippet" class="text-center py-24">
        <div class="mb-8 opacity-50">
          <UIcon name="i-ph-code" class="text-6xl text-gray-300 dark:text-gray-600" />
        </div>
        <h3 class="text-2xl font-600 text-gray-700 dark:text-gray-300 mb-4">
          Fetching code snippet...
        </h3>
        <p class="text-size-4 font-300 text-gray-500 dark:text-gray-400">
          Discovering beautiful code from the open-source community
        </p>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="text-center py-24">
        <div class="mb-8 opacity-50">
          <UIcon name="i-ph-warning-circle" class="text-6xl text-red-400" />
        </div>
        <h3 class="text-2xl font-600 text-red-600 dark:text-red-400 mb-4">
          Failed to load code snippet
        </h3>
        <p class="text-size-4 font-300 text-gray-500 dark:text-gray-400 mb-6">
          {{ error }}
        </p>
        <UButton @click="fetchNewSnippet" variant="outline">
          <UIcon name="i-ph-arrow-clockwise" class="mr-2" />
          Try Again
        </UButton>
      </div>

      <!-- Code Snippet Display -->
      <WallOfCodeDisplay v-if="currentSnippet" :snippet="currentSnippet" />

      <!-- Empty State -->
      <div v-else class="text-center py-24">
        <div class="mb-8 opacity-50">
          <UIcon name="i-ph-code" class="text-6xl text-gray-300 dark:text-gray-600" />
        </div>
        <h3 class="text-2xl font-600 text-gray-700 dark:text-gray-300 mb-4">
          Ready to explore code
        </h3>
        <p class="text-size-4 font-300 text-gray-500 dark:text-gray-400 mb-6">
          Click "Discover New Code" to start exploring beautiful code snippets from open-source projects
        </p>
      </div>
    </section>

    <!-- Discovery Story Section -->
    <section class="w-full max-w-4xl mb-16 px-4">
      <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-8">
        <h2 class="text-2xl font-600 text-gray-800 dark:text-gray-200 mb-6">
          <UIcon name="i-ph-lightbulb" class="mr-2" />
          The Discovery Story
        </h2>
        <div class="prose prose-gray dark:prose-invert max-w-none">
          <p class="text-gray-600 dark:text-gray-400 leading-relaxed mb-4">
            Code is poetry in motion. Every function, every algorithm, every elegant solution tells a story 
            of human creativity and problem-solving. The Wall of Code celebrates this artistry by showcasing 
            real code from open-source projects around the world.
          </p>
          <p class="text-gray-600 dark:text-gray-400 leading-relaxed mb-4">
            From simple utility functions to complex algorithms, each snippet represents hours of thought, 
            iteration, and refinement. By exploring these code fragments, we gain insight into different 
            programming styles, learn new techniques, and appreciate the diverse approaches developers take 
            to solve similar problems.
          </p>
          <p class="text-gray-600 dark:text-gray-400 leading-relaxed">
            This experiment connects us to the global developer community, reminding us that behind every 
            line of code is a human being sharing their knowledge and creativity with the world.
          </p>
        </div>
      </div>
    </section>

    <!-- Visual Patterns Section -->
    <section class="w-full max-w-4xl mb-16 px-4">
      <div class="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-8">
        <h2 class="text-2xl font-600 text-gray-800 dark:text-gray-200 mb-6">
          <UIcon name="i-ph-palette" class="mr-2" />
          Visual Patterns
        </h2>
        <div class="grid md:grid-cols-2 gap-6">
          <div>
            <h3 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-3">Typography & Readability</h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">
              The code display uses JetBrains Mono, a monospace font designed specifically for developers. 
              Proper line spacing and syntax highlighting enhance readability and comprehension.
            </p>
          </div>
          <div>
            <h3 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-3">Contextual Information</h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">
              Each snippet includes rich metadata: repository information, file paths, star counts, and 
              last update times, providing context about the code's origin and popularity.
            </p>
          </div>
          <div>
            <h3 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-3">Responsive Design</h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">
              The layout adapts seamlessly across devices, ensuring code remains readable on mobile 
              while taking advantage of larger screens for better code visualization.
            </p>
          </div>
          <div>
            <h3 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-3">Interactive Discovery</h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">
              Simple, prominent action buttons encourage exploration, while loading states and error 
              handling provide smooth user experience during API interactions.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Further Reading Section -->
    <section class="w-full max-w-4xl mb-24 px-4">
      <div class="bg-purple-50 dark:bg-purple-900/20 rounded-lg p-8">
        <h2 class="text-2xl font-600 text-gray-800 dark:text-gray-200 mb-6">
          <UIcon name="i-ph-book-open" class="mr-2" />
          Further Reading
        </h2>
        <div class="space-y-4">
          <div>
            <h3 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-2">Open Source Philosophy</h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed mb-2">
              Explore the principles and impact of open-source software development on global innovation.
            </p>
            <ULink 
              to="https://opensource.org/osd" 
              target="_blank" 
              class="text-purple-600 dark:text-purple-400 text-sm hover:underline"
            >
              The Open Source Definition →
            </ULink>
          </div>
          <div>
            <h3 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-2">Code as Literature</h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed mb-2">
              Discover how code can be viewed as a form of creative expression and communication.
            </p>
            <ULink 
              to="https://www.literateprogramming.com/" 
              target="_blank" 
              class="text-purple-600 dark:text-purple-400 text-sm hover:underline"
            >
              Literate Programming →
            </ULink>
          </div>
          <div>
            <h3 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-2">GitHub API Documentation</h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm leading-relaxed mb-2">
              Learn about the GitHub API that powers this experiment's code discovery functionality.
            </p>
            <ULink 
              to="https://docs.github.com/en/rest" 
              target="_blank" 
              class="text-purple-600 dark:text-purple-400 text-sm hover:underline"
            >
              GitHub REST API →
            </ULink>
          </div>
        </div>
      </div>
    </section>

    <Footer class="mt-24 mb-36" />
  </div>
</template>

<script lang="ts" setup>
// Types
interface CodeSnippet {
  code: string
  projectName: string
  filePath: string
  repositoryUrl: string
  language: string
  starCount: number
  lastUpdated: string
  commitHash?: string
}

// Meta
useHead({
  title: "Wall of Code • experiments",
  meta: [
    {
      name: 'description',
      content: "Discover beautiful code snippets from open-source projects around the world. Each refresh reveals new algorithms, utilities, and creative solutions from the global developer community.",
    },
  ],
})

// State
const currentSnippet = ref<CodeSnippet | null>(null)
const isLoading = ref(false)
const error = ref<string | null>(null)
const selectedLanguage = ref<string | null>(null)
const copyLoading = ref(false)
const copySuccess = ref(false)

// Popular languages for filtering
const popularLanguages = [
  'JavaScript', 'TypeScript', 'Python', 'Java', 'Go',
  'Rust', 'C++', 'Ruby', 'PHP', 'Swift'
]

// Methods
const fetchNewSnippet = async (language?: string) => {
  isLoading.value = true
  error.value = null

  try {
    const queryParams = language ? `?language=${encodeURIComponent(language)}` : ''
    const response = await $fetch<{ success: boolean; snippet?: CodeSnippet; error?: string }>(`/api/experiments/wall-of-code/snippet${queryParams}`)

    if (response.success && response.snippet) {
      currentSnippet.value = response.snippet
    } else {
      error.value = response.error || 'Failed to fetch code snippet'
    }
  } catch (err: any) {
    error.value = err?.message || 'Network error occurred'
    console.error('Error fetching snippet:', err)
  } finally {
    isLoading.value = false
  }
}

const filterByLanguage = (language: string) => {
  selectedLanguage.value = language
  fetchNewSnippet(language)
}

const clearLanguageFilter = () => {
  selectedLanguage.value = null
  fetchNewSnippet()
}

const copyToClipboard = async () => {
  if (!currentSnippet.value) return

  copyLoading.value = true
  try {
    await navigator.clipboard.writeText(currentSnippet.value.code)
    copySuccess.value = true
    setTimeout(() => {
      copySuccess.value = false
    }, 2000)
  } catch (err) {
    console.error('Failed to copy code:', err)
  } finally {
    copyLoading.value = false
  }
}

// Load initial snippet on mount
onMounted(() => {
  fetchNewSnippet()
})
</script>
