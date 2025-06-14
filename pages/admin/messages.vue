<template>
  <div class="frame">
    <header class="mt-12 mb-8 border-b b-dashed pb-6 border-gray-200 dark:border-gray-700">
      <div class="flex gap-2">
        <ULink to="/" class="hover:scale-102 active:scale-99 transition">
          <span class="i-ph-house-simple-duotone"></span>
        </ULink>
        <span>•</span>
        <ULink to="/user" class="hover:scale-102 active:scale-99 transition text-gray-600 dark:text-gray-400">
          Profile
        </ULink>
        <span>•</span>
        <h1 class="font-body font-600 text-gray-800 dark:text-gray-200">
          Admin Messages
        </h1>
      </div>
    </header>

    <div v-if="!loggedIn || user?.role !== 'admin'" class="text-center py-12">
      <div class="i-ph-lock text-6xl text-gray-400 mb-4"></div>
      <h2 class="text-xl font-semibold text-gray-700 dark:text-gray-300 mb-2">Access Denied</h2>
      <p class="text-gray-600 dark:text-gray-400">You need admin privileges to access this page.</p>
      <UButton to="/user" class="mt-4">Go to Profile</UButton>
    </div>

    <div v-else>
      <AdminMessageHeader 
        :total-messages="pagination.total"
        :unread-count="unreadCount"
        :selected-count="Object.values(selectedMessages).filter(Boolean).length"
        :is-loading="isLoading"
        @refresh="fetchMessages"
        @bulk-action="handleBulkAction"
        @search="handleSearch"
        @filter-change="handleFilterChange"
      />

      <AdminMessageList
        :messages="messages"
        :selected-messages="selectedMessages"
        :is-loading="isLoading"
        @select-message="toggleMessageSelection"
        @select-all="toggleSelectAll"
        @mark-read="markAsRead"
        @delete-message="showDeleteDialog"
        @view-message="viewMessage"
      />

      <AdminMessagePagination
        v-if="pagination.totalPages > 1"
        :pagination="pagination"
        @page-change="handlePageChange"
      />
    </div>

    <Footer />

    <AdminMessageModal
      v-if="selectedMessage"
      :message="selectedMessage"
      :is-open="isModalOpen"
      @close="closeModal"
      @mark-read="markAsRead"
      @delete="showDeleteDialog"
    />

    <AdminMessageDeleteDialog
      v-if="selectedMessage"
      :message-id="selectedMessage.id"
      :is-open="isDeleteDialogOpen"
      :subject="selectedMessage.subject"
      @confirm="deleteMessage"
      @close="closeDeleteDialog"
    />

    <AdminMessageDeleteBulkDialog 
      :is-open="isDeleteBulkDialogOpen"
      :count="Object.values(selectedMessages).filter(Boolean).length"
      @confirm="() => handleBulkAction('delete')"
      @close="isDeleteBulkDialogOpen = false"
    />
  </div>
</template>

<script lang="ts" setup>
import type { Message } from '~/types/message'
import type { Pagination } from '~/types/pagination'

const { loggedIn, user } = useUserSession()
const { toast } = useToast()

definePageMeta({
  middleware: 'authenticated'
})

const messages = ref<Message[]>([])
const selectedMessages = ref<Record<number, boolean>>({})
const selectedMessage = ref<Message | null>(null)
const isModalOpen = ref(false)
const isDeleteDialogOpen = ref(false)
const isDeleteBulkDialogOpen = ref(false)
const isLoading = ref(false)
const unreadCount = ref(0)

const pagination = ref<Pagination>({
  page: 1,
  limit: 20,
  total: 0,
  totalPages: 0,
  hasNext: false,
  hasPrev: false
})

const filters = ref({
  search: '',
  read: undefined as boolean | undefined
})

const fetchMessages = async () => {
  if (!loggedIn.value || user.value?.role !== 'admin') return
  isLoading.value = true
  
  try {
    const query = new URLSearchParams({
      page: pagination.value.page.toString(),
      limit: pagination.value.limit.toString(),
    })

    if (filters.value.search) {
      query.append('search', filters.value.search)
    }

    if (filters.value.read !== undefined) {
      query.append('read', filters.value.read.toString())
    }

    const response = await $fetch(`/api/admin/messages?${query.toString()}`)
    
    if (response.success) {
      messages.value = response.data.messages
      pagination.value = response.data.pagination
      
      // Calculate unread count
      unreadCount.value = messages.value.filter(m => !m.read).length
    }
  } catch (error) {
    console.error('Error fetching messages:', error)
    toast({
      title: 'Error',
      description: 'Failed to fetch messages. Please try again.',
      toast: 'soft-error',
      duration: 5000
    })
  } finally {
    isLoading.value = false
  }
}

const toggleMessageSelection = (messageId: number) => {
  if (selectedMessages.value[messageId]) {
    delete selectedMessages.value[messageId]
    return
  }

  selectedMessages.value[messageId] = true
}

const toggleSelectAll = () => {
  const selectedTrue = Object.values(selectedMessages.value).filter(Boolean).length
  const allSelected = selectedTrue === messages.value.length
  if (allSelected) {
    selectedMessages.value = {}
    return
  }

  selectedMessages.value = messages.value.reduce((acc, message) => {
    acc[message.id] = true
    return acc
  }, {} as Record<number, boolean>)
}

const markAsRead = async (messageId: number, read: boolean = true) => {
  try {
    const response = await $fetch(`/api/admin/messages/${messageId}`, {
      method: 'PATCH',
      body: { read }
    })

    if (response.success) {
      // Update local state
      const messageIndex = messages.value.findIndex(m => m.id === messageId)
      if (messageIndex > -1) {
        messages.value[messageIndex] = response.data
      }

      // Update selected message if it's open
      if (selectedMessage.value?.id === messageId) {
        selectedMessage.value = response.data
      }

      // Update unread count
      unreadCount.value = messages.value.filter(m => !m.read).length

      toast({
        title: 'Success',
        description: `Message marked as ${read ? 'read' : 'unread'}`,
        toast: 'soft-success',
        duration: 3000
      })
    }
  } catch (error) {
    console.error('Error updating message:', error)
    toast({
      title: 'Error',
      description: 'Failed to update message. Please try again.',
      toast: 'soft-error',
      duration: 5000
    })
  }
}

const deleteMessage = async (messageId: number) => {
  try {
    const response = await $fetch(`/api/admin/messages/${messageId}`, {
      method: 'DELETE'
    })

    if (response.success) {
      // Remove from local state
      messages.value = messages.value.filter(m => m.id !== messageId)
      delete selectedMessages.value[messageId]
      
      // Close modal if this message was open
      if (selectedMessage.value?.id === messageId) {
        closeModal()
        closeDeleteDialog()
      }

      // Update pagination total
      pagination.value.total--
      unreadCount.value = messages.value.filter(m => !m.read).length

      toast({
        title: 'Success',
        description: 'Message deleted successfully',
        toast: 'soft-success',
        duration: 3000
      })
    }
  } catch (error) {
    console.error('Error deleting message:', error)
    toast({
      title: 'Error',
      description: 'Failed to delete message. Please try again.',
      toast: 'soft-error',
      duration: 5000
    })
  }
}

const handleBulkAction = async (action: 'mark_read' | 'mark_unread' | 'confirm_delete' | 'delete') => {
  const selectedTrueMap = Object.entries(selectedMessages.value)
    .filter(([, val]) => val === true)
    .map(([key]) => key)

  if (selectedTrueMap.length === 0) return

  if (action === 'confirm_delete') {
    isDeleteBulkDialogOpen.value = true
    return
  }

  if (action === 'delete') {
    isDeleteBulkDialogOpen.value = false
  }

  try {
    const response = await $fetch('/api/admin/messages/bulk', {
      method: 'POST',
      body: {
        action,
        messageIds: selectedTrueMap,
      }
    })

    if (response.success) {
      // Refresh messages list
      await fetchMessages()
      selectedMessages.value = {}

      toast({
        title: 'Success',
        description: `Successfully processed ${response.processedCount} messages`,
        toast: 'soft-success',
        duration: 3000
      })
    }
  } catch (error) {
    console.error('Error processing bulk action:', error)
    toast({
      title: 'Error',
      description: 'Failed to process bulk action. Please try again.',
      toast: 'soft-error',
      duration: 5000
    })
  }
}

const handleSearch = (searchTerm: string) => {
  filters.value.search = searchTerm
  pagination.value.page = 1
  fetchMessages()
}

const handleFilterChange = (filterType: string, value: any) => {
  if (filterType === 'read') {
    filters.value.read = value
  }

  pagination.value.page = 1
  fetchMessages()
}

const handlePageChange = (page: number) => {
  pagination.value.page = page
  fetchMessages()
}

const viewMessage = (message: Message) => {
  selectedMessage.value = message
  isModalOpen.value = true
  
  // Mark as read when viewing
  if (!message.read) {
    markAsRead(message.id, true)
  }
}

const closeModal = () => {
  selectedMessage.value = null
  isModalOpen.value = false
}

const showDeleteDialog = (message: Message) => {
  selectedMessage.value = message
  isDeleteDialogOpen.value = true
}

const closeDeleteDialog = () => {
  isDeleteDialogOpen.value = false
}

onMounted(() => {
  if (loggedIn.value && user.value?.role === 'admin') {
    fetchMessages()
  }
})

watch([loggedIn, () => user.value?.role], ([newLoggedIn, newRole]) => {
  if (newLoggedIn && newRole === 'admin') {
    fetchMessages()
  }
})
</script>

<style scoped>
.frame {
  width: 800px;
  border-radius: 0.75rem;
  padding: 2rem;
  padding-bottom: 38vh;
  display: flex;
  flex-direction: column;
  transition-property: all;
  transition-duration: 500ms;
  overflow-y: auto;
}

@media (max-width: 768px) {
  .frame {
    width: 100%;
    padding: 1rem;
  }
}
</style>