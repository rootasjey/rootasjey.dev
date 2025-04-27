<template>
  <div class="rounded-xl p-8 flex items-center flex-col">
    <header class="mb-12 text-center flex flex-col items-center">
      <div class="flex items-center gap-2 ml--3">
        <UTooltip content="Go back">
          <template #default>
            <button opacity-50 flex items-center gap-2 @click="$router.back()">
              <div class="i-ph:arrow-bend-down-left-bold"></div>
            </button>
          </template>
        </UTooltip>
        <h1 class="font-title text-2xl font-600">Add Post</h1>
      </div>
      <h5 class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
        Add a new post to {{ project?.name }}
      </h5>
    </header>

    <div class="w-full">
      <form @submit.prevent="createPost" class="flex flex-col gap-4">
        <ULabel label="Name *" class="uppercase opacity-30 text-3 -mb-2" />
        <UInput v-model="_name" label="Name" :placeholder="`How I've built ${project?.name}`" input="solid"
          class="min-w-260px" :disabled="_isLoading" :loading="_isLoading" :una="{
            inputLoading: 'animate-pulse',
            inputLoadingIcon: 'i-icon-park-outline:more',
          }" />

        <ULabel label="Description" class="uppercase opacity-30 text-3 -mb-2 mt-0" />
        <UInput v-model="_description" label="Description" placeholder="This jouney started at 2:00 AM..."
          input="outline-lime" :disabled="_isLoading" />

        <UButton type="submit" btn="solid" :loading="_isLoading">
          {{ _isLoading ? 'Creating Post...' : 'Create Post' }}
        </UButton>
      </form>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { ProjectType } from '~/types/project'

const route = useRoute()
const router = useRouter()

const _projectId = route.params.id as string
const _isLoading = ref(false)

const {  data: project } = await useFetch<ProjectType>(`/api/projects/${_projectId}`)
const _name = ref(`How I've built ${project?.value?.name}`)
const _description = ref("This jouney started at 2:00 AM...")

const createPost = async () => {
  _isLoading.value = true

  try {
    const { data } = await useFetch(`/api/projects/${_projectId}/add-post`, {
      method: 'POST',
      body: {
        name: _name.value || `How I've built ${project?.value?.name}`,
        description: _description.value ?? "This jouney started at 2:00 AM...",
      },
    })
  
    if (data.value) {
      router.push(`/projects/${_projectId}`)
    }
  } catch (error) {
    console.error(error)
  } finally {
    _isLoading.value = false
  }
}
</script>
