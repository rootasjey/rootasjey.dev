<template>
  <UDialog v-model:open="showLocal" title="Tag Management" description="Manage your post tags">
    <div class="space-y-4">
      <!-- Tag Statistics -->
      <div class="grid grid-cols-2 gap-4">
        <div class="bg-gray-50 dark:bg-gray-800 p-3 rounded-lg">
          <div class="text-sm font-medium text-gray-700 dark:text-gray-300">Total Tags</div>
          <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ tagStats.total }}</div>
        </div>
        <div class="bg-gray-50 dark:bg-gray-800 p-3 rounded-lg">
          <div class="text-sm font-medium text-gray-700 dark:text-gray-300">Custom Tags</div>
          <div class="text-2xl font-bold text-gray-900 dark:text-white">{{ tagStats.custom }}</div>
        </div>
      </div>

      <!-- Add New Tag Section -->
      <UCollapsible>
        <UCollapsibleTrigger class="group flex items-center gap-2 w-full p-3 border border-gray-200 dark:border-gray-700 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors">
          <span class="i-ph-plus-bold text-xs text-gray-600 dark:text-gray-400"></span>
          <span class="text-xs font-medium text-gray-700 dark:text-gray-300">Add New Tag</span>
          <span class="i-lucide-chevron-down text-xs text-gray-600 dark:text-gray-400 ml-auto transition-transform duration-200 group-data-[state=open]:rotate-180"></span>
        </UCollapsibleTrigger>
        <UCollapsibleContent class="mt-2">
          <div class="border border-gray-200 dark:border-gray-700 rounded-lg p-4">
            <div class="flex gap-2">
              <UInput
                v-model="newTagName"
                placeholder="Tag name"
                class="flex-1"
                size="xs"
                :disabled="isCreatingTag"
              />
              <USelect
                v-model="newTagCategory"
                :items="categoryOptions"
                item-key="label"
                value-key="label"
                label="Tag Category"
                placeholder="Category"
                class="w-32"
                size="xs"
                :disabled="isCreatingTag"
              />
              <UButton
                @click="handleCreateTag"
                :loading="isCreatingTag"
                :disabled="!newTagName.trim()"
                btn="solid-gray"
                size="xs"
                class="px-6"
              >
                Add
              </UButton>
            </div>
          </div>
        </UCollapsibleContent>
      </UCollapsible>

      <!-- Tags -->
      <div v-if="tags.length > 0">
        <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Tags</h4>
        <div class="flex flex-wrap gap-2">
          <UBadge
            v-for="tag in tags"
            :key="tag.id"
            :badge="tag.isUsed ? 'soft-green' : 'soft-gray'"
            size="xs"
            closable
            class="cursor-pointer rounded-full"
            @click.self="handleEditTag(tag)"
            @close="handleDeleteTag(tag)"
          >
            {{ tag.isUsed ? `${tag.name} (${tag.count})` : tag.name }}
          </UBadge>
        </div>
      </div>
    </div>

    <template #footer>
      <div class="flex gap-2 justify-end mt-4">
        <UButton
          v-if="tags.some(tag => !tag.isUsed)"
          btn="ghost-gray"
          size="xs"
          @click="handleClearUnusedTags"
          :loading="isClearingUnused"
        >
          Clear Unused Tags
        </UButton>
        <UButton
          @click="handleExportTags"
          btn="ghost-gray"
          size="xs"
          label="Export Tags"
          :loading="isExporting"
        />
        <UButton
          @click="showLocal = false"
          btn="soft-blue"
          size="xs"
          label="Close"
          class="px-6"
        />
      </div>
    </template>

    <!-- Edit Tag Dialog -->
    <UDialog v-model:open="showEditDialog" title="Edit Tag" description="Update tag name and category">
      <div class="space-y-4">
        <UInput
          v-model="editingTagName"
          label="Tag Name"
          placeholder="Enter tag name"
        />
        <USelect
          v-model="editingTagCategory"
          label="Tag Category"
          :items="categoryOptions"
          item-key="label"
          value-key="label"
          placeholder="Select category"
        />
      </div>
      <template #footer>
        <div class="w-full flex gap-2 justify-between">
          <UButton
            @click="editingTag && handleDeleteTag(editingTag)"
            btn="link-pink"
            size="xs"
            label="Delete Tag"
            :loading="isDeletingTag"
            :disabled="isUpdatingTag || !editingTag"
          />
          <div class="flex gap-2">
            <UButton
              @click="showEditDialog = false"
              btn="ghost-gray"
              label="Cancel"
              size="xs"
            />
            <UButton
              @click="handleUpdateTag"
              btn="solid-black"
              size="xs"
              label="Update Tag"
              :loading="isUpdatingTag"
              :disabled="!editingTagName.trim()"
            />
          </div>
        </div>
      </template>
    </UDialog>

    <!-- Delete Confirmation Dialog -->
    <UDialog v-model:open="showDeleteDialog" title="Delete Tag" description="Are you sure you want to delete this tag?">
      <div class="space-y-4">
        <p class="text-sm text-gray-600 dark:text-gray-400">
          This will permanently delete the tag "{{ deletingTag?.name }}" and remove it from all posts.
          This action cannot be undone.
        </p>
        <div v-if="deletingTagUsage > 0" class="p-3 bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-md">
          <p class="text-sm text-yellow-700 dark:text-yellow-300">
            This tag is currently used in {{ deletingTagUsage }} post{{ deletingTagUsage === 1 ? '' : 's' }}.
          </p>
        </div>
      </div>
      <template #footer>
        <div class="flex gap-2 justify-end">
          <UButton 
            @click="showDeleteDialog = false" 
            btn="ghost" 
            label="Cancel"
            size="xs"
          />
          <UButton 
            @click="handleConfirmDelete" 
            btn="soft-red"
            size="xs"
            label="Delete Tag"
            :loading="isDeletingTag"
          />
        </div>
      </template>
    </UDialog>

    <!-- Category Creation Dialog -->
    <UDialog v-model:open="showCategoryDialog" title="Add New Category" description="Create a new category for organizing your tags">
      <div class="space-y-4">
        <UInput
          v-model="newCategoryName"
          label="Category Name"
          placeholder="Enter category name"
          :error="categoryError"
          @keyup.enter="handleCreateCategory"
        />
        <div v-if="categoryError" class="text-sm text-red-600 dark:text-red-400">
          {{ categoryError }}
        </div>
      </div>
      <template #footer>
        <div class="flex gap-2 justify-end">
          <UButton
            @click="handleCancelCategoryCreation"
            btn="ghost"
            label="Cancel"
            size="xs"
          />
          <UButton
            @click="handleCreateCategory"
            btn="solid"
            label="Add Category"
            size="xs"
            :loading="isCreatingCategory"
            :disabled="!newCategoryName.trim()"
          />
        </div>
      </template>
    </UDialog>
  </UDialog>
</template>

<script lang="ts" setup>
import type { ApiTag } from '~/types/tag'
import type { Post } from '~/types/post'

interface Props {
  open: boolean
  posts: Post[]
}

interface Emits {
  (e: 'update:open', value: boolean): void
  (e: 'tags-updated'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// Local state management
const showLocal = computed({
  get: () => props.open,
  set: (value) => emit('update:open', value)
})

// Tag management state
const tagsStore = useTagsStore()
const { toast } = useToast()
const newTagName = ref('')
const newTagCategory = ref({ label: 'General', value: 'general' })
const isCreatingTag = ref(false)
const isClearingUnused = ref(false)
const isExporting = ref(false)

// Edit tag state
const showEditDialog = ref(false)
const editingTag = ref<ApiTag | null>(null)
const editingTagName = ref('')
const editingTagCategory = ref('')
const isUpdatingTag = ref(false)

// Delete tag state
const showDeleteDialog = ref(false)
const deletingTag = ref<ApiTag | null>(null)
const isDeletingTag = ref(false)

// Category creation state
const showCategoryDialog = ref(false)
const newCategoryName = ref('')
const isCreatingCategory = ref(false)
const categoryError = ref('')
const previousCategoryValue = ref({ label: 'General', value: 'general' })

// Category options (reactive for dynamic additions)
const baseCategoryOptions = [
  { label: 'General', value: 'general' },
  { label: 'Custom', value: 'custom' },
  { label: 'Primary', value: 'primary' },
  { label: 'Technology', value: 'technology' },
  { label: 'Design', value: 'design' },
  { label: 'Business', value: 'business' }
]

const customCategories = ref<Array<{ label: string; value: string }>>([])

const categoryOptions = computed(() => [
  ...baseCategoryOptions,
  ...customCategories.value,
  { label: '+ Add New Category', value: '__add_new__', class: 'text-blue-600 dark:text-blue-400 font-medium' }
])

// Computed properties
const tagStats = computed(() => {
  const all = tagsStore.allTags
  return {
    total: all.length,
    custom: all.filter(t => t.category === 'custom').length,
  }
})

const tags = computed(() => {
  // Count tag usage in all posts
  const tagCounts: Record<number, number> = {}
  props.posts.forEach(post => {
    post.tags?.forEach(tag => {
      tagCounts[tag.id] = (tagCounts[tag.id] || 0) + 1
    })
  })

  // Return all tags with usage information
  return tagsStore.allTags
    .map(tag => {
      const count = tagCounts[tag.id] || 0
      return {
        ...tag,
        count,
        isUsed: count > 0
      }
    })
    .sort((a, b) => {
      // Sort by usage (used tags first), then by count (descending), then by name
      if (a.isUsed && !b.isUsed) return -1
      if (!a.isUsed && b.isUsed) return 1
      if (a.isUsed && b.isUsed) return b.count - a.count
      return a.name.localeCompare(b.name)
    })
})

const deletingTagUsage = computed(() => {
  if (!deletingTag.value) return 0
  return getTagUsage(deletingTag.value)
})

// Methods
const getTagUsage = (tag: ApiTag) => {
  return props.posts.reduce((acc, post) => acc + (post.tags?.some(t => t.id === tag.id) ? 1 : 0), 0)
}

const handleCreateTag = async () => {
  if (!newTagName.value.trim()) return

  isCreatingTag.value = true
  try {
    await tagsStore.createTag(newTagName.value.trim(), newTagCategory.value.value)
    newTagName.value = ''
    newTagCategory.value = { label: 'General', value: 'general' }
    emit('tags-updated')
  } catch (error: any) {
    toast({
      title: 'Failed to create tag',
      description: error?.message || 'Unknown error occurred',
      duration: 5000,
      showProgress: true,
      toast: 'soft-error'
    })
  } finally {
    isCreatingTag.value = false
  }
}

const handleEditTag = (tag: ApiTag) => {
  editingTag.value = tag
  editingTagName.value = tag.name
  editingTagCategory.value = tag.category
  showEditDialog.value = true
}

const handleUpdateTag = async () => {
  if (!editingTag.value || !editingTagName.value.trim()) return

  isUpdatingTag.value = true
  try {
    await tagsStore.updateTag(editingTag.value.id, editingTagName.value.trim(), editingTagCategory.value)
    showEditDialog.value = false
    editingTag.value = null
    emit('tags-updated')
  } catch (error: any) {
    toast({
      title: 'Failed to update tag',
      description: error?.message || 'Unknown error occurred',
      duration: 5000,
      showProgress: true,
      toast: 'soft-error'
    })
  } finally {
    isUpdatingTag.value = false
  }
}

const handleDeleteTag = (tag: ApiTag) => {
  deletingTag.value = tag
  showDeleteDialog.value = true
}

const handleConfirmDelete = async () => {
  if (!deletingTag.value) return

  isDeletingTag.value = true
  try {
    await tagsStore.deleteTag(deletingTag.value.id)
    showDeleteDialog.value = false
    deletingTag.value = null
    emit('tags-updated')
  } catch (error: any) {
    toast({
      title: 'Failed to delete tag',
      description: error?.message || 'Unknown error occurred',
      duration: 5000,
      showProgress: true,
      toast: 'soft-error'
    })
  } finally {
    isDeletingTag.value = false
  }
}

const handleClearUnusedTags = async () => {
  const confirmClear = confirm('Remove all unused tags? This action cannot be undone.')
  if (!confirmClear) return

  isClearingUnused.value = true
  const unused = tags.value.filter(tag => !tag.isUsed)

  try {
    for (const tag of unused) {
      await tagsStore.deleteTag(tag.id)
    }
    emit('tags-updated')
  } catch (error: any) {
    toast({
      title: 'Failed to clear unused tags',
      description: error?.message || 'Unknown error occurred',
      duration: 5000,
      showProgress: true,
      toast: 'soft-error'
    })
  } finally {
    isClearingUnused.value = false
  }
}

const handleExportTags = () => {
  isExporting.value = true
  try {
    const exportData = tagsStore.allTags
    const blob = new Blob([JSON.stringify(exportData, null, 2)], {
      type: 'application/json'
    })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `tags-export-${new Date().toISOString().split('T')[0]}.json`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
  } catch (error: any) {
    toast({
      title: 'Failed to export tags',
      description: error?.message || 'Unknown error occurred',
      duration: 5000,
      showProgress: true,
      toast: 'soft-error'
    })
  } finally {
    isExporting.value = false
  }
}

// Category creation methods
const validateCategoryName = (name: string): string => {
  if (!name.trim()) {
    return 'Category name is required'
  }

  const normalizedName = name.trim().toLowerCase()
  const existingCategories = [
    ...baseCategoryOptions.map(cat => cat.value.toLowerCase()),
    ...customCategories.value.map(cat => cat.value.toLowerCase())
  ]

  if (existingCategories.includes(normalizedName)) {
    return 'Category already exists'
  }

  return ''
}

const handleCreateCategory = async () => {
  categoryError.value = validateCategoryName(newCategoryName.value)
  if (categoryError.value) return

  isCreatingCategory.value = true
  try {
    const categoryValue = newCategoryName.value.trim().toLowerCase()
    const categoryLabel = newCategoryName.value.trim()

    // Add to custom categories
    customCategories.value.push({
      label: categoryLabel,
      value: categoryValue
    })

    // Select the new category
    newTagCategory.value = { label: categoryLabel, value: categoryValue }

    // Close modal and reset
    showCategoryDialog.value = false
    newCategoryName.value = ''
    categoryError.value = ''

    toast({
      title: 'Category created successfully',
      description: `"${categoryLabel}" category has been added`,
      duration: 3000,
      showProgress: true,
      toast: 'soft-success'
    })
  } catch (error: any) {
    toast({
      title: 'Failed to create category',
      description: error?.message || 'Unknown error occurred',
      duration: 5000,
      showProgress: true,
      toast: 'soft-error'
    })
  } finally {
    isCreatingCategory.value = false
  }
}

const handleCancelCategoryCreation = () => {
  showCategoryDialog.value = false
  newCategoryName.value = ''
  categoryError.value = ''
  // Keep the previous category selection
}

// Watch for category selection changes
watch(newTagCategory, (newValue, oldValue) => {
  if (newValue.value === '__add_new__') {
    previousCategoryValue.value = oldValue
    showCategoryDialog.value = true
    // Reset the select to previous value temporarily
    nextTick(() => {
      newTagCategory.value = previousCategoryValue.value
    })
  }
})

// Initialize tags when component is mounted
onMounted(async () => {
  await tagsStore.fetchTags()
})
</script>
