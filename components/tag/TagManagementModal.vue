<template>
  <UDialog v-model:open="showLocal" title="Tag Management" description="Manage your post tags">
    <div class="space-y-4">
      <!-- Tag Statistics -->
      <TagStatistics :stats="tagManagement.tagStats.value" />

      <!-- Add New Tag Section -->
      <TagCreationForm
        v-model:tag-name="tagManagement.newTagName.value"
        v-model:tag-category="tagManagement.newTagCategory.value"
        :category-options="tagManagement.categoryOptions.value"
        :is-creating="tagManagement.isCreatingTag.value"
        @create="handleCreateTag"
      />

      <!-- Tags List -->
      <TagList
        :tags="tagManagement.tagsWithUsage.value"
        @edit="handleEditTag"
        @delete="handleDeleteTag"
      />
    </div>

    <template #footer>
      <div class="flex gap-2 justify-end mt-4">
        <UButton
          v-if="tagManagement.tagsWithUsage.value.some(tag => !tag.isUsed)"
          btn="ghost-gray"
          size="xs"
          @click="handleClearUnusedTags"
          :loading="tagManagement.isClearingUnused.value"
        >
          Clear Unused Tags
        </UButton>
        <UButton
          @click="handleExportTags"
          btn="ghost-gray"
          size="xs"
          label="Export Tags"
          :loading="tagManagement.isExporting.value"
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
    <TagEditDialog
      v-model:open="showEditDialog"
      v-model:tag-name="tagManagement.editingTagName.value"
      v-model:tag-category="tagManagement.editingTagCategory.value"
      :category-options="tagManagement.categoryOptions.value"
      :is-updating-tag="tagManagement.isUpdatingTag.value"
      :is-deleting-tag="tagManagement.isDeletingTag.value"
      @update="handleUpdateTag"
      @delete="handleDeleteFromEdit"
    />

    <!-- Delete Confirmation Dialog -->
    <TagDeleteConfirmation
      v-model:open="showDeleteDialog"
      :tag-name="tagManagement.deletingTag.value?.name || ''"
      :usage-count="tagManagement.deletingTagUsage.value"
      :is-deleting="tagManagement.isDeletingTag.value"
      @confirm="handleConfirmDelete"
    />

    <!-- Category Creation Dialog -->
    <TagCategoryManagementModal
      v-model:open="showCategoryDialog"
      v-model:category-name="newCategoryName"
      v-model:error="categoryError"
      :is-creating="isCreatingCategory"
      :existing-categories="tagManagement.categoryOptions.value"
      @create="handleCreateCategory"
    />
  </UDialog>
</template>

<script lang="ts" setup>
import type { Post } from '~/types/post'
import type { CategoryOption } from '~/composables/useTagManagement'
import { useTagManagement } from '~/composables/useTagManagement'

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

// Use the tag management composable
const tagManagement = useTagManagement(toRef(props, 'posts'))

// Dialog states
const showEditDialog = ref(false)
const showDeleteDialog = ref(false)
const showCategoryDialog = ref(false)

// Category creation state (still needed for the dialog)
const newCategoryName = ref('')
const isCreatingCategory = ref(false)
const categoryError = ref('')
const previousCategoryValue = ref<CategoryOption>({ label: 'General', value: 'general' })

// Event handlers
const handleCreateTag = async () => {
  const success = await tagManagement.createTag()
  if (success) {
    emit('tags-updated')
  }
}

const handleEditTag = (tag: any) => {
  tagManagement.startEditingTag(tag)
  showEditDialog.value = true
}

const handleUpdateTag = async () => {
  const success = await tagManagement.updateTag()
  if (success) {
    showEditDialog.value = false
    emit('tags-updated')
  }
}

const handleDeleteTag = (tag: any) => {
  tagManagement.startDeletingTag(tag)
  showDeleteDialog.value = true
}

const handleDeleteFromEdit = () => {
  if (tagManagement.editingTag.value) {
    tagManagement.startDeletingTag(tagManagement.editingTag.value)
    showEditDialog.value = false
    showDeleteDialog.value = true
  }
}

const handleConfirmDelete = async () => {
  const success = await tagManagement.deleteTag()
  if (success) {
    showDeleteDialog.value = false
    emit('tags-updated')
  }
}

const handleClearUnusedTags = async () => {
  const success = await tagManagement.clearUnusedTags()
  if (success) {
    emit('tags-updated')
  }
}

const handleExportTags = async () => {
  await tagManagement.exportTags()
}

// Category creation methods
const handleCreateCategory = async () => {
  const categoryValue = newCategoryName.value.trim().toLowerCase()
  const categoryLabel = newCategoryName.value.trim()

  isCreatingCategory.value = true
  try {
    // Add to custom categories in the composable
    tagManagement.addCustomCategory({
      label: categoryLabel,
      value: categoryValue
    })

    // Select the new category
    tagManagement.newTagCategory.value = { label: categoryLabel, value: categoryValue }

    // Close modal and reset
    showCategoryDialog.value = false
    newCategoryName.value = ''
    categoryError.value = ''
  } catch (error: any) {
    categoryError.value = 'Failed to create category'
  } finally {
    isCreatingCategory.value = false
  }
}

// Watch for category selection changes
watch(() => tagManagement.newTagCategory.value, (newValue, oldValue) => {
  if (newValue.value === '__add_new__') {
    previousCategoryValue.value = oldValue
    showCategoryDialog.value = true
    // Reset the select to previous value temporarily
    nextTick(() => {
      tagManagement.newTagCategory.value = previousCategoryValue.value
    })
  }
})

// Initialize tags when component is mounted
onMounted(async () => {
  const tagsStore = useTagsStore()
  await tagsStore.initialize()
})
</script>
