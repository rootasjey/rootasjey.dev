<template>
  <article 
    :id="project.id.toString()"
    class="group flex flex-col gap-2"
  >
    <div class="flex gap-2">
      <div class="w-6 h-6 rounded-1 shadow relative overflow-hidden">
        <UDropdownMenu 
          v-if="loggedIn && projectMenuItems.length > 0" 
          :items="projectMenuItems" 
          size="xs" 
          menu-label="" 
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

      <ULink :to="`/projects/${project.slug}`" class="block mb-3">
        <h3 class="font-text font-700 text-size-4  text-gray-800 dark:text-gray-200 line-clamp-2 group-hover:text-gray-600 dark:group-hover:text-gray-300 transition-colors">
          {{ project.name }}
        </h3>
      </ULink>

      <!-- Action buttons overlay -->
      <div class="flex items-start gap-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
        <ULink v-if="projectLink"
          :href="projectLink" target="_blank"
          class="w-6 h-6 bg-white/90 dark:bg-gray-900/90 backdrop-blur-sm rounded-full flex items-center justify-center hover:scale-110 transition-transform">
          <span class="i-ph:arrow-up-right text-sm"></span>
        </ULink>
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
          :primary-tag-color="primaryTagColor"
        />

        <UDropdownMenu 
          v-if="loggedIn && projectMenuItems.length > 0" 
          :items="projectMenuItems" 
          size="xs" 
          menu-label="" 
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
  </article>
</template>

<script lang="ts" setup>
import type { Project, ProjectLink } from '~/types/project'

interface Props {
  project: Project
  index: number
  loggedIn: boolean
  projectMenuItems?: Array<{
    label: string
    onClick: () => void
  } | {}>
  colors?: string[]
}

const props = withDefaults(defineProps<Props>(), {
  projectMenuItems: () => [],
  colors: () => []
})

// Computed properties
const primaryTagColor = computed(() => {
  return props.colors[props.index]?.replace('color-', '') || 'blue'
})

const projectLink = computed(() => {
  const link = props.project.links?.find((l: ProjectLink) => l.name === 'project')
  return link?.href || ''
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

.line-clamp-3 {
  display: -webkit-box;
  line-clamp: 3;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
