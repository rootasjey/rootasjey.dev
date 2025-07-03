<template>
  <header class="w-[820px] mt-24 md:mt-42 mb-12 text-center p-2 md:p-8">
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

    <div v-if="showDialogs" class="mb-8">
      <UButton
        @click="$emit('update:createDialogModel', true)"
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
      <ULink v-for="(project, index) in projects" :key="project.slug"
        :to="`#${project.slug}`"
        :style="{ color: colors[index]?.replace('color-', '') || '#8F87F1' }"
        class="hover:scale-150 transition-all duration-300 text-xl opacity-70 hover:opacity-100">
        •
      </ULink>
    </div>

    <!-- Error message display -->
    <div v-if="error" class="mt-2 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-md">
      <div class="flex items-start gap-2">
        <span class="i-lucide-alert-circle text-red-600 dark:text-red-400 text-sm flex-shrink-0 mt-0.5"></span>
        <div class="text-sm text-red-700 dark:text-red-300">
          <p>{{ error }}</p>
          <UButton
            btn="text"
            size="xs"
            class="mt-1 text-red-600 dark:text-red-400 hover:text-red-800 dark:hover:text-red-200"
            @click="$emit('retry-error')"
          >
            Retry
          </UButton>
        </div>
      </div>
    </div>

    <!-- Dialogs - only render if showDialogs is true -->
    <template v-if="showDialogs">
      <!-- Create Project Dialog -->
      <CreateProjectDialog
        :model-value="createDialogModel"
        @update:model-value="$emit('update:createDialogModel', $event)"
        @create-project="$emit('create-project', $event)"
      />

      <!-- Edit Project Dialog -->
      <EditProjectDialog
        v-if="editingProject"
        :model-value="editDialogModel"
        @update:model-value="$emit('update:editDialogModel', $event)"
        :project="editingProject"
        @update-project="$emit('update-project', $event)"
      />

      <!-- Delete Project Dialog -->
      <DeleteProjectDialog
        v-if="deletingProject"
        :model-value="deleteDialogModel"
        @update:model-value="$emit('update:deleteDialogModel', $event)"
        :project="deletingProject"
        @delete-project="$emit('delete-project', $event)"
      />
    </template>
  </header>
</template>

<script lang="ts" setup>
import type { Project } from '~/types/project'

interface Props {
  isLoading?: boolean
  error?: string
  showDialogs?: boolean
  createDialogModel?: boolean
  editDialogModel?: boolean
  deleteDialogModel?: boolean
  editingProject?: Project
  deletingProject?: Project
  projects?: Project[]
  colors?: string[]
}

withDefaults(defineProps<Props>(), {
  isLoading: false,
  error: undefined,
  showDialogs: false,
  createDialogModel: false,
  editDialogModel: false,
  deleteDialogModel: false,
  editingProject: undefined,
  deletingProject: undefined,
  projects: () => [],
  colors: () => []
})

defineEmits<{
  'create-project': [projectData: any]
  'update-project': [updateData: any]
  'delete-project': [project: Project]
  'retry-error': []
  'update:createDialogModel': [modelValue: boolean]
  'update:editDialogModel': [modelValue: boolean]
  'update:deleteDialogModel': [modelValue: boolean]
}>()
</script>