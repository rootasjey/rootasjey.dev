<template>
  <div class="p-6">
    <!-- Header with Actions -->
    <div class="flex items-center justify-between mb-6">
      <div>
        <h2 class="text-2xl font-600 font-body text-gray-800 dark:text-gray-200 mb-2">
          Posts Management
        </h2>
        <p class="text-gray-600 dark:text-gray-400">
          Manage all posts across your application
        </p>
      </div>
      
      <div class="flex items-center gap-3">
        <!-- Search -->
        <UInput
          v-model="searchQuery"
          placeholder="Search posts..."
          leading="i-ph-magnifying-glass"
          class="w-64"
          @input="handleSearch"
        />
        
        <!-- Create Post Button -->
        <UButton
          @click="showCreateDialog = true"
          btn="soft-blue"
          size="sm"
          class="hover:scale-102 active:scale-99 transition"
        >
          <span class="i-ph-plus mr-2"></span>
          Create Post
        </UButton>
      </div>
    </div>

    <!-- Bulk Actions Bar -->
    <div v-if="selectedPosts.length > 0" class="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4 mb-6">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-4">
          <span class="text-sm font-600 text-blue-800 dark:text-blue-200">
            {{ selectedPosts.length }} post{{ selectedPosts.length === 1 ? '' : 's' }} selected
          </span>
          
          <UButton
            @click="clearSelection"
            btn="ghost-blue"
            size="xs"
          >
            Clear Selection
          </UButton>
        </div>
        
        <div class="flex items-center gap-2">
          <UButton
            @click="handleBulkPublish"
            btn="soft-green"
            size="xs"
            :disabled="!canBulkPublish"
          >
            <span class="i-ph-eye mr-1"></span>
            Publish
          </UButton>
          
          <UButton
            @click="handleBulkArchive"
            btn="soft-orange"
            size="xs"
          >
            <span class="i-ph-archive mr-1"></span>
            Archive
          </UButton>
          
          <UButton
            @click="handleBulkDelete"
            btn="soft-red"
            size="xs"
          >
            <span class="i-ph-trash mr-1"></span>
            Delete
          </UButton>
        </div>
      </div>
    </div>

    <!-- Tabs for Post Status -->
    <UTabs v-model="activeTab" class="mb-6">
      <UTabsList class="grid grid-cols-3 mb-6">
        <UTabsTrigger value="published">
          Published
          <UBadge
            v-if="publishedPosts.length > 0"
            variant="soft"
            color="blue"
            size="xs"
            class="ml-2"
          >
            {{ publishedPosts.length }}
          </UBadge>
        </UTabsTrigger>

        <UTabsTrigger value="drafts">
          Drafts
          <UBadge
            v-if="draftPosts.length > 0"
            variant="soft"
            color="lime"
            size="xs"
            class="ml-2"
          >
            {{ draftPosts.length }}
          </UBadge>
        </UTabsTrigger>

        <UTabsTrigger value="archived">
          Archived
          <UBadge
            v-if="archivedPosts.length > 0"
            variant="soft"
            color="gray"
            size="xs"
            class="ml-2"
          >
            {{ archivedPosts.length }}
          </UBadge>
        </UTabsTrigger>
      </UTabsList>

      <!-- Published Posts -->
      <UTabsContent value="published">
        <div v-if="publishedLoading" class="space-y-4">
          <div v-for="i in 5" :key="i" class="animate-pulse">
            <div class="h-16 bg-gray-200 dark:bg-gray-700 rounded-lg"></div>
          </div>
        </div>

        <div v-else-if="publishedPosts.length === 0" class="text-center py-12">
          <div class="i-ph-article text-4xl text-gray-400 mb-4"></div>
          <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
            No Published Posts
          </h3>
          <p class="text-gray-500 dark:text-gray-400">
            Published posts will appear here.
          </p>
        </div>

        <UTable
          v-else
          v-model:row-selection="selectedPostsMap"
          :columns="tableColumns"
          :data="publishedPosts"
          enable-row-selection
          enable-sorting
          row-id="id"
          @select="handlePostSelect"
          @select-all="handleSelectAll"
        >
          <!-- Status Cell -->
          <template #status-cell="{ cell }">
            <UBadge
              :badge="getStatusBadgeVariant(cell.row.original.status)"
              size="xs"
              class="capitalize"
            >
              {{ cell.row.original.status }}
            </UBadge>
          </template>

          <!-- Tags Cell -->
          <template #tags-cell="{ cell }">
            <TagDisplay
              :tags="cell.row.original.tags"
              display-mode="primary-count"
              :max-visible-tags="2"
            />
          </template>

          <!-- Actions Cell -->
          <template #actions-cell="{ cell }">
            <div class="flex items-center gap-1">
              <UButton
                @click="handleEditPost(cell.row.original)"
                btn="ghost-gray"
                size="xs"
                square
                icon
              >
                <span class="i-ph-pencil"></span>
              </UButton>

              <UButton
                @click="handleUnpublishPost(cell.row.original)"
                btn="ghost-orange"
                size="xs"
                square
                icon
                title="Unpublish"
              >
                <span class="i-ph-eye-slash"></span>
              </UButton>

              <UButton
                @click="handleArchivePost(cell.row.original)"
                btn="ghost-gray"
                size="xs"
                square
                icon
                title="Archive"
              >
                <span class="i-ph-archive"></span>
              </UButton>

              <UButton
                @click="handleDeletePost(cell.row.original)"
                btn="ghost-red"
                size="xs"
                square
                icon
                title="Delete"
              >
                <span class="i-ph-trash"></span>
              </UButton>
            </div>
          </template>

        </UTable>
      </UTabsContent>

      <!-- Draft Posts -->
      <UTabsContent value="drafts">
        <div v-if="draftsLoading" class="space-y-4">
          <div v-for="i in 5" :key="i" class="animate-pulse">
            <div class="h-16 bg-gray-200 dark:bg-gray-700 rounded-lg"></div>
          </div>
        </div>

        <div v-else-if="draftPosts.length === 0" class="text-center py-12">
          <div class="i-ph-article text-4xl text-gray-400 mb-4"></div>
          <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
            No Draft Posts
          </h3>
          <p class="text-gray-500 dark:text-gray-400">
            Draft posts will appear here.
          </p>
        </div>

        <UTable
          v-else
          v-model:row-selection="selectedPostsMap"
          :columns="tableColumns"
          :data="draftPosts"
          enable-row-selection
          enable-sorting
          row-id="id"
          @select="handlePostSelect"
          @select-all="handleSelectAll"
        >
          <!-- Status Cell -->
          <template #status-cell="{ cell }">
            <UBadge
              :badge="getStatusBadgeVariant(cell.row.original.status)"
              size="xs"
              class="capitalize"
            >
              {{ cell.row.original.status }}
            </UBadge>
          </template>

          <!-- Tags Cell -->
          <template #tags-cell="{ cell }">
            <TagDisplay
              :tags="cell.row.original.tags"
              display-mode="primary-count"
              :max-visible-tags="2"
            />
          </template>

          <!-- Actions Cell -->
          <template #actions-cell="{ cell }">
            <div class="flex items-center gap-1">
              <UButton
                @click="handleEditPost(cell.row.original)"
                btn="ghost-gray"
                size="xs"
                square
                icon
              >
                <span class="i-ph-pencil"></span>
              </UButton>

              <UButton
                @click="handlePublishPost(cell.row.original)"
                btn="ghost-green"
                size="xs"
                square
                icon
                title="Publish"
              >
                <span class="i-ph-eye"></span>
              </UButton>

              <UButton
                @click="handleDeletePost(cell.row.original)"
                btn="ghost-red"
                size="xs"
                square
                icon
                title="Delete"
              >
                <span class="i-ph-trash"></span>
              </UButton>
            </div>
          </template>

        </UTable>
      </UTabsContent>

      <!-- Archived Posts -->
      <UTabsContent value="archived">
        <div v-if="archivedLoading" class="space-y-4">
          <div v-for="i in 5" :key="i" class="animate-pulse">
            <div class="h-16 bg-gray-200 dark:bg-gray-700 rounded-lg"></div>
          </div>
        </div>

        <div v-else-if="archivedPosts.length === 0" class="text-center py-12">
          <div class="i-ph-archive text-4xl text-gray-400 mb-4"></div>
          <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
            No Archived Posts
          </h3>
          <p class="text-gray-500 dark:text-gray-400">
            Archived posts will appear here.
          </p>
        </div>

        <UTable
          v-else
          v-model:row-selection="selectedPostsMap"
          :columns="tableColumns"
          :data="archivedPosts"
          enable-row-selection
          enable-sorting
          row-id="id"
          @select="handlePostSelect"
          @select-all="handleSelectAll"
        >
          <!-- Status Cell -->
          <template #status-cell="{ cell }">
            <UBadge
              :badge="getStatusBadgeVariant(cell.row.original.status)"
              size="xs"
              class="capitalize"
            >
              {{ cell.row.original.status }}
            </UBadge>
          </template>

          <!-- Tags Cell -->
          <template #tags-cell="{ cell }">
            <TagDisplay
              :tags="cell.row.original.tags"
              display-mode="primary-count"
              :max-visible-tags="2"
            />
          </template>

          <!-- Actions Cell -->
          <template #actions-cell="{ cell }">
            <div class="flex items-center gap-1">
              <UButton
                @click="handleEditPost(cell.row.original)"
                btn="ghost-gray"
                size="xs"
                square
                icon
              >
                <span class="i-ph-pencil"></span>
              </UButton>

              <UButton
                @click="handleRestorePost(cell.row.original)"
                btn="ghost-blue"
                size="xs"
                square
                icon
                title="Restore"
              >
                <span class="i-ph-arrow-counter-clockwise"></span>
              </UButton>

              <UButton
                @click="handleDeletePost(cell.row.original)"
                btn="ghost-red"
                size="xs"
                square
                icon
                title="Delete"
              >
                <span class="i-ph-trash"></span>
              </UButton>
            </div>
          </template>

        </UTable>
      </UTabsContent>
    </UTabs>

    <!-- Create Post Dialog -->
    <CreatePostDialog
      v-model="showCreateDialog"
      @create-post="handleCreatePost"
    />

    <!-- Edit Post Dialog -->
    <EditPostDialog
      v-model="showEditDialog"
      :post="editingPost"
      @update-post="handleUpdatePost"
    />

    <!-- Delete Confirmation Dialog -->
    <DeletePostDialog
      v-model="showDeleteDialog"
      :post="deletingPost || undefined"
      @delete-post="handleConfirmDelete"
    />

    <!-- Bulk Delete Confirmation Dialog -->
    <AdminBulkDeleteDialog
      v-model="showBulkDeleteDialog"
      :count="selectedPosts.length"
      item-type="posts"
      @confirm="handleConfirmBulkDelete"
    />
  </div>
</template>

<script setup lang="ts">
import type { Post } from '~/types/post'
import type { ColumnDef } from '@tanstack/vue-table'

// Data management
const searchQuery = ref('')
const activeTab = ref('published')
const selectedPosts = ref<number[]>([])

// Dialog states
const showCreateDialog = ref(false)
const showEditDialog = ref(false)
const showDeleteDialog = ref(false)
const showBulkDeleteDialog = ref(false)
const editingPost = ref<Post | null>(null)
const deletingPost = ref<Post | null>(null)

// Posts data
const publishedPosts = ref<Post[]>([])
const draftPosts = ref<Post[]>([])
const archivedPosts = ref<Post[]>([])

// Loading states
const publishedLoading = ref(false)
const draftsLoading = ref(false)
const archivedLoading = ref(false)

// Table selection management
const selectedPostsMap = computed({
  get: () => {
    const map: Record<string, boolean> = {}
    selectedPosts.value.forEach(id => {
      map[id.toString()] = true
    })
    return map
  },
  set: (value: Record<string, boolean>) => {
    selectedPosts.value = Object.keys(value)
      .filter(key => value[key])
      .map(key => parseInt(key))
  }
})

// Table columns definition
const tableColumns: ColumnDef<Post>[] = [
  {
    header: 'Title',
    accessorKey: 'name',
    cell: ({ row }) => {
      const post = row.original
      return h('div', { class: 'min-w-0' }, [
        h('div', { class: 'font-medium text-gray-900 dark:text-gray-100 truncate' }, post.name),
        post.description ? h('div', { class: 'text-sm text-gray-500 dark:text-gray-400 truncate mt-1' }, post.description) : null
      ])
    },
    enableSorting: true,
  },
  {
    header: 'Status',
    accessorKey: 'status',
    id: 'status',
    enableSorting: true,
  },
  {
    header: 'Tags',
    accessorKey: 'tags',
    id: 'tags',
    enableSorting: false,
  },
  {
    header: 'Author',
    accessorKey: 'user.name',
    cell: ({ row }) => {
      const user = row.original.user
      return user?.name || 'Unknown'
    },
    enableSorting: true,
  },
  {
    header: 'Created',
    accessorKey: 'createdAt',
    cell: ({ row }) => {
      const date = new Date(row.original.createdAt)
      return date.toLocaleDateString()
    },
    enableSorting: true,
  },
  {
    header: 'Updated',
    accessorKey: 'updatedAt',
    cell: ({ row }) => {
      const date = new Date(row.original.updatedAt)
      return date.toLocaleDateString()
    },
    enableSorting: true,
  },
  {
    header: 'Views',
    accessorKey: 'metrics.views',
    cell: ({ row }) => {
      return row.original.metrics.views.toLocaleString()
    },
    enableSorting: true,
  },
  {
    header: 'Actions',
    id: 'actions',
    enableSorting: false,
  },
]



// Computed properties
const canBulkPublish = computed(() => {
  return selectedPosts.value.some(id => {
    const post = [...draftPosts.value, ...archivedPosts.value].find(p => p.id === id)
    return post && post.status !== 'published'
  })
})

// Table helper methods
const getStatusBadgeVariant = (status: string) => {
  switch (status) {
    case 'published':
      return 'soft-green'
    case 'draft':
      return 'soft-amber'
    case 'archived':
      return 'soft-gray'
    default:
      return 'soft-gray'
  }
}

const handlePostSelect = (_post: Post) => {
  // This is handled by the v-model:row-selection binding
}

const handleSelectAll = (_posts: Post[]) => {
  // This is handled by the v-model:row-selection binding
}

// Methods
const handleSearch = useDebounceFn(() => {
  fetchPosts()
}, 300)

const clearSelection = () => {
  selectedPosts.value = []
}

// CRUD operations
const { showCreateSuccess, showUpdateSuccess, showApiError } = useAdminToast()

const handleCreatePost = async (postData: any) => {
  try {
    await $fetch('/api/posts', {
      method: 'POST',
      body: postData
    })
    showCreateDialog.value = false
    showCreateSuccess('Post', postData.name)
    await fetchPosts()
  } catch (error) {
    showApiError(error, 'Create Post')
  }
}

const handleEditPost = (post: Post) => {
  editingPost.value = post
  showEditDialog.value = true
}

const handleUpdatePost = async (postData: any) => {
  try {
    await $fetch(`/api/posts/${editingPost.value?.id}`, {
      method: 'PUT',
      body: postData
    })
    showEditDialog.value = false
    showUpdateSuccess('Post', editingPost.value?.name)
    editingPost.value = null
    await fetchPosts()
  } catch (error) {
    showApiError(error, 'Update Post')
  }
}

const handleDeletePost = (post: Post) => {
  deletingPost.value = post
  showDeleteDialog.value = true
}

const handleConfirmDelete = async () => {
  if (!deletingPost.value) return
  
  try {
    await $fetch(`/api/posts/${deletingPost.value.id}`, {
      method: 'DELETE'
    })
    showDeleteDialog.value = false
    deletingPost.value = null
    await fetchPosts()
  } catch (error) {
    console.error('Error deleting post:', error)
  }
}

// Bulk operations
const handleBulkPublish = async () => {
  try {
    await Promise.all(
      selectedPosts.value.map(id =>
        $fetch(`/api/posts/${id}`, {
          method: 'PUT',
          body: { status: 'published' }
        })
      )
    )
    clearSelection()
    await fetchPosts()
  } catch (error) {
    console.error('Error bulk publishing posts:', error)
  }
}

const handleBulkArchive = async () => {
  try {
    await Promise.all(
      selectedPosts.value.map(id =>
        $fetch(`/api/posts/${id}`, {
          method: 'PUT',
          body: { status: 'archived' }
        })
      )
    )
    clearSelection()
    await fetchPosts()
  } catch (error) {
    console.error('Error bulk archiving posts:', error)
  }
}

const handleBulkDelete = () => {
  showBulkDeleteDialog.value = true
}

const handleConfirmBulkDelete = async () => {
  try {
    await Promise.all(
      selectedPosts.value.map(id =>
        $fetch(`/api/posts/${id}`, {
          method: 'DELETE'
        })
      )
    )
    clearSelection()
    showBulkDeleteDialog.value = false
    await fetchPosts()
  } catch (error) {
    console.error('Error bulk deleting posts:', error)
  }
}

// Status change operations
const handlePublishPost = async (post: Post) => {
  try {
    await $fetch(`/api/posts/${post.id}`, {
      method: 'PUT',
      body: { status: 'published' }
    })
    await fetchPosts()
  } catch (error) {
    console.error('Error publishing post:', error)
  }
}

const handleUnpublishPost = async (post: Post) => {
  try {
    await $fetch(`/api/posts/${post.id}`, {
      method: 'PUT',
      body: { status: 'draft' }
    })
    await fetchPosts()
  } catch (error) {
    console.error('Error unpublishing post:', error)
  }
}

const handleArchivePost = async (post: Post) => {
  try {
    await $fetch(`/api/posts/${post.id}`, {
      method: 'PUT',
      body: { status: 'archived' }
    })
    await fetchPosts()
  } catch (error) {
    console.error('Error archiving post:', error)
  }
}

const handleRestorePost = async (post: Post) => {
  try {
    await $fetch(`/api/posts/${post.id}`, {
      method: 'PUT',
      body: { status: 'draft' }
    })
    await fetchPosts()
  } catch (error) {
    console.error('Error restoring post:', error)
  }
}

// Data fetching
const fetchPosts = async () => {
  try {
    publishedLoading.value = true
    draftsLoading.value = true
    archivedLoading.value = true

    const [published, drafts, archived] = await Promise.all([
      $fetch('/api/posts', { query: { search: searchQuery.value } }),
      $fetch('/api/posts/drafts', { query: { search: searchQuery.value } }),
      $fetch('/api/posts/archived', { query: { search: searchQuery.value } })
    ])

    publishedPosts.value = published
    draftPosts.value = drafts
    archivedPosts.value = archived
  } catch (error) {
    console.error('Error fetching posts:', error)
  } finally {
    publishedLoading.value = false
    draftsLoading.value = false
    archivedLoading.value = false
  }
}

// Initialize
onMounted(() => {
  fetchPosts()
})

// Watch for tab changes to clear selection
watch(activeTab, () => {
  clearSelection()
})
</script>
