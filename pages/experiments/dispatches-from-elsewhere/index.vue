<template>
  <div class="frame">
    <ULink class="flex flex-col items-center justify-center mt-6" 
      to="/">
      <span class="i-ph-house-simple-duotone"></span>
    </ULink>

    <PageHeader 
      title="Dispatches from Elsewhere" 
      subtitle="A handmade video tribute to the TV show"
    />

    <div class="flex flex-col items-center justify-center">
    <!-- Video Player Section -->
      <div class="video-container relative mb-8 w-full max-w-3xl rounded-4 overflow-hidden">
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
        <div class="video-controls flex justify-between items-center mt-2">
          <div class="controls-buttons flex gap-2">
            <UButton 
              @click="togglePlay"
              btn="soft"
              icon
              :label="isPlaying ? 'i-ph-pause' : 'i-ph-play'"
              size="sm"
              class="dark:bg-pink-4 dark:text-pink-100 dark:hover:bg-pink-5 dark:hover:text-pink-100"
            />
            
            <UButton 
              @click="restartVideo"
              btn="soft"
              icon
              label="i-ph-arrow-clockwise"
              size="sm"
              class="dark:bg-[#687EFF] dark:text-white dark:hover:bg-[#1B56FD]"
            />
          </div>
        </div>

      <!-- Explanation Section -->
      <div class="explanations max-w-2xl text-gray-700 dark:text-gray-300">
        <div class="border-b b-dashed w-full h-1 dark:b-pink-600 mt-8 mb-12"></div>
        
        <h3 class="font-body text-size-6 font-600 mb-4">The well of creativity</h3>

        <p class="text-gray-700 dark:text-gray-300">
          "Dispatches from Elsewhere" is a fascinating TV show created by Jason Segel that follows four ordinary people who stumble onto a puzzle hiding just behind the veil of everyday life. The show explores themes of identity, connection, and the extraordinary nature of ordinary lives.
        </p>
        
        <h4 class="font-500 mt-16 mb-4">
          <i class="i-ph-hammer-duotone dark:text-pink-400" />
          The Making Process
        </h4>
        <p class="text-gray-700 dark:text-gray-300 mb-6">
          Creating this tribute video was a journey in itself. I wanted to capture the essence of the show's magical realism and its ability to find wonder in the mundane. The process involved:
        </p>
        
        <ol class="list-decimal pl-8 mb-8">
          <li class="mb-2 color-[#7d5fff] dark:color-[#E9A5F1]">Collecting and curating visual elements that represent the show's aesthetic</li>
          <li class="mb-2 color-[#7d5fff] dark:color-[#E9A5F1]">Composing a soundtrack that echoes the show's emotional landscape</li>
          <li class="mb-2 color-[#7d5fff] dark:color-[#E9A5F1]">Editing the footage to create a narrative that invites curiosity</li>
          <li class="mb-2 color-[#7d5fff] dark:color-[#E9A5F1]">Adding subtle visual effects to enhance the sense of wonder</li>
        </ol>
        
        <h4 class="font-500 mt-16 mb-4"><i class="i-ph-brain" /> Personal Reflections</h4>

        <p class="text-gray-700 dark:text-gray-300 mb-4">
          What drew me to "Dispatches from Elsewhere" was its celebration of human connection and the extraordinary potential hidden within ordinary lives. The show reminds us that magic exists in the everyday if we're willing to look for it. This video tribute is my way of extending that invitation to others—to see the world through a lens of possibility and wonder.
        </p>
      </div>
    </div>

    <Footer />
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

// Format time in MM:SS format
const formatTime = (timeInSeconds: number) => {
  if (isNaN(timeInSeconds)) return '00:00'
  
  const minutes = Math.floor(timeInSeconds / 60)
  const seconds = Math.floor(timeInSeconds % 60)
  
  return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
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

.frame {
  width: 600px;
  border-radius: 0.75rem;
  padding: 2rem;
  padding-bottom: 38vh;
  display: flex;
  flex-direction: column;
  transition-property: all;
  transition-duration: 500ms;
  overflow-y: auto;
}

.video-container {
  box-shadow: 0 0 16px rgba(0, 0, 0, 0.5);
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

.progress-container {
  cursor: pointer;
  transition: height 0.2s ease;
}

.progress-container:hover {
  height: 4px;
}

.progress-bar {
  transition: width 0.1s linear;
}

.explanations {
  ul, ol {
    li {
      margin-top: 0.5rem;
    }

    li::marker {
      font-weight: 600;
    }
  }
}
</style>
