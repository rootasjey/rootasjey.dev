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
import { useFirebaseAuth } from 'vuefire'
import { signInWithEmailAndPassword } from 'firebase/auth'
import { useRouter } from 'vue-router'

const email = ref('')
const password = ref('')
const error = ref('')
const auth = useFirebaseAuth()
const router = useRouter()

const handleLogin = async () => {
  try {
    error.value = ''
    await signInWithEmailAndPassword(auth, email.value, password.value)
    router.push('/')
  } catch (e) {
    error.value = e.message
  }
}

onMounted(() => {
  // Redirect if user is already authenticated
  const unsubscribe = auth.onAuthStateChanged((user) => {
    if (!user) return
    router.push('/')
  })

  // Cleanup subscription
  onUnmounted(() => unsubscribe())
})
</script>
