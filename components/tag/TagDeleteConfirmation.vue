<template>
  <UDialog v-model:open="showLocal" title="Delete Tag" description="Are you sure you want to delete this tag?">
    <div class="space-y-4">
      <p class="text-sm text-gray-600 dark:text-gray-400">
        This will permanently delete the tag "{{ tagName }}" and remove it from all posts.
        This action cannot be undone.
      </p>
      <div v-if="usageCount > 0" class="p-3 bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-md">
        <p class="text-sm text-yellow-700 dark:text-yellow-300">
          This tag is currently used in {{ usageCount }} post{{ usageCount === 1 ? '' : 's' }}.
        </p>
      </div>
    </div>
    <template #footer>
      <div class="flex gap-2 justify-end">
        <UButton 
          @click="handleCancel" 
          btn="ghost" 
          label="Cancel"
          size="xs"
        />
        <UButton 
          @click="handleConfirm" 
          btn="soft-red"
          size="xs"
          label="Delete Tag"
          :loading="isDeleting"
        />
      </div>
    </template>
  </UDialog>
</template>

<script lang="ts" setup>
interface Props {
  open: boolean
  tagName: string
  usageCount: number
  isDeleting: boolean
}

interface Emits {
  (e: 'update:open', value: boolean): void
  (e: 'confirm'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const showLocal = computed({
  get: () => props.open,
  set: (value) => emit('update:open', value)
})

const handleConfirm = () => {
  emit('confirm')
}

const handleCancel = () => {
  emit('update:open', false)
}
</script>
