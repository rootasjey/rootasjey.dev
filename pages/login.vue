<template>
  <div class="w-[600px] rounded-xl p-8 flex flex-col transition-all duration-500">
    <header class="mb-8">
      <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
        Sign in
      </h1>
      <p class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
        Welcome back
      </p>
    </header>

    <form @submit.prevent="handleLogin" class="flex flex-col gap-4">
      <div class="flex flex-col gap-2">
        <label class="text-gray-800 dark:text-gray-200">Email</label>
        <input 
          v-model="email"
          type="email" 
          required
          class="p-2 rounded border border-gray-200 dark:border-gray-700 bg-transparent"
        />
      </div>

      <div class="flex flex-col gap-2">
        <label class="text-gray-800 dark:text-gray-200">Password</label>
        <input 
          v-model="password"
          type="password" 
          required
          class="p-2 rounded border border-gray-200 dark:border-gray-700 bg-transparent"
        />
      </div>

      <button 
        type="submit"
        class="mt-4 px-4 py-2 bg-gray-800 dark:bg-gray-200 text-white dark:text-gray-800 rounded hover:opacity-90"
      >
        Sign in
      </button>

      <p v-if="error" class="text-red-500 text-sm">{{ error }}</p>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const email = ref('')
const password = ref('')
const error = ref('')
const router = useRouter()

const handleLogin = async () => {
  try {
    error.value = ""
    const { token } = await $fetch('/api/user/signin', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: {
        email: email.value,
        password: password.value
      }
    })

    // Set both cookie and localStorage
    document.cookie = `token=${token}; path=/`
    localStorage.setItem('token', token)
    localStorage.setItem('email', email.value)
    localStorage.setItem('password', password.value)
    router.push('/')
  } catch (e) {
    error.value = e.message
  }
}
onMounted(async () => {
  // Redirect if user is already authenticated
  const token = localStorage.getItem('token')
  if (token && checkTokenExpiration(token)) {
    console.log("OK")
    document.cookie = `token=${token}; path=/`
    router.push('/')
    return
  }
  
  const savedEmail = localStorage.getItem('email')
  const savedPassword = localStorage.getItem('password')
  if (email && password) {
    email.value = savedEmail
    password.value = savedPassword
    handleLogin()
  }
})

const checkTokenExpiration = (token) => {
  const base64Url = token.split('.')[1]
  const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/')
  const payload = JSON.parse(window.atob(base64))
  return payload.exp * 1000 > Date.now()
}

</script>
