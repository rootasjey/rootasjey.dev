<template>
  <UDialog 
    :open="isOpen"
    @update:open="$emit('close')"
    :ui="{ width: 'sm:max-w-2xl' }"
    :_dialog-close="{
      btn: 'solid-gray',
    }"
  >
    <UCard>
      <!-- Header -->
      <template #header>
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div
              class="w-3 h-3 rounded-full"
              :class="message.read ? 'bg-gray-300 dark:bg-gray-600' : 'bg-blue-500'"
              :title="message.read ? 'Read' : 'Unread'"
            ></div>
            <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
              Message Details
            </h3>
          </div>
        </div>
      </template>

      <!-- Message Content -->
      <div class="space-y-6">
        <!-- Message Info -->
        <div class="flex flex-col gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              From
            </label>
            <div class="flex items-center gap-2 p-3 bg-gray-50 dark:bg-gray-700 rounded-lg">
              <span class="i-ph-envelope text-gray-400"></span>
              <span class="text-sm text-gray-900 dark:text-white">{{ message.sender_email }}</span>
            </div>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Received
            </label>
            <div class="flex items-center gap-2 p-3 bg-gray-50 dark:bg-gray-700 rounded-lg">
              <span class="i-ph-clock text-gray-400"></span>
              <span class="text-sm text-gray-900 dark:text-white">{{ formatFullDate(message.created_at) }}</span>
            </div>
          </div>
        </div>

        <!-- Subject -->
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Subject
          </label>
          <div class="p-4 bg-gray-50 dark:bg-gray-700 rounded-lg">
            <h4 class="text-base font-semibold text-gray-900 dark:text-white">
              {{ message.subject }}
            </h4>
          </div>
        </div>

        <!-- Message Body -->
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Message
          </label>
          <div class="p-4 bg-gray-50 dark:bg-gray-700 rounded-lg max-h-96 overflow-y-auto">
            <div 
              class="text-sm text-gray-900 dark:text-white whitespace-pre-wrap leading-relaxed"
              v-html="formattedMessage"
            ></div>
          </div>
        </div>

        <!-- Message Metadata -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4 border-t border-gray-200 dark:border-gray-600">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Message ID
            </label>
            <span class="text-sm text-gray-600 dark:text-gray-400">#{{ message.id }}</span>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Status
            </label>
            <div class="flex items-center gap-2">
              <div
                class="w-2 h-2 rounded-full"
                :class="message.read ? 'bg-gray-400' : 'bg-blue-500'"
              ></div>
              <span class="text-sm text-gray-600 dark:text-gray-400">
                {{ message.read ? 'Read' : 'Unread' }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Footer Actions -->
      <template #footer>
        <div class="flex items-center gap-4 justify-between">
          <div class="flex gap-4">
            <UButton
              v-if="!message.read"
              @click="handleMarkRead(true)"
              btn="soft"
              size="sm"
            >
              <span class="i-ph-check mr-2"></span>
              Mark as Read
            </UButton>
            
            <UButton
              v-else
              @click="handleMarkRead(false)"
              btn="soft"
              size="sm"
            >
              <span class="i-ph-circle mr-2"></span>
              Mark as Unread
            </UButton>
          </div>

          <div class="flex gap-4">
            <UButton
              @click="emit('delete', props.message)"
              btn="soft-pink"
              size="sm"
              class="px-6"
            >
              <span class="i-ph-trash mr-2"></span>
              Delete
            </UButton>
            
            <UButton
              @click="$emit('close')"
              btn="ghost-gray"
              class="px-6"
            >
              Close
            </UButton>
          </div>
        </div>
      </template>
    </UCard>
  </UDialog>
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
  message: Message
  isOpen: boolean
}

interface Emits {
  (e: 'close'): void
  (e: 'mark-read', messageId: number, read: boolean): void
  (e: 'delete', message: Message): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// Computed properties
const formattedMessage = computed(() => {
  // Basic HTML escaping and formatting
  let formatted = props.message.message
    .replace(/&/g, '&')
    .replace(/</g, '<')
    .replace(/>/g, '>')
    .replace(/"/g, '"')
    .replace(/'/g, '\'')
  
  // Convert URLs to links
  const urlRegex = /(https?:\/\/[^\s]+)/g
  formatted = formatted.replace(urlRegex, '<a href="$1" target="_blank" rel="noopener noreferrer" class="text-blue-600 dark:text-blue-400 hover:underline">$1</a>')
  
  // Convert email addresses to mailto links
  const emailRegex = /([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/g
  formatted = formatted.replace(emailRegex, '<a href="mailto:$1" class="text-blue-600 dark:text-blue-400 hover:underline">$1</a>')
  
  return formatted
})

// Utility functions
const formatFullDate = (dateString: string): string => {
  const date = new Date(dateString)
  return date.toLocaleString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    hour12: true
  })
}

// Event handlers
const handleMarkRead = (read: boolean) => {
  emit('mark-read', props.message.id, read)
}
</script>

<style scoped>
/* Custom scrollbar for message content */
.overflow-y-auto::-webkit-scrollbar {
  width: 6px;
}

.overflow-y-auto::-webkit-scrollbar-track {
  background-color: rgb(243 244 246); border-radius: 0.25rem;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
  background-color: rgb(209 213 219);
  border-radius: 0.25rem;
}

.overflow-y-auto::-webkit-scrollbar-thumb:hover {
  background-color: rgb(156 163 175);
}

.dark {
  .overflow-y-auto::-webkit-scrollbar-track {
    background-color: rgb(31 41 55); 
  }
  
  .overflow-y-auto::-webkit-scrollbar-thumb {
    background-color: rgb(75 85 99) in dark mode;
  }

  .overflow-y-auto::-webkit-scrollbar-thumb:hover {
    background-color: rgb(107 114 128);
  }
}
</style>