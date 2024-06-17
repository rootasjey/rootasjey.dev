<template>
  <div class="my-container w-full">
    <UTooltip :text="isDark ? 'Turn on the lights' : 'Apaga las luces'" class="brightness-button"
      :shortcuts="['⌘', 'i']" :popper="{ placement: 'left' }">
      <UButton :icon="isDark ? 'i-heroicons-moon-20-solid' : 'i-heroicons-sun-20-solid'" color="primary" variant="ghost"
        aria-label="Theme" :ui="{ rounded: 'rounded-full' }" @click="onClickBrightness"
        @contextmenu.prevent="onContextMenu" />
    </UTooltip>

    <UContextMenu v-model="isOpen" :virtual-element="virtualElement" class="context-menu"
      :ui="{ ring: 'flex flex-col' }">
      <UButton icon="i-tabler-brightness" label="System" :color="colorMode.preference === 'system' ? 'indigo' :' gray'"
        variant="ghost" @click="colorMode.preference = 'system'" class="context-menu-item" />
      <UDivider />
      <UButton :icon=" colorMode.preference === 'dark' ?'i-heroicons-moon-20-solid' :'i-heroicons-moon'" label="Dark"
        :color="colorMode.preference === 'dark' ? 'indigo' : 'gray'" variant="ghost"
        @click="colorMode.preference = 'dark'" class="context-menu-item" />
      <UDivider />
      <UButton icon="i-heroicons-sun-20-solid" label="Light"
        :color="colorMode.preference === 'light' ? 'indigo': 'gray'" variant="ghost"
        @click="colorMode.preference = 'light'" class="context-menu-item" />
    </UContextMenu>

    <div class="hero-container">
      <div>
        <h1 class="title">I'm a creative developer</h1>
        <div class="description">
          I'm constantly seeking out new ways to solve problems,
          thinking outside the box, and pushing boundaries of what is possible in the world of technology.
          I thrive in collaborative environments, where I can bounce ideas off others and contribute to builind
          truly remarkable software solutions.
        </div>

        <div class="flex social-container">
          <UTooltip text="Go to my GitHub" :popper="{ placement: 'bottom' }">
            <UButton :icon="'i-tabler-brand-github'" size="sm" color="gray" square variant="link"
              to="https://github.com/rootasjey" />
          </UTooltip>

          <UTooltip text="Go to my LinkedIn profile" :popper="{ placement: 'bottom' }">
            <UButton :icon="'i-tabler-brand-linkedin'" size="sm" color="gray" square variant="link"
              to="https://www.linkedin.com/in/jérémie-c-7b25194a" />
          </UTooltip>

          <UTooltip text="You can still contact me" :popper="{ placement: 'bottom' }">
          <UButton label="Closed for work" :icon="'i-tabler-file-cv'" size="sm" :color="isDark ? 'secondary' : 'primary'"
            square variant="outline" :ui="{ rounded: 'rounded-full' }" class="px-3"
            to="https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/assets%2Ffiles%2Fjc-resume-fullstack-dev-2024-en.pdf?alt=media&token=e838ef0b-eadb-4476-926a-020c56030f8c" />
          </UTooltip>
        </div>
      </div>
    </div>

    <div class="tabs-container">
      <UTabs v-model="selected" :items="items" :ui="{ list:{width: '' } }">
        <template #user-stories>
          <UserStories />
        </template>
        <template #projects>
          <Projects />
        </template>
        <template #interests>
          <Interests />
        </template>
      </UTabs>
    </div>

    <div class="bottom-floating-button-container">
      <UButton icon="i-tabler-square-rounded-chevron-down"
        :class="{'bottom-floating-button': true, 'inverse': currentScrollPosition > 0}" variant="soft"
        :color="isDark ? 'black' : 'gray'" size="sm" @click="scrollTo" />
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref, type Ref, computed, onMounted, unref } from 'vue'
  import { useMouse, useWindowScroll } from '@vueuse/core'

  const colorMode = useColorMode()
  const isDark = computed({
    get () {
      return colorMode.value === 'dark'
    },
    set () {
      colorMode.preference = colorMode.value === 'dark' ? 'light' : 'dark'
    }
  })

defineShortcuts({
  meta_i: {
    usingInput: false,
    handler: () => {
      colorMode.preference = colorMode.value === 'dark' ? 'light' : 'dark'
      playLightSound()
    },
  },
  i: {
    usingInput: false,
    handler: () => {
      router.replace({ query: { tab: items[2].label }, hash: '#sections' })
    },
  },
  p: {
    usingInput: false,
    handler: () => {
      router.replace({ query: { tab: items[1].label }, hash: '#sections' })
    },
  },
  u: {
    usingInput: false,
    handler: () => {
      router.replace({ query: { tab: items[0].label }, hash: '#sections' })
    },
  },
})

  const { x, y } = useMouse()
  const { y: windowY } = useWindowScroll()

  const isOpen = ref(false)
  const virtualElement = ref({ getBoundingClientRect: () => ({}) })
  const currentScrollPosition = ref(0);

/**
 * Plays a sound based on the current color mode.
 *
 * @return {void} This function does not return anything.
 */
function playLightSound() {
  const soundPath = colorMode.value === 'dark' ? '/sounds/light-on.wav' : '/sounds/light-off.wav'
  const audio = new Audio(soundPath)
  audio.play()
}

function onClickBrightness() {
  colorMode.preference = colorMode.value === 'dark' ? 'light' : 'dark'
  playLightSound()
}

  function onContextMenu () {
    const top = unref(y) - unref(windowY)
    const left = unref(x)

    virtualElement.value.getBoundingClientRect = () => ({
      width: 0,
      height: 0,
      top,
      left
    })

    isOpen.value = true
  }

  onMounted(() => {
  window.addEventListener('scroll', () => {
    currentScrollPosition.value = window.scrollY;
  });
});

  const scrollTo = () => {
    if (window.scrollY <= 0) {
      window.scrollTo({ top: document.documentElement.clientHeight, left: 0, behavior: 'smooth' })
      return
    }
    
    window.scrollTo({ top: 0, left: 0, behavior: 'smooth' })
  }

  const items = [{
    label: 'User Stories',
    slot: 'user-stories',
  }, {
    label: 'Projects',
    slot: 'projects',
  }, {
    label: 'Interests',
    slot: 'interests',
  }]

  const route = useRoute()
  const router = useRouter()

  const selected = computed({
    get () {
      const index = items.findIndex((item) => item.label === route.query.tab)
      if (index === -1) {
        return 0
      }

      return index
    },
    set (value: number) {
      // Hash is specified here to prevent the page from scrolling to the top
      router.replace({ query: { tab: items[value].label }, hash: '#sections' })
    }
  })

</script>

<style global>
.tabs-container > div {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}
</style>

<style scoped>
.bottom-floating-button-container {
  display: flex;
  justify-content: center;
}

.bottom-floating-button {
  position: fixed;
  bottom: 20px;
  background-color: var(--color-background);
  z-index: 1;
  transition: all 0.3s ease;
}

.bottom-floating-button.inverse {
  transform: rotate(180deg);
  transition: all 0.3s ease;
}

.brightness-button {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 1;
}

.context-menu {
  display: flex;
  flex-direction: column;
}

.context-menu-item {
  opacity: 0.8;
}

.tabs-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  width: 100%;
}

.hero-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  margin: 0rem auto;
  max-width: 90%;
  width: 90%;
  height: 100vh;

  .title {
    font-size: 1.4rem;
    font-weight: 400;
    color: var(--primary-color);
    margin-bottom: 0.5rem;
  }

  .description {
    opacity: 0.5;
    font-size: 0.9rem;
    font-weight: 400;
    font-family: "Rubik";

    max-width: 460px;
  }

  .social-container {
    margin-top: 2rem;

    display: flex;
    gap: 1rem;
    align-items: center;
  }

  .open-for-work {
    margin-top: 2rem;
  }
}

@media screen and (max-width: 600px) {
  .hero-container {
    max-width: 100%;
    width: 100%;
    padding-left: 3rem;
    padding-right: 3rem;

    overflow-x: hidden;
  }
}

</style>
