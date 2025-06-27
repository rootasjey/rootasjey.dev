<template>
  <UDialog v-model:open="isOpen"
    :showClose="false" 
    :_dialog-content="{
      class: 'p-0 top-[35%]',
    }"
  >
    <template #header>
      <UInput
        v-model="query"
        @input="onInput"
        leading="i-ph:magnifying-glass-bold"
        :loading="loading"
        trailing="i-ph-x-bold"
        @trailing="onClickSearchX"
        placeholder="Search posts, projects, experiments..."
        autofocus
        :una="{
          inputTrailing: 'pointer-events-auto cursor-pointer',
        }"
      />
    </template>

    <div class="min-h-[36vh] max-h-[80vh] overflow-y-auto" ref="resultsContainer">
      <div v-if="loading" class="search-loading">Searching...</div>
      <div v-if="error" class="search-error">{{ error }}</div>
      <div v-if="results.length > 0" class="search-results">
        <UButton v-for="(item, idx) in results" :key="item.type + '-' + item.id" 
          btn="soft-gray"
          class="search-result"
          :class="{ active: idx === activeIndex }"
          :to="getLinkTo(item)"
          @click="isOpen = false"
          @mouseover="activeIndex = idx"
          @focus="activeIndex = idx"
        >
          <UIcon :name="getIconName(item.type)" />
          <span class="search-type">{{ item.type }}</span>
          <strong>{{ item.name }}</strong>
          <p class="search-desc">{{ item.description }}</p>
          <div class="search-tags">
            <span v-for="tag in item.tags" :key="tag" class="search-tag">{{ tag }}</span>
          </div>
        </UButton>
      </div>

      <div v-if="isOpen && !query && !loading && !error" class="search-placeholder px-6 py-8 text-center">
        <div class="mb-4 text-gray-500">
          <UIcon name="search" class="text-3xl mb-2" />
          <div class="text-lg font-semibold">What are you looking for?</div>
          <div class="text-sm">Try searching for a topic, a subject, or tag.</div>
        </div>
        <div v-if="suggestions.length" class="flex flex-wrap justify-center gap-2 mt-4">
          <UButton
            v-for="suggestion in suggestions"
            :key="suggestion.text"
            btn="soft-gray"
            class="search-suggestion"
            @click="selectSuggestion(suggestion.text)"
          >
            <UIcon :name="suggestion.icon" class="mr-1" />
            {{ suggestion.text }}
          </UButton>
        </div>
      </div>
      <div v-if="results.length === 0 && query && !loading && !error" class="search-no-results">
        No results found.
      </div>
    </div>
  </UDialog>
</template>

<script setup lang="ts">
import type { SearchResult } from "~/types/search"

const query = ref("")
const { results, total, loading, error, search } = useSearch()

let debounceTimeout: ReturnType<typeof setTimeout> | null = null

interface Props {
  modelValue?: boolean
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false
})

const emit = defineEmits<Emits>()

const isOpen = computed({
  get: () => props.modelValue,
  set: (value: boolean) => emit('update:modelValue', value)
})

const activeIndex = ref(-1)
const resultsContainer = ref<HTMLElement | null>(null)

const focusInput = () => {
  // Focus the input when dialog opens
  nextTick(() => {
    const input = document.querySelector('input[autofocus]')
    if (input) (input as HTMLInputElement).focus()
  })
}

const suggestions = ref([
  { icon: 'i-ph-code', text: 'Tech stack' },
  { icon: 'i-ph-knife', text: 'Curious suicide & deaths' },
  { icon: 'i-ph-robot', text: 'AI' },
  { icon: 'i-ph-video', text: 'Video Montage' },
  { icon: 'i-ph-heart', text: 'Gatsby' },
])

const selectSuggestion = (suggestion: string) => {
  query.value = suggestion;
  search(query.value);
}

watch(isOpen, (open) => {
  if (open) {
    activeIndex.value = -1
    focusInput()
  }
})

watch(results, () => {
  activeIndex.value = results.value.length > 0 ? 0 : -1
})

const onInput = () => {
  if (debounceTimeout) clearTimeout(debounceTimeout)
  debounceTimeout = setTimeout(() => {
    search(query.value)
  }, 350)
}

const onClickSearchX = () => {
  if (query.value === "") {
    isOpen.value = false
    return
  }
  
  query.value = ""
  search(query.value)
}

const getLinkTo = (item: SearchResult) => {
  if (item.type === "post") {
    return `/posts/${item.slug}`
  } else if (item.type === "project") {
    return `/projects/${item.slug}`
  } else if (item.type === "experiment") {
    return `/experiments/${item.slug}`
  }

  return "/"
}

const getIconName = (type: string) => {
  if (type === 'post') return 'i-ph-article-ny-times'
  if (type === 'project') return 'i-ph-app-window'
  if (type === 'experiment') return 'i-ph-test-tube'
  return 'i-ph-question'
}

const onKeydown = (e: KeyboardEvent) => {
  if (!isOpen.value) return

  if (["ArrowDown", "ArrowUp", "Enter", "Escape"].includes(e.key)) {
    e.preventDefault()
  }

  if (e.key === "ArrowDown") {
    if (results.value.length === 0) return
    activeIndex.value = (activeIndex.value + 1) % results.value.length
    scrollActiveIntoView()
  } else if (e.key === "ArrowUp") {
    if (results.value.length === 0) return
    activeIndex.value = (activeIndex.value - 1 + results.value.length) % results.value.length
    scrollActiveIntoView()
  } else if (e.key === "Enter") {
    if (activeIndex.value >= 0 && results.value[activeIndex.value]) {
      const link = getLinkTo(results.value[activeIndex.value])
      navigateTo(link)
      isOpen.value = false
    }
  } else if (e.key === "Escape") {
    isOpen.value = false
  }
}

const scrollActiveIntoView = () => {
  nextTick(() => {
    const container = resultsContainer.value
    if (!container) return
    const activeEl = container.querySelector('.search-result.active')
    if (activeEl && activeEl instanceof HTMLElement) {
      activeEl.scrollIntoView({ block: 'nearest' })
    }
  })
}

onMounted(() => {
  window.addEventListener('keydown', onKeydown)
})
onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKeydown)
})
</script>

<style scoped>
.search-loading,
.search-error,
.search-no-results {
  margin: 1em;
}

.search-results {
  margin: 0.5em;
  display: flex;
  flex-direction: column;
  gap: 0.5em;
  
  .search-result {
    display: flex;
    justify-content: start;
    align-items: center;
    overflow-x: hidden;
    border-radius: 5px;
  transition: background 0.2s ease;

    .search-type {
      font-size: 0.8em;
      color: #888;
      margin-right: 0.5em;
      text-transform: uppercase;
    }

    .search-desc {
      color: #555;
      text-overflow: ellipsis;
      white-space: nowrap;
      overflow: hidden;
    }
  }

  .search-result.active {
    outline: 2px solid #a3bffa;
  }
}

.search-tags {
  display: flex;
  gap: 0.5em;
  
  .search-tag {
    display: inline-block;
    background: #f0f0f0;
    color: #333;
    border-radius: 3px;
    padding: 0.05em 0.5em;
    font-size: 0.85em;
  }
}
</style>