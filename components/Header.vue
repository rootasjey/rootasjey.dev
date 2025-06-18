<template>
  <div class="fixed top-0 w-full px-6 py-2 flex justify-between items-center backdrop-blur-lg z-3">
    <ULink to="/" label="root" class="text-size-4 font-700 font-body" />

    <div class="navigation flex justify-center items-center gap-6 
      absolute left-1/2 -translate-x-1/2
      text-size-3.5 font-600 color-gray-800 dark:color-gray-200">
      <ULink to="/" label="Home" />
      <ULink to="/reflexions" label="Reflexions" />
      <ULink to="/projects" label="Projects" />
      <ULink to="/experiments" label="Experiments" />
    </div>

    <div class="flex items-center gap-2">
      <UTooltip :_tooltip-content="{
          side: 'right',
        }">
        <template #default>
          <div :class="timeIcon" 
            class="cursor-pointer hover:scale-120 hover:accent-rose active:scale-99 transition" 
            @click="$colorMode.preference = $colorMode.value === 'dark' ? 'light' : 'dark'" 
            @click.right="$colorMode.preference = 'system'"
          />
        </template>
        <template #content>
          <button @click="$colorMode.preference = 'system'" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md m-0
            border-1 border-dashed class="b-#3D3BF3">
            System theme
          </button>
        </template>
      </UTooltip>

      <UButton 
        icon
        btn="ghost-gray"
        label="i-ph-magnifying-glass-bold"
      />

      <UButton
        to="/login"
        btn="ghost-gray"
        label="Sign in"
        class="font-600 h-auto py-1 px-3"
      />
    </div>
  </div>
</template>

<script lang="ts" setup>

const timeIcon = computed(() => {
  const hour = new Date().getHours()
  
  if (hour >= 5 && hour < 12) return 'i-ph-sun-horizon'
  if (hour >= 12 && hour < 17) return 'i-line-md:moon-to-sunny-outline-loop-transition'
  if (hour >= 17 && hour < 22) return 'i-ph:sun-horizon-bold'
  return 'i-line-md:moon-rising-twotone-loop'
})

</script>