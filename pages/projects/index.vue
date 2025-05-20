// pages/projects/index.vue
<template>
  <div class="max-w-[900px] rounded-xl p-8 
    flex flex-col transition-all duration-500 overflow-y-auto
    mt-[12vh] pb-[38vh]">

    <div class="flex gap-2">
      <ULink class="flex flex-col ml-3" to="/">
        <span class="i-ph-house-simple-duotone text-xl text-gray-600 dark:text-gray-400" />
      </ULink>

      <div v-if="loggedIn">
        <UDialog v-model:open="_isDialogOpen" title="Create Project" description="Add a new project with a description">
          <template #trigger>
            <UButton 
              label="i-ph-plus-bold" 
              class="w-auto h-auto p-1" 
              btn="ghost" size="xs" icon />
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

    <header class="w-full ml-6 mb-6 text-center flex flex-col items-start">
      <div class="flex items-center gap-2 ml--3">
        <UTooltip content="Go back" :_tooltip-content="{
          side: 'right',
        }">
          <template #default>
            <button class="opacity-50 flex items-center gap-2 hover:scale-110 focus:scale-90 transition-all" @click="$router.back()">
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
        <h1 class="font-title text-2xl font-600 text-gray-800 dark:text-gray-200">
          Projects
        </h1>
      </div>
      <h5 class="ml-4 text-gray-800 dark:text-gray-200 text-12px opacity-50">
        A collection of my creative work
      </h5>

      <div class="colored-dots flex flex-row gap-2 ml-4 text-size-6 line-height-8">
        <ULink v-for="(project, index) in projects" :key="project.id" 
          :to="`#${project.id}`" 
          :class="_colors[index]" class="hover:text-size-12 transition-all">•</ULink>
      </div>
    </header>

    <div class="flex flex-col">
      <div v-for="(project, index) in projects" :key="project.id" 
        :id="project.id"
        class="project-container group 
          w-full
          flex flex-col p-3
          border b-dashed b-transparent shadow-gray-200 rounded-xl 
          hover:pl-6 
        hover:border-gray-200 hover:shadow-md dark:hover:shadow-gray-800
          transition-all duration-300">
          <div class="flex flex-row justify-between items-center">
            <div class="flex flex-row gap-2 items-center">
              <div class="rounded-2 p-2">
                <NuxtLink :to="`/projects/${project.slug}`">
                  <h2 class="text-size-20 text-gray-600" :class="`${_colors[index]}`">{{ project.id }}</h2>
                </NuxtLink>
              </div>

              <div class="title-description">
                <div class="flex flex-row gap-2 items-center">
                  <NuxtLink :to="`/projects/${project.slug}`">
                    <h2 class="font-text text-size-8 font-400 text-gray-600  dark:text-gray-300">
                      {{ project.name }}
                    </h2>
                  </NuxtLink>
                  <div class="project-link flex flex-row gap-2 items-center">
                    <NuxtLink v-if="project.links?.find((l: ProjectLinkType) => l.name === 'project')"
                      :href="project.links?.find((l: ProjectLinkType) => l.name === 'project')?.href" target="_blank">
                      <button
                        class="i-ph:arrow-down-right-duotone rotate--90 hover:scale-110 active:scale-99 transition"></button>
                    </NuxtLink>

                    <NuxtLink v-if="project.links?.find((l: ProjectLinkType) => l.name === 'post')"
                      :to="project.links?.find((l: ProjectLinkType) => l.name === 'post')?.href">
                      <button class="i-icon-park-outline:enter-key hover:scale-110 active:scale-99 transition"></button>
                    </NuxtLink>

                    <div v-if="loggedIn">
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
                  <span class="font-text text-3.5 font-400 text-gray-600 dark:text-gray-400 group-hover:text-gray-600 dark:group-hover:text-white transition-all">
                    {{ project.description }}
                  </span>
                </div>
            </div>

            <NuxtLink :to="`projects/${project.slug}`">
              <i class="i-ph-caret-right text-size-12 opacity-0 group-hover:opacity-100 group-hover:mr-4 transition-all" />
            </NuxtLink>
          </div>
        </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { CreateProjectType, ProjectLinkType, ProjectType } from '~/types/project'
const { loggedIn } = useUserSession()


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

const _colors = [
  'color-#8F87F1',
  'color-#C68EFD',
  'color-#E9A5F1',
  'color-#FED2E2',
  'color-#FFC6C6',
  'color-#FDB7EA',
  'color-#B7B1F2',
  'color-#AFDDFF',
  'color-#60B5FF',
  'color-#FFCDB2',
  'color-#FFB4A2',
  'color-#E5989B',
  'color-#B5828C',
  'color-#FFC785',
  'color-#F6F7C4',
  'color-#A1EEBD',
  'color-#7BD3EA',
  'color-#9FB3DF',
  'color-#9EC6F3',
  'color-#BDDDE4',
  'color-#FFF1D5',
]

const projectMenuItems = (project: ProjectType) => {
  if (!loggedIn.value) return []

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

  return items
}

const { data } = await useFetch('/api/projects')
const projects = (data?.value ?? []) as ProjectType[]
// const categories = toRefs(data?.value ?? {})
const categories = {}

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
  })
}

const deleteProject = async (project: ProjectType) => {
  project.isDeleteDialogOpen = false
  const { data } = await useFetch("/api/projects/delete", {
    method: "DELETE",
    body: {
      id: project.id,
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

.project-container:hover .project-link {
  opacity: 1;
}
</style>
