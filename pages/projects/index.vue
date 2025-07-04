<template>
  <div class="w-full bg-[#F1F1F1] dark:bg-[#000] flex flex-col items-center min-h-screen">
    <ProjectsHeader
      :is-loading="status === 'pending'"
      :show-dialogs="loggedIn"
      :create-dialog-model="isCreateDialogOpen"
      :edit-dialog-model="isEditDialogOpen"
      :delete-dialog-model="isDeleteDialogOpen"
      :editing-project="projectToEdit"
      :deleting-project="projectToDelete"
      :projects="projects"
      :colors="_colors"
      @create-project="handleCreateProject"
      @update-project="handleUpdateProjectDialog"
      @delete-project="handleDeleteProject"
      @update:create-dialog-model="isCreateDialogOpen = $event"
      @update:edit-dialog-model="isEditDialogOpen = $event"
      @update:delete-dialog-model="isDeleteDialogOpen = $event"
    />

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
        <ProjectMinimalCard
          v-for="(project, index) in projects"
          :key="project.id"
          :project="project"
          :index="index"
          :logged-in="loggedIn"
          :project-menu-items="projectMenuItems(project)"
          :colors="_colors"
        />
      </div>
    </section>

    <Footer class="mt-24 mb-42" :class="{ 'w-[1100px]': projects.length !== 0 }" />
  </div>
</template>

<script lang="ts" setup>
import type { CreateProjectPayload, Project } from '~/types/project'
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
const projectToEdit = ref<Project | undefined>(undefined)

const isDeleteDialogOpen = ref(false)
const projectToDelete = ref<Project | undefined>(undefined)

// Handler to open the edit dialog
const openEditDialog = (project: Project) => {
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
    startDate: updateData.startDate,
    endDate: updateData.endDate,
  })
  isEditDialogOpen.value = false
  projectToEdit.value = undefined
}

// Handler to open the delete dialog
const openDeleteDialog = (project: Project) => {
  projectToDelete.value = project
  isDeleteDialogOpen.value = true
}

// Handler for delete project event
const handleDeleteProject = async (project: Project) => {
  isDeleteDialogOpen.value = false
  projectToDelete.value = undefined
  await deleteProject(project)
}
const projectMenuItems = (project: Project) => {
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
        openDeleteDialog(project)
      }
    }
  ]
}

const { data, status, refresh } = await useFetch('/api/projects')
const projects = data.value?.projects as Project[]

const handleCreateProject = async (payload: CreateProjectPayload) => {
  try {
    await $fetch("/api/projects", {
      method: "POST",
      body: payload,
    })
    
    await refresh()
    console.log('Project created successfully')
  } catch (error) {
    console.error('Failed to create project:', error)
  }
}

const updateProject = async (projectId: string, payload: Partial<Project>) => {
  try {
    await $fetch(`/api/projects/${projectId}`, {
      method: "PUT",
      body: payload,
    })
    
    await refresh()
    console.log('Project updated successfully')
  } catch (error) {
    console.error('Failed to update project:', error)
  }
}

const deleteProject = async (project: Project) => {
  try {
    await $fetch(`/api/projects/${project.id}`, {
      method: "DELETE",
    })

    await refresh()
  } catch (error) {
    console.error('Failed to delete project:', error)
  }
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
