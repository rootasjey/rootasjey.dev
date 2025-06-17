<template>
  <UDialog 
    v-model:open="isOpen" 
    title="Delete Post" 
    description="This action cannot be undone."
  >
    <div class="py-4">
      <div class="flex items-start gap-3 mb-4">
        <div class="flex-shrink-0 w-10 h-10 bg-red-100 dark:bg-red-900/20 rounded-full flex items-center justify-center">
          <span class="i-lucide-trash-2 text-red-600 dark:text-red-400 text-lg"></span>
        </div>
        <div class="flex-1">
          <p class="text-sm text-gray-900 dark:text-gray-100 font-medium mb-2">
            Are you sure you want to delete this post?
          </p>
          <p v-if="post?.name" class="text-sm text-gray-600 dark:text-gray-400 mb-3">
            <span class="font-semibold text-gray-900 dark:text-gray-100">"{{ post.name }}"</span>
          </p>
          <p class="text-sm text-gray-500 dark:text-gray-500">
            This will permanently remove the post and all its content. This action cannot be undone.
          </p>
        </div>
      </div>

      <!-- Error message if deletion fails -->
      <div v-if="errorMessage" class="mb-4 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-md">
        <div class="flex items-start gap-2">
          <span class="i-lucide-alert-circle text-red-600 dark:text-red-400 text-sm flex-shrink-0 mt-0.5"></span>
          <p class="text-sm text-red-700 dark:text-red-300">
            {{ errorMessage }}
          </p>
        </div>
      </div>
    </div>

    <template #footer>
      <div class="flex gap-2 justify-end">
        <UButton 
          ref="cancelButtonRef"
          @click="handleCancel" 
          btn="ghost-gray" 
          label="Cancel"
          :disabled="isLoading"
        />
        <UButton 
          ref="deleteButtonRef"
          @click="handleDeletePost" 
          :loading="isLoading"
          :disabled="isLoading || !post"
          btn="solid-red"
          label="Delete Post"
        />
      </div>
    </template>
  </UDialog>
</template>

<script setup lang="ts">
import type { PostType } from '~/types/post'

interface Props {
  modelValue?: boolean
  post?: PostType | null
}

interface Emits {
  (e: 'update:modelValue', value: boolean): void
  (e: 'delete-post', post: PostType): void
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  post: null
})

const emit = defineEmits<Emits>()

// Refs for focus management
const cancelButtonRef = ref<ComponentPublicInstance<HTMLButtonElement>>()
const deleteButtonRef = ref<ComponentPublicInstance<HTMLButtonElement>>()

// UI state
const isLoading = ref(false)
const errorMessage = ref('')

// Computed
const isOpen = computed({
  get: () => props.modelValue,
  set: (value: boolean) => emit('update:modelValue', value)
})

// Methods
const handleCancel = () => {
  if (isLoading.value) return
  
  isOpen.value = false
  errorMessage.value = ''
}

const handleDeletePost = async () => {
  if (!props.post || isLoading.value) return

  isLoading.value = true
  errorMessage.value = ''

  try {
    emit('delete-post', props.post)
    
    // Close dialog on successful deletion
    isOpen.value = false
    
  } catch (error) {
    console.error('Failed to delete post:', error)
    errorMessage.value = 'Failed to delete the post. Please try again.'
  } finally {
    isLoading.value = false
  }
}

// Focus management - focus Cancel button for safety
watch(isOpen, (newValue) => {
  if (newValue && props.post) {
    // Reset error message when dialog opens
    errorMessage.value = ''
    
    // Focus Cancel button by default for safety
    nextTick(() => {
      cancelButtonRef.value?.$el?.focus()
    })
  }
})

// Keyboard shortcuts
onMounted(() => {
  const handleKeydown = (event: KeyboardEvent) => {
    if (!isOpen.value || isLoading.value) return
    
    // Enter to confirm deletion (only if delete button is focused for safety)
    if (event.key === 'Enter' && document.activeElement === deleteButtonRef.value?.$el) {
      event.preventDefault()
      handleDeletePost()
    }
    
    // Escape to cancel
    if (event.key === 'Escape') {
      event.preventDefault()
      handleCancel()
    }
  }
  
  document.addEventListener('keydown', handleKeydown)
  
  onUnmounted(() => {
    document.removeEventListener('keydown', handleKeydown)
  })
})

// Reset error when post changes
watch(() => props.post, () => {
  errorMessage.value = ''
})
</script>