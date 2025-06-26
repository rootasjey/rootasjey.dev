<template>
  <div class="fixed top-0 w-full px-6 py-2 flex justify-between items-center backdrop-blur-lg z-3">
    <ULink to="/" label="root" 
      class="text-size-4 font-700 font-body transition-all duration-300 hover:text-shadow-glow" 
      @click="scrollToTopLogo"
    />

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
        @click="showSearch = true"
      />

      <div>
        <UButton
          v-if="!loggedIn"
          to="/login"
          btn="ghost-gray"
          label="Sign in"
          class="font-600 h-auto py-1 px-3"
        />

        <UDropdownMenu
          v-else
          :items="userMenuItems"
          size="xs"
          menu-label=""
          :_dropdown-menu-content="{
            class: 'w-44',
            align: 'end',
            side: 'bottom',
          }"
        >
          <div class="cursor-pointer w-5 h-5 rounded-full overflow-hidden flex items-center justify-center hover:scale-105 transition">
            <svg viewBox="0 0 36 36" fill="none" role="img" xmlns="http://www.w3.org/2000/svg" width="80" height="80"><mask id=":ru4:" maskUnits="userSpaceOnUse" x="0" y="0" width="36" height="36"><rect width="36" height="36" rx="72" fill="#FFFFFF"></rect></mask><g mask="url(#:ru4:)"><rect width="36" height="36" fill="#ff005b"></rect><rect x="0" y="0" width="36" height="36" transform="translate(9 -5) rotate(219 18 18) scale(1)" fill="#ffb238" rx="6"></rect><g transform="translate(4.5 -4) rotate(9 18 18)"><path d="M15 19c2 1 4 1 6 0" stroke="#000000" fill="none" stroke-linecap="round"></path><rect x="10" y="14" width="1.5" height="2" rx="1" stroke="none" fill="#000000"></rect><rect x="24" y="14" width="1.5" height="2" rx="1" stroke="none" fill="#000000"></rect></g></g></svg>
          </div>
        </UDropdownMenu>
      </div>
    </div>
  </div>
  <SearchBox 
    :model-value="showSearch" 
    @update:model-value="showSearch = $event"
  />
</template>

<script lang="ts" setup>
const { loggedIn, clear } = useUserSession()
const route = useRoute()
const router = useRouter()
const showSearch = ref(false)

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

const userMenuItems = [
  {
    label: 'Profile',
    onClick: () => router.push('/user'),
  },
  {},
  {
    label: 'Logout',
    onClick: () => {
      clear()
      router.replace("/")
    },
  },
]

const timeIcon = computed(() => {
  const hour = new Date().getHours()
  
  if (hour >= 5 && hour < 12) return 'i-ph-sun-horizon'
  if (hour >= 12 && hour < 17) return 'i-line-md:moon-to-sunny-outline-loop-transition'
  if (hour >= 17 && hour < 22) return 'i-ph:sun-horizon-bold'
  return 'i-line-md:moon-rising-twotone-loop'
})

const scrollToTopLogo = () => {
  if (route.path !== "/") return
  if (window.scrollY === 0) return
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}

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
    background-color: #000;
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

.dark  {
  .navigation {
    a::before {
      background-color: #eee;
    }
  }
}

.hover\:text-shadow-glow:hover {
  text-shadow: 
    2px 2px 0px #FFAAAA,
    4px 4px 0px #FE5D26,
    6px 6px 0px #00CAFF,
    6px 6px 0px #4300FF;
  transform: translateX(-2px) translateY(-2px);
}

.hover\:text-shadow-glow:active {
  text-shadow: none;
  transform: translateX(-2px) translateY(-2px);
}

/* For dark mode */
.dark .hover\:text-shadow-glow:hover {
  text-shadow: 
    2px 2px 0px #093FB4,
    4px 4px 0px #FFFCFB,
    6px 6px 0px #ED3500,
    6px 6px 0px #FFD8D8;
}

.dark .hover\:text-shadow-glow:active {
  text-shadow: none;
}
</style>