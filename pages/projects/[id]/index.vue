<template>
  <div class="frame">
    <article class=" max-w-4xl mx-auto px-4 py-2 my-24 space-y-8">
      <header v-if="project" class="mt-2
        w-full text-center flex flex-col justify-center items-center">
        
        <div class="w-md mt-2">
          <UInput v-model="project.name"
            class="font-text text-xl font-800 min-h-0 mb-2 p-0 overflow-y-hidden shadow-none text-align-center"
            :readonly="!_canEdit" input="~" label="Name" type="textarea" :rows="1" autoresize />

          <UInput v-model="project.description"
            class="font-text text-gray-700 dark:text-gray-300 shadow-none text-align-center"
            :readonly="!_canEdit" input="~" label="Description" type="textarea" autoresize />
          
          <div class="flex items-center gap-2 mt-2 justify-center">
            <!-- Primary Tag Display/Edit -->
            <div v-if="!_canEdit && primaryTag" class="px-2 py-1 rounded-full text-xs bg-blue-100 dark:bg-blue-900 shadow-sm">
              {{ primaryTag }}
            </div>

            <div class="max-w-40" v-if="_canEdit">
              <USelect v-model="_selectedPrimaryTag" :items="_availableTags" placeholder="Primary tag"
                value-key="value"
                item-key="label"
              >
                <template #trigger>
                  <UIcon name="i-lucide-tag" v-if="_selectedPrimaryTag" />
                  <UIcon name="i-lucide-plus" v-else />
                </template>
              </USelect>
            </div>

            <!-- Status Control -->
            <div class="max-w-20">
              <USelect v-if="_canEdit" v-model="project.status" :items="availableStatuses" item-key="label">
                <template #trigger>
                  <UIcon name="i-ph-rocket-launch" v-if="project.status === 'active'" />
                  <UIcon name="i-ph-rocket" v-else-if="project.status === 'completed'" />
                  <UIcon name="i-ph-hourglass" v-else-if="project.status === 'on-hold'" />
                  <UIcon name="i-ph-archive" v-else-if="project.status === 'archived'" />
                </template>
              </USelect>
            </div>

            <!-- Cover Image Upload -->
            <UTooltip v-if="!project.image?.src && _canEdit">
              <template #default>
                <UButton @click="openFilePicker" :disabled="!_canEdit" btn="outline-gray">
                  <div class="i-icon-park-outline:upload-picture"></div>
                </UButton>
              </template>

              <template #content>
                <div class="px-2 py-1">
                  <p>Upload a cover image for your project.</p>
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
                      The slug is the part of the URL that identifies the project.
                    </p>
                  </div>
                  <UInput v-model="project.slug" label="Slug" class="mt-2" />
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
                  <p>Manage project tags</p>
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
              <svg viewBox="0 0 36 36" fill="none" role="img" xmlns="http://www.w3.org/2000/svg" width="80" height="80"><mask :id="`avatar-mask-${project.id}`" maskUnits="userSpaceOnUse" x="0" y="0" width="36" height="36"><rect width="36" height="36" rx="72" fill="#FFFFFF"></rect></mask><g mask="url(#:ru4:)"><rect width="36" height="36" fill="#ff005b"></rect><rect x="0" y="0" width="36" height="36" transform="translate(9 -5) rotate(219 18 18) scale(1)" fill="#ffb238" rx="6"></rect><g transform="translate(4.5 -4) rotate(9 18 18)"><path d="M15 19c2 1 4 1 6 0" stroke="#000000" fill="none" stroke-linecap="round"></path><rect x="10" y="14" width="1.5" height="2" rx="1" stroke="none" fill="#000000"></rect><rect x="24" y="14" width="1.5" height="2" rx="1" stroke="none" fill="#000000"></rect></g></g></svg>
            </div>
            <div class="text-align-start flex flex-col">
              <h4>{{ project.user?.name }}</h4>
              <span class="text-size-3 text-gray-500 dark:text-gray-400">
                {{ formatDate(project.created_at) }}
              </span>

              <div class="flex items-center gap-2 justify-center">
                <span class="text-size-3 text-gray-500 dark:text-gray-500 dark:hover:text-gray-200 transition">
                  Last updated on {{ formatDate(project.updated_at) }}
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
        <div v-if="project.image?.src" class="relative group">
          <NuxtImg 
            provider="hubblob"
            :src="`/${project.image.src}/original.${project.image.ext}`" 
            class="w-full h-80 object-cover rounded-lg mt-4" 
          />
          <div class="flex gap-2 absolute top-1 right-1">
            <UButton v-if="_canEdit" icon @click="openFilePicker" btn="~" label="i-icon-park-outline:upload-picture"
              class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />

            <UButton v-if="_canEdit" icon @click="removeImage" btn="~" label="i-icon-park-outline:delete"
              class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />
          </div>
        </div>
        
        <div v-else class="mb-8 mt-8 w-md">
          <div class="border-b b-dashed b-b-amber"></div>
          <div class="border-b b-dashed b-b-blue relative top-2"></div>
        </div>
      </header>

      <client-only>
        <div class="w-500px pt-8 mx-auto text-gray-700 dark:text-gray-300">
          <tiptap-editor :can-edit="loggedIn" :model-value="project.article" @update:model-value="onUpdateEditor" />
        </div>
      </client-only>
    </article>

    <div class="w-500px mx-auto">
      <Footer />
    </div>

    <!-- Edit toolbar -->
    <div class="fixed w-full bottom-8 flex justify-center items-center">
      <div class="flex gap-1 backdrop-blur border bg-white/80 dark:bg-black/20 shadow-2xl p-2 rounded-4">
        <UTooltip content="Go back">
          <template #default>
            <UButton icon btn="ghost-gray" @click="$router.back()">
              <div class="i-ph:arrow-bend-down-left-bold"></div>
            </UButton>
          </template>
          <template #content>
            <button @click="$router.back()" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
              Go back
            </button>
          </template>
        </UTooltip>

        <UTooltip v-if="loggedIn">
          <template #default>
            <UButton icon btn="ghost-gray" @click="_canEdit = !_canEdit">
              <UIcon v-if="!_canEdit" name="i-ph:pencil" />
              <UIcon v-else name="i-ph-eye-bold" />
            </UButton>
          </template>
          <template #content>
            <button @click="_canEdit = !_canEdit" 
              bg="light dark:dark" 
              text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
              {{ _canEdit ? 'View as readonly' : 'Edit project'}}
            </button>
          </template>
        </UTooltip>

        <UTooltip v-if="loggedIn" content="Export to JSON">
          <template #default>
            <UButton icon btn="ghost-gray" @click="exportProjectToJson">
              <div class="i-icon-park-outline:download-two"></div>
            </UButton>
          </template>
          <template #content>
            <button @click="exportProjectToJson" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1
              rounded-md border-1 border-dashed class="b-#3D3BF3">
              Export to JSON
            </button>
          </template>
        </UTooltip>

        <UTooltip content="Upload cover image" v-if="loggedIn && !project.image.src">
          <template #default>
            <UButton 
              icon
              btn="ghost-gray"
              label="i-icon-park-outline-upload-picture"
              @click="openFilePicker"
            />
          </template>
          <template #content>
            <button bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
              Upload cover image
            </button>
          </template>
        </UTooltip>

        <input 
          type="file" 
          ref="fileInput" 
          accept="image/*" 
          class="hidden" 
          @change="handleCoverSelect" 
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { ProjectType } from '~/types/project'

const { loggedIn, user } = useUserSession()
const route = useRoute()
const { allTags, addTag, getSuggestedTags, getPrimaryTag, getSecondaryTags } = useTags()

const availableStatuses = [
  { label: 'Active', value: 'active' },
  { label: 'Completed', value: 'completed' },
  { label: 'On Hold', value: 'on-hold' },
  { label: 'Archived', value: 'archived' },
]

const fileInput = ref<HTMLInputElement | null>(null)
const isUploading = ref(false)
let _articleTimer: NodeJS.Timeout
const _saving = ref(false)
const _showTagsDialog = ref(false)
const _selectedPrimaryTag = ref('')
const _projectTags = ref<string[]>([])

const id = route.params.id
const { data } = await useFetch(`/api/projects/${id}`)
const project = ref((data.value ?? {}) as ProjectType)

const _canEdit = ref<boolean>(loggedIn.value && project.value?.user_id === user.value?.id)

// Initialize tags from project
if (project.value?.tags) {
  _projectTags.value = [...project.value.tags]
  _selectedPrimaryTag.value = getPrimaryTag(project.value.tags) || ''
}

const openFilePicker = () => {
  fileInput.value?.click()
}

const removeImage = async () => {
  project.value.image.src = ''
  project.value.image.alt = ''

  const response = await $fetch(`/api/projects/${id}/cover`, {
    method: "DELETE",
  })

  if (!response.success) {
    console.error('Failed to remove image, ', response.error)
  }
}

const handleCoverSelect = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  isUploading.value = true
  
  try {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('fileName', file.name)
    formData.append('type', file.type)
    
    const response = await $fetch(`/api/projects/${id}/cover`, {
      method: 'POST',
      body: formData,
    })
    
    if (response.success) {
      project.value.image.src = response.image.src
      project.value.image.alt = response.image.alt
    }
  } catch (error) {
    console.error('Error uploading image:', error)
    alert('Failed to upload image. Please try again.')
  } finally {
    isUploading.value = false
    // Reset the file input
    if (fileInput.value) {
      fileInput.value.value = ''
    }
  }
}

const onUpdateEditor = (value: Object) => {
  clearTimeout(_articleTimer)
  _articleTimer = setTimeout(() => updateProjectArticle(value), 2000)
}

const updateProjectArticle = async (value: Object) => {
  await $fetch(`/api/projects/${route.params.id}/article`, {
    method: "PUT",
    body: {
      article: value,
    },
  })
}

/**
 * Export the current project to a JSON file and download it to the user's device
 */
const exportProjectToJson = () => {
  if (!project.value) return
  
  // Create a clean version of the project for export
  const exportData = {
    tags: project.value.tags,
    company: project.value.company,
    article: project.value.article,
    created_at: project.value.created_at,
    description: project.value.description,
    id: project.value.id,
    image: project.value.image,
    links: project.value.links,
    name: project.value.name,
    slug: project.value.slug,
    post: project.value.post,
    user_id: project.value.user_id,
    updated_at: project.value.updated_at,
    status: project.value.status,
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
  a.download = `${project.value.slug || project.value.id}-${new Date().toISOString().split('T')[0]}.json`
  
  // Append to the document, click to download, then remove
  document.body.appendChild(a)
  a.click()
  
  // Clean up
  setTimeout(() => {
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
  }, 0)
}

// Computed properties for tags
const _availableTags = computed(() => {
  return allTags.value.map(tag => ({ label: tag, value: tag }))
})

const primaryTag = computed(() => {
  return getPrimaryTag(project.value?.tags || [])
})

const secondaryTags = computed(() => {
  return getSecondaryTags(project.value?.tags || [])
})

const formatDate = (date: string | Date): string => {
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

</script>

<style scoped>
.frame {
  border-radius: 0.75rem;
  padding: 2rem;
  padding-bottom: 38vh;
  display: flex;
  flex-direction: column;
  transition-property: all;
  transition-duration: 500ms;
  overflow-y: auto;

  background-color: #f1f1f1;
  width: 100%;
  min-height: 100vh;
}

.dark .frame {
  background-color: #000;
}
</style>
