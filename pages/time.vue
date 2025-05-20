<template>
  <div class="w-[600px] rounded-xl p-8 flex flex-col transition-all duration-500">
    <!-- Header -->
    <header class="mb-8 text-center">
      <!-- <h1 class="font-body text-size-2 font-600 text-gray-800 dark:text-gray-200">
        Current Time
      </h1> -->
      
      <div class="flex justify-center items-center gap-2">
        <div :class="timeIcon" class="cursor-pointer hover:scale-120 hover:accent-rose active:scale-99 transition" @click="$colorMode.preference = $colorMode.value === 'dark' ? 'light' : 'dark'" />
        
        <h2 class="font-bold text-gray-800 dark:text-gray-200 cursor-pointer 
          hover:scale-102 active:scale-99 transition" 
          @click="toggleClockSize"
          :class="{
            'text-size-4': clockSize === 1,
            'text-size-24': clockSize === 2,
            'text-size-54': clockSize === 3,
          }"
        >
          {{ formattedTime }}
        </h2>
      </div>

      <div class="w-40 flex text-center justify-center my-2 mx-auto">
        <div class="w-full h-2">
          <svg viewBox="0 0 300 10" preserveAspectRatio="none">
            <path d="M 0 5 Q 15 0, 30 5 T 60 5 T 90 5 T 120 5 T 150 5 T 180 5 T 210 5 T 240 5 T 270 5 T 300 5"
              stroke="currentColor" fill="none" class="text-gray-300 dark:text-gray-700" stroke-width="1" />
          </svg>
        </div>
      </div>
    </header>

    <!-- Back to Home -->
    <div class="mt-8 text-center">
      <ULink to="/" class="text-size-3 font-500 hover:scale-102 active:scale-99 transition">
        <span class="i-ph-arrow-left mr-1"></span>
        <span>Back to Home</span>
      </ULink>
    </div>
  </div>
</template>

<script setup>
const currentTime = ref(new Date())
const clockSize = ref(1)

const toggleClockSize = () => {
  // clockSize.value = clockSize.value === 1 ? 2 : 1
  clockSize.value = clockSize.value === 1 ? 2 : clockSize.value === 2 ? 3 : 1
}

// Format time as hh:mm
const formattedTime = computed(() => {
  const hours = currentTime.value.getHours().toString().padStart(2, '0')
  const minutes = currentTime.value.getMinutes().toString().padStart(2, '0')
  return `${hours}:${minutes}`
})

// Update time icon based on current hour (reusing logic from index.vue)
const timeIcon = computed(() => {
  const hour = currentTime.value.getHours()
  
  if (hour >= 5 && hour < 12) return 'i-ph-sun-horizon'
  if (hour >= 12 && hour < 17) return 'i-line-md:moon-to-sunny-outline-loop-transition'
  if (hour >= 17 && hour < 22) return 'i-ph:sun-horizon-bold'
  return 'i-line-md:moon-rising-twotone-loop'
})

// Update time every second
let intervalId

onMounted(() => {
  intervalId = setInterval(() => {
    currentTime.value = new Date()
  }, 1000)
})

onUnmounted(() => {
  clearInterval(intervalId)
})
</script>
