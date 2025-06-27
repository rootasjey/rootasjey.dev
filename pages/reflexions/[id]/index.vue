<template>
  <div class="frame">
    <article>
      <header v-if="post" class="mt-24
        w-full text-center flex flex-col justify-center items-center">
        
        <div class="w-md mt-2">
          <UInput v-model="post.name"
            class="font-text text-xl font-800 min-h-0 mb-2 p-0 overflow-y-hidden shadow-none text-align-center"
            :readonly="!_canEdit" input="~" label="Name" type="textarea" :rows="1" autoresize />

          <UInput v-model="post.description"
            class="font-text text-gray-700 dark:text-gray-300 shadow-none text-align-center"
            :readonly="!_canEdit" input="~" label="Description" type="textarea" autoresize />
          
          <div class="flex items-center gap-2 mt-2 justify-center">
            <!-- Primary Tag Display/Edit -->
            <div v-if="!_canEdit && primaryTag" class="px-2 py-1 rounded-full text-xs bg-blue-100 dark:bg-blue-900 shadow-sm">
              {{ primaryTag }}
            </div>

            <div class="max-w-40" v-if="_canEdit">
              <USelect v-model="_selectedPrimaryTag" :items="availableTags" item-key="label" placeholder="Primary tag">
                <template #trigger>
                  <UIcon name="i-lucide-tag" v-if="_selectedPrimaryTag" />
                  <UIcon name="i-lucide-plus" v-else />
                </template>
              </USelect>
            </div>

            <!-- Status Control -->
            <div class="max-w-20">
              <USelect v-if="_canEdit" v-model="post.status" :items="availableStatuses" item-key="label">
                <template #trigger>
                  <UIcon name="i-icon-park-outline:preview-close" v-if="post.status === 'draft'" />
                  <UIcon name="i-icon-park-outline:preview-open" v-else-if="post.status === 'published'" />
                  <UIcon name="i-ph-archive" v-else />
                </template>
              </USelect>
            </div>

            <!-- Language Selection -->
            <USelect v-if="_canEdit"
              :items="_languages" 
              v-model="_selectedLanguage" 
              item-key="label"
              value-key="label"
              label="Choose the post language"
            >
              <template #label="{ label }">
                <div class="flex items-center gap-2">
                  <UIcon name="i-ph-globe-stand" />
                  <span>{{ label }}</span>
                </div>
              </template>
            </USelect>

            <!-- Cover Image Upload -->
            <UTooltip v-if="!post.image?.src && _canEdit">
              <template #default>
                <UButton @click="uploadCoverImage" :disabled="!_canEdit" btn="outline-gray">
                  <div class="i-icon-park-outline:upload-picture"></div>
                </UButton>
              </template>

              <template #content>
                <div class="px-2 py-1">
                  <p>Upload a cover image for your post.</p>
                </div>
              </template>
            </UTooltip>

            <!-- Hidden file input -->
            <input type="file" ref="_fileInput" class="hidden" accept="image/*" @change="handleCoverSelect" />

            <!-- Slug Editor -->
            <UPopover v-if="_canEdit" :disabled="!_canEdit">
              <template #trigger>
                <UButton v-if="_canEdit" btn="outline-white" leading="i-icon-park-outline:edit" label="edit slug" />
              </template>
              <template #default>
                <div>
                  <div class="space-y-1">
                    <h4 class="font-medium leading-none">
                      Update slug
                    </h4>
                    <p class="text-xs text-muted">
                      The slug is the part of the URL that identifies the post.
                    </p>
                  </div>
                  <UInput v-model="post.slug" label="Slug" class="mt-2" />
                </div>
              </template>
            </UPopover>

            <!-- Tags Management Button -->
            <UTooltip v-if="_canEdit">
              <template #default>
                <UButton @click="_showTagsDialog = true" :disabled="!_canEdit" btn="outline-gray">
                  <div class="i-lucide-tags"></div>
                </UButton>
              </template>

              <template #content>
                <div class="px-2 py-1">
                  <p>Manage post tags</p>
                </div>
              </template>
            </UTooltip>
          </div>

          <!-- Secondary Tags Display -->
          <div v-if="secondaryTags.length > 0" class="flex flex-wrap gap-2 mt-3 justify-center">
            <UBadge
              v-for="tag in secondaryTags"
              :key="tag"
              variant="outline"
              color="gray"
              size="sm"
            >
              {{ tag }}
            </UBadge>
          </div>
        </div>

        <div class="w-md mt-4 flex justify-between pt-4 border-t-2 dark:border-gray-800">
          <div class="flex gap-4 items-center">
            <div class="w-8 h-8 bg-gradient-to-br from-blue-400 to-purple-500 rounded-full flex items-center justify-center">
              <svg viewBox="0 0 36 36" fill="none" role="img" xmlns="http://www.w3.org/2000/svg" width="80" height="80"><mask :id="`avatar-mask-${post.id}`" maskUnits="userSpaceOnUse" x="0" y="0" width="36" height="36"><rect width="36" height="36" rx="72" fill="#FFFFFF"></rect></mask><g mask="url(#:ru4:)"><rect width="36" height="36" fill="#ff005b"></rect><rect x="0" y="0" width="36" height="36" transform="translate(9 -5) rotate(219 18 18) scale(1)" fill="#ffb238" rx="6"></rect><g transform="translate(4.5 -4) rotate(9 18 18)"><path d="M15 19c2 1 4 1 6 0" stroke="#000000" fill="none" stroke-linecap="round"></path><rect x="10" y="14" width="1.5" height="2" rx="1" stroke="none" fill="#000000"></rect><rect x="24" y="14" width="1.5" height="2" rx="1" stroke="none" fill="#000000"></rect></g></g></svg>
            </div>
            <div class="text-align-start flex flex-col">
              <h4>{{ post.user?.name }}</h4>
              <span class="text-size-3 text-gray-500 dark:text-gray-400">
                {{ formatPublishedDate(post.published_at ?? post.updated_at) }}
              </span>

              <div class="flex items-center gap-2 justify-center">
                <span class="text-size-3 text-gray-500 dark:text-gray-500 dark:hover:text-gray-200 transition">
                  Last updated on {{ formatUpdatedDate(post.updated_at ?? post.created_at) }}
                </span>
                <UIcon :name="_saving === undefined ? '' : _saving ? 'i-loading' : 'i-check'"
                  :class="_saving ? 'animate-spin text-muted' : 'text-lime-300'" />
              </div>
            </div>
          </div>

          <div class="flex">
            <UButton 
              icon
              label="i-ph-chat"
              btn="ghost-gray"
              class="hover:scale-102 active:scale-99 transition"
            />
            <UButton 
              icon
              label="i-lucide-share"
              btn="ghost-gray"
              class="hover:scale-102 active:scale-99 transition"
            />
          </div>
        </div>

        <!-- Cover Image Display -->
        <div v-if="post.image?.src" class="relative group">
          <NuxtImg 
            provider="hubblob"
            :src="`/${post.image.src}/original.${post.image.ext}`" 
            class="w-full h-80 object-cover rounded-lg mt-4" 
          />
          <div class="flex gap-2 absolute top-1 right-1">
            <UButton v-if="_canEdit" icon @click="uploadCoverImage" btn="~" label="i-icon-park-outline:upload-picture"
              class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />

            <UButton v-if="_canEdit" icon @click="removeCoverImage" btn="~" label="i-icon-park-outline:delete"
              class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />
          </div>
        </div>
        
        <div v-else class="mb-8 mt-8 w-md">
          <div class="border-b b-dashed b-b-amber"></div>
          <div class="border-b b-dashed b-b-blue relative top-2"></div>
        </div>
      </header>

      <main v-if="post" class="md:w-xl pt-8 mx-auto">
        <client-only>
          <tiptap-editor :can-edit="true" :model-value="post.article" @update:model-value="onUpdateEditor" />
        </client-only>
      </main>

      <div v-else class="flex justify-center items-center h-60vh">
        <UProgress indeterminate />
      </div>
    </article>

    <div class="mt-32 w-500px md:w-xl mx-auto">
      <Footer />
    </div>

    <!-- Tags Management Dialog -->
    <UDialog v-model:open="_showTagsDialog" title="Manage Post Tags" description="Edit tags for this post">
      <div class="space-y-4">
        <!-- Tag Input Component -->
        <TagInput
          v-model="_postTags"
          placeholder="Add tags..."
        />
        
        <!-- Quick Tag Suggestions -->
        <div v-if="_suggestedTags.length > 0">
          <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Suggested Tags</h4>
          <div class="flex flex-wrap gap-2">
            <UButton
              v-for="tag in _suggestedTags"
              :key="tag"
              btn="outline"
              size="xs"
              @click="addSuggestedTag(tag)"
              :disabled="_postTags.includes(tag)"
            >
              {{ tag }}
            </UButton>
          </div>
        </div>
      </div>

      <template #footer>
        <div class="flex gap-2 justify-end">
          <UButton 
            @click="cancelTagsEdit" 
            btn="outline" 
            label="Cancel"
          />
          <UButton 
            @click="saveTagsEdit" 
            btn="solid"
            label="Save Tags" 
          />
        </div>
      </template>
    </UDialog>

    <!-- Edit toolbar -->
    <div class="fixed w-full bottom-8 flex justify-center items-center">
      <div class="flex gap-1 backdrop-blur border dark:bg-black shadow-2xl p-2 rounded-4">
        <UTooltip content="Go back">
          <template #default>
            <UButton btn="ghost-gray" icon label="i-ph:arrow-bend-down-left-bold" class="" @click="$router.back()" />
          </template>
          <template #content>
            <button @click="$router.back()" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md
              border-1 border-dashed class="b-#3D3BF3">
              Go back
            </button>
          </template>
        </UTooltip>

        <UTooltip v-if="loggedIn" content="Lock edit">
          <template #default>
            <UButton btn="ghost-gray" icon @click="_canEdit = !_canEdit">
              <UIcon v-if="_canEdit" name="i-ph-eye-bold" />
              <UIcon v-else name="i-ph-pencil-bold" />
            </UButton>
          </template>
          <template #content>
            <button @click="_canEdit = !_canEdit" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1
              rounded-md border-1 border-dashed class="b-#3D3BF3">
              {{ _canEdit ? "View as readonly" : "Edit metadata" }}
            </button>
          </template>
        </UTooltip>

        <UTooltip v-if="loggedIn" content="Export to JSON">
          <template #default>
            <UButton btn="ghost-gray" icon label="i-ph-download-simple-bold" @click="exportPostToJson" />
          </template>
          <template #content>
            <button @click="exportPostToJson" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1
              rounded-md border-1 border-dashed class="b-#3D3BF3">
              Download (JSON)
            </button>
          </template>
        </UTooltip>

        <!-- Import from JSON button -->
        <UTooltip v-if="loggedIn && _canEdit" content="Import from JSON">
          <template #default>
            <button opacity-50 flex items-center gap-2 @click="triggerJsonImport">
              <div class="i-icon-park-outline:upload-two"></div>
            </button>
          </template>
          <template #content>
            <button @click="triggerJsonImport" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1
              rounded-md border-1 border-dashed class="b-#3D3BF3">
              Import from JSON
            </button>
          </template>
        </UTooltip>
        <!-- Hidden file input for JSON import -->
        <input type="file" ref="_jsonFileInput" class="hidden" accept="application/json" @change="handleJsonFileSelect" />
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { PostType } from '~/types/post'
const { loggedIn } = useUserSession()

const route = useRoute()
let _articleTimer: NodeJS.Timeout

/** True if data is being saved. */
const _saving = ref<boolean>()
let _updatePostMetaTimer: NodeJS.Timeout
const _fileInput = ref<HTMLInputElement>()
const _jsonFileInput = ref<HTMLInputElement>()

// Tags management
const { allTags, addTag, getSuggestedTags, getPrimaryTag, getSecondaryTags } = useTags()
const _showTagsDialog = ref(false)
const _postTags = ref<string[]>([])
const _selectedPrimaryTag = ref('')

const _languages = ref([
  {
    label: "English",
    value: "en",
  },
  {
    label: "Français",
    value: "fr",
  },
])

const availableStatuses = [
  { label: 'Draft', value: 'draft' },
  { label: 'Published', value: 'published' },
  { label: 'Archived', value: 'archived' },
]

const _selectedLanguage = ref(_languages.value[0])

const { data: post } = await useFetch<PostType>(`/api/posts/${route.params.id}`)

_selectedLanguage.value = _languages.value.find(l => l.value === post.value?.language) ?? _languages.value[0]

/** True if the current user is the author of the post. */
const _canEdit = ref(post.value?.canEdit ?? false)

// Initialize tags from post
if (post.value?.tags) {
  _postTags.value = [...post.value.tags]
  _selectedPrimaryTag.value = getPrimaryTag(post.value.tags) || ''
}

// Computed properties for tags
const availableTags = computed(() => {
  return allTags.value.map(tag => ({ label: tag, value: tag }))
})

const primaryTag = computed(() => {
  return getPrimaryTag(post.value?.tags || [])
})

const secondaryTags = computed(() => {
  return getSecondaryTags(post.value?.tags || [])
})

const _suggestedTags = computed(() => {
  if (!post.value?.name && !post.value?.description) return []
  
  const content = `${post.value?.name || ''} ${post.value?.description || ''}`.toLowerCase()
  return getSuggestedTags(content, 5).filter(tag => !_postTags.value.includes(tag))
})

// Tags management methods
const addSuggestedTag = (tag: string) => {
  if (!_postTags.value.includes(tag)) {
    _postTags.value.push(tag)
  }
}

const cancelTagsEdit = () => {
  // Reset to original tags
  if (post.value?.tags) {
    _postTags.value = [...post.value.tags]
  }
  _showTagsDialog.value = false
}

const saveTagsEdit = async () => {
  if (!post.value) return
  
  try {
    _saving.value = true
    
    // Update post tags
    post.value.tags = [..._postTags.value]
    
    // Update primary tag selection
    _selectedPrimaryTag.value = getPrimaryTag(_postTags.value) || ''
    
    // Add new tags to global tags list
    _postTags.value.forEach(tag => {
      if (!allTags.value.includes(tag)) {
        addTag(tag)
      }
    })
    
    // Save to server
    await updatePost()
    
    _showTagsDialog.value = false
    
    useToast().toast({
      title: 'Tags updated',
      description: 'Post tags have been successfully updated',
      showProgress: true,
      leading: 'i-lucide-check',
      progress: "success"
    })
    
  } catch (error) {
    console.error('Error updating tags:', error)
    useToast().toast({
      title: 'Update failed',
      description: 'Failed to update post tags',
      showProgress: true,
      leading: 'i-lucide-x',
      progress: "warning"
    })
  } finally {
    _saving.value = false
  }
}

/**
 * Export the current post to a JSON file and download it to the user's device
 */
const exportPostToJson = () => {
  if (!post.value) return
  
  // Create a clean version of the post for export
  const exportData = {
    id: post.value.id,
    name: post.value.name,
    slug: post.value.slug,
    description: post.value.description,
    article: post.value.article,
    tags: post.value.tags,
    language: post.value.language,
    status: post.value.status,
    created_at: post.value.created_at,
    updated_at: post.value.updated_at,
    image: post.value.image,
  }
  
  // Convert to JSON string with pretty formatting
  const jsonString = JSON.stringify(exportData, null, 2)
  
  // Create a blob with the JSON data
  const blob = new Blob([jsonString], { type: 'application/json' })
  
  // Create a URL for the blob
  const url = URL.createObjectURL(blob)
  
  // Create a temporary anchor element to trigger the download
  const a = document.createElement('a')
  a.href = url
  a.download = `${post.value.slug || post.value.id}-${new Date().toISOString().split('T')[0]}.json`
  
  // Append to the document, click to download, then remove
  document.body.appendChild(a)
  a.click()
  
  // Clean up
  setTimeout(() => {
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
  }, 0)
}

/**
 * Trigger the file input to select a JSON file for import
 */
const triggerJsonImport = () => {
  if (!_canEdit) return
  _jsonFileInput.value?.click()
}

/**
 * Handle the selected JSON file and import its contents
 */
const handleJsonFileSelect = async (event: Event) => {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file || !post.value || !_canEdit) return

  try {
    _saving.value = true
    
    // Read the file content
    const fileContent = await file.text()
    const importedData = JSON.parse(fileContent)
    
    // Update post metadata
    if (importedData.name) post.value.name = importedData.name
    if (importedData.description) post.value.description = importedData.description
    if (importedData.tags && Array.isArray(importedData.tags)) {
      post.value.tags = importedData.tags
      _postTags.value = [...importedData.tags]
      _selectedPrimaryTag.value = getPrimaryTag(importedData.tags) || ''
      
      // Add imported tags to global tags list
      importedData.tags.forEach((tag: string) => {
        if (!allTags.value.includes(tag)) {
          addTag(tag)
        }
      })
    }
    if (importedData.language) {
      post.value.language = importedData.language
      _selectedLanguage.value = _languages.value.find(l => l.value === importedData.language) ?? _languages.value[0]
    }
    
    if (importedData.article) {
      post.value.article = importedData.article
      await updatePostArticle(importedData.article)
    }
    
    await updatePost()
    
    useToast().toast({
      title: 'Import successful',
      description: 'The post has been updated with the imported data',
      showProgress: true,
      leading: 'i-lucide-check',
      progress: "success"
    })
    
  } catch (error) {
    console.error('Error importing JSON:', error)
    useToast().toast({
      title: 'Import failed',
      description: 'Failed to import the JSON file. Please check the file format.',
      showProgress: true,
      leading: 'i-lucide-x',
      progress: "warning"
    })
  } finally {
    _saving.value = false
    // Reset the file input
    if (_jsonFileInput.value) {
      _jsonFileInput.value.value = ''
    }
  }
}

const onUpdateEditor = (value: Object) => {
  clearTimeout(_articleTimer)
  _articleTimer = setTimeout(() => updatePostArticle(value), 2000)
}

const updatePostArticle = async (value: Object) => {
  await $fetch(`/api/posts/${route.params.id}/article`, {
    method: "PUT",
    body: {
      article: value,
    },
  })
}

const formatPublishedDate = (date: string | Date): string => {
  if (!date) return "Unknown Date"
  const dateObj = new Date(date)
  const options: Intl.DateTimeFormatOptions = { 
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }
  return dateObj.toLocaleString('fr', options)
}

const formatUpdatedDate = (date: string | Date): string => {
  if (!date) return "Unknown Date"
  const dateObj = new Date(date)
  const options: Intl.DateTimeFormatOptions = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  }
  return dateObj.toLocaleString('fr', options)
}

/**
 * Watches for changes in the post's name, description, tags, 
 * slug, status, and selected language. 
 * When any of these values change, 
 * it clears the _updatePostMetaTimer and sets a new timer 
 * to call the updatePost function after a 2000ms delay. 
 * This allows for debouncing of updates to the post's metadata, 
 * preventing excessive API calls.
 */
watch(
  [
    () => post.value?.name, 
    () => post.value?.description, 
    () => post.value?.tags, 
    () => post.value?.slug, 
    () => post.value?.status,
    () => _selectedLanguage.value,
    () => _selectedPrimaryTag.value,
  ],
  () => {
    clearTimeout(_updatePostMetaTimer)
    _updatePostMetaTimer = setTimeout(updatePost, 2000)
  },
)

// Watch for primary tag changes and update post tags
watch(_selectedPrimaryTag, (newPrimaryTag) => {
  if (!post.value || !_canEdit.value) return
  
  const currentTags = post.value.tags || []
  const secondaryTags = getSecondaryTags(currentTags)
  
  // Rebuild tags array with new primary tag first
  const newTags = newPrimaryTag ? [newPrimaryTag, ...secondaryTags] : secondaryTags
  
  post.value.tags = newTags
  _postTags.value = [...newTags]
})

const updatePost = async () => {
  _saving.value = true

  const { post: updatedPost } = await $fetch<{post: PostType}>(
    `/api/posts/${route.params.id}/`, {
    method: "PUT",
    body: {
      tags: post.value?.tags,
      description: post.value?.description,
      language: _selectedLanguage.value.value,
      name: post.value?.name,
      slug: post.value?.slug,
      status: post.value?.status,
    },
  })

  _saving.value = false
  if (!post.value) return

  post.value.updated_at = updatedPost.updated_at
}

const removeCoverImage = async () => {
  const { success } = await $fetch(`/api/posts/${route.params.id}/cover`, {
    method: "DELETE",
  })

  if (success && post.value?.image) {
    post.value.image.src = ""
    post.value.image.alt = ""
  }
}

const uploadCoverImage = () => {
  _fileInput.value?.click()
}

const handleCoverSelect = async (event: Event) => {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file) return

  try {
    _saving.value = true
    const formData = new FormData()
    formData.append('file', file)
    formData.append('fileName', file.name)
    formData.append('type', file.type)

    const { image } = await $fetch(`/api/posts/${route.params.id}/cover`, {
      method: 'POST',
      body: formData,
    })

    if (post.value && image.src) {
      post.value.image.src = image.src
      post.value.image.alt = image.alt
    }
  } catch (error) {
    console.error('Error uploading image:', error)
  } finally {
    _saving.value = false
  }
}

useHead({
  title: `rootasjey • ${(post.value as PostType)?.name ?? 'Loading...'}`,
  meta: [
    {
      name: 'description',
      content: (post.value as PostType)?.description ?? 'Loading post...',
    },
  ],
})
</script>

<style scoped>

.frame {
  padding: 0;
  padding-bottom: 38vh;
  display: flex;
  flex-direction: column;
  transition-property: all;
  overflow-y: auto;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);

  width: 100%;
  background-color: #F1F1F1;
}

.dark .frame {
  background-color: #111;
}
</style>
