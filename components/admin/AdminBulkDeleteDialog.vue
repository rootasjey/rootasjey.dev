<template>
  <UDialog v-model:open="isOpen" title="Confirm Bulk Delete" :description="dialogDescription">
    <div class="space-y-4">
      <div class="flex items-center gap-3 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
        <div class="i-ph-warning-circle text-red-500 text-xl flex-shrink-0"></div>
        <div>
          <h4 class="font-600 text-red-800 dark:text-red-200 mb-1">
            This action cannot be undone
          </h4>
          <p class="text-sm text-red-700 dark:text-red-300">
            {{ warningMessage }}
          </p>
        </div>
      </div>
      
      <div class="text-sm text-gray-600 dark:text-gray-400">
        <p>Selected {{ itemType }} will be permanently deleted from the system.</p>
      </div>
    </div>

    <template #footer>
      <div class="flex gap-2 justify-end">
        <UButton 
          @click="handleCancel" 
          btn="ghost-gray" 
          label="Cancel"
        />
        <UButton 
          @click="handleConfirm" 
          btn="solid-red"
          :loading="isDeleting"
          :disabled="isDeleting"
        >
          <span class="i-ph-trash mr-2"></span>
          Delete {{ count }} {{ itemType }}
        </UButton>
      </div>
    </template>
  </UDialog>
</template>

<script setup lang="ts">
interface Props {
  modelValue: boolean
  count: number
  itemType: string
  isDeleting?: boolean
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'confirm'): void
  (e: 'cancel'): void
}

const props = withDefaults(defineProps<Props>(), {
  isDeleting: false
})

const emit = defineEmits<Emits>()

const isOpen = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const dialogDescription = computed(() => {
  return `You are about to delete ${props.count} ${props.itemType}.`
})

const warningMessage = computed(() => {
  const itemWord = props.count === 1 ? props.itemType.slice(0, -1) : props.itemType
  return `${props.count} ${itemWord} will be permanently removed.`
})

const handleConfirm = () => {
  emit('confirm')
}

const handleCancel = () => {
  emit('cancel')
  isOpen.value = false
}
</script>
