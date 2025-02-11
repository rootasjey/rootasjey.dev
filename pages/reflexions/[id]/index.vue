<template>
  <div class="container mx-auto px-4 py-8 mt-[22vh] relative">
    <header class="mb-16 text-center flex flex-col items-center">
      <!-- Top toolbar -->
      <div class="flex items-center gap-4 -ml-3">
        <UTooltip content="Go back" :_tooltip-content="{ side: 'right' }">
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
        <UTooltip v-if="token" content="Lock edit" :_tooltip-content="{ side: 'right' }">
          <template #default>
            <button opacity-50 flex items-center gap-2 @click="_canEdit = !_canEdit">
              <div :class="_canEdit ? 'i-icon-park-outline:lock' : 'i-icon-park-outline:unlock'"></div>
            </button>
          </template>
          <template #content>
            <button @click="_canEdit = !_canEdit" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1
              rounded-md border-1 border-dashed class="b-#3D3BF3">
              {{ _canEdit ? "Lock edit" : "Unlock edit" }}
            </button>
          </template>
        </UTooltip>
      </div>

      <div v-if="post" class="mt-2">
        <!-- <h1 class="text-6xl font-600 mb-4">{{ post.name }}</h1> -->
        <UInput v-model="post.name"
          :class="`text-6xl font-800 mb-4 p-0 overflow-y-hidden shadow-none ${_stylesMeta.center ? 'text-align-center' : ''}`"
          :readonly="!_canEdit" input="~" label="Name" type="textarea" :rows="1" autoresize />

        <UInput v-model="post.description"
          :class="`text-gray-700 dark:text-gray-300 -mt-4 -ml-2.5 shadow-none ${_stylesMeta.center ? 'text-align-center' : ''}`"
          :readonly="!_canEdit" input="~" label="Description" />

        <div :class="`flex items-center gap-2 ${_stylesMeta.center ? 'justify-center' : 'justify-start'}`">
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
        <div :class="`flex items-center gap-2 mt-2 ${_stylesMeta.center ? 'justify-center' : 'justify-start'}`">
          <span v-if="post.category && !_canEdit" class="px-2 py-1 rounded-full text-xs bg-gray-100 dark:bg-gray-800">
            {{ post.category }}
          </span>
          <USelect v-if="_canEdit" v-model="post.category" :items="_categories">
            <template #trigger>
              <UIcon name="i-icon-park-outline:movie-board" v-if="post.category === 'cinema'" />
              <UIcon name="i-icon-park-outline:computer" v-else-if="post.category === 'development'" />
              <UIcon name="i-icon-park-outline:music" v-else-if="post.category === 'music'" />
              <UIcon name="i-icon-park-outline:book" v-else-if="post.category === 'literature'" />
              <UIcon name="i-icon-park-outline:tag" v-else />
            </template>
          </USelect>
          <USelect v-if="_canEdit" v-model="post.visibility" :items="_visibilities">
            <template #trigger>
              <UIcon name="i-icon-park-outline:preview-close" v-if="post.visibility === 'private'" />
              <UIcon name="i-icon-park-outline:preview-open" v-else-if="post.visibility === 'public'" />
              <UIcon name="i-icon-park-outline:ad-product" v-else-if="post.visibility === 'project:private'" />
              <UIcon name="i-icon-park-outline:badge" v-else-if="post.visibility === 'project:public'" />
              <UIcon name="i-icon-park-outline:preview-close" v-else />
            </template>
          </USelect>

          <USelect :items="_languages" v-if="_canEdit" v-model="_selectedLanguage" item-attribute="label"
            value-attribute="value" />

          <UTooltip v-if="!post.image?.src && _canEdit" content="Upload cover image">
            <template #default>
              <button opacity-50 flex items-center gap-2 @click="uploadCoverImage" :disabled="!_canEdit">
                <div class="i-icon-park-outline:upload-picture"></div>
              </button>
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

          <UToggle v-if="_canEdit" label="i-icon-park-outline:center-alignment" v-model:pressed="_stylesMeta.center"
            toggle-on="soft-blue" toggle-off="soft-gray" />
        </div>

        <div v-if="post.image?.src" class="relative group">
          <img v-if="post.image?.src" :src="post.image.src" class="w-full h-80 object-cover rounded-lg mt-4" />
          <div class="flex gap-2 absolute top-1 right-1">
            <UButton v-if="_canEdit" icon @click="uploadCoverImage" btn="~" label="i-icon-park-outline:upload-picture"
              class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />

            <UButton v-if="_canEdit" icon @click="removeCoverImage" btn="~" label="i-icon-park-outline:delete"
              class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />
          </div>
        </div>
      </div>
    </header>

    <div class="w-full flex justify-center my-8">
      <div class="w-full h-2">
        <svg viewBox="0 0 300 10" preserveAspectRatio="none">
          <path d="M 0 5 Q 15 0, 30 5 T 60 5 T 90 5 T 120 5 T 150 5 T 180 5 T 210 5 T 240 5 T 270 5 T 300 5"
            stroke="currentColor" fill="none" class="text-gray-300 dark:text-gray-700" stroke-width="1" />
        </svg>
      </div>
    </div>


    <main v-if="post" class="max-w-2xl mx-auto pt-8 pb-70%">
      <client-only>
        <tiptap-editor :can-edit="_canEdit" :model-value="post.content" @update:model-value="onUpdateEditorContent" />
      </client-only>
    </main>

    <div v-else class="flex justify-center items-center h-60vh">
      <UProgress indeterminate />
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { PostType } from '~/types/post'
import TiptapEditor from '~/components/TiptapEditor.vue'

const route = useRoute()
let _updatePostContentTimer: NodeJS.Timeout

/** True if data is being saved. */
const _saving = ref<boolean>()
let _updatePostMetaTimer: NodeJS.Timeout
let _updatePostStylesTimer: NodeJS.Timeout
const _fileInput = ref<HTMLInputElement>()

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
  "private", "project:private", "project:public", "public",
])

const _stylesMeta = ref({
  center: false,
})

const getTokenFromCookie = (cookieStr: string) => {
  const tokenMatch = cookieStr?.match(/token=([^;]+)/)
  return tokenMatch ? tokenMatch[1] : ''
}

const headers = useRequestHeaders(['cookie'])
const token = computed(() => {
  // Server side
  if (import.meta.server) {
    return getTokenFromCookie(headers.cookie ?? "")
  }

  // Client side
  return localStorage.getItem("token") ?? ""
})

const { data: post } = await useFetch<PostType>(`/api/posts/${route.params.id}`, {
  headers: {
    "Authorization": token.value ?? "",
  },
})

_selectedLanguage.value = _languages.value.find(l => l.value === post.value?.language) ?? _languages.value[0]
_stylesMeta.value.center = post.value?.styles?.meta?.align === "center"

/** True if the current user is the author of the post. */
const _canEdit = ref(post.value?.canEdit ?? false)

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
    headers: {
      "Authorization": localStorage.getItem("token") ?? "",
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
    headers: {
      "Authorization": localStorage.getItem("token") ?? "",
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
    headers: {
      "Authorization": localStorage.getItem("token") ?? "",
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
    headers: {
      "Authorization": localStorage.getItem("token") ?? "",
    },
  })

  if (success && post.value?.image) {
    // post.value.image.src = ""
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

  const reader = new FileReader()
  reader.onload = async () => {
    try {
      _saving.value = true
      const { image } = await $fetch(`/api/posts/${route.params.id}/upload-image`, {
        method: 'POST',
        body: {
          file: reader.result,
          fileName: file.name,
          type: file.type,
          placement: _imageUploadPlacement.value,
        },
        headers: {
          "Authorization": token.value ?? "",
        },
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
  reader.readAsDataURL(file)
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
