<template>
  <UDialog v-model:open="isOpen" :title="title" :description="description">
    <div class="space-y-4">
      <div v-if="showWarning" :class="warningClasses">
        <div class="flex items-start gap-3">
          <div :class="[warningIcon, warningIconColor, 'text-lg flex-shrink-0 mt-0.5']"></div>
          <div>
            <h4 :class="warningTitleColor" class="font-600 mb-1">
              {{ warningTitle }}
            </h4>
            <p :class="warningTextColor" class="text-sm">
              {{ warningMessage }}
            </p>
          </div>
        </div>
      </div>
      
      <div v-if="message" class="text-sm text-gray-600 dark:text-gray-400">
        <p>{{ message }}</p>
      </div>
      
      <slot />
    </div>

    <template #footer>
      <div class="flex gap-2 justify-end">
        <UButton 
          @click="handleCancel" 
          btn="ghost-gray" 
          :label="cancelText"
          :disabled="isLoading"
        />
        <UButton 
          @click="handleConfirm" 
          :btn="confirmVariant"
          :loading="isLoading"
          :disabled="isLoading"
        >
          <span v-if="confirmIcon" :class="[confirmIcon, 'mr-2']"></span>
          {{ confirmText }}
        </UButton>
      </div>
    </template>
  </UDialog>
</template>

<script setup lang="ts">
interface Props {
  modelValue: boolean
  title: string
  description?: string
  message?: string
  confirmText?: string
  cancelText?: string
  confirmIcon?: string
  confirmVariant?: string
  isLoading?: boolean
  showWarning?: boolean
  warningType?: 'danger' | 'warning' | 'info'
  warningTitle?: string
  warningMessage?: string
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'confirm'): void
  (e: 'cancel'): void
}

const props = withDefaults(defineProps<Props>(), {
  description: undefined,
  message: undefined,
  confirmText: 'Confirm',
  cancelText: 'Cancel',
  confirmIcon: undefined,
  confirmVariant: 'solid-blue',
  isLoading: false,
  showWarning: false,
  warningType: 'danger',
  warningTitle: 'Warning',
  warningMessage: 'This action cannot be undone.'
})

const emit = defineEmits<Emits>()

const isOpen = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const warningClasses = computed(() => {
  const baseClasses = 'p-4 border rounded-lg'
  
  switch (props.warningType) {
    case 'danger':
      return `${baseClasses} bg-red-50 dark:bg-red-900/20 border-red-200 dark:border-red-800`
    case 'warning':
      return `${baseClasses} bg-yellow-50 dark:bg-yellow-900/20 border-yellow-200 dark:border-yellow-800`
    case 'info':
      return `${baseClasses} bg-blue-50 dark:bg-blue-900/20 border-blue-200 dark:border-blue-800`
    default:
      return `${baseClasses} bg-red-50 dark:bg-red-900/20 border-red-200 dark:border-red-800`
  }
})

const warningIcon = computed(() => {
  switch (props.warningType) {
    case 'danger':
      return 'i-ph-warning-circle'
    case 'warning':
      return 'i-ph-warning'
    case 'info':
      return 'i-ph-info'
    default:
      return 'i-ph-warning-circle'
  }
})

const warningIconColor = computed(() => {
  switch (props.warningType) {
    case 'danger':
      return 'text-red-500'
    case 'warning':
      return 'text-yellow-500'
    case 'info':
      return 'text-blue-500'
    default:
      return 'text-red-500'
  }
})

const warningTitleColor = computed(() => {
  switch (props.warningType) {
    case 'danger':
      return 'text-red-800 dark:text-red-200'
    case 'warning':
      return 'text-yellow-800 dark:text-yellow-200'
    case 'info':
      return 'text-blue-800 dark:text-blue-200'
    default:
      return 'text-red-800 dark:text-red-200'
  }
})

const warningTextColor = computed(() => {
  switch (props.warningType) {
    case 'danger':
      return 'text-red-700 dark:text-red-300'
    case 'warning':
      return 'text-yellow-700 dark:text-yellow-300'
    case 'info':
      return 'text-blue-700 dark:text-blue-300'
    default:
      return 'text-red-700 dark:text-red-300'
  }
})

const handleConfirm = () => {
  emit('confirm')
}

const handleCancel = () => {
  emit('cancel')
  isOpen.value = false
}
</script>
