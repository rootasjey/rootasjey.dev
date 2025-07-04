<template>
  <article 
    :class="[
      'border border-gray-200 dark:border-gray-700 rounded-xl p-2 bg-gray-50 dark:bg-[#1B1F29] opacity-100 transition-all duration-200',
      hoverColor,
      spanClass
    ]"
  >
    <div class="p-4 flex flex-col justify-between bg-white dark:bg-[#141418] rounded-xl h-100% relative">
      <!-- Content Section -->
      <div>
        <ULink :to="project ? `/projects/${project.slug}` : '#'" class="hover:underline decoration-offset-4">
          <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-3">
            {{ title }}
          </h3>
        </ULink>
        <p class="text-gray-600 dark:text-gray-400 text-sm mb-6 leading-relaxed">
          {{ description }}
        </p>
      </div>

      <!-- Project-specific content (tags, links, etc.) -->
      <div v-if="project" class="mb-4">
        <TagDisplay 
          v-if="project.tags && project.tags.length > 0"
          :tags="project.tags" 
          display-mode="primary-count"
          class="mb-3"
          :primary-tag-color="primaryTagColor"
        />
        
        <!-- Project Links -->
        <div v-if="project.links && project.links.length > 0" class="flex gap-2 mb-3">
          <ULink 
            v-for="link in project.links.slice(0, 2)" 
            :key="link.name"
            :href="link.href" 
            target="_blank"
            class="text-xs px-2 py-1 bg-gray-100 dark:bg-gray-800 rounded-md hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
          >
            {{ link.name }}
          </ULink>
        </div>

        <!-- Project Status -->
        <div v-if="project.status" class="flex items-center gap-2 mb-3">
          <UIcon 
            :name="statusIcon" 
            class="text-sm"
            :class="statusColor"
          />
          <span class="text-xs text-gray-600 dark:text-gray-400 capitalize">
            {{ project.status.replace('-', ' ') }}
          </span>
        </div>
      </div>
      
      <!-- Mock Interface Section -->
      <div v-if="showMockInterface" class="bg-[#F1F1F1] dark:bg-gray-900 rounded-lg p-4 border border-gray-200 dark:border-gray-700">
        <!-- Message Interface Type -->
        <div v-if="mockInterfaceType === 'message'" class="flex items-start gap-3 mb-4">
          <div class="flex-1">
            <div class="flex items-center justify-between gap-2 mb-1">
              <span class="text-sm font-medium">{{ mockUser || 'Alice Smith' }}</span>
              <span class="text-gray-600 dark:text-gray-400 text-xs">{{ mockTime || '4 months ago' }}</span>
            </div>
            <div class="text-sm font-medium mb-2">
              {{ mockTitle || 'Welcome' }}
              <UIcon name="i-ph-heart-bold" size="3" />
            </div>
            <p class="text-gray-600 dark:text-gray-300 text-xs leading-relaxed mb-3">
              {{ mockMessage || 'Thank you for joining our us! I hope you\'re settling in well. This is an open source project, and I\'m always happy to receive contributions. If you have any questions, don\'t hesitate to ask.' }}
            </p>
            <div v-if="mockTags && mockTags.length > 0" class="flex gap-2">
              <span
                v-for="tag in mockTags"
                :key="tag"
                class="px-2 py-1 bg-gray-700 text-gray-300 text-xs font-600 rounded-xl"
              >
                {{ tag }}
              </span>
            </div>
          </div>
        </div>

        <!-- Email List Interface Type -->
        <div v-else-if="mockInterfaceType === 'email-list'" class="space-y-2">
          <div v-for="(email, index) in mockEmailList" :key="index" class="flex items-center gap-2 text-xs">
            <div
              :class="[
                'w-2 h-2 rounded-full',
                email.dotColor || 'bg-yellow-400'
              ]"
            ></div>
            <span>{{ email.address }}</span>
            <UIcon
              :name="email.rightIcon || 'i-ph-caret-down'"
              size="3"
              class="ml-auto"
            />
          </div>
        </div>
      </div>

      <!-- Project Menu (if logged in and project provided) -->
      <UDropdownMenu 
        v-if="loggedIn && project && projectMenuItems.length > 0" 
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
          class="absolute top-4 right-4 cursor-pointer hover:scale-110 transition-transform"
        />
      </UDropdownMenu>
    </div>
  </article>
</template>

<script lang="ts" setup>
import type { Project } from '~/types/project'

interface MockEmail {
  address: string
  dotColor?: string
  rightIcon?: string
}

interface Props {
  // Content props
  title: string
  description: string

  // Layout props
  span?: 1 | 2 | 3 | 'full'
  hoverColor?: string

  // Project-specific props (optional)
  project?: Project
  index?: number
  loggedIn?: boolean
  projectMenuItems?: Array<{
    label: string
    onClick: () => void
  } | {}>
  colors?: string[]

  // Mock interface props (for empty states)
  showMockInterface?: boolean
  mockInterfaceType?: 'message' | 'email-list'
  // Message interface props
  mockUser?: string
  mockTime?: string
  mockTitle?: string
  mockMessage?: string
  mockTags?: string[]
  // Email list interface props
  mockEmailList?: MockEmail[]
}

const props = withDefaults(defineProps<Props>(), {
  span: 2,
  hoverColor: 'hover:border-pink-400',
  index: 0,
  loggedIn: false,
  projectMenuItems: () => [],
  colors: () => [],
  showMockInterface: false,
  mockInterfaceType: 'message',
  mockTags: () => ['hello', 'world'],
  mockEmailList: () => [
    { address: 'Alicia Koch', dotColor: 'bg-yellow-400', rightIcon: 'i-ph-caret-down' },
    { address: 'alicia@example.com', dotColor: 'bg-green-400', rightIcon: 'i-ph-check' },
    { address: 'alicia@gmail.com', dotColor: 'bg-gray-400', rightIcon: 'i-ph-envelope' },
    { address: 'alicia@me.com', dotColor: 'bg-gray-400', rightIcon: 'i-ph-cloud' }
  ]
})

// Computed properties
const spanClass = computed(() => {
  switch (props.span) {
    case 1:
      return 'col-span-1'
    case 2:
      return 'col-span-2'
    case 3:
      return 'col-span-3'
    case 'full':
      return 'col-span-full'
    default:
      return 'col-span-2'
  }
})

const primaryTagColor = computed(() => {
  return props.colors[props.index]?.replace('color-', '') || 'blue'
})

const statusIcon = computed(() => {
  if (!props.project?.status) return 'i-ph-circle'
  
  switch (props.project.status) {
    case 'active':
      return 'i-ph-rocket-launch'
    case 'completed':
      return 'i-ph-rocket'
    case 'on-hold':
      return 'i-ph-hourglass'
    case 'archived':
      return 'i-ph-archive'
    default:
      return 'i-ph-circle'
  }
})

const statusColor = computed(() => {
  if (!props.project?.status) return 'text-gray-400'
  
  switch (props.project.status) {
    case 'active':
      return 'text-green-500'
    case 'completed':
      return 'text-blue-500'
    case 'on-hold':
      return 'text-yellow-500'
    case 'archived':
      return 'text-gray-500'
    default:
      return 'text-gray-400'
  }
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
