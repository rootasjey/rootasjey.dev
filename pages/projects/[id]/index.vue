<template>
  <div class="bg-[#F1F1F1] dark:bg-[#000] w-full min-h-screen">
    <article class=" max-w-4xl mx-auto px-4 py-8 my-24 space-y-8">
      <!-- Header -->
       <header class="mb-16 text-center flex flex-col items-center">
        <div class="flex items-center gap-4">
          <UTooltip
            content="Go back"
          :_tooltip-content="{
            side: 'right',
          }">
            <template #default>
              <button opacity-50 flex items-center gap-2 @click="$router.back()">
                <div class="i-ph:arrow-bend-down-left-bold"></div>
              </button>
            </template>
            <template #content>
              <button @click="$router.back()" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
                Go back
              </button>
            </template>
          </UTooltip>

          <UTooltip
           v-if="loggedIn"
            content="Edit project"
          :_tooltip-content="{
            side: 'right',
          }">
            <template #default>
              <button opacity-50 flex items-center gap-2 @click="navigateTo(`/projects/${project.id}/edit`)">
                <div class="i-ph:pencil"></div>
              </button>
            </template>
            <template #content>
              <button @click="navigateTo(`/projects/${project.id}/edit`)" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
                Edit project's metadata
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
            @change="handleFileChange" 
          />
        </div>

        <div class="flex items-center gap-2 ml--3">
          <h1 class="font-body text-size-18 font-600 text-gray-800 dark:text-gray-200">
            {{ project.name }}
          </h1>
        </div>
        <h5 class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
          {{ project.description }}
        </h5>
        <div class="flex gap-4 items-center">
          <a href="#" class="text-[#8E7DBE] dark:text-[#AFDDFF] text-3 hover:underline">GitHub</a>
          <span>•</span>
          <a href="#" class="text-[#F75A5A] text-3 hover:underline">See it live <i class="i-ph-rocket-launch-duotone" /> </a>
        </div>
      </header>

      <!-- Hero Image -->
      <div v-if="isUploading" class="w-full h-[300px] rounded-4 flex items-center justify-center bg-gray-100 dark:bg-gray-800">
        <div class="animate-spin i-ph:spinner-gap text-6"></div>
      </div>
      <div v-if="project.image.src" >
        <NuxtImg 
          provider="hubblob"
          :src="project.image.src" 
          :alt="project.image.alt || project.name" 
          class="w-full rounded-4 shadow-lg h-auto max-h-[500px] object-cover"
        />
        <div v-if="loggedIn" class="flex justify-end gap-4 mt-2 mr-2">
          <button @click="removeImage" class="font-600 text-size-3 text-gray-500 hover:text-[#F75A5A]">Remove Image</button>
          <button @click="openFilePicker" class="font-600 text-size-3 text-gray-500 hover:text-[#3A59D1]">Change Image</button>
        </div>
      </div>

      <client-only>
        <div class="pt-8 max-w-3xl mx-auto text-size-8 font-text text-gray-800 dark:text-gray-200">
          <tiptap-editor :can-edit="loggedIn" :model-value="project.content" @update:model-value="onUpdateEditorContent" />
        </div>
      </client-only>

      <!-- Buttons navigation -->
      <div class="flex gap-2 mt-8">
        <button 
          @click="$router.back()"
          class="hover:border-1 border-dashed b-amber 
            text-3 opacity-60 hover:opacity-100 font-600 
            py-1 px-4 rounded flex gap-2 items-center 
            hover:scale-105 transition-all 
            active:scale-99 active:border-solid">
          <div class="i-ph:arrow-bend-down-left-bold"></div>
          <span>back</span>
        </button>
      </div>
    </article>
  </div>
</template>

<script lang="ts" setup>
import type { ProjectType } from '~/types/project'

const { loggedIn } = useUserSession()
const route = useRoute()
const fileInput = ref<HTMLInputElement | null>(null)
const isUploading = ref(false)

let _updatePostContentTimer: NodeJS.Timeout

const id = route.params.id
const { data } = await useFetch(`/api/projects/${id}`)

const project = ref((data.value ?? {}) as ProjectType)
if (typeof project.value?.content === "string") {
  project.value.content = JSON.parse(project.value.content)
}

const openFilePicker = () => {
  fileInput.value?.click()
}

const removeImage = async () => {
  project.value.image.src = ''
  project.value.image.alt = ''

  const response = await $fetch(`/api/projects/${id}/remove-image`, {
    method: "DELETE",
  })

  if (!response.success) {
    console.error('Failed to remove image, ', response.error)
  }
}

const handleFileChange = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  isUploading.value = true
  
  try {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('fileName', file.name)
    formData.append('type', file.type)
    
    const response = await $fetch(`/api/projects/${id}/upload-image`, {
      method: 'POST',
      body: formData
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

const onUpdateEditorContent = (value: Object) => {
  clearTimeout(_updatePostContentTimer)
  _updatePostContentTimer = setTimeout(() => updateProjectContent(value), 2000)
}

const updateProjectContent = async (value: Object) => {
  await $fetch(`/api/projects/${route.params.id}/update-content`, {
    method: "PUT",
    body: {
      content: value,
    },
  })
}
</script>

<style scoped></style>
