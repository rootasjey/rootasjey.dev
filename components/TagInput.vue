<template>
  <div class="tag-input">
    <div class="form-group">
      <div class="input-container">
        <UInput
          ref="inputRef"
          v-model="inputValue"
          type="text"
          :placeholder="placeholder"
          @keydown="handleKeydown"
          @input="handleInput"
          @focus="handleFocus"
          @blur="handleBlur"
        />

        <!-- Autocomplete Dropdown -->
        <div
          v-if="enableAutocomplete && showSuggestions && filteredSuggestions.length > 0"
          class="suggestions-dropdown"
        >
          <div
            v-for="(suggestion, index) in filteredSuggestions"
            :key="suggestion.id"
            class="suggestion-item"
            :class="{ 'suggestion-item-active': index === selectedSuggestionIndex }"
            @mousedown.prevent="selectSuggestion(suggestion)"
            @mouseenter="selectedSuggestionIndex = index"
          >
            <span class="suggestion-name">{{ suggestion.name }}</span>
            <span v-if="suggestion.category" class="suggestion-category">{{ suggestion.category }}</span>
          </div>
        </div>
      </div>

      <p class="form-help">
        Press <UKbd label="Enter" /> or <UKbd label="," /> to add tags. The first tag will be your primary tag.
        <span v-if="enableAutocomplete"> Use arrow keys to navigate suggestions.</span>
      </p>
    </div>

    <!-- Preview -->
    <div v-if="allCurrentTags.length > 0" class="tags-container">
      <TagDisplay :tags="allCurrentTags" display-mode="all" @tag:remove="removeTag" @tag:click="setPrimaryTag" />
    </div>
  </div>
</template>

<script setup lang="ts">
import type { ApiTag } from '~/types/tag'

interface Props {
  modelValue: ApiTag[]
  placeholder?: string
  enableAutocomplete?: boolean
}

interface Emits {
  (e: 'update:modelValue', value: ApiTag[]): void
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Enter tags... (Press Enter or comma to add)',
  enableAutocomplete: false
})

const emit = defineEmits<Emits>()

// Tags store integration (only when autocomplete is enabled)
const tagStore = props.enableAutocomplete ? useTagStore() : null

// Reactive state
const inputValue = ref('')
const primaryTag = ref<ApiTag | null>(null)
const additionalTags = ref<ApiTag[]>([])

// Autocomplete state
const inputRef = ref<HTMLInputElement>()
const showSuggestions = ref(false)
const selectedSuggestionIndex = ref(-1)

// For generating unique negative ids for new tags
let tempTagId = -1

// Initialize from modelValue
watchImmediate(() => props.modelValue, (newTags) => {
  if (newTags && newTags.length > 0) {
    // Find primary tag by category, fallback to first tag
    const primary = newTags.find(tag => tag.category === 'primary') || newTags[0]
    primaryTag.value = primary
    additionalTags.value = newTags.filter(tag => tag.id !== primary.id)
  } else {
    primaryTag.value = null
    additionalTags.value = []
  }
})

// Computed
const allCurrentTags = computed(() => {
  const tags: ApiTag[] = []
  if (primaryTag.value) tags.push(primaryTag.value)
  tags.push(...additionalTags.value)
  return tags
})

// Autocomplete computed properties
const filteredSuggestions = computed(() => {
  if (!props.enableAutocomplete || !tagStore || !inputValue.value.trim()) {
    return []
  }

  const query = inputValue.value.trim().toLowerCase()
  const currentTagNames = allCurrentTags.value.map(tag => tag.name.toLowerCase())

  return tagStore.allTags
    .filter(tag => {
      // Filter out already selected tags
      if (currentTagNames.includes(tag.name.toLowerCase())) {
        return false
      }
      // Filter by name match
      return tag.name.toLowerCase().includes(query)
    })
    .slice(0, 8) // Limit to 8 suggestions for performance and UX
})

// Methods
const handleKeydown = (event: KeyboardEvent) => {
  // Handle autocomplete navigation
  if (props.enableAutocomplete && showSuggestions.value && filteredSuggestions.value.length > 0) {
    if (event.key === 'ArrowDown') {
      event.preventDefault()
      selectedSuggestionIndex.value = Math.min(
        selectedSuggestionIndex.value + 1,
        filteredSuggestions.value.length - 1
      )
      return
    } else if (event.key === 'ArrowUp') {
      event.preventDefault()
      selectedSuggestionIndex.value = Math.max(selectedSuggestionIndex.value - 1, 0)
      return
    } else if (event.key === 'Enter' && selectedSuggestionIndex.value >= 0) {
      event.preventDefault()
      selectSuggestion(filteredSuggestions.value[selectedSuggestionIndex.value])
      return
    } else if (event.key === 'Escape') {
      event.preventDefault()
      hideSuggestions()
      return
    }
  }

  // Original key handling
  if (event.key === 'Enter' || event.key === ',') {
    event.preventDefault()
    addTagFromInput()
  } else if (event.key === 'Backspace' && inputValue.value === '') {
    removeLastTag()
  }
}

const addTagFromInput = () => {
  const tagValue = inputValue.value.trim().replace(/,$/, '')
  if (!tagValue) return
  // Check if tag already exists (by name)
  if (allCurrentTags.value.some(t => t.name.toLowerCase() === tagValue.toLowerCase())) {
    inputValue.value = ''
    return
  }

  // Create a local ApiTag object with a unique negative id and required fields
  const now = new Date().toISOString()
  const tag: ApiTag = {
    id: tempTagId--,
    name: tagValue,
    category: '',
    created_at: now,
    updated_at: now
  }

  // Add as primary tag if none exists, otherwise as additional tag
  if (!primaryTag.value) {
    tag.category = 'primary'
    primaryTag.value = tag
  } else {
    tag.category = 'secondary'
    additionalTags.value.push(tag)
  }

  inputValue.value = ''
  emitUpdate()
}

const removeTag = (tagToRemove: ApiTag) => {
  if (primaryTag.value && tagToRemove.name === primaryTag.value.name) {
    removePrimaryTag()
  } else {
    removeAdditionalTag(tagToRemove)
  }
  emitUpdate()
}

const removePrimaryTag = () => {
  if (additionalTags.value.length > 0) {
    primaryTag.value = additionalTags.value.shift() || null
  } else {
    primaryTag.value = null
  }
  emitUpdate()
}

const removeAdditionalTag = (tag: ApiTag) => {
  const index = additionalTags.value.findIndex(t => t.name === tag.name)
  if (index > -1) {
    additionalTags.value.splice(index, 1)
    emitUpdate()
  }
}

const removeLastTag = () => {
  if (additionalTags.value.length > 0) {
    additionalTags.value.pop()
  } else if (primaryTag.value) {
    primaryTag.value = null
  }
  emitUpdate()
}

const setPrimaryTag = (tag: ApiTag) => {
  if (primaryTag.value && primaryTag.value.name === tag.name) return
  // Remove from additional tags if it exists
  const idx = additionalTags.value.findIndex(t => t.name === tag.name)
  if (idx > -1) {
    additionalTags.value.splice(idx, 1)
  }
  if (primaryTag.value) {
    additionalTags.value.unshift(primaryTag.value)
  }
  primaryTag.value = tag
  emitUpdate()
}

const emitUpdate = () => {
  emit('update:modelValue', allCurrentTags.value)
}

// Autocomplete methods
const handleInput = (event?: Event) => {
  if (props.enableAutocomplete) {
    selectedSuggestionIndex.value = -1
    // Use the event target value to get the current input value
    const currentValue = event?.target ? (event.target as HTMLInputElement).value : inputValue.value
    showSuggestions.value = currentValue.trim().length > 0
  }
}

const handleFocus = () => {
  if (props.enableAutocomplete && inputValue.value.trim().length > 0) {
    showSuggestions.value = true
  }
}

const handleBlur = () => {
  // Delay hiding suggestions to allow for click selection
  setTimeout(() => {
    hideSuggestions()
  }, 150)
}

const selectSuggestion = (suggestion: ApiTag) => {
  // Create a copy of the existing tag with the appropriate category
  const tagCopy: ApiTag = {
    ...suggestion,
    category: !primaryTag.value ? 'primary' : 'secondary'
  }

  if (!primaryTag.value) {
    primaryTag.value = tagCopy
  } else {
    additionalTags.value.push(tagCopy)
  }

  inputValue.value = ''
  hideSuggestions()
  emitUpdate()
}

const hideSuggestions = () => {
  showSuggestions.value = false
  selectedSuggestionIndex.value = -1
}

// Initialize tags store if autocomplete is enabled
if (props.enableAutocomplete && tagStore) {
  tagStore.initialize()
}
</script>

<style scoped>
.tag-input {
  display: flex;
  flex-direction: column;
  gap: 1rem; /* 16px */
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem; /* 8px */
}

.input-container {
  position: relative;
}

.form-label {
  display: block;
  font-size: 0.875rem; /* 14px */
  font-weight: 500;
  color: #374151; /* text-gray-700 */
}

/* Dark mode for form-label */
@media (prefers-color-scheme: dark) {
  .form-label {
    color: #d1d5db; /* text-gray-300 */
  }
}

.form-help {
  font-size: 0.75rem; /* 12px */
  color: #6b7280; /* text-gray-500 */
}

.current-tags {
  display: flex;
  flex-direction: column;
  gap: 0.5rem; /* 8px */
}

.tags-container {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem; /* 8px */
}

.tag-badge {
  display: flex;
  align-items: center;
  gap: 0.25rem; /* 4px */
}

.primary-tag {
  order: -1; /* Ensure primary tag appears first */
}

.primary-indicator {
  font-size: 0.75rem;
  color: currentColor;
}

.tag-preview {
  padding: 0.75rem; /* 12px */
  background-color: #f9fafb; /* bg-gray-50 */
  border-radius: 0.5rem; /* 8px */
  display: flex;
  flex-direction: column;
  gap: 0.5rem; /* 8px */
}

/* Dark mode for tag-preview */
@media (prefers-color-scheme: dark) {
  .tag-preview {
    background-color: #1f2937; /* bg-gray-800 */
  }
}

/* Autocomplete dropdown styles */
.suggestions-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  z-index: 50;
  background-color: white;
  border: 1px solid #d1d5db; /* border-gray-300 */
  border-radius: 0.5rem; /* 8px */
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  max-height: 200px;
  overflow-y: auto;
  margin-top: 0.25rem; /* 4px */
}

/* Dark mode for suggestions dropdown */
@media (prefers-color-scheme: dark) {
  .suggestions-dropdown {
    background-color: #1f2937; /* bg-gray-800 */
    border-color: #374151; /* border-gray-600 */
  }
}

.suggestion-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.75rem; /* 12px */
  cursor: pointer;
  border-bottom: 1px solid #f3f4f6; /* border-gray-100 */
  transition: background-color 0.15s ease-in-out;
}

.suggestion-item:last-child {
  border-bottom: none;
}

.suggestion-item:hover,
.suggestion-item-active {
  background-color: #f9fafb; /* bg-gray-50 */
}

/* Dark mode for suggestion items */
@media (prefers-color-scheme: dark) {
  .suggestion-item {
    border-bottom-color: #374151; /* border-gray-600 */
  }

  .suggestion-item:hover,
  .suggestion-item-active {
    background-color: #374151; /* bg-gray-600 */
  }
}

.suggestion-name {
  font-weight: 500;
  color: #111827; /* text-gray-900 */
}

.suggestion-category {
  font-size: 0.75rem; /* 12px */
  color: #6b7280; /* text-gray-500 */
  background-color: #f3f4f6; /* bg-gray-100 */
  padding: 0.125rem 0.5rem; /* 2px 8px */
  border-radius: 0.25rem; /* 4px */
}

/* Dark mode for suggestion content */
@media (prefers-color-scheme: dark) {
  .suggestion-name {
    color: #f9fafb; /* text-gray-50 */
  }

  .suggestion-category {
    color: #d1d5db; /* text-gray-300 */
    background-color: #4b5563; /* bg-gray-600 */
  }
}
</style>