<template>
  <UDialog v-model:open="isOpen" title="Edit Post" description="Update post information">
    <div class="grid gap-4 py-4">
      <div class="grid gap-2">
        <!-- Name Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-name" class="text-right">
            Name 
            <UIcon name="i-ph-star-four" class="inline-block ml-1" 
              :class="{ 'text-pink-600': errors.name, 'text-lime-600': !errors.name }"
              title="Post name is required and should be descriptive."/>
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
        
        <!-- Slug Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-slug" class="text-right">
            Slug 
            <UIcon name="i-ph-star-four" class="inline-block ml-1" 
              :class="{ 'text-pink-600': errors.slug, 'text-lime-600': !errors.slug }"
              title="Slug is used in the URL. It should be unique and descriptive."/>
          </ULabel>
          <UInput 
            id="edit-slug" 
            ref="slugInputRef"
            v-model="form.slug" 
            :class="{ 'border-red-500': errors.slug }"
            placeholder="Enter post slug"
            @input="markAsChanged"
            :una="{ inputWrapper: 'col-span-2' }"
            aria-describedby="edit-slug-error"
          />
          <p v-if="errors.slug" id="edit-slug-error" class="text-red-500 text-sm mt-1" role="alert">
            {{ errors.slug }}
          </p>
        </div>

        <!-- Tags Field -->
        <div class="grid grid-cols-3 items-start gap-4 mb-4">
          <ULabel for="edit-tags" class="text-right pt-2">
            Tags 
            <UIcon name="i-ph-star-four" class="inline-block ml-1" 
              :class="{ 'text-pink-600': errors.tags, 'text-lime-600': !errors.tags }"
              title="You must categorize your post with at least one tag."/>
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

        <!-- Status Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-status" class="text-right">
            Status
          </ULabel>
          <USelect 
            id="edit-status" 
            v-model="form.status" 
            item-key="label"
            value-key="label"
            :items="visibilityOptions" 
            placeholder="Select status"
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
import type { Post, UpdatePostPayload } from '~/types/post'
import type { ApiTag } from '~/types/tag'

interface Props {
  modelValue?: boolean
  post?: Post | null
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'update-post', post: UpdatePostPayload): void
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  post: null
})

const emit = defineEmits<Emits>()

// Refs for focus management
const nameInputRef = ref<HTMLInputElement>()
const slugInputRef = ref<HTMLInputElement>()

// Form state
const form = reactive({
  name: '',
  description: '',
  slug: '',
  status: { label: 'Draft', value: 'draft' },
  tags: [] as ApiTag[],
})

// Original form state for change detection
const originalForm = reactive({
  name: '',
  description: '',
  slug: '',
  status: { label: 'Draft', value: 'draft' },
  tags: [] as ApiTag[],
})

// Validation state
const errors = reactive({
  name: '',
  slug: '',
  tags: '',
})

// UI state
const isLoading = ref(false)
const hasChanges = ref(false)

// Status options
const visibilityOptions = [
  { label: 'Draft', value: 'draft' },
  { label: 'Published', value: 'published' },
  { label: 'Archived', value: 'archived' }
]

// Computed
const isOpen = computed({
  get: () => props.modelValue,
  set: (value: boolean) => emit('update:modelValue', value)
})

const isFormValid = computed(() => {
  return form.name.trim().length > 0 && 
         form.tags.length > 0 && 
         form.slug &&
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

const validateSlug = () => {
  if (!form.slug.trim()) {
    errors.slug = 'Slug is required'
  } else if (form.slug.trim().length < 3) {
    errors.slug = 'Slug must be at least 3 characters'
  } else {
    errors.slug = ''
  }
}

const markAsChanged = () => {
  validateTags()
  validateSlug()
  
  // Check if current form differs from original
  hasChanges.value = (
    form.name !== originalForm.name ||
    form.description !== originalForm.description ||
    form.slug !== originalForm.slug ||
    form.status !== originalForm.status ||
    JSON.stringify(form.tags) !== JSON.stringify(originalForm.tags)
  )
}

const populateForm = (post: Post) => {
  form.name = post.name || ''
  form.description = post.description || ''
  form.slug = post.slug || ''
  form.status = convertVisibility(post.status)
  form.tags = Array.isArray(post.tags) ? [...post.tags] : []
  
  // Store original values for change detection
  originalForm.name = form.name
  originalForm.description = form.description
  originalForm.slug = form.slug
  originalForm.status = form.status
  originalForm.tags = [...form.tags]
  
  // Reset change detection
  hasChanges.value = false
  errors.name = ''
  errors.slug = ''
  errors.tags = ''
}

const convertVisibility = (visibility: string) => {
  return visibilityOptions.find(option => option.value === visibility) || { label: 'Draft', value: 'draft' }
}

const resetForm = () => {
  form.name = ''
  form.description = ''
  form.tags = []
  form.status = { label: 'Draft', value: 'draft' }
  originalForm.name = ''
  originalForm.description = ''
  originalForm.slug = ''
  originalForm.status = { label: 'Draft', value: 'draft' }
  originalForm.tags = []

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
  validateSlug()
  validateTags()
  
  if (!isFormValid.value) {
    // Focus the first invalid field
    if (errors.name) {
      nameInputRef.value?.focus()
    }
    if (errors.slug) {
      slugInputRef.value?.focus()
    }
    return
  }

  if (!props.post) {
    console.error('No post to update')
    return
  }

  isLoading.value = true

  try {
    const updateData = {
      id: props.post.id,
      name: form.name.trim(),
      description: form.description.trim(),
      slug: originalForm.slug.trim() !== form.slug.trim() ? form.slug.trim() : undefined,
      status: form.status.value as 'draft' | 'published' | 'archived',
      tags: form.tags.map(tag => ({
        name: tag.name,
        category: tag.category ?? '',
      })),
    }

    emit('update-post', updateData)
    
    // Update original form state to reflect saved changes
    originalForm.name = form.name
    originalForm.description = form.description
    originalForm.slug = form.slug
    originalForm.status = form.status
    originalForm.tags = [...form.tags]
    hasChanges.value = false
    
    isOpen.value = false
    
  } catch (error) {
    console.error('Failed to update post:', error)
    // You could add a toast notification here for error feedback
    useToast().toast({
      title: 'Error',
      description: 'Failed to update post. Please try again.',
      toast: 'error',
      duration: 3000,
    })
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