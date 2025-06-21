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
    
    <div v-else-if="projects && projects.length > 0" 
      class="flex flex-wrap gap-0"
    >
      <ULink v-for="project in projects.slice(0, 6)" :key="project.id" :to="`/projects/${project.slug}`"
        class="w-36 h-36 border b-dashed flex items-center justify-center
        hover:b-solid hover:b-2 hover:border-blue-400 dark:hover:border-blue-300 transition-all"
      >
        <UIcon :name="iconProjects[project.slug]" size="16" />
      </ULink>
      <ULink key="more-projects" to="/projects"
        class="w-36 h-36 border b-dashed flex flex-col items-center justify-center gap-2
        hover:b-solid hover:b-2 hover:border-blue-400 dark:hover:border-blue-300 transition-all"
      >
        <h3 class="text-size-6 font-600 text-center text-gray-600">all projects</h3>
        <UIcon name="i-ph-arrow-right-duotone" size="4" />
      </ULink>
    </div>
    
    <div v-else class="text-center py-8">
      <div class="text-gray-600 dark:text-gray-400">No projects available</div>
    </div>
  </section>
</template>

<script lang="ts" setup>
import type { ProjectType } from '~/types/project';

interface Props {
  projects: ProjectType[];
  projectsLoading: boolean;
  projectsError: boolean;
}

defineProps<Props>();

const iconProjects: { [key: string]: string } = {
  "saas-banking": "i-ph-piggy-bank",
  "kwotes-trivia": "i-ph-question",
  "trombidex": "i-ph-dice-five",
  "feels-uwp": "i-ph-cloud-sun",
  "backwards": "i-ph-arrow-circle-left",
  "comptoirs": "i-ph-storefront",
}
</script>
