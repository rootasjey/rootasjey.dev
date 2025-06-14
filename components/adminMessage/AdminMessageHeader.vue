<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg p-6 mb-6 border border-gray-200 dark:border-gray-700">
    <!-- Stats Row -->
    <div class="flex flex-wrap items-center justify-between gap-4 mb-6">
      <div class="w-full flex justify-around">
        <div class="text-center">
          <div class="text-size-24 font-200 text-#525FE1 dark:text-white">{{ totalMessages }}</div>
          <div class="text-sm font-600 text-gray-600 dark:text-gray-400">Total Messages</div>
        </div>
        <div class="text-center">
          <div class="text-size-24 font-200 text-#09A8FA">{{ unreadCount }}</div>
          <div class="text-sm font-600 text-gray-600 dark:text-gray-400">Unread</div>
        </div>
        <div class="text-center">
          <div class="text-size-24 font-200 text-#616EEF">{{ selectedCount }}</div>
          <div class="text-sm font-600 text-gray-600 dark:text-gray-400">Selected</div>
        </div>
      </div>
    </div>

    <!-- Search and Filters Row -->
    <div class="flex flex-wrap gap-4 mb-4">
      <div class="flex-1 min-w-64">
        <UInput
          v-model="searchQuery"
          placeholder="Search messages..."
          @keyup.enter="handleSearch"
          @input="debouncedSearch"
        >
          <template #leading>
            <span class="i-ph-magnifying-glass"></span>
          </template>
        </UInput>
      </div>
      
      <USelect
        v-model="readFilter"
        :items="readFilterOptions"
        @update:model-value="handleFilterChange"
        placeholder="Filter by status"
        item-key="label"
        value-key="label"
      />
    </div>

    <!-- Bulk Actions Row -->
    <div class="flex flex-wrap gap-2 pt-4 border-t b-dashed border-gray-200 dark:border-gray-700">
      <UTooltip>
        <template #default>
          <UButton 
            @click="$emit('refresh')" 
            :loading="isLoading"
            btn="soft-indigo"
            size="sm"
          >
            <span class="i-ph-arrow-clockwise mr-2"></span>
            <span class="hidden md:inline">Refresh</span>
          </UButton>
        </template>
        <template #content>
          <div class="px-3 py-1">Refresh data</div>
        </template>
      </UTooltip>

      <div v-if="selectedCount > 0" class="flex flex-wrap gap-2">
        <UTooltip>
          <template #default>
            <UButton
              @click="$emit('bulk-action', 'mark_read')"
              size="sm"
              btn="soft"
            >
              <span class="i-ph-check mr-2"></span>
              <span class="hidden md:inline">Mark Read </span>
              <span>({{ selectedCount }})</span>
            </UButton>
          </template>
          <template #content>
            <div class="px-3 py-1">Mark {{ selectedCount }} selected messages as read</div>
          </template>
        </UTooltip>
        
        <UTooltip>
          <template #default>
            <UButton
              @click="$emit('bulk-action', 'mark_unread')"
              size="sm"
              btn="soft-gray"
            >
              <span class="i-ph-circle mr-2"></span>
              <span class="hidden md:inline">Mark Unread </span>
              <span>({{ selectedCount }})</span>
            </UButton>
          </template>
          <template #content>
            <div class="px-3 py-1">Mark {{ selectedCount }} selected messages as unread</div>
          </template>
        </UTooltip>
        
        <UTooltip>
          <template #default>
            <UButton
              @click="$emit('bulk-action', 'confirm_delete')"
              size="sm"
              btn="soft-pink"
            >
              <span class="i-ph-trash mr-2"></span>
              <span class="hidden md:inline">Delete </span>
              <span>({{ selectedCount }})</span>
            </UButton>
          </template>
          <template #content>
            <div class="px-3 py-1">Delete {{ selectedCount }} selected messages</div>
          </template>
        </UTooltip>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
interface Props {
  totalMessages: number
  unreadCount: number
  selectedCount: number
  isLoading: boolean
}

interface ReadFilterOption {
  label: string
  value: boolean | undefined
}

interface Emits {
  (e: 'refresh'): void
  (e: 'bulk-action', action: 'mark_read' | 'mark_unread' | 'confirm_delete' | 'delete'): void
  (e: 'search', query: string): void
  (e: 'filter-change', filterType: string, value: any): void
}

defineProps<Props>()
const emit = defineEmits<Emits>()

// Local state
const searchQuery = ref('')
const readFilter = ref<string | undefined>(undefined)

const readFilterOptions = [
  { label: 'All Messages', value: undefined },
  { label: 'Unread Only', value: 'false' },
  { label: 'Read Only', value: 'true' }
]

// Debounced search
let searchTimeout: NodeJS.Timeout
const debouncedSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    handleSearch()
  }, 500)
}

const handleSearch = () => {
  emit('search', searchQuery.value)
}

const handleFilterChange = () => {
  const selectedFilter = readFilter.value as unknown as ReadFilterOption
  const filterValue = selectedFilter.value === undefined ? undefined : selectedFilter.value
  emit('filter-change', 'read', filterValue)
}
</script>
