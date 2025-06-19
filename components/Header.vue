<template>
  <div class="fixed top-0 w-full px-6 py-2 flex justify-between items-center backdrop-blur-lg z-3">
    <ULink to="/" label="root" class="text-size-4 font-700 font-body" />

    <div class="navigation flex justify-center items-center gap-6 
      absolute left-1/2 -translate-x-1/2
      text-size-3.5 font-600 color-gray-800 dark:color-gray-200">
      <ULink 
        v-for="link in links" 
        :key="link.label" 
        :to="link.to" 
        :label="link.label"  
        :class="$route.path === link.to ? 'active' : ''"
      />
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
const links = [
  {
    label: 'Home',
    to: '/',
  },
  {
    label: 'Reflexions',
    to: '/reflexions',
  },
  {
    label: 'Projects',
    to: '/projects',
  },
  {
    label: 'Experiments',
    to: '/experiments',
  },
]

const timeIcon = computed(() => {
  const hour = new Date().getHours()
  
  if (hour >= 5 && hour < 12) return 'i-ph-sun-horizon'
  if (hour >= 12 && hour < 17) return 'i-line-md:moon-to-sunny-outline-loop-transition'
  if (hour >= 17 && hour < 22) return 'i-ph:sun-horizon-bold'
  return 'i-line-md:moon-rising-twotone-loop'
})

</script>

<style scoped>
.navigation {
  a {
    position: relative;
    text-decoration: none;
  }

  a::before {
    content: '';
    position: absolute;
    width: 100%;
    height: 4px;
    border-radius: 4px;
    background-color: #eee;
    bottom: -7px;
    left: 0;
    transform-origin: right;
    transform: scaleX(0);
    transition: transform .3s ease-in-out;
  }

  a:hover::before, a.active::before {
    transform-origin: left;
    transform: scaleX(1);
  }

}
</style>