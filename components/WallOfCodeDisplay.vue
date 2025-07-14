<template>
  <div class="space-y-6">
    <!-- Metadata -->
    <div class="bg-white dark:bg-gray-800 rounded-lg p-6 shadow-sm border border-gray-200 dark:border-gray-700">
      <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div class="space-y-2">
          <div class="flex items-center gap-2">
            <UIcon name="i-ph-github-logo" class="text-gray-600 dark:text-gray-400" />
            <ULink
              :to="snippet.repositoryUrl"
              target="_blank"
              class="text-lg font-600 text-blue-600 dark:text-blue-400 hover:underline"
            >
              {{ snippet.projectName }}
            </ULink>
            <span class="px-2 py-1 text-xs bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-full">
              GitHub
            </span>
          </div>
          <div class="text-sm text-gray-600 dark:text-gray-400">
            <UIcon name="i-ph-file-code" class="mr-1" />
            <span class="font-500">{{ snippet.filePath }}</span>
          </div>
        </div>
        
        <div class="flex flex-wrap gap-4 text-sm text-gray-500 dark:text-gray-400">
          <div class="flex items-center gap-1">
            <UIcon name="i-ph-code" />
            <span>{{ snippet.language }}</span>
          </div>
          <div class="flex items-center gap-1">
            <UIcon name="i-ph-star" />
            <span>{{ formatNumber(snippet.starCount) }}</span>
          </div>
          <div class="flex items-center gap-1">
            <UIcon name="i-ph-clock" />
            <span>{{ formatDate(snippet.lastUpdated) }}</span>
          </div>
          <div v-if="snippet.commitHash" class="flex items-center gap-1">
            <UIcon name="i-ph-git-commit" />
            <span class="font-mono text-xs">{{ snippet.commitHash.substring(0, 7) }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Code Block with Shiki -->
    <div class="code-wall-container">
      <div v-if="highlightedCode" class="code-wall-block" v-html="highlightedCode"></div>
      <pre v-else class="code-wall-block-fallback"><code>{{ snippet.code }}</code></pre>
    </div>
  </div>
</template>

<script lang="ts" setup>
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

interface Props {
  snippet: CodeSnippet
}

const props = defineProps<Props>()

// Reactive highlighted code
const highlightedCode = ref<string>('')

// Language mapping for Shiki
const getShikiLanguage = (language: string): string => {
  const languageMap: Record<string, string> = {
    'JavaScript': 'javascript',
    'TypeScript': 'typescript',
    'Python': 'python',
    'Java': 'java',
    'Go': 'go',
    'Rust': 'rust',
    'C++': 'cpp',
    'C': 'c',
    'Ruby': 'ruby',
    'PHP': 'php',
    'Swift': 'swift',
    'Kotlin': 'kotlin',
    'Scala': 'scala',
    'C#': 'csharp',
    'Dart': 'dart',
    'Shell': 'bash',
    'JSON': 'json',
    'YAML': 'yaml',
    'XML': 'xml',
    'HTML': 'html',
    'CSS': 'css',
    'SQL': 'sql',
    'Unknown': 'text'
  }

  return languageMap[language] || 'javascript' // Default to JavaScript for better highlighting
}

// Access color mode for theme switching
const { $colorMode } = useNuxtApp()

// Highlight code using Shiki with theme support
const highlightCode = async () => {
  try {
    // Select theme based on current color mode
    const lightTheme = 'github-light'
    const darkTheme = 'github-dark'
    const currentTheme = $colorMode.value === 'dark' ? darkTheme : lightTheme

    const shikiLang = getShikiLanguage(props.snippet.language)

    // Use direct Shiki import for reliable highlighting
    const { createHighlighter } = await import('shiki')

    // Try with the specific language first
    try {
      const highlighter = await createHighlighter({
        themes: [lightTheme, darkTheme],
        langs: [shikiLang]
      })

      highlightedCode.value = highlighter.codeToHtml(props.snippet.code, {
        lang: shikiLang,
        theme: currentTheme,
      })
    } catch (langError) {
      console.warn(`Language ${shikiLang} not supported, falling back to JavaScript:`, langError)

      // Fallback to JavaScript highlighting
      const highlighter = await createHighlighter({
        themes: [lightTheme, darkTheme],
        langs: ['javascript']
      })

      highlightedCode.value = highlighter.codeToHtml(props.snippet.code, {
        lang: 'javascript',
        theme: currentTheme,
      })
    }
  } catch (error) {
    console.error('Error highlighting code with Shiki:', error)
    // Final fallback to plain text
    highlightedCode.value = ''
  }
}

// Utility functions
const formatNumber = (num: number): string => {
  if (num >= 1000000) {
    return (num / 1000000).toFixed(1) + 'M'
  } else if (num >= 1000) {
    return (num / 1000).toFixed(1) + 'K'
  }
  return num.toString()
}

const formatDate = (dateString: string): string => {
  const date = new Date(dateString)
  const now = new Date()
  const diffTime = Math.abs(now.getTime() - date.getTime())
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays === 1) return '1 day ago'
  if (diffDays < 30) return `${diffDays} days ago`
  if (diffDays < 365) return `${Math.floor(diffDays / 30)} months ago`
  return `${Math.floor(diffDays / 365)} years ago`
}

// Watch for snippet changes and re-highlight
watch(() => props.snippet, () => {
  highlightCode()
}, { immediate: true })

// Watch for color mode changes and re-highlight
watch(() => $colorMode.value, () => {
  highlightCode()
})

// Highlight on mount
onMounted(() => {
  highlightCode()
})
</script>

<style scoped>
.code-wall-container {
  position: relative;
  border-radius: 0.75rem;
  overflow: hidden;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

.code-wall-block {
  /* Light theme styles */
  background: #ffffff;
  color: #24292f;
  font-family: 'JetBrainsMono', 'Monaco', 'Consolas', monospace;
  font-size: 0.875rem;
  line-height: 1.6;
  margin: 0;
  padding: 2rem;
  overflow-x: auto;
  position: relative;
  min-height: 400px;
  max-height: 600px;
  overflow-y: auto;
  border: 1px solid #d1d9e0;
}

/* Dark theme styles for code block */
.dark .code-wall-block {
  background: #0d1117;
  color: #f0f6fc;
  border: 1px solid #30363d;
}

.code-wall-block-fallback {
  /* Light theme fallback */
  background: #f6f8fa;
  border: 1px solid #d1d9e0;
  color: #24292f;
  font-family: 'JetBrainsMono', 'Monaco', 'Consolas', monospace;
  font-size: 0.875rem;
  line-height: 1.6;
  margin: 0;
  padding: 2rem;
  overflow-x: auto;
  position: relative;
  min-height: 400px;
  max-height: 600px;
  overflow-y: auto;
}

/* Dark theme fallback */
.dark .code-wall-block-fallback {
  background: #1F2937;
  border: 1px solid #374151;
  color: #F9FAFB;
}

.code-wall-block:before,
.code-wall-block-fallback:before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  /* Light theme gradient */
  background: linear-gradient(90deg, #5046E5, #8B5CF6, #EC4899);
  border-radius: 0.75rem 0.75rem 0 0;
}

/* Dark theme gradient */
.dark .code-wall-block:before,
.dark .code-wall-block-fallback:before {
  background: linear-gradient(90deg, #8B5CF6, #A855F7, #F472B6);
}

/* Shiki theme overrides */
.code-wall-block :deep(pre) {
  background: transparent !important;
  margin: 0 !important;
  padding: 0 !important;
  overflow: visible !important;
}

.code-wall-block :deep(code) {
  background: transparent !important;
  font-family: inherit !important;
  font-size: inherit !important;
  line-height: inherit !important;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .code-wall-block,
  .code-wall-block-fallback {
    padding: 1rem;
    font-size: 0.8rem;
    min-height: 300px;
    max-height: 500px;
  }
}

/* Custom scrollbar for code block */
.code-wall-block::-webkit-scrollbar,
.code-wall-block-fallback::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

.code-wall-block::-webkit-scrollbar-track,
.code-wall-block-fallback::-webkit-scrollbar-track {
  /* Light theme scrollbar track */
  background: #f1f3f4;
  border-radius: 4px;
}

.code-wall-block::-webkit-scrollbar-thumb,
.code-wall-block-fallback::-webkit-scrollbar-thumb {
  /* Light theme scrollbar thumb */
  background: #c1c7cd;
  border-radius: 4px;
}

.code-wall-block::-webkit-scrollbar-thumb:hover,
.code-wall-block-fallback::-webkit-scrollbar-thumb:hover {
  background: #a8b1ba;
}

/* Dark theme scrollbar */
.dark .code-wall-block::-webkit-scrollbar-track,
.dark .code-wall-block-fallback::-webkit-scrollbar-track {
  background: #21262d;
}

.dark .code-wall-block::-webkit-scrollbar-thumb,
.dark .code-wall-block-fallback::-webkit-scrollbar-thumb {
  background: #484f58;
}

.dark .code-wall-block::-webkit-scrollbar-thumb:hover,
.dark .code-wall-block-fallback::-webkit-scrollbar-thumb:hover {
  background: #6e7681;
}

.code-wall-block::-webkit-scrollbar-track,
.code-wall-block-fallback::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

.code-wall-block::-webkit-scrollbar-thumb,
.code-wall-block-fallback::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}

.code-wall-block::-webkit-scrollbar-thumb:hover,
.code-wall-block-fallback::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.5);
}
</style>
