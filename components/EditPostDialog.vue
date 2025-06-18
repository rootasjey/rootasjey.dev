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

        <!-- Category Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-category" class="text-right">
            Category
          </ULabel>
          <div class="col-span-2 flex flex-row gap-2">
            <!-- Category Select (shown when not adding new category) -->
            <USelect 
              v-if="!isAddingCategory"
              id="edit-category" 
              v-model="form.category" 
              :items="categories" 
              placeholder="Select a category"
              class="flex-1"
              @change="markAsChanged"
            />
            
            <!-- New Category Input (shown when adding new category) -->
            <UInput
              v-else
              id="edit-new-category-input"
              ref="newCategoryInputRef"
              v-model="newCategoryName"
              placeholder="Enter new category name"
              class="flex-1"
              @keyup.enter="handleAddCategory"
              @keyup.escape="cancelAddCategory"
            />

            <!-- Add Category Button -->
            <UTooltip>
              <template #default>
                <UButton 
                  v-if="!isAddingCategory"
                  btn="outline" 
                  icon 
                  label="i-icon-park-outline:add-print"
                  @click="startAddingCategory"
                  aria-label="Add new category"
                />
                <!-- Save/Cancel buttons when adding category -->
                <div v-else class="flex gap-1">
                  <UButton
                    btn="outline"
                    icon
                    label="i-lucide-check"
                    size="xs"
                    @click="handleAddCategory"
                    :disabled="!newCategoryName.trim()"
                    aria-label="Save new category"
                  />
                  <UButton
                    btn="outline"
                    icon
                    label="i-lucide-x"
                    size="xs"
                    @click="cancelAddCategory"
                    aria-label="Cancel adding category"
                  />
                </div>
              </template>
              <template #content>
                <div class="bg-light dark:bg-dark text-dark dark:text-white text-sm px-3 py-1 rounded-md border border-dashed border-[#3D3BF3]">
                  {{ isAddingCategory ? 'Save new category' : 'Add a new category' }}
                </div>
              </template>
            </UTooltip>
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
          btn="outline" 
          label="Cancel"
          :disabled="isLoading"
        />
        <UButton 
          @click="handleUpdatePost" 
          :loading="isLoading"
          :disabled="!isFormValid || !hasChanges || isLoading"
          btn="solid"
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
  categories?: string[]
  post?: PostType | null
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'update-post', data: { 
    id: number
    name: string
    description: string
    category: string
    visibility: string
  }): void
  (e: 'add-category', category: string): void
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  categories: () => [],
  post: null
})

const emit = defineEmits<Emits>()

// Refs for focus management
const nameInputRef = ref<HTMLInputElement>()
const newCategoryInputRef = ref<HTMLInputElement>()

// Form state
const form = reactive({
  name: '',
  description: '',
  category: '',
  visibility: { label: 'Private', value: 'private' },
})

// Original form state for change detection
const originalForm = reactive({
  name: '',
  description: '',
  category: '',
  visibility: { label: 'Private', value: 'private' },
})

// Validation state
const errors = reactive({
  name: ''
})

// UI state
const isLoading = ref(false)
const isAddingCategory = ref(false)
const newCategoryName = ref('')
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
  return form.name.trim().length > 0 && !errors.name
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

const markAsChanged = () => {
  // Check if current form differs from original
  hasChanges.value = (
    form.name !== originalForm.name ||
    form.description !== originalForm.description ||
    form.category !== originalForm.category ||
    form.visibility !== originalForm.visibility
  )
}

const populateForm = (post: PostType) => {
  form.name = post.name || ''
  form.description = post.description || ''
  form.category = post.category || ''
  form.visibility = convertVisibility(post.visibility)
  
  // Store original values for change detection
  originalForm.name = form.name
  originalForm.description = form.description
  originalForm.category = form.category
  originalForm.visibility = form.visibility
  
  // Reset change detection
  hasChanges.value = false
  errors.name = ''
}

const convertVisibility = (visibility: string) => {
  return visibilityOptions.find(option => option.value === visibility.toLowerCase()) || { label: 'Private', value: 'private' }
}

const resetForm = () => {
  form.name = ''
  form.description = ''
  form.category = ''
  form.visibility = {  label: 'Private', value: 'private' }
  originalForm.name = ''
  originalForm.description = ''
  originalForm.category = ''
  originalForm.visibility = { label: 'Private', value: 'private' }
  errors.name = ''
  hasChanges.value = false
  isAddingCategory.value = false
  newCategoryName.value = ''
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
    const updateData = {
      id: props.post.id,
      name: form.name.trim(),
      description: form.description.trim(),
      category: form.category,
      visibility: form.visibility.value,
    }

    emit('update-post', updateData)
    
    // Update original form state to reflect saved changes
    originalForm.name = form.name
    originalForm.description = form.description
    originalForm.category = form.category
    originalForm.visibility = form.visibility
    hasChanges.value = false
    
    isOpen.value = false
    
  } catch (error) {
    console.error('Failed to update post:', error)
    // You could add a toast notification here for error feedback
  } finally {
    isLoading.value = false
  }
}

const startAddingCategory = () => {
  isAddingCategory.value = true
  nextTick(() => {
    newCategoryInputRef.value?.focus()
  })
}

const handleAddCategory = () => {
  const categoryName = newCategoryName.value.trim()
  if (!categoryName) return

  // Emit the new category to parent
  emit('add-category', categoryName)
  
  // Set the new category as selected
  form.category = categoryName
  markAsChanged()
  
  // Reset add category state
  cancelAddCategory()
}

const cancelAddCategory = () => {
  isAddingCategory.value = false
  newCategoryName.value = ''
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