<template>
  <div class="tag-input">
    <div class="form-group">
      <UInput
        v-model="inputValue"
        type="text"
        :placeholder="placeholder"
        @keydown="handleKeydown"
        @blur="handleBlur"
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
interface Props {
  modelValue: string[]
  placeholder?: string
}

interface Emits {
  (e: 'update:modelValue', value: string[]): void
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Enter tags... (Press Enter or comma to add)'
})

const emit = defineEmits<Emits>()

const { allTags, addTag } = useTags()

// Reactive state
const inputValue = ref('')
const primaryTag = ref<string>('')
const additionalTags = ref<string[]>([])

// Initialize from modelValue
watchImmediate(() => props.modelValue, (newTags) => {
  if (newTags && newTags.length > 0) {
    primaryTag.value = newTags[0]
    additionalTags.value = newTags.slice(1)
  } else {
    primaryTag.value = ''
    additionalTags.value = []
  }
})

// Computed
const allCurrentTags = computed(() => {
  const tags = []
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
    // Remove last tag when backspacing on empty input
    removeLastTag()
  }
}

const handleBlur = () => {
  // Add tag on blur if there's content
  if (inputValue.value.trim()) {
    addTagFromInput()
  }
}

const addTagFromInput = () => {
  const tagValue = inputValue.value.trim().replace(/,$/, '') // Remove trailing comma
  
  if (!tagValue) return
  
  // Check if tag already exists
  if (allCurrentTags.value.includes(tagValue)) {
    inputValue.value = ''
    return
  }
  
  // Add as primary tag if none exists, otherwise as additional tag
  if (!primaryTag.value) {
    primaryTag.value = tagValue
  } else {
    additionalTags.value.push(tagValue)
  }
  
  // Add to global tags if it's new
  if (!allTags.value.includes(tagValue)) {
    addTag(tagValue)
  }
  
  inputValue.value = ''
  emitUpdate()
}

const removeTag = (tagToRemove: string) => {
  if (tagToRemove === primaryTag.value) {
    removePrimaryTag()
  } else {
    removeAdditionalTag(tagToRemove)
  }
  emitUpdate()
}

const removePrimaryTag = () => {
  // Move first additional tag to primary, or clear primary
  if (additionalTags.value.length > 0) {
    primaryTag.value = additionalTags.value.shift() || ''
  } else {
    primaryTag.value = ''
  }
  emitUpdate()
}

const removeAdditionalTag = (tag: string) => {
  const index = additionalTags.value.indexOf(tag)
  if (index > -1) {
    additionalTags.value.splice(index, 1)
    emitUpdate()
  }
}

const removeLastTag = () => {
  if (additionalTags.value.length > 0) {
    additionalTags.value.pop()
  } else if (primaryTag.value) {
    primaryTag.value = ''
  }
  emitUpdate()
}

const setPrimaryTag = (tag: string) => {
  if (primaryTag.value === tag) return

  // Remove from additional tags if it exists
  if (additionalTags.value.includes(tag)) {
    removeAdditionalTag(tag)
  }

  additionalTags.value.push(primaryTag.value)

  // Set as primary tag
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