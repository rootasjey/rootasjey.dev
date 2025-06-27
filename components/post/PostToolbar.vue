<template>
  <div class="fixed w-full bottom-8 flex justify-center items-center">
    <div class="flex gap-1 backdrop-blur border dark:bg-black shadow-2xl p-2 rounded-4">
      <UTooltip content="Go back">
        <template #default>
          <UButton btn="ghost-gray" icon label="i-ph:arrow-bend-down-left-bold" @click="$emit('goBack')" />
        </template>
        <template #content>
          <button @click="$emit('goBack')" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
            Go back
          </button>
        </template>
      </UTooltip>

      <UTooltip v-if="loggedIn" content="Lock edit">
        <template #default>
          <UButton btn="ghost-gray" icon @click="$emit('toggleEdit')">
            <UIcon v-if="canEdit" name="i-ph-eye-bold" />
            <UIcon v-else name="i-ph-pencil-bold" />
          </UButton>
        </template>
        <template #content>
          <button @click="$emit('toggleEdit')" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
            {{ canEdit ? 'View as readonly' : 'Edit metadata' }}
          </button>
        </template>
      </UTooltip>

      <UTooltip v-if="loggedIn" content="Export to JSON">
        <template #default>
          <UButton btn="ghost-gray" icon label="i-ph-download-simple-bold" @click="$emit('exportJson')" />
        </template>
        <template #content>
          <button @click="$emit('exportJson')" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
            Download (JSON)
          </button>
        </template>
      </UTooltip>

      <UTooltip v-if="loggedIn && canEdit" content="Import from JSON">
        <template #default>
          <button opacity-50 flex items-center gap-2 @click="$emit('importJson')">
            <div class="i-icon-park-outline:upload-two"></div>
          </button>
        </template>
        <template #content>
          <button @click="$emit('importJson')" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
            Import from JSON
          </button>
        </template>
      </UTooltip>
    </div>
  </div>
</template>

<script lang="ts" setup>
defineProps({
  canEdit: Boolean,
  loggedIn: Boolean,
})
</script>
