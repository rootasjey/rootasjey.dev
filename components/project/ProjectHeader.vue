<template>
  <header v-if="project" class="mt-2 w-full text-center flex flex-col justify-center items-center">
    <div class="w-md mt-2">
      <UInput v-model="project.name"
        class="font-text text-xl font-800 min-h-0 mb-2 p-0 overflow-y-hidden shadow-none text-align-center"
        :readonly="!canEdit" input="~" label="Name" type="textarea" :rows="1" autoresize />

      <UInput v-model="project.description"
        class="font-text text-gray-700 dark:text-gray-300 shadow-none text-align-center"
        :readonly="!canEdit" input="~" label="Description" type="textarea" autoresize />

      <!-- Primary Tag Display/Edit -->
      <div class="flex items-center gap-2 mt-2 justify-center">
        <div v-if="!canEdit && primaryTag" class="px-2 py-1 rounded-full text-xs bg-blue-100 dark:bg-blue-900 shadow-sm">
          {{ primaryTag }}
        </div>
        <div class="max-w-40" v-if="canEdit">
          <USelect v-model="selectedPrimaryTag" :items="availableTags" placeholder="Primary tag"
            value-key="value" item-key="label">
            <template #trigger>
              <UIcon name="i-lucide-tag" v-if="selectedPrimaryTag" />
              <UIcon name="i-lucide-plus" v-else />
            </template>
          </USelect>
        </div>
        <!-- Status Control -->
        <div class="max-w-20">
          <USelect v-if="canEdit" v-model="project.status" :items="availableStatuses" item-key="label">
            <template #trigger>
              <UIcon name="i-ph-rocket-launch" v-if="project.status === 'active'" />
              <UIcon name="i-ph-rocket" v-else-if="project.status === 'completed'" />
              <UIcon name="i-ph-hourglass" v-else-if="project.status === 'on-hold'" />
              <UIcon name="i-ph-archive" v-else-if="project.status === 'archived'" />
            </template>
          </USelect>
        </div>
        <!-- Cover Image Upload -->
        <UTooltip v-if="!project.image?.src && canEdit">
          <template #default>
            <UButton @click="$emit('open-file-picker')" :disabled="!canEdit" btn="outline-gray">
              <div class="i-icon-park-outline:upload-picture"></div>
            </UButton>
          </template>
          <template #content>
            <div class="px-2 py-1">
              <p>Upload a cover image for your project.</p>
            </div>
          </template>
        </UTooltip>
        <!-- Slug Editor -->
        <UPopover v-if="canEdit" :disabled="!canEdit">
          <template #trigger>
            <UButton v-if="canEdit" btn="outline-white" leading="i-icon-park-outline:edit" label="edit slug" />
          </template>
          <template #default>
            <div>
              <div class="space-y-1">
                <h4 class="font-medium leading-none">Update slug</h4>
                <p class="text-xs text-muted">The slug is the part of the URL that identifies the project.</p>
              </div>
              <UInput v-model="project.slug" label="Slug" class="mt-2" @change="$emit('update-slug', project.slug)" />
            </div>
          </template>
        </UPopover>
        <!-- Tags Management Button -->
        <UTooltip v-if="canEdit">
          <template #default>
            <UButton @click="$emit('show-tags-dialog')" :disabled="!canEdit" btn="outline-gray">
              <div class="i-lucide-tags"></div>
            </UButton>
          </template>
          <template #content>
            <div class="px-2 py-1">
              <p>Manage project tags</p>
            </div>
          </template>
        </UTooltip>
      </div>
      <!-- Secondary Tags Display -->
      <div v-if="secondaryTags.length > 0" class="flex flex-wrap gap-2 mt-3 justify-center">
        <UBadge v-for="tag in secondaryTags" :key="tag" variant="outline" color="gray" size="sm">
          {{ tag }}
        </UBadge>
      </div>
    </div>
    <!-- User and cover image info -->
    <div class="w-md mt-4 flex justify-between pt-4 border-t-2 dark:border-gray-800">
      <div class="flex gap-4 items-center">
        <div class="w-8 h-8 bg-gradient-to-br from-blue-400 to-purple-500 rounded-full flex items-center justify-center">
          <!-- Avatar SVG or image here -->
        </div>
        <div class="text-align-start flex flex-col">
          <h4>{{ project.user?.name }}</h4>
          <span class="text-size-3 text-gray-500 dark:text-gray-400">{{ formatDate(project.created_at) }}</span>
          <div class="flex items-center gap-2 justify-center">
            <span class="text-size-3 text-gray-500 dark:text-gray-500 dark:hover:text-gray-200 transition">
              Last updated on {{ formatDate(project.updated_at) }}
            </span>
            <UIcon :name="saving === undefined ? '' : saving ? 'i-loading' : 'i-check'" :class="saving ? 'animate-spin text-muted' : 'text-lime-300'" />
          </div>
        </div>
      </div>
      <div class="flex">
        <UButton icon label="i-ph-chat" btn="ghost-gray" class="hover:scale-102 active:scale-99 transition" />
        <UButton icon label="i-lucide-share" btn="ghost-gray" class="hover:scale-102 active:scale-99 transition" />
      </div>
    </div>
    <!-- Cover Image Display -->
    <div v-if="project.image?.src" class="relative group">
      <NuxtImg provider="hubblob" :src="`/${project.image.src}/original.${project.image.ext}`" class="w-full h-80 object-cover rounded-lg mt-4" />
      <div class="flex gap-2 absolute top-1 right-1">
        <UButton v-if="canEdit" icon @click="$emit('open-file-picker')" btn="~" label="i-icon-park-outline:upload-picture" class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />
        <UButton v-if="canEdit" icon @click="$emit('remove-image')" btn="~" label="i-icon-park-outline:delete" class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />
      </div>
    </div>
    <div v-else class="mb-8 mt-8 w-md">
      <div class="border-b b-dashed b-b-amber"></div>
      <div class="border-b b-dashed b-b-blue relative top-2"></div>
    </div>
  </header>
</template>

<script lang="ts" setup>
import type { ProjectType } from '~/types/project';
import { computed, ref } from 'vue';

const props = defineProps<{
  project: ProjectType;
  canEdit: boolean;
  saving?: boolean;
}>();

const emit = defineEmits([
  'open-file-picker',
  'remove-image',
  'show-tags-dialog',
  'update-slug',
]);

// Dummy data for available tags/statuses, replace with real data or props as needed
const availableStatuses = [
  { label: 'Active', value: 'active' },
  { label: 'Completed', value: 'completed' },
  { label: 'On Hold', value: 'on-hold' },
  { label: 'Archived', value: 'archived' },
];
const availableTags = computed(() => (props.project.tags || []).map(tag => ({ label: tag, value: tag })));
const selectedPrimaryTag = ref(props.project.primaryTag || '');
const primaryTag = computed(() => props.project.primaryTag || '');
const secondaryTags = computed(() => props.project.secondaryTags || []);

function formatDate(date: string | Date): string {
  if (!date) return 'Unknown Date';
  const dateObj = new Date(date);
  const options: Intl.DateTimeFormatOptions = {
    year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit',
  };
  return dateObj.toLocaleString('fr', options);
}
</script>
