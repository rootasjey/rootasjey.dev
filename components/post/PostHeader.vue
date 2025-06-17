<template>
  <header class="mt-12 mb-8 border-b b-dashed border-gray-200 dark:border-gray-700 pb-6">
    <div class="flex gap-2">
      <ULink to="/" class="hover:scale-102 active:scale-99 transition">
        <span class="i-ph-house-simple-duotone"></span>
      </ULink>
      <span>•</span>
      <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
        reflexions
      </h1>
    </div>
    <p class="text-gray-700 dark:text-gray-500">
      Thoughts and reflections on various topics
    </p>

    <!-- Error message display -->
    <div v-if="error" class="mt-2 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-md">
      <div class="flex items-start gap-2">
        <span class="i-lucide-alert-circle text-red-600 dark:text-red-400 text-sm flex-shrink-0 mt-0.5"></span>
        <div class="text-sm text-red-700 dark:text-red-300">
          <p>{{ error }}</p>
          <UButton 
            btn="text" 
            size="xs" 
            class="mt-1 text-red-600 dark:text-red-400 hover:text-red-800 dark:hover:text-red-200"
            @click="$emit('retry-error')"
          >
            Retry
          </UButton>
        </div>
      </div>
    </div>

    <!-- Dialogs - only render if showDialogs is true -->
    <template v-if="showDialogs">
      <!-- Create Post Button -->
      <CreatePostDialog
        :model-value="createDialogModel"
        @update:model-value="$emit('update:createDialogModel', $event)"
        :categories="categories"
        @create-post="$emit('create-post', $event)"
        @add-category="$emit('add-category', $event)"
      />

      <!-- Edit Post Dialog -->
      <EditPostDialog
        :model-value="editDialogModel"
        @update:model-value="$emit('update:editDialogModel', $event)"
        :categories="categories"
        :post="editingPost"
        @update-post="$emit('update-post', $event)"
        @add-category="$emit('add-category', $event)"
      />

      <!-- Delete Confirmation Dialog -->
      <DeletePostDialog
        :model-value="deleteDialogModel"
        @update:model-value="$emit('update:deleteDialogModel', $event)"
        :post="deletingPost"
        @delete-post="$emit('delete-post', $event)"
      />
    </template>
  </header>
</template>

<script lang="ts" setup>
import type { PostType } from '~/types/post'

interface Props {
  isLoading?: boolean
  error?: string | null
  categories?: string[]
  showDialogs?: boolean
  createDialogModel?: boolean
  editDialogModel?: boolean
  deleteDialogModel?: boolean
  editingPost?: PostType | null
  deletingPost?: PostType | null
}

withDefaults(defineProps<Props>(), {
  isLoading: false,
  error: null,
  categories: () => [],
  showDialogs: false,
  createDialogModel: false,
  editDialogModel: false,
  deleteDialogModel: false,
  editingPost: null,
  deletingPost: null
})

defineEmits<{
  'create-post': [postData: any]
  'update-post': [updateData: any]
  'delete-post': [post: PostType]
  'add-category': [category: string]
  'retry-error': []
  'update:createDialogModel': [modelValue: boolean]
  'update:editDialogModel': [modelValue: boolean]
  'update:deleteDialogModel': [modelValue: boolean]
}>()
</script>