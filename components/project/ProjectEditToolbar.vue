<template>
  <div class="fixed w-full bottom-8 flex justify-center items-center">
    <div class="flex gap-1 backdrop-blur border bg-white/80 dark:bg-black/20 shadow-2xl p-2 rounded-4">
      <UTooltip content="Go back">
        <template #default>
          <UButton icon btn="ghost-gray" @click="$emit('go-back')">
            <div class="i-ph:arrow-bend-down-left-bold"></div>
          </UButton>
        </template>
        <template #content>
          <button @click="$emit('go-back')" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
            Go back
          </button>
        </template>
      </UTooltip>
      <UTooltip v-if="loggedIn">
        <template #default>
          <UButton icon btn="ghost-gray" @click="$emit('toggle-can-edit')">
            <UIcon v-if="!canEdit" name="i-ph:pencil" />
            <UIcon v-else name="i-ph-eye-bold" />
          </UButton>
        </template>
        <template #content>
          <button @click="$emit('toggle-can-edit')" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
            {{ canEdit ? 'View as readonly' : 'Edit project'}}
          </button>
        </template>
      </UTooltip>
      <UTooltip v-if="loggedIn" content="Export to JSON">
        <template #default>
          <UButton icon btn="ghost-gray" @click="$emit('export-project-to-json')">
            <div class="i-icon-park-outline:download-two"></div>
          </UButton>
        </template>
        <template #content>
          <button @click="$emit('export-project-to-json')" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
            Export to JSON
          </button>
        </template>
      </UTooltip>
      <UTooltip content="Upload cover image" v-if="loggedIn && project && !project.image?.src">
        <template #default>
          <UButton icon btn="ghost-gray" label="i-icon-park-outline-upload-picture" @click="$emit('open-file-picker')" />
        </template>
        <template #content>
          <button bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
            Upload cover image
          </button>
        </template>
      </UTooltip>
      <input type="file" ref="fileInput" accept="image/*" class="hidden" @change="$emit('handle-cover-select', $event)" />
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { ProjectType } from '~/types/project';

interface Props {
  project: ProjectType;
  canEdit: boolean;
  loggedIn: boolean;
}

defineProps<Props>();

defineEmits<{
  (e: 'go-back'): void;
  (e: 'toggle-can-edit'): void;
  (e: 'export-project-to-json'): void;
  (e: 'open-file-picker'): void;
  (e: 'handle-cover-select', event: Event): void;
}>();
</script>
