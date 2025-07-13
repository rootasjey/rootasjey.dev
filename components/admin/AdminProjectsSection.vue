<template>
  <div class="p-6">
    <!-- Header with Actions -->
    <div class="flex items-center justify-between mb-6">
      <div>
        <h2 class="text-2xl font-600 font-body text-gray-800 dark:text-gray-200 mb-2">
          Projects Management
        </h2>
        <p class="text-gray-600 dark:text-gray-400">
          Manage all projects across your application
        </p>
      </div>
      
      <div class="flex items-center gap-3">
        <!-- Search -->
        <UInput
          v-model="searchQuery"
          placeholder="Search projects..."
          leading="i-ph-magnifying-glass"
          class="w-64"
        />
        
        <!-- Create Project Button -->
        <UButton
          btn="soft-green"
          size="sm"
          class="hover:scale-102 active:scale-99 transition"
        >
          <span class="i-ph-plus mr-2"></span>
          Create Project
        </UButton>
      </div>
    </div>

    <!-- Projects Grid -->
    <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="i in 6" :key="i" class="animate-pulse">
        <div class="h-48 bg-gray-200 dark:bg-gray-700 rounded-lg"></div>
      </div>
    </div>
    
    <div v-else-if="projects.length === 0" class="text-center py-12">
      <div class="i-ph-folder text-4xl text-gray-400 mb-4"></div>
      <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
        No Projects Found
      </h3>
      <p class="text-gray-500 dark:text-gray-400">
        Create your first project to get started.
      </p>
    </div>
    
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div 
        v-for="(project, index) in projects" 
        :key="project.id || index"
        class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-6 hover:shadow-md transition-shadow"
      >
        <div class="flex items-start justify-between mb-4">
          <div class="flex-1">
            <h3 class="font-600 text-gray-800 dark:text-gray-200 mb-2">
              {{ project.name }}
            </h3>
            <p class="text-sm text-gray-600 dark:text-gray-400 line-clamp-2">
              {{ project.description }}
            </p>
          </div>
          
          <UDropdownMenu :items="getProjectMenuItems(project)">
            <UButton
              icon
              btn="ghost-gray"
              size="xs"
              label="i-ph-dots-three-vertical-bold"
            />
          </UDropdownMenu>
        </div>
        
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-2">
            <span 
              :class="getStatusBadgeClass(project.status)"
              class="px-2 py-1 text-xs font-500 rounded-full"
            >
              {{ project.status }}
            </span>
          </div>
          
          <div class="text-xs text-gray-400">
            {{ formatDate(project.createdAt) }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Project } from '~/types/project'

// Data
const searchQuery = ref('')
const projects = ref<Project[]>([])
const loading = ref(true)

// Methods
const getProjectMenuItems = (project: Project) => [
  {
    label: 'Edit',
    onClick: () => handleEditProject(project)
  },
  {
    label: 'View',
    onClick: () => handleViewProject(project)
  },
  {},
  {
    label: 'Delete',
    onClick: () => handleDeleteProject(project)
  }
]

const getStatusBadgeClass = (status: 'active' | 'completed' | 'on-hold' | 'archived') => {
  const statusMap = {
    active: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200',
    completed: 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200',
    'on-hold': 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200',
    archived: 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200'
  }
  return statusMap[status] || 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200'
}

// Removed getVisibilityBadgeClass since projects don't have visibility

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString()
}

// Handlers
const handleEditProject = (project: Project) => {
  console.log('Edit project:', project)
}

const handleViewProject = (project: Project) => {
  navigateTo(`/projects/${project.slug}`)
}

const handleDeleteProject = (project: Project) => {
  console.log('Delete project:', project)
}

// Data fetching
const fetchProjects = async () => {
  try {
    loading.value = true
    const response = await $fetch('/api/projects', {
      query: { search: searchQuery.value }
    })
    projects.value = (response.projects as Project[]) || []
  } catch (error) {
    console.error('Error fetching projects:', error)
  } finally {
    loading.value = false
  }
}

// Search handling
const handleSearch = useDebounceFn(() => {
  fetchProjects()
}, 300)

watch(searchQuery, handleSearch)

// Initialize
onMounted(() => {
  fetchProjects()
})
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  line-clamp: 2;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
