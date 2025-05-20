<template>
  <div class="w-[600px] rounded-xl p-8 flex flex-col transition-all duration-500 overflow-y-auto">
    <!-- Header -->
    <header class="mb-8 text-center">
      <ULink to="/" class="hover:scale-102 active:scale-99 transition">
        <span class="i-ph-house-simple-duotone"></span>
      </ULink>
      <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
        Weather
      </h1>
      <h5 class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
        Current weather conditions and forecasts
      </h5>

      <div class="w-40 flex text-center justify-center my-2 mx-auto">
        <div class="w-full h-2">
          <svg viewBox="0 0 300 10" preserveAspectRatio="none">
            <path d="M 0 5 Q 15 0, 30 5 T 60 5 T 90 5 T 120 5 T 150 5 T 180 5 T 210 5 T 240 5 T 270 5 T 300 5"
              stroke="currentColor" fill="none" class="text-gray-300 dark:text-gray-700" stroke-width="1" />
          </svg>
        </div>
      </div>
    </header>

    <!-- Location Input -->
    <div class="mb-4">
      <div class="flex gap-2">
        <UInput 
          v-model="searchQuery" 
          placeholder="Search location..." 
          class="flex-1"
          @keyup.enter="searchLocation"
        />
        <UButton @click="searchLocation" btn="outline">
          <span class="i-ph-magnifying-glass"></span>
        </UButton>
      </div>
      <p v-if="locationName" class="text-sm text-gray-600 dark:text-gray-400 mt-2">
        Showing weather for: {{ locationName }}
      </p>
    </div>

    <!-- Weather Content -->
    <div v-if="isLoading" class="flex-1 flex justify-center items-center">
      <div class="i-ph-spinner-gap animate-spin text-4xl text-gray-500"></div>
    </div>
    
    <div v-else-if="error" class="flex-1 p-4 rounded-lg bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400">
      <p>{{ error }}</p>
      <p class="text-sm mt-2">Please try again later or search for a different location.</p>
    </div>
    
    <div v-else class="flex-1 flex flex-col gap-4">
      <!-- Current Weather -->
      <div class="p-4 rounded-lg bg-gray-100 dark:bg-gray-800">
        <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-2">
          Current Weather
        </h2>
        <div class="flex items-center gap-4">
          <div 
            :class="{
              'i-ph-sun-dim-duotone': weatherData?.current?.condition?.icon === 'sun' && weatherData?.current?.is_day,
              'i-ph-moon-duotone': weatherData?.current?.condition?.icon === 'sun' && !weatherData?.current?.is_day,
              'i-ph-cloud-sun-duotone': weatherData?.current?.condition?.icon === 'cloud-sun',
              'i-ph-cloud-rain-duotone': weatherData?.current?.condition?.icon === 'cloud-rain',
              'i-ph-cloud-snow-duotone': weatherData?.current?.condition?.icon === 'cloud-snow',
              'i-ph-cloud-lightning-duotone': weatherData?.current?.condition?.icon === 'cloud-lightning',
              'i-ph-cloud-fog-duotone': weatherData?.current?.condition?.icon === 'cloud-fog',
              'i-ph-question-duotone': weatherData?.current?.condition?.icon === 'question',
              'text-amber-500': weatherData?.current?.condition?.icon === 'sun',
              'text-blue-400': weatherData?.current?.condition?.icon === 'cloud-sun',
              'text-blue-500': weatherData?.current?.condition?.icon === 'cloud-rain',
              'text-blue-300': weatherData?.current?.condition?.icon === 'cloud-snow',
              'text-purple-500': weatherData?.current?.condition?.icon === 'cloud-lightning',
              'text-gray-400': weatherData?.current?.condition?.icon === 'cloud-fog',
              'text-gray-500': weatherData?.current?.condition?.icon === 'question'
            }"
            class="text-4xl"
          ></div>
          <div>
            <div class="text-2xl font-bold text-gray-800 dark:text-gray-200">
              {{ Math.round(weatherData?.current?.temp_c || 0) }}°C
            </div>
            <div class="text-sm text-gray-600 dark:text-gray-400">
              {{ weatherData?.current?.condition?.text || 'Unknown' }}
            </div>
          </div>
        </div>
      </div>

      <!-- Forecast -->
      <div class="p-4 rounded-lg bg-gray-100 dark:bg-gray-800">
        <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-2">
          Forecast
        </h2>
        <div class="grid grid-cols-3 gap-2">
          <div 
            v-for="(day, index) in weatherData?.forecast?.forecastday" 
            :key="index" 
            class="text-center p-2"
          >
            <div class="text-sm text-gray-600 dark:text-gray-400">{{ day.date }}</div>
            <div 
              :class="{
                'i-ph-sun-duotone': day.day.condition.icon === 'sun',
                'i-ph-cloud-sun-duotone': day.day.condition.icon === 'cloud-sun',
                'i-ph-cloud-rain-duotone': day.day.condition.icon === 'cloud-rain',
                'i-ph-cloud-snow-duotone': day.day.condition.icon === 'cloud-snow',
                'i-ph-cloud-lightning-duotone': day.day.condition.icon === 'cloud-lightning',
                'i-ph-cloud-fog-duotone': day.day.condition.icon === 'cloud-fog',
                'i-ph-question-duotone': day.day.condition.icon === 'question',
                'text-amber-500': day.day.condition.icon === 'sun',
                'text-blue-400': day.day.condition.icon === 'cloud-sun',
                'text-blue-500': day.day.condition.icon === 'cloud-rain',
                'text-blue-300': day.day.condition.icon === 'cloud-snow',
                'text-purple-500': day.day.condition.icon === 'cloud-lightning',
                'text-gray-400': day.day.condition.icon === 'cloud-fog',
                'text-gray-500': day.day.condition.icon === 'question'
              }"
              class="text-2xl mx-auto my-1"
            ></div>
            <div class="text-gray-800 dark:text-gray-200">
              {{ Math.round(day.day.avgtemp_c) }}°C
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Back Button -->
    <div class="mt-6 text-center">
      <UButton to="/" btn="link-[#8DD8FF]" class="text-color-[#8DD8FF]">
        <span class="i-ph-arrow-bend-down-left-bold mr-1"></span>
        Back to Home
      </UButton>
    </div>
  </div>
</template>

<script setup>
const searchQuery = ref('')
const latitude = ref(48.8588255) // Default: Paris
const longitude = ref(2.2646342) // Default: Paris
const locationName = ref('Paris, France')
const isLoading = ref(false)
const error = ref(null)
const currentTime = ref(new Date())

// Fetch weather data from our API
const { data: weatherData, refresh } = await useFetch('/api/meteo', {
  query: {
    latitude,
    longitude
  },
  onResponse({ response }) {
    isLoading.value = false
    currentTime.value = new Date()
    console.log(currentTime.value.getHours())
    if (!response.ok) {
      error.value = 'Failed to fetch weather data'
    }
  },
  onResponseError() {
    isLoading.value = false
    error.value = 'Failed to fetch weather data'
  }
})

// Use Open-Meteo Geocoding API to convert location names to coordinates
async function searchLocation() {
  if (!searchQuery.value.trim()) return;
  
  isLoading.value = true;
  error.value = null;
  
  try {
    // Call the Open-Meteo Geocoding API
    const response = await fetch(
      `https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(searchQuery.value)}&count=1&language=en&format=json`
    );
    
    if (!response.ok) {
      throw new Error('Geocoding API error');
    }
    
    const data = await response.json();
    
    // Check if we got results
    if (!data.results || data.results.length === 0) {
      throw new Error('Location not found');
    }
    
    // Get the first result
    const location = data.results[0];
    
    // Update coordinates and location name
    latitude.value = location.latitude;
    longitude.value = location.longitude;
    
    // Format location name
    let formattedName = location.name;
    if (location.admin1) {
      formattedName += `, ${location.admin1}`;
    }
    if (location.country) {
      formattedName += `, ${location.country}`;
    } else if (location.country_code) {
      formattedName += `, ${location.country_code}`;
    }
    
    locationName.value = formattedName;

    refresh(); // Refresh weather data with new coordinates
  } catch (err) {
    console.error('Geocoding error:', err);
    error.value = err.message === 'Location not found' 
      ? 'Location not found. Please try a different search.'
      : 'Error searching for location. Please try again.';
    isLoading.value = false;
  }
}

// Initial load
onMounted(() => {
  isLoading.value = false;
});
</script>
