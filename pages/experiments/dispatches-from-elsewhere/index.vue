<template>
  <div class="container mx-auto px-4 py-8 pb-24">
    <ULink class="flex flex-col items-center justify-center mt-6" 
      to="/experiments">
      <span class="i-ph-flask mx-auto text-center text-md text-gray-600 dark:text-gray-400" />
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
            />
            
            <UButton 
              @click="restartVideo"
              btn="soft"
              icon
              label="i-ph-arrow-clockwise"
              size="sm"
            />
          </div>
        </div>

      <!-- Explanation Section -->
      <div class="explanations max-w-2xl text-gray-700">
        <div class="border-b b-dashed w-full h-1 b-pink-600 mt-8 mb-12"></div>
        
        <h3 class="font-text text-16 font-200 mb-4">All my love for <i>Dispatches from Elsewhere</i> </h3>
        <p class="font-text font-400 text-gray-500 dark:text-gray-400 mb-6">
          "Dispatches from Elsewhere" is a fascinating TV show created by Jason Segel that follows four ordinary people who stumble onto a puzzle hiding just behind the veil of everyday life. The show explores themes of identity, connection, and the extraordinary nature of ordinary lives.
        </p>
        
        <h4 class="text-size-8 font-200 mt-8 mb-4">The Making Process</h4>
        <p class="font-text font-400 text-gray-500 dark:text-gray-400 mb-6">
          Creating this tribute video was a journey in itself. I wanted to capture the essence of the show's magical realism and its ability to find wonder in the mundane. The process involved:
        </p>
        
        <ol class="list-decimal pl-8 mb-8">
          <li class="mb-2 color-[#8F87F1]">Collecting and curating visual elements that represent the show's aesthetic</li>
          <li class="mb-2 color-[#8F87F1]">Composing a soundtrack that echoes the show's emotional landscape</li>
          <li class="mb-2 color-[#8F87F1]">Editing the footage to create a narrative that invites curiosity</li>
          <li class="mb-2 color-[#8F87F1]">Adding subtle visual effects to enhance the sense of wonder</li>
        </ol>
        
        <h4 class="text-size-8 font-200 mt-8 mb-4">Personal Reflections</h4>
        <p class="font-text font-400 text-gray-500 dark:text-gray-400">
          What drew me to "Dispatches from Elsewhere" was its celebration of human connection and the extraordinary potential hidden within ordinary lives. The show reminds us that magic exists in the everyday if we're willing to look for it. This video tribute is my way of extending that invitation to others—to see the world through a lens of possibility and wonder.
        </p>
      </div>
    </div>
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
