<template>
  <div class="w-[900px] rounded-xl p-8 
    flex flex-col transition-all duration-500 overflow-y-auto
    mt-[12vh] pb-[38vh]">

    <!-- Header -->
    <header class="mb-8">
      <div class="flex gap-2">
        <ULink to="/" class="hover:scale-102 active:scale-99 transition">
          <span class="i-ph-house-simple-duotone"></span>
        </ULink>
        <span>•</span>
        <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
          Projects
        </h1>
      </div>
      
      <div class="w-40 flex text-center justify-center my-2">
        <div class="w-full h-2">
          <svg viewBox="0 0 300 10" preserveAspectRatio="none">
            <path d="M 0 5 Q 15 0, 30 5 T 60 5 T 90 5 T 120 5 T 150 5 T 180 5 T 210 5 T 240 5 T 270 5 T 300 5"
              stroke="currentColor" fill="none" class="text-gray-300 dark:text-gray-700" stroke-width="1" />
          </svg>
        </div>
      </div>
      
      <p class="text-gray-700 dark:text-gray-300">
        A collection of my creative work
      </p>


        <!-- Add project button for logged in users -->
        <div v-if="loggedIn">
          <UDialog v-model:open="_isDialogOpen" title="Create Project" description="Add a new project with a description">
            <template #trigger>
              <UButton btn="text" size="xs" class="-ml-4 dark:text-amber-400">
                <span>Add a project</span>
                <!-- <span class="i-ph-plus-duotone"></span> -->
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

      <div class="colored-dots flex flex-row gap-2 text-size-6 line-height-8">
        <ULink v-for="(project, index) in projects" :key="project.id" 
          :to="`#${project.id}`" 
          :class="_colors[index]" class="hover:text-size-12 transition-all">•</ULink>
      </div>
    </header>

    <!-- Loading State -->
    <section v-if="status === 'pending'" class="mb-12">
      <div class="flex flex-col items-center justify-center py-8">
        <span class="i-ph-spinner-gap animate-spin text-3xl text-gray-400 dark:text-gray-600 mb-4"></span>
        <p class="text-gray-600 dark:text-gray-400">Loading projects...</p>
      </div>
    </section>

    <!-- Empty State -->
    <section v-if="projects.length === 0 && status !== 'pending'" class="mb-12">
      <div class="flex flex-col items-center justify-center py-16">
        <div class="mb-6">
          <span class="i-ph-app-window text-2xl text-gray-300 dark:text-gray-600"></span>
        </div>
        <h3 class="text-xl font-600 text-gray-700 dark:text-gray-300 mb-2">
          No projects yet
        </h3>
        <p class="text-gray-500 dark:text-gray-400 text-center mb-6 max-w-md">
          This is where my creative projects will live. Check back soon for updates!
        </p>
        <div v-if="loggedIn" class="flex gap-3">
          <UButton @click="_isDialogOpen = true" btn="solid" size="sm">
            <span class="i-ph-plus mr-2"></span>
            Create your first project
          </UButton>
        </div>
      </div>
    </section>

    <!-- Projects List -->
    <section v-else class="my-8">
      <h2 class="text-3 font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-folder-open -mt-1 mr-2"></span>
        Available Projects
      </h2>
      
      <div class="flex flex-row flex-wrap gap-4">
        <div v-for="(project, index) in projects" :key="project.id" 
          :id="project.id"
          class="project-container group 
            w-64 h-72
            flex flex-col
            bg-white dark:bg-gray-900 
            rounded-lg border border-gray-200 dark:border-gray-800
            hover:shadow-sm hover:border-gray-300 dark:hover:border-gray-700
            transition-all duration-300 overflow-hidden">
            
            <!-- Project Image (if available) -->
            <ULink v-if="project.image && project.image.src" :to="`/projects/${project.slug}`" 
              class="w-full h-32 overflow-hidden">
              <NuxtImg 
                provider="hubblob"
                :src="project.image.src" 
                :alt="project.image.alt || project.name" 
                class="w-full h-full object-cover group-hover:scale-105 transition-transform"
              />
            </ULink>
            
            <!-- Project Content -->
            <div class="flex flex-col p-4 flex-grow">
              <div class="flex flex-row justify-between items-start mb-2">
                <NuxtLink :to="`/projects/${project.slug}`" class="flex-grow">
                  <h3 class="text-lg font-bold text-gray-800 dark:text-gray-200 line-clamp-2">
                    {{ project.name }}
                  </h3>
                </NuxtLink>
                
                <div class="project-link flex flex-row gap-1 items-center">
                  <NuxtLink v-if="project.links?.find((l: ProjectLinkType) => l.name === 'project')"
                    :href="project.links?.find((l: ProjectLinkType) => l.name === 'project')?.href" target="_blank">
                    <button
                      class="i-ph:arrow-down-right-duotone rotate--90 hover:scale-110 active:scale-99 transition"></button>
                  </NuxtLink>

                  <NuxtLink v-if="project.links?.find((l: ProjectLinkType) => l.name === 'post')"
                    :to="project.links?.find((l: ProjectLinkType) => l.name === 'post')?.href">
                    <button class="i-icon-park-outline:enter-key hover:scale-110 active:scale-99 transition"></button>
                  </NuxtLink>

                  <UDropdownMenu 
                    v-if="loggedIn && projectMenuItems(project).length > 0" 
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
              
              <p class="text-gray-600 dark:text-gray-400 text-size-3 line-clamp-3 flex-grow">
                {{ project.description }}
              </p>
              
              <div class="mt-auto pt-2 flex justify-between items-center">
                <span :class="`${_colors[index]} text-xs font-medium`">
                  {{ project.category || 'Project' }}
                </span>
                
                <NuxtLink :to="`projects/${project.slug}`" class="flex items-center text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 transition-colors">
                  <span class="text-size-2 flex items-center">
                    <span class="i-ph-arrow-right"></span>
                  </span>
                </NuxtLink>
              </div>
            </div>
            
            <!-- Delete Dialog (only for logged in users) -->
            <UDialog v-if="loggedIn" v-model:open="project.isDeleteDialogOpen" :title="`Delete ${project.name}`"
              description="Are you sure you want to delete this project?">
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
    </section>

    <Footer />
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

const { data, status } = await useFetch('/api/projects')
const projects = (data?.value ?? []) as ProjectType[]
// const categories = toRefs(data?.value ?? {})
const categories = {}

const availableCategories = computed(() => {
  return Object.keys(categories ?? {})
})

const createProject = async ({ name, description, category }: CreateProjectType) => {
  _isDialogOpen.value = false
  await useFetch("/api/projects", {
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
  await useFetch(`/api/projects/${project.id}`, {
    method: "DELETE",
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
