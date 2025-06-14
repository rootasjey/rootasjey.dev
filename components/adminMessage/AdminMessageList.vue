<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 overflow-hidden">
    <!-- Table Header -->
    <div class="bg-gray-50 dark:bg-gray-700 px-4 py-3 border-b border-gray-200 dark:border-gray-600">
      <div class="flex items-center gap-4">
        <UCheckbox
          :model-value="isIndeterminate ? 'indeterminate' : isAllSelected"
          :indeterminate="isIndeterminate"
          @update:model-value="$emit('select-all')"
        />
        <span class="text-sm font-medium text-gray-700 dark:text-gray-300">
          {{ selectedMessagesCount > 0 ? `${selectedMessagesCount} selected` : 'Select all' }}
        </span>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="p-8 text-center">
      <div class="animate-spin i-ph-spinner text-2xl text-gray-400 mb-2"></div>
      <p class="text-gray-600 dark:text-gray-400">Loading messages...</p>
    </div>

    <!-- Empty State -->
    <div v-else-if="messages.length === 0" class="p-8 text-center">
      <div class="i-ph-envelope text-4xl text-gray-400 mb-4"></div>
      <h3 class="text-lg font-medium text-gray-700 dark:text-gray-300 mb-2">No messages found</h3>
      <p class="text-gray-600 dark:text-gray-400">There are no messages to display.</p>
    </div>

    <!-- Messages List -->
    <div v-else class="divide-y divide-gray-200 dark:divide-gray-600">
      <div
        v-for="message in messages"
        :key="message.id"
        class="flex items-center gap-4 p-4 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors cursor-pointer"
        @click="$emit('view-message', message)"
      >
        <!-- Checkbox -->
        <UCheckbox
          v-model:model-value="selectedMessages[message.id]"
          @click.stop
        />

        <!-- Read Status Indicator -->
        <div class="flex-shrink-0">
          <div
            v-if="!message.read"
            class="w-2 h-2 bg-blue-500 rounded-full"
            title="Unread"
          ></div>
          <div
            v-else
            class="w-2 h-2 bg-gray-300 dark:bg-gray-600 rounded-full"
            title="Read"
          ></div>
        </div>

        <!-- Message Content -->
        <div class="flex-1 min-w-0">
          <div class="flex items-start justify-between gap-4">
            <div class="flex-1 min-w-0">
              <!-- Sender Email -->
              <div class="flex items-center gap-2 mb-1">
                <span class="i-ph-envelope text-gray-400"></span>
                <span class="text-sm font-medium text-gray-900 dark:text-white truncate">
                  {{ message.sender_email }}
                </span>
              </div>

              <!-- Subject -->
              <h3 
                class="text-base font-semibold text-gray-800 dark:text-gray-200 truncate mb-1"
                :class="{ 'font-bold': !message.read }"
              >
                {{ message.subject }}
              </h3>

              <!-- Message Preview -->
              <p class="text-sm text-gray-600 dark:text-gray-400 line-clamp-2">
                {{ truncateMessage(message.message) }}
              </p>
            </div>

            <!-- Timestamp and Actions -->
            <div class="flex-shrink-0 text-right">
              <div class="text-xs text-gray-500 dark:text-gray-400 mb-2">
                {{ formatDate(message.created_at) }}
              </div>
              
              <!-- Action Buttons -->
              <div class="flex gap-1" @click.stop>
                <UButton
                  v-if="!message.read"
                  @click="$emit('mark-read', message.id, true)"
                  size="xs"
                  btn="ghost-gray"
                  title="Mark as read"
                >
                  <span class="i-ph-check"></span>
                </UButton>
                
                <UButton
                  v-else
                  @click="$emit('mark-read', message.id, false)"
                  size="xs"
                  btn="ghost-gray"
                  title="Mark as unread"
                >
                  <span class="i-ph-circle"></span>
                </UButton>

                <UButton
                  @click="$emit('delete-message', message)"
                  size="xs"
                  btn="ghost-gray"
                  title="Delete message"
                >
                  <span class="i-ph-trash"></span>
                </UButton>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
interface Message {
  id: number
  sender_email: string
  subject: string
  message: string
  read: boolean
  created_at: string
  updated_at: string
}

interface Props {
  messages: Message[]
  selectedMessages: Record<number, boolean>
  isLoading: boolean
}

interface Emits {
  (e: 'select-message', messageId: number): void
  (e: 'select-all'): void
  (e: 'mark-read', messageId: number, read: boolean): void
  (e: 'delete-message', message: Message): void
  (e: 'view-message', message: Message): void
}

const props = defineProps<Props>()
defineEmits<Emits>()

const selectedMessagesCount = computed(() => {
  return Object.values(props.selectedMessages).filter(Boolean).length
})

// Computed properties for select all checkbox
const isAllSelected = computed(() => {
  return props.messages.length > 0 && selectedMessagesCount.value === props.messages.length
})

const isIndeterminate = computed(() => {
  return selectedMessagesCount.value > 0 && selectedMessagesCount.value < props.messages.length
})

// Utility functions
const truncateMessage = (message: string, maxLength: number = 150): string => {
  if (message.length <= maxLength) return message
  return message.substring(0, maxLength) + '...'
}

const formatDate = (dateString: string): string => {
  const date = new Date(dateString)
  const now = new Date()
  const diffInHours = Math.floor((now.getTime() - date.getTime()) / (1000 * 60 * 60))

  if (diffInHours < 1) {
    const diffInMinutes = Math.floor((now.getTime() - date.getTime()) / (1000 * 60))
    return diffInMinutes < 1 ? 'Just now' : `${diffInMinutes}m ago`
  }

  if (diffInHours < 24) {
    return `${diffInHours}h ago`
  }

  if (diffInHours < 24 * 7) {
    const diffInDays = Math.floor(diffInHours / 24)
    return `${diffInDays}d ago`
  }

  return date.toLocaleDateString('fr-FR', {
    month: 'short',
    day: 'numeric',
    year: date.getFullYear() !== now.getFullYear() ? 'numeric' : undefined
  })
}
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>