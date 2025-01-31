
<template>
  <div class="container mx-auto px-4 py-8">
     <header class="mb-16 text-center flex flex-col items-center">
      <div class="flex items-center gap-2 ml--3">
        <UTooltip
          content="Go back"
        :_tooltip-content="{
          side: 'right',
        }">
          <template #default>
            <button opacity-50 flex items-center gap-2 @click="$router.back()">
              <div class="i-ph:arrow-bend-down-left-bold"></div>
            </button>
          </template>
          <template #content>
            <button @click="$router.back()" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
              Go back
            </button>
          </template>
        </UTooltip>
        <h1 class="font-title text-2xl font-600 text-gray-800 dark:text-gray-200">
          Experiments
        </h1>
      </div>
      <h5 class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
        Unleash your curiosity and explore a new world
      </h5>
    </header>
  </div>
</template>

<script>
export default {
  name: 'ExperimentsPage'
}
</script>
