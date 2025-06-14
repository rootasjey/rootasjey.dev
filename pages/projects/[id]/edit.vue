<template>
  <div class="max-w-[900px] rounded-xl p-8 flex flex-col">
    <header class="mb-8">
      <div class="flex items-center gap-2">
        <UTooltip content="Go back" :_tooltip-content="{
          side: 'right',
        }">
          <template #default>
            <button opacity-50 flex items-center gap-2 @click="$router.back()">
              <div class="i-ph:arrow-bend-down-left-bold"></div>
            </button>
          </template>
          <template #content>
            <button @click="$router.back()" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md m-0
              border-1 border-dashed class="b-#3D3BF3">
              Go back
            </button>
          </template>
        </UTooltip>
        <div>
          <h1 class="font-title text-2xl">Edit {{ project.name }} </h1>
          <div class="flex items-center gap-2 -mt-2">
            <h5 class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
              Edit this project fields
            </h5>

            <div v-if="loggedIn">
              <UDialog v-model:open="project.isDeleteDialogOpen" :title="`Delete ${project.name}`"
                description="Are you sure you want to delete this project?">
                <template #trigger>
                  <UButton btn="link" label="• Delete project" class="text-red-500 dark:text-red-400 p-0 text-12px" />
                </template>

                <template #default>
                  <div class="flex flex-col gap-2">
                    <UButton btn="solid-gray" @click="project.isDeleteDialogOpen = false">
                      Cancel
                    </UButton>
                    <UButton btn="solid-red" @click="deleteProject(project)">
                      Delete
                    </UButton>
                  </div>
                </template>
              </UDialog>
            </div>
          </div>
        </div>
      </div>
    </header>

    <div class="grid gap-6">
      <div class="grid grid-cols-3 items-center gap-4">
        <ULabel for="name">Name <span class="text-red">*</span></ULabel>
        <UInput required type="text" id="name" v-model="project.name" :una="{ inputWrapper: 'col-span-2' }" />
      </div>

      <div class="grid grid-cols-3 items-center gap-4">
        <ULabel for="description">Description</ULabel>
        <UInput id="description" v-model="project.description" :una="{ inputWrapper: 'col-span-2' }" type="textarea"
          placeholder="Write your message here..." />
      </div>

      <div class="grid grid-cols-3 items-center gap-4">
        <ULabel for="category">Category</ULabel>
        <USelect id="category" v-model="project.category" :items="availableCategories" />
      </div>

      <div class="grid grid-cols-3 items-center gap-4">
        <ULabel for="company">Company</ULabel>
        <UInput id="company" v-model="project.company" :una="{ inputWrapper: 'col-span-2' }" />
      </div>

      <div class="grid grid-cols-3 items-center gap-4">
        <ULabel for="slug">Slug</ULabel>
        <UInput id="slug" v-model="project.slug" :una="{ inputWrapper: 'col-span-2' }" />
      </div>

      <div class="grid grid-cols-3 items-center gap-4">
        <ULabel for="visibility">Visibility</ULabel>
        <USelect id="category" v-model="project.visibility" :items="availableVisibility" />
      </div>

      <div class="flex justify-end gap-4 mt-4">
        <UButton btn="outline" @click="$router.back()">Cancel</UButton>
        <UButton btn="solid" @click="saveProject">Save Changes</UButton>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { ProjectType } from '~/types/project'
const { loggedIn, user, fetch: refreshSession, session } = useUserSession()

const route = useRoute()
const _isDeletePostDialogIsOpen = ref(false)

const project = ref <ProjectType>({
  category: "",
  company: "",
  created_at: "",
  description: "",
  id: "0",
  image: {
    alt: "",
    src: "",
  },
  links: [],
  name: "",
  slug: "",
  updated_at: "",
  user_id: "0",
  visibility: "public",
})

// Fetch project data on page load
const { data } = await useFetch(`/api/projects/${route.params.id}`)

// Populate form with existing data
project.value = { ...data.value as ProjectType }

const availableCategories = ref([
  "entrepreneur", "employee", "freelancer",
])

const availableVisibility = ref([
  "public", "private"
])

const saveProject = async () => {
  try {
    await $fetch(`/api/projects/${route.params.id}/update`, {
      method: 'PUT',
      body: project.value,
    })
  
    if (data.value) {
      navigateTo('/projects')
    }
  } catch (error) {
    console.error(error)
  }
}

const deleteProject = async (project: ProjectType) => {
  project.isDeleteDialogOpen = false
  await useFetch(`/api/projects/${project.id}`, {
    method: "DELETE",
  })
}

const deletePost = async (postId: string) => {
  try {
    project.value.post = ""
    
    await $fetch(`/api/projects/${route.params.id}/delete-post`, {
      method: 'PUT',
      body: {
        postId
      },
    })
  } catch (error) {
    project.value.post = postId
    console.error(error)
  } finally {
    _isDeletePostDialogIsOpen.value = false
  }
}
</script>
