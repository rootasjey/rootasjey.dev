<template>
  <div class="frame">
    <!-- Hero Section -->
    <section class="w-full max-w-2xl mt-12 md:mt-24 mb-8 text-center p-2 md:p-8 ">
      <h1 class="font-body text-6xl font-600 mb-6 text-gray-800 dark:text-gray-200">
        {{ isLogin ? 'Sign in' : 'Sign up' }}
      </h1>
      <h5 v-if="isLogin" class="text-size-5 font-300 mb-4 text-gray-800 dark:text-gray-200">
        Welcome back! It's a shinny day <UIcon name="i-ph-sun" /> <br />
        Log back into your user account.
      </h5>
      <h5 v-else class="text-size-5 font-300 mb-4 text-gray-800 dark:text-gray-200">
        Hello new comers. Create your new account.
      </h5>
    </section>

    <!-- Login/Register Form -->
    <section class="w-full max-w-md mb-24">
      <form @submit.prevent="handleSubmit" class="space-y-6">
        <!-- Name field (only for registration) -->
        <div v-if="!isLogin">
          <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            <span class="i-ph-user mr-2"></span>
            Name <span class="text-[#EC7FA9] dark:text-[#FFB8E0]">*</span>
          </label>
          <UInput
            id="name"
            v-model="name"
            type="text"
            placeholder="Your full name"
            required
            class="w-full"
            :ui="{ 
              base: 'transition duration-200',
              rounded: 'rounded-lg',
              color: {
                gray: {
                  outline: 'bg-white dark:bg-gray-900 ring-1 ring-gray-300 dark:ring-gray-700 focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400'
                }
              }
            }"
          />
        </div>

        <div>
          <label for="email" class="block text-sm font-medium dark:text-gray-300 mb-2">
            <span class="i-ph-envelope mr-2"></span>
            Email <span class="text-[#EC7FA9] dark:text-[#FFB8E0]">*</span>
          </label>
          <UInput
            id="email"
            v-model="email"
            type="email"
            placeholder="your@email.com"
            required
            size="lg"
            class="w-full"
            :ui="{ 
              base: 'transition duration-200',
              rounded: 'rounded-lg',
              color: {
                gray: {
                  outline: 'bg-white dark:bg-gray-900 ring-1 ring-gray-300 dark:ring-gray-700 focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400'
                }
              }
            }"
          />
        </div>

        <div>
          <label for="password" class="block text-sm font-medium dark:text-gray-300 mb-2">
            <span class="i-ph-lock mr-2"></span>
            Password <span class="text-[#EC7FA9] dark:text-[#FFB8E0]">*</span>
          </label>
          <UInput
            id="password"
            v-model="password"
            type="password"
            placeholder="Enter your password"
            required
            size="lg"
            class="w-full"
            :ui="{ 
              base: 'transition duration-200',
              rounded: 'rounded-lg',
              color: {
                gray: {
                  outline: 'bg-white dark:bg-gray-900 ring-1 ring-gray-300 dark:ring-gray-700 focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400'
                }
              }
            }"
          />
          <p v-if="!isLogin" class="text-xs text-gray-500 dark:text-gray-400 mt-1">
            Password must be at least 8 characters long
          </p>
        </div>

        <div v-if="!isLogin">
          <label for="master-password" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            <span class="i-ph-lock mr-2"></span>
            Master Password <span class="text-[#EC7FA9] dark:text-[#FFB8E0]">*</span>
          </label>
          <UInput
            id="master-password"
            v-model="masterPassword"
            type="password"
            placeholder="Enter the master password"
            required
            class="w-full"
            :ui="{ 
              base: 'transition duration-200',
              rounded: 'rounded-lg',
              color: {
                gray: {
                  outline: 'bg-white dark:bg-gray-900 ring-1 ring-gray-300 dark:ring-gray-700 focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400'
                }
              }
            }"
          />
          <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
            The master paswword is necessary to create an account.
          </p>
        </div>

        <!-- Optional fields for registration -->
        <div v-if="!isLogin && showOptionalFields" class="space-y-4">
          <div>
            <label for="biography" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              <span class="i-ph-note mr-2"></span>
              Biography
            </label>
            <UInput
              id="biography"
              type="textarea"
              v-model="biography"
              placeholder="Tell us about yourself..."
              class="w-full"
              :rows="3"
            />
          </div>

          <div>
            <label for="job" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              <span class="i-ph-briefcase mr-2"></span>
              Job Title
            </label>
            <UInput
              id="job"
              v-model="job"
              type="text"
              placeholder="Your job title"
              class="w-full"
            />
          </div>

          <div>
            <label for="location" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              <span class="i-ph-map-pin mr-2"></span>
              Location
            </label>
            <UInput
              id="location"
              v-model="location"
              type="text"
              placeholder="Your location"
              class="w-full"
            />
          </div>
        </div>

        <!-- Toggle optional fields for registration -->
        <div v-if="!isLogin" class="text-center w-full">
          <UButton
            type="button"
            @click="showOptionalFields = !showOptionalFields"
            btn="text-blue"
            size="sm"
          >
            {{ showOptionalFields ? 'Hide optional fields' : 'Add optional details' }}
            <span :class="showOptionalFields ? 'i-ph-caret-up' : 'i-ph-caret-down'"></span>
          </UButton>
        </div>

        <div class="pt-4">
          <UButton
            type="submit"
            btn="solid-black dark:solid-pink"
            :loading="isSubmitting"
            :disabled="isSubmitting"
            size="md"
            class="w-full hover:scale-101 active:scale-99 transition"
          >
          {{ isLogin ? 'Sign in' : 'Sign up' }}
          <span :class="isLogin ? 'i-ph-sign-in-bold' : 'i-ph-user-plus'"></span>
          </UButton>
        </div>

        <!-- Error Alert -->
        <UAlert
          v-if="error"
          class="mt-4"
          alert="soft-pink"
          title="Authentication Error"
          icon="i-ph-warning-circle"
          :close-button="{ icon: 'i-ph-x', color: 'gray' }"
          @close="error = ''"
        >
          {{ error }}
        </UAlert>

        <!-- Success Alert -->
        <UAlert
          v-if="successMessage"
          class="mt-4"
          alert="soft-blue"
          title="Success"
          icon="i-ph-check-circle"
          :close-button="{ icon: 'i-ph-x', color: 'gray' }"
          @close="successMessage = ''"
        >
          {{ successMessage }}
        </UAlert>

        <!-- Toggle between login/signup -->
        <div class="text-center">
          <UButton
            type="button"
            @click="toggleMode"
            btn="text-black"
            size="sm"
            class="hover:scale-103 active:scale-99 transition"
          >
            {{ isLogin ? 'Need an account? Sign up' : 'Already have an account? Sign in' }}
          </UButton>
        </div>
      </form>
    </section>

    <Footer />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
const { loggedIn, fetch: refreshSession } = useUserSession()

// Form fields
const name = ref('')
const email = ref('')
const password = ref('')
const masterPassword = ref('')
const biography = ref('')
const job = ref('')
const location = ref('')

// UI state
const error = ref('')
const successMessage = ref('')
const isLogin = ref(true)
const isSubmitting = ref(false)
const showOptionalFields = ref(false)

onMounted(async () => {
  if (loggedIn.value) {
    await navigateTo('/user')
  }
})

watch(loggedIn, (newValue) => {
  if (newValue) {
    navigateTo('/user')
  }
})

const toggleMode = () => {
  isLogin.value = !isLogin.value
  error.value = ''
  successMessage.value = ''
  
  // Clear form fields when switching modes
  if (isLogin.value) {
    name.value = ''
    biography.value = ''
    job.value = ''
    location.value = ''
    masterPassword.value = ''
    showOptionalFields.value = false
  }
}

const handleSubmit = async () => {
  error.value = ""
  successMessage.value = ""
  isSubmitting.value = true

  if (isLogin.value) {
    // Login logic
    try {
      await $fetch('/api/login', {
        method: 'POST',
        body: {
          email: email.value,
          password: password.value,
        },
      })
      
      await refreshSession()
      await navigateTo('/')
    } catch (e) {
      error.value = e.data?.message || 'Invalid credentials. Please try again.'
    }
  } else {
    // Registration logic
    try {
      // Client-side validation
      if (name.value.length < 2) {
        error.value = 'Name must be at least 2 characters long.'
        return
      }
      
      if (password.value.length < 8) {
        error.value = 'Password must be at least 8 characters long.'
        return
      }
      
      if (masterPassword.value.length === 0) {
        error.value = 'Master password is required.';
        return
      }

      const response = await $fetch('/api/register', {
        method: 'POST',
        body: {
          name: name.value,
          email: email.value,
          password: password.value,
          masterPassword: masterPassword.value,
          biography: biography.value || undefined,
          job: job.value || undefined,
          location: location.value || undefined,
        },
      })
      
      successMessage.value = response.message || 'Account created successfully!'
      
      // Refresh session since the register endpoint sets the user session
      await refreshSession()
      
      // Redirect after a short delay to show success message
      setTimeout(async () => {
        await navigateTo('/')
      }, 1500)
      
    } catch (e) {
      console.error('Registration error:', e)
      error.value = e.data?.message || 'Failed to create account. Please try again.'
    }
  }

  isSubmitting.value = false
}
</script>

<style scoped>
.frame {
  width: 100%;
  padding: 2rem;
  padding-bottom: 38vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  min-height: 100vh;
}
</style>
