<template>
  <div class="tag-input">
    <div class="form-group">
      <UInput
        v-model="inputValue"
        type="text"
        :placeholder="placeholder"
        @keydown="handleKeydown"
      />
      <p class="form-help">
        Press <UKbd label="Enter" /> or <UKbd label="," /> to add tags. The first tag will be your primary tag.
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
}

interface Emits {
  (e: 'update:modelValue', value: ApiTag[]): void
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Enter tags... (Press Enter or comma to add)'
})

const emit = defineEmits<Emits>()

// Reactive state
const inputValue = ref('')
const primaryTag = ref<ApiTag | null>(null)
const additionalTags = ref<ApiTag[]>([])

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

// Methods
const handleKeydown = (event: KeyboardEvent) => {
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
</style>