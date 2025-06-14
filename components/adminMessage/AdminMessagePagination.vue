<template>
  <div class="flex items-center justify-between bg-white dark:bg-gray-800 rounded-lg p-4 border border-gray-200 dark:border-gray-700 mt-6">
    <!-- Results Info -->
    <div class="text-sm text-gray-600 dark:text-gray-400">
      Showing {{ startItem }} to {{ endItem }} of {{ pagination.total }} messages
    </div>

    <!-- Pagination Controls -->
    <div class="flex items-center gap-2">
      <!-- First Page -->
      <UButton
        @click="$emit('page-change', 1)"
        :disabled="!pagination.hasPrev"
        size="sm"
        btn="ghost"
        title="First page"
      >
        <span class="i-ph-caret-double-left"></span>
      </UButton>

      <!-- Previous Page -->
      <UButton
        @click="$emit('page-change', pagination.page - 1)"
        :disabled="!pagination.hasPrev"
        size="sm"
        btn="ghost"
        title="Previous page"
      >
        <span class="i-ph-caret-left"></span>
      </UButton>

      <!-- Page Numbers -->
      <div class="flex items-center gap-1">
        <template v-for="page in visiblePages" :key="page">
          <span
            v-if="page === '...'"
            class="px-2 py-1 text-gray-500 dark:text-gray-400"
          >
            ...
          </span>
          <UButton
            v-else
            @click="$emit('page-change', typeof page === 'number' ? page : -1)"
            :btn="page === pagination.page ? 'solid' : 'ghost'"
            size="sm"
            class="min-w-8"
          >
            {{ page }}
          </UButton>
        </template>
      </div>

      <!-- Next Page -->
      <UButton
        @click="$emit('page-change', pagination.page + 1)"
        :disabled="!pagination.hasNext"
        size="sm"
        btn="ghost"
        title="Next page"
      >
        <span class="i-ph-caret-right"></span>
      </UButton>

      <!-- Last Page -->
      <UButton
        @click="$emit('page-change', pagination.totalPages)"
        :disabled="!pagination.hasNext"
        size="sm"
        btn="ghost"
        title="Last page"
      >
        <span class="i-ph-caret-double-right"></span>
      </UButton>
    </div>

    <!-- Items per page selector -->
    <div class="flex items-center gap-2">
      <span class="text-sm text-gray-600 dark:text-gray-400">Per page:</span>
      <USelect
        :model-value="pagination.limit"
        :options="limitOptions"
        @change="handleLimitChange"
        size="sm"
        class="w-20"
      />
    </div>
  </div>
</template>

<script lang="ts" setup>
interface Pagination {
  page: number
  limit: number
  total: number
  totalPages: number
  hasNext: boolean
  hasPrev: boolean
}

interface Props {
  pagination: Pagination
}

interface Emits {
  (e: 'page-change', page: number): void
  (e: 'limit-change', limit: number): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// Items per page options
const limitOptions = [
  { label: '10', value: 10 },
  { label: '20', value: 20 },
  { label: '50', value: 50 },
  { label: '100', value: 100 }
]

// Computed properties
const startItem = computed(() => {
  return (props.pagination.page - 1) * props.pagination.limit + 1
})

const endItem = computed(() => {
  const end = props.pagination.page * props.pagination.limit
  return Math.min(end, props.pagination.total)
})

const visiblePages = computed(() => {
  const current = props.pagination.page
  const total = props.pagination.totalPages
  const delta = 2 // Number of pages to show on each side of current page
  
  if (total <= 7) {
    // Show all pages if total is small
    return Array.from({ length: total }, (_, i) => i + 1)
  }
  
  const pages: (number | string)[] = []
  
  // Always show first page
  pages.push(1)
  
  // Calculate start and end of middle section
  let start = Math.max(2, current - delta)
  let end = Math.min(total - 1, current + delta)
  
  // Adjust if we're near the beginning
  if (current <= delta + 2) {
    end = Math.min(total - 1, 2 * delta + 2)
  }
  
  // Adjust if we're near the end
  if (current >= total - delta - 1) {
    start = Math.max(2, total - 2 * delta - 1)
  }
  
  // Add ellipsis after first page if needed
  if (start > 2) {
    pages.push('...')
  }
  
  // Add middle pages
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  
  // Add ellipsis before last page if needed
  if (end < total - 1) {
    pages.push('...')
  }
  
  // Always show last page (if it's not the first page)
  if (total > 1) {
    pages.push(total)
  }
  
  return pages
})

// Event handlers
const handleLimitChange = (newLimit: number) => {
  emit('limit-change', newLimit)
}
</script>