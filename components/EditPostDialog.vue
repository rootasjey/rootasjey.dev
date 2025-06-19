<template>
  <UDialog v-model:open="isOpen" title="Edit Post" description="Update post information">
    <div class="grid gap-4 py-4">
      <div class="grid gap-2">
        <!-- Name Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-name" class="text-right">
            Name *
          </ULabel>
          <div class="col-span-2">
            <UInput 
              id="edit-name" 
              ref="nameInputRef"
              v-model="form.name" 
              :class="{ 'border-red-500': errors.name }"
              placeholder="Enter post name"
              @blur="validateName"
              @input="markAsChanged"
              aria-describedby="edit-name-error"
            />
            <p v-if="errors.name" id="edit-name-error" class="text-red-500 text-sm mt-1" role="alert">
              {{ errors.name }}
            </p>
          </div>
        </div>

        <!-- Description Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-description" class="text-right">
            Description
          </ULabel>
          <UInput 
            id="edit-description" 
            v-model="form.description" 
            placeholder="Enter post description"
            @input="markAsChanged"
            :una="{ inputWrapper: 'col-span-2' }"
          />
        </div>

        <!-- Tags Field -->
        <div class="grid grid-cols-3 items-start gap-4 mb-4">
          <ULabel for="edit-tags" class="text-right pt-2">
            Tags *
          </ULabel>
          <div class="col-span-2">
            <TagInput
              id="edit-tags"
              v-model="form.tags"
              placeholder="Select or add tags..."
              @update:model-value="markAsChanged"
            />
            <p v-if="errors.tags" id="edit-tags-error" class="text-red-500 text-sm mt-1" role="alert">
              {{ errors.tags }}
            </p>
          </div>
        </div>

        <!-- Visibility Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-visibility" class="text-right">
            Visibility
          </ULabel>
          <USelect 
            id="edit-visibility" 
            v-model="form.visibility" 
            item-key="label"
            value-key="label"
            :items="visibilityOptions" 
            placeholder="Select visibility"
            @change="markAsChanged"
          />
        </div>
      </div>
    </div>

    <template #footer>
      <div class="flex gap-2 justify-end">
        <UButton 
          @click="handleCancel" 
          btn="text-gray" 
          label="Cancel"
          :disabled="isLoading"
        />
        <UButton 
          @click="handleUpdatePost" 
          :loading="isLoading"
          :disabled="!isFormValid || !hasChanges || isLoading"
          btn="soft-gray"
          :label="hasChanges ? 'Update post' : 'No changes'"
        />
      </div>
    </template>
  </UDialog>
</template>

<script setup lang="ts">
import type { PostType } from '~/types/post'

interface Props {
  modelValue?: boolean
  post?: PostType | null
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'update-post', data: { 
    id: number
    name: string
    description: string
    tags: string[]
    visibility: string
  }): void
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  post: null
})

const emit = defineEmits<Emits>()

// Use tags composable
const { getPrimaryTag, getSecondaryTags, incrementPostTagsUsage, decrementPostTagsUsage } = useTags()

// Refs for focus management
const nameInputRef = ref<HTMLInputElement>()

// Form state
const form = reactive({
  name: '',
  description: '',
  tags: [] as string[],
  visibility: { label: 'Private', value: 'private' },
})

// Original form state for change detection
const originalForm = reactive({
  name: '',
  description: '',
  tags: [] as string[],
  visibility: { label: 'Private', value: 'private' },
})

// Validation state
const errors = reactive({
  name: '',
  tags: ''
})

// UI state
const isLoading = ref(false)
const hasChanges = ref(false)

// Visibility options
const visibilityOptions = [
  { label: 'Private', value: 'private' },
  { label: 'Public', value: 'public' },
  { label: 'Draft', value: 'draft' }
]

// Computed
const isOpen = computed({
  get: () => props.modelValue,
  set: (value: boolean) => emit('update:modelValue', value)
})

const isFormValid = computed(() => {
  return form.name.trim().length > 0 && 
         form.tags.length > 0 && 
         !errors.name && 
         !errors.tags
})

// Methods
const validateName = () => {
  errors.name = ''
  if (!form.name.trim()) {
    errors.name = 'Post name is required'
  } else if (form.name.trim().length < 3) {
    errors.name = 'Post name must be at least 3 characters'
  }
}

const validateTags = () => {
  errors.tags = ''
  if (!form.tags || form.tags.length === 0) {
    errors.tags = 'At least one tag is required'
  }
}

const markAsChanged = () => {
  // Validate tags when they change
  validateTags()
  
  // Check if current form differs from original
  hasChanges.value = (
    form.name !== originalForm.name ||
    form.description !== originalForm.description ||
    JSON.stringify(form.tags) !== JSON.stringify(originalForm.tags) ||
    form.visibility !== originalForm.visibility
  )
}

const populateForm = (post: PostType) => {
  form.name = post.name || ''
  form.description = post.description || ''
  form.tags = Array.isArray(post.tags) ? [...post.tags] : []
  form.visibility = convertVisibility(post.visibility)
  
  // Store original values for change detection
  originalForm.name = form.name
  originalForm.description = form.description
  originalForm.tags = [...form.tags]
  originalForm.visibility = form.visibility
  
  // Reset change detection
  hasChanges.value = false
  errors.name = ''
  errors.tags = ''
}

const convertVisibility = (visibility: string) => {
  return visibilityOptions.find(option => option.value === visibility.toLowerCase()) || { label: 'Private', value: 'private' }
}

const resetForm = () => {
  form.name = ''
  form.description = ''
  form.tags = []
  form.visibility = { label: 'Private', value: 'private' }
  originalForm.name = ''
  originalForm.description = ''
  originalForm.tags = []
  originalForm.visibility = { label: 'Private', value: 'private' }
  errors.name = ''
  errors.tags = ''
  hasChanges.value = false
}

const handleCancel = () => {
  if (hasChanges.value) {
    // Could add a confirmation dialog here for unsaved changes
    const confirmDiscard = confirm('You have unsaved changes. Are you sure you want to close?')
    if (!confirmDiscard) return
  }
  
  // Reset form to original values
  if (props.post) {
    populateForm(props.post)
  }
  
  isOpen.value = false
}

const handleUpdatePost = async () => {
  // Validate before submitting
  validateName()
  validateTags()
  
  if (!isFormValid.value) {
    // Focus the first invalid field
    if (errors.name) {
      nameInputRef.value?.focus()
    }
    return
  }

  if (!props.post) {
    console.error('No post to update')
    return
  }

  isLoading.value = true

  try {
    // Update tag usage statistics
    // Decrement usage for old tags
    if (originalForm.tags.length > 0) {
      decrementPostTagsUsage(originalForm.tags)
    }
    
    // Increment usage for new tags
    if (form.tags.length > 0) {
      incrementPostTagsUsage(form.tags)
    }

    const updateData = {
      id: props.post.id,
      name: form.name.trim(),
      description: form.description.trim(),
      tags: form.tags,
      visibility: form.visibility.value,
    }

    emit('update-post', updateData)
    
    // Update original form state to reflect saved changes
    originalForm.name = form.name
    originalForm.description = form.description
    originalForm.tags = [...form.tags]
    originalForm.visibility = form.visibility
    hasChanges.value = false
    
    isOpen.value = false
    
  } catch (error) {
    console.error('Failed to update post:', error)
    // Revert tag usage changes on error
    if (originalForm.tags.length > 0) {
      incrementPostTagsUsage(originalForm.tags)
    }
    if (form.tags.length > 0) {
      decrementPostTagsUsage(form.tags)
    }
    // You could add a toast notification here for error feedback
  } finally {
    isLoading.value = false
  }
}

// Watchers
watch(() => props.post, (newPost) => {
  if (newPost) {
    populateForm(newPost)
  } else {
    resetForm()
  }
}, { immediate: true })

// Focus management
watch(isOpen, (newValue) => {
  if (newValue && props.post) {
    // Focus first input when dialog opens
    nextTick(() => {
      nameInputRef.value?.focus()
    })
  }
})

// Keyboard shortcuts
onMounted(() => {
  const handleKeydown = (event: KeyboardEvent) => {
    if (!isOpen.value) return
    
    // Ctrl/Cmd + Enter to submit
    if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
      event.preventDefault()
      handleUpdatePost()
    }
    
    // Ctrl/Cmd + S to save
    if ((event.ctrlKey || event.metaKey) && event.key === 's') {
      event.preventDefault()
      handleUpdatePost()
    }
  }
  
  document.addEventListener('keydown', handleKeydown)
  
  onUnmounted(() => {
    document.removeEventListener('keydown', handleKeydown)
  })
})
</script>