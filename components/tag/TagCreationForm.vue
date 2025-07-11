<template>
  <UCollapsible>
    <UCollapsibleTrigger class="group flex items-center gap-2 w-full p-3 border border-gray-200 dark:border-gray-700 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
      <span class="i-ph-plus-bold text-xs text-gray-600 dark:text-gray-400"></span>
      <span class="text-xs font-medium text-gray-700 dark:text-gray-300">Add New Tag</span>
      <span class="i-lucide-chevron-down text-xs text-gray-600 dark:text-gray-400 ml-auto transition-transform duration-200 group-data-[state=open]:rotate-180"></span>
    </UCollapsibleTrigger>
    <UCollapsibleContent class="mt-2">
      <div class="border border-gray-200 dark:border-gray-700 rounded-lg p-4">
        <div class="flex gap-2">
          <UInput
            v-model="tagName"
            placeholder="Tag name"
            class="flex-1"
            size="xs"
            :disabled="isCreating"
            @keyup.enter="handleCreate"
          />
          <USelect
            v-model="tagCategory"
            :items="categoryOptions"
            item-key="label"
            value-key="label"
            label="Tag Category"
            placeholder="Category"
            class="w-32"
            size="xs"
            :disabled="isCreating"
          />
          <UButton
            @click="handleCreate"
            :loading="isCreating"
            :disabled="!tagName.trim()"
            btn="solid-gray"
            size="xs"
            class="px-6"
          >
            Add
          </UButton>
        </div>
      </div>
    </UCollapsibleContent>
  </UCollapsible>
</template>

<script lang="ts" setup>
import type { CategoryOption } from '~/composables/useTagManagement'

interface Props {
  tagName: string
  tagCategory: CategoryOption
  categoryOptions: CategoryOption[]
  isCreating: boolean
}

interface Emits {
  (e: 'update:tagName', value: string): void
  (e: 'update:tagCategory', value: CategoryOption): void
  (e: 'create'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// Computed properties for v-model binding
const tagName = computed({
  get: () => props.tagName,
  set: (value) => emit('update:tagName', value)
})

const tagCategory = computed({
  get: () => props.tagCategory,
  set: (value) => emit('update:tagCategory', value)
})

const handleCreate = () => {
  emit('create')
}
</script>
