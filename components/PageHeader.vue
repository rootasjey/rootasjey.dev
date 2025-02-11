<template>
  <header class="mb-16 text-center flex flex-col items-center">
    <div class="flex items-center gap-2 ml--3">
      <UTooltip content="Go back" :_tooltip-content="{
        side: 'right',
      }">
        <template #default>
          <button class="opacity-50 flex items-center gap-2 hover:scale-110 focus:scale-90 transition-all" @click="$router.back()">
            <div class="i-ph:arrow-bend-down-left-bold"></div>
          </button>
        </template>
        <template #content>
          <button @click="$router.back()" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md m-0
            border-1 border-dashed class="b-#3D3BF3">
            Go back
          </button>
        </template>
      </UTooltip>
      <h1 class="font-title text-2xl font-600 text-gray-800 dark:text-gray-200">
        {{ title }}
      </h1>
    </div>
    <h5 class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
      {{ subtitle }}
    </h5>
    <slot></slot>
  </header>
</template>

<script setup lang="ts">
defineProps<{
  title: string
  subtitle: string
}>()
</script>
