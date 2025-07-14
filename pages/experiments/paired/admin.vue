<template>
  <div class="min-h-screen w-full bg-gray-50 dark:bg-[#0C0A09]">
    <Header />
    
    <div class="pt-16">
      <main class="max-w-6xl mx-auto p-6">
        <!-- Page Header -->
        <div class="mb-8">
          <div class="flex items-center gap-3 mb-2">
            <UButton
              to="/experiments/paired"
              btn="link-gray"
              size="xs"
              leading="i-ph-arrow-left"
              class="px-0 hover:scale-102 active:scale-99 transition"
            >
              Back to Game
            </UButton>
          </div>
          <h1 class="text-3xl font-700 font-body text-gray-800 dark:text-gray-200 mb-2">
            Paired Game Admin
          </h1>
          <p class="text-gray-600 dark:text-gray-400">
            Manage topics and card pairs for the Paired memory card game
          </p>
        </div>

        <!-- Loading State -->
        <div v-if="isLoading" class="flex items-center justify-center py-12">
          <div class="text-center">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-4"></div>
            <p class="text-gray-600 dark:text-gray-400">Loading topics...</p>
          </div>
        </div>

        <!-- Main Content -->
        <div v-else class="space-y-6">
          <!-- Header with Search and Create Button -->
          <div class="space-y-4">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
              <h2 class="text-xl font-600 text-gray-800 dark:text-gray-200">
                <span v-if="searchQuery.trim()">
                  {{ filteredTopics.length }} of {{ topics.length }} topics
                </span>
                <span v-else>
                  Topics ({{ topics.length }})
                </span>
              </h2>
              <UButton
                @click="showCreateDialog = true"
                btn="solid-blue"
                leading="i-ph-plus"
              >
                Create New Topic
              </UButton>
            </div>

            <!-- Search Input -->
            <div class="relative max-w-md">
              <UInput
                v-model="searchQuery"
                placeholder="Search topics..."
                leading="i-ph-magnifying-glass"
                class="w-full"
                :trailing="searchQuery.trim() ? 'i-ph-x-bold' : undefined"
                @trailing="clearSearch"
                :una="{
                  inputTrailing: 'pointer-events-auto cursor-pointer',
                }"
              />
            </div>
          </div>

          <!-- Topics List -->
          <div v-if="filteredTopics.length > 0" class="space-y-4">
            <div
              v-for="topic in filteredTopics"
              :key="topic.id"
              class="bg-white dark:bg-[#0D0D0D] rounded-lg border border-gray-200 dark:border-gray-700"
            >
              <UCollapsible>
                <UCollapsibleTrigger class="w-full p-4 flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors">
                  <div class="flex items-center gap-3">
                    <UIcon :name="topic.icon || 'i-ph-cards'" class="text-lg" />
                    <span class="font-600 text-gray-800 dark:text-gray-200">
                      {{ topic.name }} ({{ topic.cardCount }} pairs)
                    </span>
                  </div>
                  <UIcon name="i-ph-caret-down" class="text-gray-500 transition-transform ui-open:rotate-180" />
                </UCollapsibleTrigger>

                <UCollapsibleContent>
                  <div class="border-t border-gray-200 dark:border-gray-700">
                    <TopicEditForm
                      :topic="topic"
                      :topic-id="topic.id"
                      @save="handleSaveTopic"
                      @delete="handleDeleteTopic"
                    />
                  </div>
                </UCollapsibleContent>
              </UCollapsible>
            </div>
          </div>

          <!-- Empty State -->
          <div v-else class="text-center py-12 bg-white dark:bg-[#0D0D0D] rounded-lg border border-gray-200 dark:border-gray-700">
            <!-- No search results -->
            <div v-if="searchQuery.trim() && topics.length > 0">
              <UIcon name="i-ph-magnifying-glass" class="text-6xl mb-4" />
              <h3 class="text-lg font-600 text-gray-800 dark:text-gray-200 mb-2">No topics found</h3>
              <p class="text-gray-600 dark:text-gray-400 mb-4">
                No topics match your search for "{{ searchQuery.trim() }}". Try a different search term.
              </p>
              <UButton
                @click="clearSearch"
                btn="soft-blue"
                leading="i-ph-x"
              >
                Clear Search
              </UButton>
            </div>

            <!-- No topics at all -->
            <div v-else>
              <div class="text-6xl mb-4">🎮</div>
              <h3 class="text-lg font-600 text-gray-800 dark:text-gray-200 mb-2">No topics found</h3>
              <p class="text-gray-600 dark:text-gray-400 mb-4">
                Create your first topic to get started with the Paired memory game.
              </p>
              <UButton
                @click="showCreateDialog = true"
                btn="solid-blue"
                leading="i-ph-plus"
              >
                Create First Topic
              </UButton>
            </div>
          </div>
        </div>
      </main>
    </div>

    <!-- Create Topic Dialog -->
    <UDialog
      v-model:open="showCreateDialog"
      title="Create New Topic"
      description="Add a new topic with card pairs for the Paired memory game."
      :ui="{ width: 'sm:max-w-4xl' }"
    >
      <TopicCreateForm
        @save="handleCreateTopic"
        @cancel="showCreateDialog = false"
      />
    </UDialog>

    <!-- Delete Confirmation Dialog -->
    <UDialog
      v-model:open="showDeleteDialog"
      title="Delete Topic"
      :description="`Are you sure you want to delete '${topicToDelete?.name}'? This action cannot be undone.`"
    >
      <template #footer>
        <div class="flex gap-2 justify-end">
          <UButton
            @click="showDeleteDialog = false"
            btn="ghost-gray"
          >
            Cancel
          </UButton>
          <UButton
            @click="confirmDeleteTopic"
            btn="solid-red"
            :loading="isDeleting"
          >
            Delete Topic
          </UButton>
        </div>
      </template>
    </UDialog>

    <UToaster />
  </div>
</template>

<script setup lang="ts">
import type { TopicData } from '~/types/paired'
import { generateTopicId } from '~/utils/paired-game-data'

// Page metadata
definePageMeta({
  middleware: 'admin'
})

useHead({
  title: "Paired Game Admin • experiments • rootasjey",
  meta: [
    {
      name: 'description',
      content: 'Admin interface for managing Paired memory card game topics and content',
    },
  ],
})

// Reactive state
const topics = ref<Array<{ id: string; name: string; description: string; cardCount: number; difficulty: string; icon: string; createdAt: string; updatedAt: string }>>([])
const isLoading = ref(true)
const showCreateDialog = ref(false)
const showDeleteDialog = ref(false)
const topicToDelete = ref<{ id: string; name: string } | null>(null)
const isDeleting = ref(false)
const searchQuery = ref('')

// Toast (using direct toast function like other parts of codebase)

// Computed properties
const filteredTopics = computed(() => {
  if (!searchQuery.value.trim()) {
    return topics.value
  }

  const query = searchQuery.value.toLowerCase().trim()
  return topics.value.filter(topic =>
    topic.name.toLowerCase().includes(query) ||
    topic.description.toLowerCase().includes(query) ||
    topic.difficulty.toLowerCase().includes(query)
  )
})

// Search functionality
const clearSearch = () => {
  searchQuery.value = ''
}

// Fetch topics
const fetchTopics = async () => {
  isLoading.value = true
  try {
    const response = await $fetch('/api/experiments/paired/topics') as any
    if (response.success) {
      topics.value = response.topics
    }
  } catch (error) {
    console.error('Error fetching topics:', error)
    toast({
      title: 'Error',
      description: 'Failed to load topics',
      toast: 'error',
      duration: 5000
    })
  } finally {
    isLoading.value = false
  }
}

// Handle create topic
const handleCreateTopic = async (topicData: TopicData & { name: string }) => {
  try {
    const topicId = generateTopicId(topicData.name)
    
    await $fetch('/api/experiments/paired/admin/topic', {
      method: 'POST',
      body: {
        id: topicId,
        ...topicData
      }
    })

    toast({
      title: 'Success',
      description: `Topic "${topicData.name}" created successfully`,
      toast: 'success',
      duration: 5000
    })

    showCreateDialog.value = false
    await fetchTopics()
  } catch (error: any) {
    console.error('Error creating topic:', error)
    toast({
      title: 'Error',
      description: error.data?.message || 'Failed to create topic',
      toast: 'error',
      duration: 5000
    })
  }
}

// Handle save topic
const handleSaveTopic = async (topicId: string, topicData: TopicData) => {
  try {
    await $fetch('/api/experiments/paired/admin/topic', {
      method: 'POST',
      body: {
        id: topicId,
        ...topicData
      }
    })

    toast({
      title: 'Success',
      description: `Topic "${topicData.name}" updated successfully`,
      toast: 'success',
      duration: 5000
    })

    await fetchTopics()
  } catch (error: any) {
    console.error('Error saving topic:', error)
    toast({
      title: 'Error',
      description: error.data?.message || 'Failed to save topic',
      toast: 'error',
      duration: 5000
    })
  }
}

// Handle delete topic
const handleDeleteTopic = (topicId: string, topicName: string) => {
  topicToDelete.value = { id: topicId, name: topicName }
  showDeleteDialog.value = true
}

// Confirm delete topic
const confirmDeleteTopic = async () => {
  if (!topicToDelete.value) return

  isDeleting.value = true
  try {
    await $fetch(`/api/experiments/paired/admin/topic/${topicToDelete.value.id}`, {
      method: 'DELETE'
    })

    toast({
      title: 'Success',
      description: `Topic "${topicToDelete.value.name}" deleted successfully`,
      toast: 'success',
      duration: 5000
    })

    showDeleteDialog.value = false
    topicToDelete.value = null
    await fetchTopics()
  } catch (error: any) {
    console.error('Error deleting topic:', error)
    toast({
      title: 'Error',
      description: error.data?.message || 'Failed to delete topic',
      toast: 'error',
      duration: 5000
    })
  } finally {
    isDeleting.value = false
  }
}

// Initialize
onMounted(() => {
  fetchTopics()
})
</script>
