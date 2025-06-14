<template>
  <div class="frame">
    <article>
      <header class="min-h-95vh 
        m-4 border-1 b-dashed rounded-2 border-gray-200 dark:border-gray-800
        text-center flex flex-col justify-center items-center">
        <div v-if="post" class="mt-2">
          <UInput v-model="post.name"
            class="text-6xl font-800 min-h-0 mb-8 p-0 overflow-y-hidden shadow-none text-align-center"
            :readonly="!_canEdit" input="~" label="Name" type="textarea" :rows="1" autoresize />

          <UInput v-model="post.description"
            class="text-gray-700 dark:text-gray-300 -mt-4 -ml-2.5 shadow-none text-align-center"
            :readonly="!_canEdit" input="~" label="Description" />

          <div :class="`flex items-center gap-2 justify-center`">
            <span class="text-size-3 text-gray-500 dark:text-gray-400">
              {{ new Date(post.created_at).toLocaleString("fr", {
              month: "long",
              day: "numeric",
              year: "numeric",
              }) }}
            </span>
            <span class="text-size-3 text-gray-500 dark:text-gray-600 dark:hover:text-gray-400 transition">
              • Last updated on {{ new Date(post.updated_at).toLocaleString("fr", {
              month: "long",
              day: "numeric",
              year: "numeric",
              hour: "numeric",
              minute: "numeric",
              second: "numeric",
              }) }}
            </span>
            <UIcon :name="_saving === undefined ? '' : _saving ? 'i-loading' : 'i-check'"
              :class="_saving ? 'animate-spin text-muted' : 'text-lime-300'" />
          </div>
          <div class="flex items-center gap-2 mt-2 justify-center">
            <span v-if="post.category && !_canEdit" class="px-2 py-1 rounded-full text-xs bg-gray-100 dark:bg-gray-800 shadow-sm">
              {{ post.category }}
            </span>

            <div class="max-w-20">
              <USelect v-if="_canEdit" v-model="post.category" :items="_categories">
                <template #trigger>
                  <UIcon name="i-icon-park-outline:movie-board" v-if="post.category === 'cinema'" />
                  <UIcon name="i-icon-park-outline:computer" v-else-if="post.category === 'development'" />
                  <UIcon name="i-icon-park-outline:music" v-else-if="post.category === 'music'" />
                  <UIcon name="i-icon-park-outline:book" v-else-if="post.category === 'literature'" />
                  <UIcon name="i-icon-park-outline:tag" v-else />
                </template>
              </USelect>
            </div>

            <div class="max-w-20">
              <USelect v-if="_canEdit" v-model="post.visibility" :items="_visibilities">
                <template #trigger>
                  <UIcon name="i-icon-park-outline:preview-close" v-if="post.visibility === 'private'" />
                  <UIcon name="i-icon-park-outline:preview-open" v-else-if="post.visibility === 'public'" />
                  <UIcon name="i-icon-park-outline:preview-close" v-else />
                </template>
              </USelect>
            </div>

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
            <input type="file" ref="_fileInput" class="hidden" accept="image/*" @change="handleFileSelect" />

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
          </div>

          <div v-if="post.image?.src" class="relative group">
            <img v-if="post.image?.src" :src="`/${post.image.src}`" class="w-full h-80 object-cover rounded-lg mt-4" />
            <div class="flex gap-2 absolute top-1 right-1">
              <UButton v-if="_canEdit" icon @click="uploadCoverImage" btn="~" label="i-icon-park-outline:upload-picture"
                class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />

              <UButton v-if="_canEdit" icon @click="removeCoverImage" btn="~" label="i-icon-park-outline:delete"
                class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />
            </div>
          </div>
        </div>
      </header>

      <main v-if="post" class="w-500px md:w-xl pt-8 mx-auto">
        <client-only>
          <tiptap-editor :can-edit="true" :model-value="post.content" @update:model-value="onUpdateEditorContent" />
        </client-only>
      </main>

      <div v-else class="flex justify-center items-center h-60vh">
        <UProgress indeterminate />
      </div>
    </article>

    <div class="w-500px md:w-xl mx-auto">
      <Footer />
    </div>

    <!-- Edit toolbar -->
    <div class="fixed w-full bottom-8 flex justify-center items-center">
      <div class="flex gap-4 backdrop-blur border dark:bg-black shadow-2xl p-2 rounded-4">
        <UTooltip content="Go back">
          <template #default>
            <button opacity-50 flex items-center gap-2 @click="$router.back()">
              <div class="i-ph:arrow-bend-down-left-bold"></div>
            </button>
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
            <button opacity-50 flex items-center gap-2 @click="_canEdit = !_canEdit">
              <div :class="_canEdit ? 'i-icon-park-outline:unlock' : 'i-icon-park-outline:lock'"></div>
            </button>
          </template>
          <template #content>
            <button @click="_canEdit = !_canEdit" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1
              rounded-md border-1 border-dashed class="b-#3D3BF3">
              {{ _canEdit ? "Lock edit" : "Unlock edit" }}
            </button>
          </template>
        </UTooltip>

        <UTooltip v-if="loggedIn" content="Export to JSON">
          <template #default>
            <button opacity-50 flex items-center gap-2 @click="exportPostToJson">
              <div class="i-icon-park-outline:download-two"></div>
            </button>
          </template>
          <template #content>
            <button @click="exportPostToJson" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1
              rounded-md border-1 border-dashed class="b-#3D3BF3">
              Export to JSON
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
import TiptapEditor from '~/components/TiptapEditor.vue'
const { loggedIn } = useUserSession()

const route = useRoute()
let _updatePostContentTimer: NodeJS.Timeout

/** True if data is being saved. */
const _saving = ref<boolean>()
let _updatePostMetaTimer: NodeJS.Timeout
let _updatePostStylesTimer: NodeJS.Timeout
const _fileInput = ref<HTMLInputElement>()
const _jsonFileInput = ref<HTMLInputElement>() // New ref for JSON import

/** Specify where the uploaded image will be placed (e.g. as the post's cover or content). */
const _imageUploadPlacement = ref<"cover" | "content">("cover")

const _categories = ref([
  "cinema", "no category", "development", "literature", "music",
])

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

const _selectedLanguage = ref(_languages.value[0])

const _visibilities = ref([
  "private", "public",
])

const _stylesMeta = ref({
  center: false,
})

const { data: post } = await useFetch<PostType>(`/api/posts/${route.params.id}`)

_selectedLanguage.value = _languages.value.find(l => l.value === post.value?.language) ?? _languages.value[0]
_stylesMeta.value.center = post.value?.styles?.meta?.align === "center"

/** True if the current user is the author of the post. */
const _canEdit = ref(post.value?.canEdit ?? false)

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
    content: post.value.content,
    category: post.value.category,
    language: post.value.language,
    visibility: post.value.visibility,
    created_at: post.value.created_at,
    updated_at: post.value.updated_at,
    image: post.value.image,
    styles: post.value.styles,
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
    if (importedData.category) {
      post.value.category = importedData.category
    }
    if (importedData.language) {
      post.value.language = importedData.language
      _selectedLanguage.value = _languages.value.find(l => l.value === importedData.language) ?? _languages.value[0]
    }
    
    // Update post content if available
    if (importedData.content) {
      post.value.content = importedData.content
      await updatePostContent(importedData.content)
    }
    
    // Update styles if available
    if (importedData.styles) {
      post.value.styles = importedData.styles
      _stylesMeta.value.center = importedData.styles?.meta?.align === "center"
      await updatePostStyles()
    }
    
    // Update other metadata
    await updatePostMeta()
    
    // Show success notification
    useToast().toast({
      title: 'Import successful',
      description: 'The post has been updated with the imported data',
      showProgress: true,
      leading: 'i-icon-park-outline:check-one',
      progress: "success"
    })
    
  } catch (error) {
    console.error('Error importing JSON:', error)
    useToast().toast({
      title: 'Import failed',
      description: 'Failed to import the JSON file. Please check the file format.',
      showProgress: true,
      leading: 'i-icon-park-outline:close-one',
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

const onUpdateEditorContent = (value: Object) => {
  clearTimeout(_updatePostContentTimer)
  _updatePostContentTimer = setTimeout(() => updatePostContent(value), 2000)
}

const updatePostContent = async (value: Object) => {
  await $fetch(`/api/posts/${route.params.id}/update-content`, {
    method: "PUT",
    body: {
      content: value,
    },
  })
}

/**
 * Watches for changes in the post's name, description, category, 
 * slug, visibility, and selected language. 
 * When any of these values change, 
 * it clears the _updatePostMetaTimer and sets a new timer 
 * to call the updatePostMeta function after a 500ms delay. 
 * This allows for debouncing of updates to the post's metadata, 
 * preventing excessive API calls.
 */
watch(
  [
    () => post.value?.name, 
    () => post.value?.description, 
    () => post.value?.category, 
    () => post.value?.slug, 
    () => post.value?.visibility,
    () => _selectedLanguage.value,
  ],
  () => {
    clearTimeout(_updatePostMetaTimer)
    _updatePostMetaTimer = setTimeout(updatePostMeta, 2000)
  },
)

watch(
  () => _stylesMeta.value.center,
  () => {
    clearTimeout(_updatePostStylesTimer)
    _updatePostStylesTimer = setTimeout(updatePostStyles, 1000)
  },
)

const updatePostStyles = async () => {
  await $fetch(`/api/posts/${route.params.id}/update-styles`, {
    method: "PUT",
    body: {
      meta: {
        align: _stylesMeta.value.center ? "center" : "",
      },
    },
  })
}

const updatePostMeta = async () => {
  _saving.value = true

  const { post: updatedPost } = await $fetch<{post: PostType}>(
    `/api/posts/${route.params.id}/update-meta`, {
    method: "PUT",
    body: {
      category: post.value?.category,
      description: post.value?.description,
      language: _selectedLanguage.value.value,
      name: post.value?.name,
      slug: post.value?.slug,
      visibility: post.value?.visibility,
    },
  })

  _saving.value = false
  if (!post.value) return

  post.value.updated_at = updatedPost.updated_at
  // updateOnlyChangedFields(updatedPost)
}

const updateOnlyChangedFields = (updatedPost: PostType) => {
  if (!post.value) return
  
  if (updatedPost.category !== post.value?.category) {
    post.value.category = updatedPost.category
  }
  if (updatedPost.description !== post.value?.description) {
    post.value.description = updatedPost.description
  }
  if (updatedPost.language !== post.value?.language) {
    post.value.language = updatedPost.language
    _selectedLanguage.value = _languages.value.find(l => l.value === updatedPost.language) ?? _languages.value[0]
  }
  if (updatedPost.name !== post.value?.name) {
    post.value.name = updatedPost.name
  }
  if (updatedPost.slug !== post.value?.slug) {
    post.value.slug = updatedPost.slug
  }
  if (updatedPost.visibility !== post.value?.visibility) {
    post.value.visibility = updatedPost.visibility
  }
}

const removeCoverImage = async () => {
  const { success } = await $fetch(`/api/posts/${route.params.id}/remove-image`, {
    method: "DELETE",
  })

  if (success && post.value?.image) {
    post.value.image.src = ""
    post.value.image.alt = ""
  }
}

const uploadCoverImage = () => {
  _imageUploadPlacement.value = "cover"
  _fileInput.value?.click()
}

const uploadContentImage = () => {
  _imageUploadPlacement.value = "content"
  _fileInput.value?.click()
}

const handleFileSelect = async (event: Event) => {
  const file = (event.target as HTMLInputElement).files?.[0]
  if (!file) return

  try {
    _saving.value = true
    const formData = new FormData()
    formData.append('file', file)
    formData.append('fileName', file.name)
    formData.append('type', file.type)
    formData.append('placement', _imageUploadPlacement.value)

    const { image } = await $fetch(`/api/posts/${route.params.id}/upload-image`, {
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
