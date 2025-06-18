<template>
  <UDialog v-model:open="isOpen" title="Create Post" description="Add a new post with a description">
    <div class="grid gap-4 py-4">
      <div class="grid gap-2">
        <!-- Name Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="create-name" class="text-right">
            Name *
          </ULabel>
          <div class="col-span-2">
            <UInput 
              id="create-name" 
              ref="nameInputRef"
              v-model="form.name" 
              :class="{ 'border-red-500': errors.name }"
              placeholder="Enter post name"
              @blur="validateName"
              aria-describedby="name-error"
            />
            <p v-if="errors.name" id="name-error" class="text-red-500 text-sm mt-1" role="alert">
              {{ errors.name }}
            </p>
          </div>
        </div>

        <!-- Description Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="create-description" class="text-right">
            Description
          </ULabel>
          <UInput 
            id="create-description" 
            v-model="form.description" 
            placeholder="Enter post description"
            :una="{ inputWrapper: 'col-span-2' }"
          />
        </div>

        <!-- Category Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="create-category" class="text-right">
            Category
          </ULabel>
          <div class="col-span-2 flex flex-row gap-2">
            <!-- Category Select (shown when not adding new category) -->
            <USelect 
              v-if="!isAddingCategory"
              id="create-category" 
              v-model="form.category" 
              :items="categories" 
              placeholder="Select a category"
              class="flex-1"
            />
            
            <!-- New Category Input (shown when adding new category) -->
            <UInput
              v-else
              id="new-category-input"
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

        <!-- Tags Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="create-tags" class="text-right">
            Tags
          </ULabel>
          <div class="col-span-2 flex flex-row gap-2">
            <!-- Tag Select (shown when not adding new tag) -->
            <UCombobox 
              v-if="!isAddingCategory"
              v-model="form.tags" 
              :items="frameworks" 
              by="value"
              multiple
              id="create-tags" 
              :_combobox-input="{
                placeholder: 'Select a tag...',
              }"
              :_combobox-list="{
                class: 'w-300px',
                align: 'start',
              }"
              class="flex-1"
            >
              <template #trigger>
                {{ form.tags?.length > 0
                  ? form.tags.map((val) => {
                    const tag = frameworks.find(f => f.value === val)
                    return tag ? tag.label : val
                  }).join(", ")
                  : "Select tags..." }}
              </template>
              <template #item="{ item, selected }">
                <UCheckbox
                  :model-value="selected"
                  tabindex="-1"
                  aria-hidden="true"
                />
                {{ item.label }}
              </template>
            </UCombobox>
            
            <!-- New Tag Input (shown when adding new tag) -->
            <UInput
              v-else
              id="new-tag-input"
              ref="newCategoryInputRef"
              v-model="newCategoryName"
              placeholder="Enter new tag name"
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
                  aria-label="Add new tag"
                />
                <!-- Save/Cancel buttons when adding tag -->
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
                    aria-label="Cancel adding tag"
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
      </div>
    </div>

    <template #footer>
      <div class="flex gap-2 justify-end">
        <UButton 
          @click="handleCancel" 
          btn="ghost-gray" 
          label="Cancel"
          :disabled="isLoading"
        />
        <UButton 
          @click="handleCreatePost" 
          :loading="isLoading"
          :disabled="!isFormValid || isLoading"
          btn="soft"
          label="Create post" 
        />
      </div>
    </template>
  </UDialog>
</template>

<script setup lang="ts">
import type { CreatePostType } from '~/types/post'

interface Props {
  modelValue?: boolean
  categories?: string[]
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'create-post', post: CreatePostType): void
  (e: 'add-category', category: string): void
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  categories: () => []
})

const emit = defineEmits<Emits>()

// Refs for focus management
const nameInputRef = ref<HTMLInputElement>()
const newCategoryInputRef = ref<HTMLInputElement>()

const frameworks = [
  { value: 'next.js', label: 'Next.js' },
  { value: 'sveltekit', label: 'SvelteKit' },
  { value: 'nuxt', label: 'Nuxt' },
  { value: 'remix', label: 'Remix' },
  { value: 'astro', label: 'Astro' },
]

// Form state
const form = reactive({
  name: '',
  description: '',
  category: '',
  tags: [],
})

// Validation state
const errors = reactive({
  name: ''
})

// UI state
const isLoading = ref(false)
const isAddingCategory = ref(false)
const newCategoryName = ref('')

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

const resetForm = () => {
  form.name = ''
  form.description = ''
  form.category = ''
  errors.name = ''
  isAddingCategory.value = false
  newCategoryName.value = ''
}

const handleCancel = () => {
  isOpen.value = false
  // Don't reset form on cancel - let user resume if they reopen
}

const handleCreatePost = async () => {
  // Validate before submitting
  validateName()
  
  if (!isFormValid.value) {
    // Focus the first invalid field
    if (errors.name) {
      nameInputRef.value?.focus()
    }
    return
  }

  isLoading.value = true

  try {
    const postData: CreatePostType = {
      name: form.name.trim(),
      description: form.description.trim(),
      category: form.category
    }
    console.log(form.tags)

    emit('create-post', postData)
    
    // Reset form only on successful creation
    resetForm()
    isOpen.value = false
    
  } catch (error) {
    console.error('Failed to create post:', error)
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
  
  // Reset add category state
  cancelAddCategory()
}

const cancelAddCategory = () => {
  isAddingCategory.value = false
  newCategoryName.value = ''
}

// Focus management
watch(isOpen, (newValue) => {
  if (newValue) {
    // Focus first input when dialog opens
    nextTick(() => {
      nameInputRef.value?.focus()
    })
  }
})

// Keyboard shortcuts
onMounted(() => {
  console.log(`categories: `, props.categories)
  const handleKeydown = (event: KeyboardEvent) => {
    if (!isOpen.value) return
    
    // Ctrl/Cmd + Enter to submit
    if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
      event.preventDefault()
      handleCreatePost()
    }
  }
  
  document.addEventListener('keydown', handleKeydown)
  
  onUnmounted(() => {
    document.removeEventListener('keydown', handleKeydown)
  })
})
</script>