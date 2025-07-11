<template>
  <UDialog v-model:open="showLocal" title="Add New Category" description="Create a new category for organizing your tags">
    <div class="space-y-4">
      <UInput
        v-model="categoryName"
        label="Category Name"
        placeholder="Enter category name"
        :error="error"
        @keyup.enter="handleCreate"
      />
      <div v-if="error" class="text-sm text-red-600 dark:text-red-400">
        {{ error }}
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
          @click="handleCreate"
          btn="solid"
          label="Add Category"
          size="xs"
          :loading="isCreating"
          :disabled="!categoryName.trim()"
        />
      </div>
    </template>
  </UDialog>
</template>

<script lang="ts" setup>
import type { CategoryOption } from '~/composables/useTagManagement'

interface Props {
  open: boolean
  categoryName: string
  error: string
  isCreating: boolean
  existingCategories: CategoryOption[]
}

interface Emits {
  (e: 'update:open', value: boolean): void
  (e: 'update:categoryName', value: string): void
  (e: 'update:error', value: string): void
  (e: 'create'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const showLocal = computed({
  get: () => props.open,
  set: (value) => emit('update:open', value)
})

// Computed property for v-model binding
const categoryName = computed({
  get: () => props.categoryName,
  set: (value) => emit('update:categoryName', value)
})

const handleCreate = () => {
  // Validate category name
  const name = props.categoryName.trim()
  if (!name) {
    emit('update:error', 'Category name is required')
    return
  }

  const normalizedName = name.toLowerCase()
  const existingNames = props.existingCategories.map(cat => cat.value.toLowerCase())
  
  if (existingNames.includes(normalizedName)) {
    emit('update:error', 'Category already exists')
    return
  }

  emit('update:error', '')
  emit('create')
}

const handleCancel = () => {
  emit('update:open', false)
  emit('update:error', '')
}
</script>
