<template>
  <UDialog v-model:open="showLocal" title="Edit Tag" description="Update tag name and category">
    <div class="space-y-4">
      <UInput
        v-model="tagName"
        label="Tag Name"
        placeholder="Enter tag name"
        @keyup.enter="handleUpdate"
      />
      <USelect
        v-model="tagCategory"
        label="Tag Category"
        :items="categoryOptions"
        item-key="label"
        value-key="label"
        placeholder="Select category"
      />
    </div>
    <template #footer>
      <div class="w-full flex gap-2 justify-between">
        <UButton
          @click="$emit('delete')"
          btn="link-pink"
          size="xs"
          label="Delete Tag"
          :loading="isDeletingTag"
          :disabled="isUpdatingTag"
        />
        <div class="flex gap-2">
          <UButton
            @click="handleCancel"
            btn="ghost-gray"
            label="Cancel"
            size="xs"
          />
          <UButton
            @click="handleUpdate"
            btn="solid-black"
            size="xs"
            label="Update Tag"
            :loading="isUpdatingTag"
            :disabled="!tagName.trim()"
          />
        </div>
      </div>
    </template>
  </UDialog>
</template>

<script lang="ts" setup>
import type { CategoryOption } from '~/composables/useTagManagement'

interface Props {
  open: boolean
  tagName: string
  tagCategory: string
  categoryOptions: CategoryOption[]
  isUpdatingTag: boolean
  isDeletingTag: boolean
}

interface Emits {
  (e: 'update:open', value: boolean): void
  (e: 'update:tagName', value: string): void
  (e: 'update:tagCategory', value: string): void
  (e: 'update'): void
  (e: 'delete'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const showLocal = computed({
  get: () => props.open,
  set: (value) => emit('update:open', value)
})

// Computed properties for v-model binding
const tagName = computed({
  get: () => props.tagName,
  set: (value) => emit('update:tagName', value)
})

const tagCategory = computed({
  get: () => props.tagCategory,
  set: (value) => emit('update:tagCategory', value)
})

const handleUpdate = () => {
  emit('update')
}

const handleCancel = () => {
  emit('update:open', false)
}
</script>
