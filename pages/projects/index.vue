<template>
  <div class="w-full bg-[#F1F1F1] dark:bg-[#000] flex flex-col items-center min-h-screen">
    <!-- Hero Section -->
    <section class="w-[820px] mt-24 md:mt-42 mb-12 text-center p-2 md:p-8">
      <div class="flex items-center justify-center gap-3 mb-6">
        <h1 class="font-body text-6xl font-600 text-gray-800 dark:text-gray-200">
          Projects
        </h1>
      </div>
      
      <h4 class="text-size-5 font-300 mb-6 text-gray-800 dark:text-gray-200 max-w-2xl mx-auto">
        A curated collection of creative endeavors. 
        Each project represents a step in the journey of learning, creating, and sharing.
      </h4>
      <h4 class="text-size-5 font-300 mb-6 text-gray-800 dark:text-gray-200 max-w-2xl mx-auto">
        I tagged them according to their technologies and for which company they were made.
        Most of my projects are open source. Feel free to explore and contribute.
      </h4>

      <div v-if="loggedIn" class="mb-8">
        <UButton 
          @click="isCreateDialogOpen = true" 
          btn="soft" 
          size="xs" 
          class="hover:scale-101 active:scale-99 transition dark:bg-gray-800 dark:text-gray-200"
        >
          <span class="i-ph-plus mr-2"></span>
          <span>Add a project</span>
        </UButton>
      </div>

      <!-- Project navigation dots -->
      <div class="colored-dots flex flex-row gap-3 justify-center mb-8">
        <ULink v-for="(project, index) in projects" :key="project.id" 
          :to="`#${project.id}`" 
          :style="{ color: _colors[index]?.replace('color-', '') || '#8F87F1' }" 
          class="hover:scale-150 transition-all duration-300 text-xl opacity-70 hover:opacity-100">
          •
        </ULink>
      </div>
    </section>

    <!-- Loading State -->
    <section v-if="status === 'pending'" class="w-[820px] mb-12">
      <div class="flex flex-col items-center justify-center py-16">
        <span class="i-ph-spinner-gap animate-spin text-4xl text-gray-400 dark:text-gray-600 mb-6"></span>
        <p class="text-size-4 font-300 text-gray-600 dark:text-gray-400">Loading projects...</p>
      </div>
    </section>

    <!-- Empty State -->
    <section v-else-if="projects.length === 0" class="w-2xl -mt-24 mb-12">
      <div class="flex flex-col items-center justify-center py-24">
        <div class="w-full mb-8 border-b b-dashed b-cyan" />
        <h3 class="text-size-4 font-600 text-gray-700 dark:text-gray-300 mb-1">
          No projects yet
        </h3>
        <p class="text-size-4 font-300 text-center mb-4 max-w-md text-gray-500 dark:text-gray-400">
          This space awaits the birth of new ideas. Every great project starts with a single step.
        </p>
        <div v-if="loggedIn">
          <UButton @click="isCreateDialogOpen = true" btn="soft-blue" size="sm" 
            class="hover:scale-101 active:scale-99 transition-transform">
            <UIcon name="i-ph-plus" />
            <span>Create your first project</span>
          </UButton>
        </div>
      </div>
    </section>

    <!-- Projects Grid -->
    <section v-else class="w-full max-w-6xl px-4 mb-24">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <article v-for="(project, index) in projects" :key="project.id" 
          :id="project.id.toString()"
          class="group flex flex-col gap-2">
          <div class="flex gap-2">
            <div class="w-6 h-6 rounded-1 shadow relative overflow-hidden">
              <UDropdownMenu 
                v-if="loggedIn && projectMenuItems(project).length > 0" 
                :items="projectMenuItems(project)" 
                size="xs" menu-label="" 
                :_dropdown-menu-content="{
                  class: 'w-52',
                  align: 'end',
                  side: 'bottom',
                }"
              >
                <div class="cursor-pointer 
                  dark:bg-[#222831]
                  w-full h-full flex items-center justify-center
                hover:scale-110 active:scale-99 transition"
                >
                  <NuxtImg 
                    v-if="project.image && project.image.src"
                    provider="hubblob"
                    :src="`/${project.image.src}/xs.${project.image.ext}`" 
                    :alt="project.image.alt || project.name" 
                    class="w-full h-full object-cover"
                  />
                  <div v-else class="flex items-center justify-center">
                    <UIcon name="i-ph-armchair-duotone" />
                  </div>
                </div>
              </UDropdownMenu>
            </div>

            <NuxtLink :to="`/projects/${project.slug}`" class="block mb-3">
              <h3 class="font-text font-700 text-size-4  text-gray-800 dark:text-gray-200 line-clamp-2 group-hover:text-gray-600 dark:group-hover:text-gray-300 transition-colors">
                {{ project.name }}
              </h3>
            </NuxtLink>

            <!-- Action buttons overlay -->
            <div class="flex items-start gap-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
              <NuxtLink v-if="extractProjectLink(project)"
                :href="extractProjectLink(project)" target="_blank"
                class="w-6 h-6 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm rounded-full flex items-center justify-center hover:scale-110 transition-transform">
                <span class="i-ph:arrow-up-right text-sm"></span>
              </NuxtLink>
            </div>
          </div>
          
          <!-- Project Content -->
          <ULink v-if="project.description" :to="`/projects/${project.slug}`" class="hover:scale-101 active:scale-99 transition-transform">
            <div class="relative p-6 bg-white dark:bg-gray-900 rounded-4">
              <p class="font-capital text-size-4 font-500 line-clamp-3 leading-relaxed text-gray-800 dark:text-gray-400 ">
                {{ project.description }}
              </p>
              
              <TagDisplay 
                v-if="project.tags && project.tags.length > 0"
                :tags="project.tags" 
                display-mode="primary-count"
                class="mt-2"
                :primary-tag-color="_colors[index]?.replace('color-', '') || 'blue'"
              />

              <UDropdownMenu 
                v-if="loggedIn && projectMenuItems(project).length > 0" 
                :items="projectMenuItems(project)" 
                size="xs" menu-label="" 
                :_dropdown-menu-content="{
                  class: 'w-52',
                  align: 'end',
                  side: 'bottom',
                }"
              >
                <UIcon 
                  name="i-ph-dots-three-vertical-bold" 
                  class="absolute bottom-4 right-4"
                />
              </UDropdownMenu>
            </div>
          </ULink>
          
          <!-- Delete Dialog -->
          <UDialog v-if="loggedIn" v-model:open="project.isDeleteDialogOpen" :title="`Delete ${project.name}`"
            description="Are you sure you want to delete this project? This action cannot be undone.">
            <template #default>
              <div class="flex flex-col gap-3 pt-4">
                <UButton btn="solid-gray" @click="project.isDeleteDialogOpen = false" class="w-full">
                  Cancel
                </UButton>
                <UButton btn="solid-red" @click="deleteProject(project)" class="w-full">
                  Delete Project
                </UButton>
              </div>
            </template>
          </UDialog>
        </article>
      </div>
    </section>

    <!-- Create Project Dialog -->
    <CreateProjectDialog 
      v-model="isCreateDialogOpen"
      @create-project="handleCreateProject"
    />

    <Footer class="mt-24 mb-42 w-[1100px]" />

    <EditProjectDialog
      v-model="isEditDialogOpen"
      :project="projectToEdit"
      @update-project="handleUpdateProjectDialog"
    />
  </div>
</template>

<script lang="ts" setup>
import type { CreateProjectType, ProjectLinkType, ProjectType } from '~/types/project'
const { loggedIn } = useUserSession()

useHead({
  title: "root • projects",
  meta: [
    {
      name: 'description',
      content: 'A curated collection of creative endeavors, experiments, and meaningful builds.',
    },
  ],
})

// Dialog state
const isCreateDialogOpen = ref(false)

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

const isEditDialogOpen = ref(false)
const projectToEdit = ref<ProjectType | null>(null)

// Handler to open the edit dialog
const openEditDialog = (project: ProjectType) => {
  projectToEdit.value = project
  isEditDialogOpen.value = true
}

// Handler for dialog update event
const handleUpdateProjectDialog = async (updateData: any) => {
  await updateProject(updateData.id, {
    name: updateData.name,
    description: updateData.description,
    company: updateData.company,
    tags: updateData.tags,
    status: updateData.status,
    start_date: updateData.startDate,
    end_date: updateData.endDate,
  })
  isEditDialogOpen.value = false
  projectToEdit.value = null
}
const projectMenuItems = (project: ProjectType) => {
  if (!loggedIn.value) return []

  return [
    {
      label: 'Edit',
      onClick: () => {
        openEditDialog(project)
      }
    },
    {},
    {
      label: 'Delete',
      onClick: () => {
        project.isDeleteDialogOpen = true
      }
    }
  ]
}

const { data, status, refresh } = await useFetch('/api/projects')
const projects = data.value?.projects as ProjectType[]

const handleCreateProject = async (projectData: CreateProjectType) => {
  try {
    await $fetch("/api/projects", {
      method: "POST",
      body: projectData,
    })
    
    await refresh()
    console.log('Project created successfully')
  } catch (error) {
    console.error('Failed to create project:', error)
  }
}

const updateProject = async (projectId: string, projectData: Partial<ProjectType>) => {
  try {
    await $fetch(`/api/projects/${projectId}`, {
      method: "PUT",
      body: projectData,
    })
    
    await refresh()
    console.log('Project updated successfully')
  } catch (error) {
    console.error('Failed to update project:', error)
  }
}

const deleteProject = async (project: ProjectType) => {
  project.isDeleteDialogOpen = false
  try {
    await $fetch(`/api/projects/${project.id}`, {
      method: "DELETE",
    })
    
    await refresh()
    console.log('Project deleted successfully')
  } catch (error) {
    console.error('Failed to delete project:', error)
  }
}

const extractProjectLink = (project: ProjectType) => {
  const link = project.links?.find((l: ProjectLinkType) => l.name === 'project')
  return link?.href || ''
}
</script>

<style scoped>
.dark .project-card {
  background-color: rgba(17, 24, 39, 0.5);
  border-color: rgb(31, 41, 55);

  &:hover {
    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
    border-color: rgb(55, 65, 81);
  }
}

@supports (backdrop-filter: blur(10px)) {
  .project-card {
    backdrop-filter: blur(10px);
  }
}
</style>
