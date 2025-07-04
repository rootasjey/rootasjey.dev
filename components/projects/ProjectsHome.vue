<template>
  <section class="w-[860px] mt-24 mb-12">
    <div class="mb-6">
      <ULink to="/projects" class="font-title text-4 font-600 text-gray-800 dark:text-gray-200">
        <span>Latest Projects</span>
        <UIcon name="i-ph-arrow-right-duotone" size="4" class="ml-2" />
      </ULink>
    </div>
    
    <div v-if="projectsLoading" class="text-center py-8">
      <div class="text-gray-600 dark:text-gray-400">Loading projects...</div>
    </div>
    
    <div v-else-if="projectsError" class="text-center py-8">
      <div class="text-red-600 dark:text-red-400">Error loading projects</div>
    </div>
    
    <div v-else-if="projects && projects.length > 0" class="space-y-4">
      <!-- First Row: 1/3 + 2/3 -->
      <div class="grid grid-cols-3 gap-4">
        <!-- First Project (1/3) -->
        <ProjectCard
          v-if="displayProjects[0]"
          :title="displayProjects[0].name"
          :description="displayProjects[0].description || 'No description available'"
          :project="displayProjects[0]"
          :span="1"
          :index="0"
          :logged-in="loggedIn"
          :project-menu-items="projectMenuItems(displayProjects[0])"
          :colors="colors"
          hover-color="hover:border-blue-400"
        />

        <!-- Second Project (2/3) -->
        <ProjectCard
          v-if="displayProjects[1]"
          :title="displayProjects[1].name"
          :description="displayProjects[1].description || 'No description available'"
          :project="displayProjects[1]"
          :span="2"
          :index="1"
          :logged-in="loggedIn"
          :project-menu-items="projectMenuItems(displayProjects[1])"
          :colors="colors"
          hover-color="hover:border-pink-400"
        />
      </div>

      <!-- Second Row: 2/3 + 1/3 -->
      <div class="grid grid-cols-3 gap-4">
        <!-- Third Project (2/3) -->
        <ProjectCard
          v-if="displayProjects[2]"
          :title="displayProjects[2].name"
          :description="displayProjects[2].description || 'No description available'"
          :project="displayProjects[2]"
          :span="2"
          :index="2"
          :logged-in="loggedIn"
          :project-menu-items="projectMenuItems(displayProjects[2])"
          :colors="colors"
          hover-color="hover:border-amber-400"
        />

        <!-- Navigation Card (1/3) -->
        <div class="col-span-1 border-2 border-dashed border-blue-300 dark:border-blue-600 rounded-xl p-6 bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-900 hover:border-blue-400 dark:hover:border-blue-500 transition-all duration-200">
          <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-3">
            View All Projects
          </h3>
          <p class="text-gray-600 dark:text-gray-400 text-sm mb-6 leading-relaxed">
            Explore all {{ projects.length }} projects in the full collection.
          </p>
          <ULink
            to="/projects"
            class="inline-flex items-center gap-2 text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300 font-medium text-sm transition-colors"
          >
            Browse Projects
            <UIcon name="i-ph-arrow-right" size="4" />
          </ULink>
        </div>
      </div>
    </div>
    
    <ProjectsHomeEmpty v-else />
  </section>
</template>

<script lang="ts" setup>
import type { Project } from '~/types/project';

interface Props {
  projects: Project[];
  projectsLoading: boolean;
  projectsError: boolean;
}

const props = defineProps<Props>();

// User session for project management
const { loggedIn } = useUserSession()

// Color array for project cards
const colors = [
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
]

// Get the first 3 projects for display
const displayProjects = computed(() => {
  return props.projects.slice(0, 3)
})

// Project menu items function (simplified for home page)
const projectMenuItems = (project: Project) => {
  if (!loggedIn.value) return []

  return [
    {
      label: 'Edit Project',
      onClick: () => {
        // Navigate to project edit page
        navigateTo(`/projects/${project.slug}`)
      }
    },
    {
      label: 'View Details',
      onClick: () => {
        navigateTo(`/projects/${project.slug}`)
      }
    }
  ]
}
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  line-clamp: 3;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
