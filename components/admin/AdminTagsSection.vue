<template>
  <div class="p-6">
    <!-- Header with Actions -->
    <div class="flex items-center justify-between mb-6">
      <div>
        <h2 class="text-2xl font-600 font-body text-gray-800 dark:text-gray-200 mb-2">
          Tags Management
        </h2>
        <p class="text-gray-600 dark:text-gray-400">
          Manage tags and categories across your application
        </p>
      </div>
      
      <div class="flex items-center gap-3">
        <!-- Search -->
        <UInput
          v-model="searchQuery"
          placeholder="Search tags..."
          leading="i-ph-magnifying-glass"
          class="w-64"
        />
        
        <!-- Create Tag Button -->
        <UButton
          @click="showCreateDialog = true"
          btn="soft-purple"
          size="sm"
          class="hover:scale-102 active:scale-99 transition"
        >
          <span class="i-ph-plus mr-2"></span>
          Create Tag
        </UButton>
      </div>
    </div>

    <!-- Tag Statistics -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
      <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
        <div class="flex items-center justify-between">
          <div class="i-ph-tag text-purple-500 text-xl"></div>
          <div class="text-2xl font-700 text-gray-800 dark:text-gray-200">
            {{ stats.total }}
          </div>
        </div>
        <div class="text-sm text-gray-600 dark:text-gray-400 mt-2">
          Total Tags
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
        <div class="flex items-center justify-between">
          <div class="i-ph-check-circle text-green-500 text-xl"></div>
          <div class="text-2xl font-700 text-gray-800 dark:text-gray-200">
            {{ stats.used }}
          </div>
        </div>
        <div class="text-sm text-gray-600 dark:text-gray-400 mt-2">
          Used Tags
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
        <div class="flex items-center justify-between">
          <div class="i-ph-circle text-gray-400 text-xl"></div>
          <div class="text-2xl font-700 text-gray-800 dark:text-gray-200">
            {{ stats.unused }}
          </div>
        </div>
        <div class="text-sm text-gray-600 dark:text-gray-400 mt-2">
          Unused Tags
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
        <div class="flex items-center justify-between">
          <div class="i-ph-folder text-blue-500 text-xl"></div>
          <div class="text-2xl font-700 text-gray-800 dark:text-gray-200">
            {{ stats.categories }}
          </div>
        </div>
        <div class="text-sm text-gray-600 dark:text-gray-400 mt-2">
          Categories
        </div>
      </div>
    </div>

    <!-- Tags List -->
    <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg">
      <div class="p-4 border-b border-gray-200 dark:border-gray-700">
        <h3 class="font-600 text-gray-800 dark:text-gray-200">
          All Tags
        </h3>
      </div>
      
      <div v-if="loading" class="p-4">
        <div class="space-y-3">
          <div v-for="i in 8" :key="i" class="animate-pulse flex items-center gap-4">
            <div class="w-8 h-8 bg-gray-200 dark:bg-gray-700 rounded-full"></div>
            <div class="flex-1 space-y-2">
              <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/4"></div>
              <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded w-1/6"></div>
            </div>
            <div class="h-6 w-12 bg-gray-200 dark:bg-gray-700 rounded"></div>
          </div>
        </div>
      </div>
      
      <div v-else-if="filteredTags.length === 0" class="p-8 text-center">
        <div class="i-ph-tag text-4xl text-gray-400 mb-4"></div>
        <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
          No Tags Found
        </h3>
        <p class="text-gray-500 dark:text-gray-400">
          {{ searchQuery ? 'Try adjusting your search terms.' : 'Create your first tag to get started.' }}
        </p>
      </div>
      
      <div v-else class="divide-y divide-gray-200 dark:divide-gray-700">
        <div 
          v-for="tag in filteredTags" 
          :key="tag.id"
          class="p-4 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
              <div 
                :class="tag.isUsed ? 'text-green-500' : 'text-gray-400'"
                class="i-ph-tag text-xl"
              ></div>
              
              <div>
                <div class="flex items-center gap-2">
                  <h4 class="font-600 text-gray-800 dark:text-gray-200">
                    {{ tag.name }}
                  </h4>
                  <span 
                    class="px-2 py-1 text-xs font-500 rounded-full bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-300"
                  >
                    {{ tag.category }}
                  </span>
                </div>
                <p class="text-sm text-gray-500 dark:text-gray-400">
                  Used {{ tag.count }} time{{ tag.count === 1 ? '' : 's' }}
                </p>
              </div>
            </div>
            
            <div class="flex items-center gap-2">
              <UTooltip content="Edit tag">
                <UButton
                  @click="handleEditTag(tag)"
                  icon
                  btn="ghost-gray"
                  size="xs"
                  class="i-ph-pencil"
                />
              </UTooltip>
              
              <UTooltip content="Delete tag">
                <UButton
                  @click="handleDeleteTag(tag)"
                  icon
                  btn="ghost-red"
                  size="xs"
                  class="i-ph-trash"
                />
              </UTooltip>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Create Tag Dialog -->
    <UDialog v-model:open="showCreateDialog" title="Create Tag" description="Add a new tag to your system">
      <div class="space-y-4">
        <div>
          <ULabel for="tag-name">Tag Name</ULabel>
          <UInput
            id="tag-name"
            v-model="newTag.name"
            placeholder="Enter tag name"
          />
        </div>
        
        <div>
          <ULabel for="tag-category">Category</ULabel>
          <UInput
            id="tag-category"
            v-model="newTag.category"
            placeholder="Enter category (optional)"
          />
        </div>
      </div>

      <template #footer>
        <div class="flex gap-2 justify-end">
          <UButton 
            @click="showCreateDialog = false" 
            btn="ghost-gray" 
            label="Cancel"
          />
          <UButton 
            @click="handleCreateTag" 
            btn="soft-purple"
            :loading="isCreating"
            :disabled="!newTag.name || isCreating"
            label="Create Tag"
          />
        </div>
      </template>
    </UDialog>
  </div>
</template>

<script setup lang="ts">
import type { TagUsageStats, TagWithUsage } from '~/types/tag'

// Data
const searchQuery = ref('')
const tags = ref<TagWithUsage[]>([])
const loading = ref(true)
const showCreateDialog = ref(false)
const isCreating = ref(false)

const newTag = ref({
  name: '',
  category: 'general'
})

const stats: Ref<TagUsageStats> = ref({
  total: 0,
  used: 0,
  unused: 0,
  categories: 0
})

// Computed
const filteredTags = computed(() => {
  if (!searchQuery.value) return tags.value
  
  const query = searchQuery.value.toLowerCase()
  return tags.value.filter(tag => 
    tag.name.toLowerCase().includes(query) ||
    tag.category.toLowerCase().includes(query)
  )
})

// Methods
const handleEditTag = (tag: TagWithUsage) => {
  console.log('Edit tag:', tag)
}

const handleDeleteTag = (tag: TagWithUsage) => {
  console.log('Delete tag:', tag)
}

const handleCreateTag = async () => {
  if (!newTag.value.name) return
  
  try {
    isCreating.value = true
    await $fetch('/api/tags', {
      method: 'POST',
      body: newTag.value
    })
    
    showCreateDialog.value = false
    newTag.value = { name: '', category: 'general' }
    await fetchTags()
  } catch (error) {
    console.error('Error creating tag:', error)
  } finally {
    isCreating.value = false
  }
}

// Data fetching
const fetchTags = async () => {
  try {
    loading.value = true
    const response = await $fetch('/api/admin/tags/with-usage')
    tags.value = (response.tags as unknown as TagWithUsage[]) || []
    stats.value = (response.stats as TagUsageStats) || { total: 0, used: 0, unused: 0, categories: 0 }
  } catch (error) {
    console.error('Error fetching tags:', error)
  } finally {
    loading.value = false
  }
}

// Initialize
onMounted(() => {
  fetchTags()
})
</script>
