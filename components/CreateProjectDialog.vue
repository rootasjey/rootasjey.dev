<template>
  <UDialog v-model:open="isOpen" title="Create Project" description="Add a new project with tags">
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
              placeholder="Enter project name"
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
            placeholder="Enter project description"
            :una="{ inputWrapper: 'col-span-2' }"
          />
        </div>

        <!-- Company Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="create-company" class="text-right">
            Company
          </ULabel>
          <UInput 
            id="create-company" 
            v-model="form.company" 
            placeholder="Enter company name"
            :una="{ inputWrapper: 'col-span-2' }"
          />
        </div>

        <!-- Tags Field -->
        <div class="grid grid-cols-3 items-start gap-4 mb-2">
          <ULabel for="create-tags" class="text-right pt-2">
            Tags *
          </ULabel>
          <div class="col-span-2">
            <TagInput
              id="create-tags"
              v-model="form.tags"
              placeholder="Select or add tags..."
              :enable-autocomplete="true"
            />
            <p v-if="errors.tags" id="tags-error" class="text-red-500 text-sm mt-1" role="alert">
              {{ errors.tags }}
            </p>
          </div>
        </div>

        <!-- Status Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="create-status" class="text-right">
            Status
          </ULabel>
          <USelect 
            id="create-status" 
            v-model="form.status" 
            item-key="label"
            value-key="label"
            :items="statusOptions" 
            placeholder="Select status"
          />
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
          @click="handleCreateProject" 
          :loading="isLoading"
          :disabled="!isFormValid || isLoading"
          btn="soft dark:solid-white"
          label="Create project" 
        />
      </div>
    </template>
  </UDialog>
</template>

<script setup lang="ts">
import type { CreateProjectPayload } from '~/types/project'
import type { ApiTag } from '~/types/tag'

interface Props {
  modelValue?: boolean
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'create-project', project: CreateProjectPayload): void
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false
})

const emit = defineEmits<Emits>()

// Refs for focus management
const nameInputRef = ref<HTMLInputElement>()

// Form state
const form = reactive({
  name: '',
  description: '',
  company: '',
  tags: [] as ApiTag[],
  status: { label: 'Active', value: 'active' },
})

// Validation state
const errors = reactive({
  name: '',
  tags: ''
})

// UI state
const isLoading = ref(false)

// Status options
const statusOptions = [
  { label: 'Active', value: 'active' },
  { label: 'Archived', value: 'archived' },
  { label: 'Completed', value: 'completed' },
  { label: 'On-hold', value: 'on-hold' },
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
    errors.name = 'Project name is required'
  } else if (form.name.trim().length < 3) {
    errors.name = 'Project name must be at least 3 characters'
  }
}

const validateTags = () => {
  errors.tags = ''
  if (!form.tags || form.tags.length === 0) {
    errors.tags = 'At least one tag is required'
  }
}

const resetForm = () => {
  form.name = ''
  form.description = ''
  form.company = ''
  form.tags = []
  form.status = form.status = statusOptions.find(o => o.value === 'active') || statusOptions[0]
  errors.name = ''
  errors.tags = ''
}

const handleCancel = () => {
  isOpen.value = false
  // Don't reset form on cancel - let user resume if they reopen
}

const handleCreateProject = async () => {
  // Validate before submitting
  validateName()
  validateTags()
  if (!isFormValid.value) {
    if (errors.name) {
      nameInputRef.value?.focus()
    }
    return
  }
  isLoading.value = true
  try {
    const projectData: CreateProjectPayload = {
      name: form.name.trim(),
      description: form.description.trim(),
      company: form.company.trim(),
      status: (['active', 'completed', 'archived', 'on-hold'] as const).includes(form.status.value as any) 
      ? form.status.value as 'active' | 'completed' | 'archived' | 'on-hold'
      : 'active',
      tags: form.tags.map(tag => ({
        name: tag.name,
        category: tag.category ?? ''
      })),
    }

    emit('create-project', projectData)
    resetForm()
    isOpen.value = false
  } catch (error) {
    console.error('Failed to create project:', error)
  } finally {
    isLoading.value = false
  }
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

watch(() => form.name, validateName)
watch(() => form.tags, validateTags)

// Keyboard shortcuts
onMounted(() => {
  const handleKeydown = (event: KeyboardEvent) => {
    if (!isOpen.value) return
    
    // Ctrl/Cmd + Enter to submit
    if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
      event.preventDefault()
      handleCreateProject()
    }
  }
  
  document.addEventListener('keydown', handleKeydown)
  
  onUnmounted(() => {
    document.removeEventListener('keydown', handleKeydown)
  })
})
</script>