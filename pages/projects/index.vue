<template>
  <div class="max-w-[900px] rounded-xl p-8 flex items-center flex-col transition-all duration-500 overflow-y-auto">
    <PageHeader 
      title="Projects" 
      subtitle="A collection of my creative work"
    />

    <div class="flex-1 flex flex-row gap-x-16 gap-y-12 flex-wrap">
      <div v-for="(projectsList, category) in categories" :key="category" flex flex-col class="w-1/4" min-w-32 max-h-96
        overflow-y-auto>
        <h1 class="text-sm font-600 mb-4 opacity-20 hover:opacity-100 transition uppercase text-center">{{ category }}
        </h1>
        <hr mb-4 />
        <div v-for="project in projectsList.value" :key="project.name" class="mb-6 project-container">
          <div flex flex-row gap-2 items-center>
            <h2 font-body text-3.5 font-500 opacity-100>{{ project.name }}</h2>
            <div class="project-link" flex flex-row gap-2 items-center>
              <NuxtLink v-if="project.links?.find((l: ProjectLinkType) => l.name === 'project')"
                :href="project.links?.find((l: ProjectLinkType) => l.name === 'project')?.href" target="_blank">
                <button
                  class="i-ph:arrow-down-right-duotone rotate--90 hover:scale-110 active:scale-99 transition"></button>
              </NuxtLink>

              <NuxtLink v-if="project.links?.find((l: ProjectLinkType) => l.name === 'post')"
                :to="project.links?.find((l: ProjectLinkType) => l.name === 'post')?.href">
                <button class="i-icon-park-outline:enter-key hover:scale-110 active:scale-99 transition"></button>
              </NuxtLink>

              <div v-if="getToken()">
                <UDialog v-model:open="project.isDeleteDialogOpen" :title="`Delete ${project.name}`"
                  description="Are you sure you want to delete this project?">
                  <template #trigger>
                    <button
                      class="i-icon-park-outline:delete-themes hover:scale-110 active:scale-99 transition -mt-1"></button>
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

              <UDropdownMenu 
                v-if="projectMenuItems(project).length > 0" 
                :items="projectMenuItems(project)" 
                size="xs" menu-label="" 
                :_dropdown-menu-content="{
                class: 'w-52',
                align: 'end',
                side: 'bottom',
              }" :_dropdown-menu-trigger="{
                icon: true,
                square: true,
                class: 'dropdown-menu-icon p-1 w-auto h-auto hover:bg-transparent hover:scale-110 active:scale-99 transition',
                label: 'i-lucide-ellipsis-vertical',
              }" />
            </div>
          </div>
          <span font-text text-3.5 font-400 class="project-description">{{ project.description }}</span>
        </div>
      </div>
    </div>

    <div v-if="getToken()" fixed bottom-12>
      <UDialog v-model:open="_isDialogOpen" title="Create Project" description="Add a new project with a description">
        <template #trigger>
          <UButton btn="solid-gray">
            Create Project
          </UButton>
        </template>

        <div class="grid gap-4 py-4">
          <div class="grid gap-2">
            <div class="grid grid-cols-3 items-center gap-4">
              <ULabel for="name">
                Name
              </ULabel>
              <UInput id="name" v-model="_name" :una="{
                inputWrapper: 'col-span-2',
              }" />
            </div>
            <div class="grid grid-cols-3 items-center gap-4">
              <ULabel for="description">
                Description
              </ULabel>
              <UInput id="description" v-model="_description" :una="{
                inputWrapper: 'col-span-2',
              }" />
            </div>
            <div class="grid grid-cols-3 items-center gap-4">
              <ULabel for="category">
                Category
              </ULabel>
              <div flex flex-row gap-2>
                <USelect id="category" :una="{
                }" v-model="_category" :items="availableCategories" placeholder="Select a category" />
                <UTooltip>
                  <template #default>
                    <UButton btn="outline" icon label="i-icon-park-outline:add-print" class=""
                      @click="toggleAddCategory" />
                  </template>
                  <template #content>
                    <button @click="toggleAddCategory" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1
                      rounded-md m-0 border-1 border-dashed class="b-#3D3BF3">
                      Add a new category
                    </button>
                  </template>
                </UTooltip>
              </div>
            </div>
          </div>
        </div>

        <template #footer>
          <UButton @click="createProject({ name: _name, description: _description, category: _category })" btn="solid"
            label="Create project" />
        </template>
      </UDialog>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { CreateProjectType, ProjectLinkType, ProjectType } from '~/types/project'
import { useAuth } from '~/composables/useAuth'

const { getValidToken, getToken } = useAuth()

useHead({
  title: "rootasjey • projects",
  meta: [
    {
      name: 'description',
      content: 'A collection of my creative work',
    },
  ],
})

const _name = ref('')
const _description = ref('')
const _category = ref('')
const _isDialogOpen = ref(false)

const projectMenuItems = (project: ProjectType) => {
  if (!getToken()) return []

  const items = [
    {
      label: 'Edit',
      onClick: () => {
        navigateTo(`/projects/${project.id}/edit`)
      }
    },
    {}, // to add a separator between items (label or items should be null).
    {
      label: 'Delete',
      onClick: () => {
        project.isDeleteDialogOpen = true
      }
    }
  ]

  if (!project.has_post) {
    items.splice(1, 0, {
      label: "Add Post",
      onClick: () => {
        navigateTo(`/projects/${project.id}/add-post`)
      }
    })
  }

  return items
}

// const { data } = await useFetchWithAuth('/api/projects')
const { data } = await useFetch('/api/projects', {
  headers: {
    "Authorization": await getValidToken(),
  },
})
const categories = toRefs(data?.value ?? {})

const availableCategories = computed(() => {
  return Object.keys(categories ?? {})
})

const createProject = async ({ name, description, category }: CreateProjectType) => {
  _isDialogOpen.value = false
  const { data } = await useFetch("/api/projects/create", {
    method: "POST",
    body: {
      name,
      description,
      category,
    },
    headers: {
      "Authorization": await getValidToken(),
    },
  })
}

const deleteProject = async (project: ProjectType) => {
  project.isDeleteDialogOpen = false
  const { data } = await useFetch("/api/projects/delete", {
    method: "DELETE",
    body: {
      id: project.id,
    },
    headers: {
      "Authorization": await getValidToken(),
    },
  })
}

const toggleAddCategory = () => {
  // const category = prompt('Enter a new category')
  // if (category) {
  //   categories.value[category] = []
  // }
  // console.log(categories.value)
  // return category
}
</script>

<style>
.dropdown-menu-icon {
  box-shadow: none;
}
</style>

<style scoped>
.project-link {
  opacity: 0;
  transition: opacity 0.2s ease-in-out;
}

.project-description {
  opacity: .3;
  transition: opacity 0.2s ease-in-out;
}

.project-container:hover .project-link {
  opacity: 1;
}

.project-container:hover .project-description {
  opacity: .7;
}
</style>
