<template>
  <UDialog v-model:open="isOpen"
    :showClose="false" 
    :_dialog-content="{
      class: 'p-0',
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
        placeholder="Search posts and projects..."
        autofocus
        :una="{
          inputTrailing: 'pointer-events-auto cursor-pointer',
        }"
      />
    </template>

    <div>
      <div v-if="loading" class="search-loading">Searching...</div>
      <div v-if="error" class="search-error">{{ error }}</div>
      <div v-if="results.length > 0" class="search-results">
        <div v-for="item in results" :key="item.type + '-' + item.id" class="search-result">
          <span class="search-type">{{ item.type }}</span>
          <NuxtLink :to="`/${item.type === 'post' ? 'reflexions' : 'projects'}/${item.slug}`">
            <strong>{{ item.name }}</strong>
          </NuxtLink>
          <p class="search-desc">{{ item.description }}</p>
          <div class="search-tags">
            <span v-for="tag in item.tags" :key="tag" class="search-tag">{{ tag }}</span>
          </div>
        </div>
      </div>
      <div v-else-if="query && !loading && !error" class="search-no-results">
        No results found.
      </div>
    </div>
  </UDialog>
</template>

<script setup lang="ts">
import { ref } from "vue"

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

function onInput() {
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
</script>

<style scoped>
.search-loading,
.search-error,
.search-no-results {
  margin: 1em;
}

.search-results {
  margin: 1em;
  
  .search-result:not(:last-child) {
    border-bottom: 1px dashed;
    padding: 0.5em 0;
  }
}

.search-type {
  font-size: 0.8em;
  color: #888;
  margin-right: 0.5em;
  text-transform: uppercase;
}

.search-desc {
  margin: 0.2em 0 0.5em 0;
  color: #555;
}

.search-tags {
  margin-top: 0.2em;
}

.search-tag {
  display: inline-block;
  background: #f0f0f0;
  color: #333;
  border-radius: 3px;
  padding: 0.1em 0.5em;
  margin-right: 0.3em;
  font-size: 0.85em;
}
</style>