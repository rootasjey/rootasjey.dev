<template>
  <div class="w-full flex flex-col items-center min-h-screen">
    <!-- Hero Section -->
    <section class="w-full max-w-4xl mt-24 md:mt-32 mb-16 text-center px-4">
      <h1 class="font-body text-4xl md:text-5xl font-600 mb-4 text-gray-800 dark:text-gray-200">
        Dispatches from Elsewhere
      </h1>
      <h4 class="text-size-5 font-300 mb-8 text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
        A handmade video tribute to the TV show that explores the extraordinary nature of ordinary lives.
        Four strangers discover a puzzle hiding just behind the veil of everyday life.
      </h4>
    </section>

    <!-- Video Player Section -->
    <section class="w-full max-w-4xl px-4 mb-16">
      <div class="flex flex-col items-center justify-center">
        <div class="video-container relative mb-6 w-full max-w-3xl rounded-lg overflow-hidden shadow-lg">
          <!-- Thumbnail with play button overlay -->
          <div v-if="!hasStartedPlaying" class="thumbnail-container relative cursor-pointer" @click="startPlaying">
            <NuxtImg
              src="thumbnail.jpg"
              class="w-full h-auto"
              alt="Dispatches from Elsewhere video thumbnail"
            />
            <div class="play-button-overlay absolute inset-0 flex items-center justify-center">
              <div class="play-icon bg-black bg-opacity-50 rounded-full p-4 text-white">
                <span class="i-ph-play text-4xl"></span>
              </div>
            </div>
          </div>

          <!-- Video (hidden until play is clicked) -->
          <video
            v-show="hasStartedPlaying"
            ref="videoRef"
            class="w-full h-auto"
            :src="`/api/videos/trailer.mp4?prefix=experiments/dispatches-from-elsewhere`"
            @timeupdate="updateProgress"
            @loadedmetadata="onVideoLoaded"
            controls
          ></video>
        </div>

        <!-- Video Controls -->
        <div class="video-controls flex justify-center items-center gap-4 mb-8">
          <UButton
            @click="togglePlay"
            :btn="isPlaying ? '~' : '~'"
            :class="{
              'light:btn-glowing dark:bg-[#426AFE]': !isPlaying,
              'bg-pink-6 dark:bg-[#15F5BA] dark:color-black': isPlaying
            }"
            :label="isPlaying ? 'Pause' : 'Play'"
            :trailing="isPlaying ? 'i-ph-pause' : 'i-ph-play'"
          />

          <UButton
            @click="restartVideo"
            btn="outline-gray"
            leading="i-ph-arrow-clockwise"
          >
            Restart
          </UButton>
        </div>
      </div>
    </section>

    <!-- Explanation Section -->
    <section class="w-full max-w-4xl px-4 mb-24 text-lg">
      <div class="explanations max-w-2xl mx-auto text-gray-700 dark:text-gray-300">
        <div class="border-b border-dashed border-gray-300 dark:border-gray-600 w-full mb-12"></div>

        <h2 class="font-body text-2xl font-600 text-gray-800 dark:text-gray-200 mb-6">
          About the Show
        </h2>

        <p class="text-gray-700 dark:text-gray-300 mb-6 leading-relaxed">
          <ULink to="https://en.wikipedia.org/wiki/Dispatches_from_Elsewhere" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline font-medium">
            "Dispatches from Elsewhere"
          </ULink>
          is a fascinating TV show created by Jason Segel that follows four ordinary people who stumble onto a puzzle hiding just behind the veil of everyday life. The show explores themes of identity, connection, and the extraordinary nature of ordinary lives.
        </p>

        <p class="text-gray-700 dark:text-gray-300 mb-6 leading-relaxed">
          What makes this series truly special is its profound exploration of meaning and purpose. The show reminds us that at any given moment in life, the most important thing is to remain open to wonder, to connection, and to the possibility that magic exists in the mundane if we're willing to look for it.
        </p>

        <p class="text-gray-700 dark:text-gray-300 mb-8 leading-relaxed">
          This series helped me find deeper meaning in life by showing how four strangers, each dealing with their own struggles and disconnection, discover that the search for something greater than themselves can transform not just their individual lives, but create genuine human connections. It's a beautiful reminder that we're all part of something larger, and that the extraordinary is always hiding in plain sight.
        </p>

        <div class="border-b border-dashed border-gray-200 dark:border-gray-700 my-8" />

        <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-4">
          <span class="i-ph-hammer-duotone mr-2 text-pink-500 dark:text-pink-400"></span>
          The Making Process
        </h3>
        <p class="text-gray-700 dark:text-gray-300 mb-6 leading-relaxed">
          Creating this tribute video was a journey in itself. I wanted to capture the essence of the show's magical realism and its ability to find wonder in the mundane. The process involved:
        </p>

        <ol class="list-decimal pl-6 space-y-3 text-base mb-8">
          <li class="text-gray-600 dark:text-gray-400">
            <span class="font-semibold text-purple-600 dark:text-purple-400">Collecting and curating visual elements</span> that represent the show's aesthetic
          </li>
          <li class="text-gray-600 dark:text-gray-400">
            <span class="font-semibold text-purple-600 dark:text-purple-400">Composing a soundtrack</span> that echoes the show's emotional landscape
          </li>
          <li class="text-gray-600 dark:text-gray-400">
            <span class="font-semibold text-purple-600 dark:text-purple-400">Editing the footage</span> to create a narrative that invites curiosity
          </li>
          <li class="text-gray-600 dark:text-gray-400">
            <span class="font-semibold text-purple-600 dark:text-purple-400">Adding subtle visual effects</span> to enhance the sense of wonder
          </li>
        </ol>

        <div class="border-b border-dashed border-gray-200 dark:border-gray-700 my-8" />

        <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-4">
          <span class="i-ph-brain mr-2 text-blue-500 dark:text-blue-400"></span>
          Personal Reflections
        </h3>

        <p class="text-gray-700 dark:text-gray-300 mb-6 leading-relaxed">
          What drew me to "Dispatches from Elsewhere" was its celebration of human connection and the extraordinary potential hidden within ordinary lives. The show reminds us that magic exists in the everyday if we're willing to look for it. This video tribute is my way of extending that invitation to others—to see the world through a lens of possibility and wonder.
        </p>

        <p class="text-gray-700 dark:text-gray-300 mb-8 leading-relaxed">
          The series taught me that meaning isn't something we find—it's something we create through our connections with others and our willingness to engage with the mystery of existence. As the show beautifully demonstrates, we are all part of something larger than ourselves, and recognizing this connection is perhaps the most important discovery we can make.
        </p>

        <div class="border-b border-dashed border-gray-200 dark:border-gray-700 my-8" />

        <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-4">Further Reading</h3>
        <div class="space-y-3">
          <p class="text-gray-700 dark:text-gray-300">
            <ULink to="https://en.wikipedia.org/wiki/Dispatches_from_Elsewhere" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline font-medium">
              Wikipedia: Dispatches from Elsewhere
            </ULink>
            <span class="text-gray-500 dark:text-gray-400 ml-2">— Comprehensive overview of the series and its themes</span>
          </p>
          <p class="text-gray-700 dark:text-gray-300">
            <ULink to="https://www.imdb.com/title/tt8258074/" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline font-medium">
              IMDb: Dispatches from Elsewhere
            </ULink>
            <span class="text-gray-500 dark:text-gray-400 ml-2">— Cast, crew, and episode information</span>
          </p>
        </div>
      </div>
    </section>

    <Footer class="mt-24 mb-42" />
  </div>
</template>

<script lang="ts" setup>
useHead({
  title: "Dispatches from Elsewhere • experiments • rootasjey",
  meta: [
    {
      name: 'description',
      content: "A handmade video tribute to the TV show Dispatches from Elsewhere",
    },
  ],
})

const videoRef = ref<HTMLVideoElement | null>(null)
const isPlaying = ref(false)
const progress = ref(0)
const currentTime = ref(0)
const duration = ref(0)
// Add a new ref to track if video has started playing
const hasStartedPlaying = ref(false)

// Add a new function to start playing
const startPlaying = () => {
  hasStartedPlaying.value = true
  // Wait for the next tick to ensure video element is rendered
  nextTick(() => {
    if (videoRef.value) {
      videoRef.value.play()
      isPlaying.value = true
    }
  })
}

// Video control functions
const togglePlay = () => {
  if (!videoRef.value) return
  
  if (videoRef.value.paused) {
    videoRef.value.play()
    isPlaying.value = true
  } else {
    videoRef.value.pause()
    isPlaying.value = false
  }
}

const restartVideo = () => {
  if (!videoRef.value) return
  
  videoRef.value.currentTime = 0
  videoRef.value.play()
  isPlaying.value = true
}

const updateProgress = () => {
  if (!videoRef.value) return
  
  currentTime.value = videoRef.value.currentTime
  progress.value = (videoRef.value.currentTime / videoRef.value.duration) * 100
}

const onVideoLoaded = () => {
  if (!videoRef.value) return
  
  duration.value = videoRef.value.duration
}



// Lifecycle hooks
onMounted(() => {
  // Add event listeners for play/pause state
  if (videoRef.value) {
    videoRef.value.addEventListener('play', () => { isPlaying.value = true })
    videoRef.value.addEventListener('pause', () => { isPlaying.value = false })
  }
})

onBeforeUnmount(() => {
  // Clean up event listeners
  if (videoRef.value) {
    videoRef.value.removeEventListener('play', () => {})
    videoRef.value.removeEventListener('pause', () => {})
  }
})
</script>

<style scoped>
.video-container {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(229, 231, 235, 0.5);
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.dark .video-container {
  background: rgba(17, 24, 39, 0.8);
  border: 1px solid rgba(75, 85, 99, 0.5);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3), 0 2px 4px -1px rgba(0, 0, 0, 0.2);
}

.thumbnail-container {
  transition: transform 0.2s ease;
}

.thumbnail-container:hover {
  transform: scale(1.02);
}

.play-button-overlay {
  transition: opacity 0.2s ease;
}

.thumbnail-container:hover .play-button-overlay {
  opacity: 1;
}

.play-icon {
  transition: transform 0.2s ease;
}

.thumbnail-container:hover .play-icon {
  transform: scale(1.1);
}

.explanations {
  ul, ol {
    li {
      line-height: 1.7;
    }

    li::marker {
      font-weight: 600;
      color: rgba(var(--una-primary-500), 1);
    }
  }
}
</style>
