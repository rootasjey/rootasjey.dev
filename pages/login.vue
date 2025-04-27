<template>
  <div class="w-full h-screen flex justify-center items-center">
    <div class="w-600px rounded-xl p-8 flex flex-col transition-all duration-500">
      <header class="mb-8">
        <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
          {{ isLogin ? 'Sign in' : 'Sign up' }}
        </h1>
        <p class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
          {{ isLogin ? 'Welcome back' : 'Create your account' }}
        </p>
      </header>

      <form @submit.prevent="handleSubmit" class="flex flex-col gap-4">
        <div class="flex flex-col gap-2">
          <label class="text-gray-800 dark:text-gray-200">Email</label>
          <input v-model="email" type="email" required
            class="p-2 rounded border border-gray-200 dark:border-gray-700 bg-transparent" />
        </div>

        <div class="flex flex-col gap-2">
          <label class="text-gray-800 dark:text-gray-200">Password</label>
          <input v-model="password" type="password" required
            class="p-2 rounded border border-gray-200 dark:border-gray-700 bg-transparent" />
        </div>

        <button type="submit"
          class="mt-4 px-4 py-2 bg-gray-800 dark:bg-gray-200 text-white dark:text-gray-800 rounded hover:opacity-90">
          {{ isLogin ? 'Sign in' : 'Sign up' }}
        </button>

        <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>

        <button type="button" @click="isLogin = !isLogin"
          class="text-sm text-gray-600 dark:text-gray-400 hover:underline">
          {{ isLogin ? 'Need an account? Sign up' : 'Already have an account? Sign in' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const { loggedIn, user, fetch: refreshSession, session } = useUserSession()

const email = ref('')
const password = ref('')
const error = ref('')
const isLogin = ref(true)
const router = useRouter()

const handleSubmit = async () => {
  error.value = ""

  if (isLogin.value) {
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
      alert('Bad credentials')
      error.value = e.message
    }

    return
  }

  // Sign up logic
  // await signUp({username: email.value, password: password.value})
}
</script>
