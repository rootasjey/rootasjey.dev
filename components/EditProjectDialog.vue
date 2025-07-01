<template>
  <UDialog v-model:open="isOpen" title="Edit Project" description="Update project information">
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
              placeholder="Enter project name"
              @blur="validateName"
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
            type="textarea"
            v-model="form.description" 
            placeholder="Enter project description"
            :una="{ inputWrapper: 'col-span-2' }"
          />
        </div>

        <!-- Company Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-company" class="text-right">
            Company
          </ULabel>
          <UInput 
            id="edit-company" 
            v-model="form.company" 
            placeholder="Enter company name"
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
            :items="statusOptions" 
            placeholder="Select status"
          />
        </div>

        <!-- Start Date Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-start-date" class="text-right">
            Start Date
          </ULabel>
          <UInput 
            id="edit-start-date" 
            v-model="form.startDate" 
            type="date"
            :una="{ inputWrapper: 'col-span-2' }"
          />
        </div>

        <!-- End Date Field -->
        <div class="grid grid-cols-3 items-center gap-4">
          <ULabel for="edit-end-date" class="text-right">
            End Date
          </ULabel>
          <div class="col-span-2">
            <UInput 
              id="edit-end-date" 
              v-model="form.endDate" 
              type="date"
              :class="{ 'border-red-500': errors.endDate }"
              aria-describedby="edit-end-date-error"
            />
            <p v-if="errors.endDate" id="edit-end-date-error" class="text-red-500 text-sm mt-1" role="alert">
              {{ errors.endDate }}
            </p>
          </div>
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
          @click="handleUpdateProject" 
          :loading="isLoading"
          :disabled="!isFormValid || !hasChanges || isLoading"
          btn="soft-gray"
          :label="hasChanges ? 'Update project' : 'No changes'"
        />
      </div>
    </template>
  </UDialog>
</template>

<script setup lang="ts">
import type { ApiTag } from '~/types/tag'
import type { ProjectType, UpdateProjectPayload } from '~/types/project'

interface Props {
  modelValue?: boolean
  project?: ProjectType | null
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'update-project', payload: UpdateProjectPayload): void
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  project: null
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
  startDate: '',
  endDate: '',
})

// Original form state for change detection
const originalForm = reactive({
  name: '',
  description: '',
  company: '',
  tags: [] as ApiTag[],
  status: { label: 'Active', value: 'active' },
  startDate: '',
  endDate: '',
})

// Validation state
const errors = reactive({
  name: '',
  tags: '',
  endDate: ''
})

// UI state
const isLoading = ref(false)
const hasChanges = ref(false)

// Status options
const statusOptions = [
  { label: 'Active', value: 'active' },
  { label: 'Completed', value: 'completed' },
  { label: 'Archived', value: 'archived' },
  { label: 'On Hold', value: 'on-hold' }
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
         !errors.tags &&
         !errors.endDate
})

// Methods
const validateName = () => {
  errors.name = ''
  if (!form.name.trim()) {
    errors.name = 'Project name is required'
    return
  }
  
  if (form.name.trim().length < 3) {
    errors.name = 'Project name must be at least 3 characters'
    return
  }
}

const validateTags = () => {
  errors.tags = ''
  if (!form.tags || form.tags.length === 0) {
    errors.tags = 'At least one tag is required'
  }
}

const validateDates = () => {
  errors.endDate = ''
  if (form.startDate && form.endDate) {
    const startDate = new Date(form.startDate)
    const endDate = new Date(form.endDate)
    if (endDate < startDate) {
      errors.endDate = 'End date must be after start date'
    }
  }
}

const markAsChanged = () => {
  validateName()
  validateTags()
  validateDates()
  
  hasChanges.value = (
    form.name !== originalForm.name ||
    form.description !== originalForm.description ||
    form.company !== originalForm.company ||
    JSON.stringify(form.tags) !== JSON.stringify(originalForm.tags) ||
    form.status.value !== originalForm.status.value ||
    form.startDate !== originalForm.startDate ||
    form.endDate !== originalForm.endDate
  )
}

const populateForm = (project: ProjectType) => {
  form.name = project.name || ''
  form.description = project.description || ''
  form.company = project.company || ''
  form.tags = Array.isArray(project.tags) ? [...project.tags] : []
  form.status = convertStatus(project.status)
  form.startDate = project.start_date ? formatDateForInput(project.start_date) : ''
  form.endDate = project.end_date ? formatDateForInput(project.end_date) : ''
  
  // Store original values for change detection
  originalForm.name = form.name
  originalForm.description = form.description
  originalForm.company = form.company
  originalForm.tags = [...form.tags]
  originalForm.status = form.status
  originalForm.startDate = form.startDate
  originalForm.endDate = form.endDate
  
  // Reset change detection
  hasChanges.value = false
  errors.name = ''
  errors.tags = ''
  errors.endDate = ''
}

const convertStatus = (status: string) => {
  return statusOptions.find((option) => {
    return option.value.toLowerCase() === status.toLowerCase()
  }) || { label: 'Active', value: 'active' }
}

const formatDateForInput = (dateString: string) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toISOString().split('T')[0]
}

const resetForm = () => {
  form.name = ''
  form.description = ''
  form.company = ''
  form.tags = []
  form.status = { label: 'Active', value: 'active' }
  form.startDate = ''
  form.endDate = ''
  originalForm.name = ''
  originalForm.description = ''
  originalForm.company = ''
  originalForm.tags = []
  originalForm.status = { label: 'Active', value: 'active' }
  originalForm.startDate = ''
  originalForm.endDate = ''
  errors.name = ''
  errors.tags = ''
  errors.endDate = ''
  hasChanges.value = false
}

const handleCancel = () => {
  if (hasChanges.value) {
    // Could add a confirmation dialog here for unsaved changes
    const confirmDiscard = confirm('You have unsaved changes. Are you sure you want to close?')
    if (!confirmDiscard) return
  }
  
  // Reset form to original values
  if (props.project) {
    populateForm(props.project)
  }
  
  isOpen.value = false
}

const handleUpdateProject = async () => {
  // Validate before submitting
  validateName()
  validateTags()
  validateDates()
  
  if (!isFormValid.value) {
    // Focus the first invalid field
    if (errors.name) {
      nameInputRef.value?.focus()
    }
    return
  }

  if (!props.project) {
    console.error('No project to update')
    return
  }

  isLoading.value = true

  try {
    const payload = {
      company: form.company.trim(),
      description: form.description.trim(),
      id: props.project.id,
      endDate: form.endDate,
      name: form.name.trim(),
      startDate: form.startDate,
      status: form.status.value as 'active' | 'completed' | 'archived' | 'on-hold',
      tags: form.tags.map(tag => ({
        name: tag.name,
        category: tag.category ?? '',
      })),
    }

    emit('update-project', payload)
    
    // Update original form state to reflect saved changes
    originalForm.name = form.name
    originalForm.description = form.description
    originalForm.company = form.company
    originalForm.tags = [...form.tags]
    originalForm.status = form.status
    originalForm.startDate = form.startDate
    originalForm.endDate = form.endDate
    hasChanges.value = false
    
    isOpen.value = false
    
  } catch (error) {
    console.error('Failed to update project:', error)
    useToast().toast({
      title: 'Error',
      description: 'Failed to update project. Please try again.',
      toast: 'error',
      duration: 3000,
    })
  } finally {
    isLoading.value = false
  }
}

// Watchers
watch(() => props.project, (newProject) => {
  if (newProject) {
    populateForm(newProject)
  } else {
    resetForm()
  }
}, { immediate: true })

// Focus management
watch(isOpen, (newValue) => {
  if (newValue && props.project) {
    // Focus first input when dialog opens
    nextTick(() => {
      nameInputRef.value?.focus()
    })
  }
})

watch(form, () => {
  markAsChanged()
})

// Keyboard shortcuts
onMounted(() => {
  const handleKeydown = (event: KeyboardEvent) => {
    if (!isOpen.value) return
    
    // Ctrl/Cmd + Enter to submit
    if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
      event.preventDefault()
      handleUpdateProject()
    }
    
    // Ctrl/Cmd + S to save
    if ((event.ctrlKey || event.metaKey) && event.key === 's') {
      event.preventDefault()
      handleUpdateProject()
    }
  }
  
  document.addEventListener('keydown', handleKeydown)
  
  onUnmounted(() => {
    document.removeEventListener('keydown', handleKeydown)
  })
})
</script>