<template>
  <header class="w-full max-w-4xl mx-auto mt-24 md:mt-42 mb-12 p-2 md:p-0">
    <div>
      <div class="flex items-center gap-3 mb-2">
        <h1 class="font-body text-6xl font-600 text-gray-800 dark:text-gray-200">
          Posts
        </h1>
      </div>
      
      <h4 class="text-size-5 font-300 mb-6 text-gray-800 dark:text-gray-200 max-w-2xl">
        Some reflections on code, creativity, knowledge, and various topics.
      </h4>
    </div>

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
        @create-post="$emit('create-post', $event)"
      />

      <!-- Edit Post Dialog -->
      <EditPostDialog
        :model-value="editDialogModel"
        @update:model-value="$emit('update:editDialogModel', $event)"
        :post="editingPost"
        @update-post="$emit('update-post', $event)"
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
import type { Post } from '~/types/post'

interface Props {
  isLoading?: boolean
  error?: string
  showDialogs?: boolean
  createDialogModel?: boolean
  editDialogModel?: boolean
  deleteDialogModel?: boolean
  editingPost?: Post
  deletingPost?: Post
}

withDefaults(defineProps<Props>(), {
  isLoading: false,
  error: undefined,
  showDialogs: false,
  createDialogModel: false,
  editDialogModel: false,
  deleteDialogModel: false,
  editingPost: undefined,
  deletingPost: undefined
})

defineEmits<{
  'create-post': [postData: any]
  'update-post': [updateData: any]
  'delete-post': [post: Post]
  'retry-error': []
  'update:createDialogModel': [modelValue: boolean]
  'update:editDialogModel': [modelValue: boolean]
  'update:deleteDialogModel': [modelValue: boolean]
}>()
</script>