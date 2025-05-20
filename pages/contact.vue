<template>
  <div class="w-[600px] rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <!-- Header -->
    <header class="mt-12 mb-8">
      <div class="flex gap-2">
        <ULink to="/" class="hover:scale-102 active:scale-99 transition">
          <span class="i-ph-house-simple-duotone"></span>
        </ULink>
        <span>•</span>
        <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
          Contact
        </h1>
      </div>
      <div class="w-40 flex text-center justify-center my-2">
        <div class="w-full h-2">
          <svg viewBox="0 0 300 10" preserveAspectRatio="none">
            <path d="M 0 5 Q 15 0, 30 5 T 60 5 T 90 5 T 120 5 T 150 5 T 180 5 T 210 5 T 240 5 T 270 5 T 300 5"
              stroke="currentColor" fill="none" class="text-gray-300 dark:text-gray-700" stroke-width="1" />
          </svg>
        </div>
      </div>
    </header>

    <!-- About Section -->
    <section class="mb-16">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        About Me
      </h2>
      <p class="text-gray-700 dark:text-gray-300 mb-4">
        I'm a creative developer based in France, exploring the intersection of code and creativity.
        My work spans from web applications to interactive experiments, always with a focus on user experience
        and clean, maintainable code.
      </p>
      <p class="text-gray-700 dark:text-gray-300 mb-4">
        Whether you're interested in collaborating on a project, have questions about my work,
        or just want to say hello, I'd love to hear from you.
      </p>
      <p class="text-gray-700 dark:text-gray-300">
        You can learn more <ULink to="/about" class="arrow"><span>about me</span></ULink> and 
        <ULink to="/resume" class="arrow"><span>my work experiences.</span></ULink>
      </p>
    </section>

    <!-- Social Links -->
    <section class="mb-16">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        Connect
      </h2>
      <div class="flex flex-wrap gap-4">
        <ULink to="https://github.com/rootasjey" target="_blank" rel="noopener noreferrer" 
           class="flex items-center gap-2 px-4 py-2 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
          <div class="i-ph-github-logo"></div>
          <span class="font-600 text-size-3">GitHub</span>
        </ULink>
        <ULink to="https://www.instagram.com/rootasjey" target="_blank" rel="noopener noreferrer"
           class="flex items-center gap-2 px-4 py-2 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
          <div class="i-ph-instagram-logo"></div>
          <span class="font-600 text-size-3">Instagram</span>
        </ULink>
        <ULink to="https://www.linkedin.com/in/jeremiecorpinot/" target="_blank" rel="noopener noreferrer"
           class="flex items-center gap-2 px-4 py-2 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
          <div class="i-ph-linkedin-logo"></div>
          <span class="font-600 text-size-3">LinkedIn</span>
        </ULink>
      </div>
    </section>

    <!-- Contact Form -->
    <section>
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        Send a bottle
      </h2>
      <span class="i-ph-bottle"></span>
      <form 
        @submit.prevent="handleSubmit" 
        v-if="!submitted"
        class="flex flex-col gap-4 p-4 py-6 rounded-lg border border-primary b-dashed dark:border dark:border-gray-700 dark:b-dashed">
        <div>
          <label for="email" class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">Email</label>
          <input 
            type="email" 
            id="email" 
            v-model="form.email" 
            class="w-full px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-2 focus:ring-accent focus:border-transparent"
            required
          />
        </div>

        <div>
          <label for="subject" class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">Subject</label>
          <input 
            type="text" 
            id="subject" 
            v-model="form.subject" 
            class="w-full px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-2 focus:ring-accent focus:border-transparent"
            required
          />
        </div>

        <div>
          <label for="message" class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">Message</label>
          <textarea 
            id="message" 
            v-model="form.message" 
            rows="5" 
            class="w-full px-4 py-2 rounded-lg border border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-800 dark:text-gray-200 focus:ring-2 focus:ring-accent focus:border-transparent"
            required
          ></textarea>
        </div>
        
        <UButton 
          btn="soft"
          type="submit" 
          class="px-6 py-2 dark:bg-teal dark:text-black dark:hover:bg-teal-5 transition-colors"
          :disabled="submitting"
        >
          {{ submitting ? 'Sending...' : 'Send Message' }}
        </UButton>
        
        <p v-if="formStatus" class="text-center" :class="formStatus.type === 'success' ? 'text-green-500' : 'text-red-500'">
          {{ formStatus.message }}
        </p>
      </form>

      <div v-if="submitted" class="p-4 rounded-2 bg-gray-100 dark:bg-gray-800">
        <p class="text-center">
          <span class="i-ph-check-circle text-size-4 mb-1 mr-1"></span>
          <span class="color-gray-600">Thanks for your message! I'll get back to you soon.</span>
          <UButton btn="link" @click="submitted = false">send another message</UButton>
        </p>
      </div>
    </section>

    <Footer />
  </div>
</template>

<script setup>
const form = ref({
  subject: '',
  email: '',
  message: ''
})

const submitting = ref(false)
const formStatus = ref(null)
const submitted = ref(false)

const handleSubmit = async () => {
  submitting.value = true
  formStatus.value = null
  
  try {
    // Send the form data to the API endpoint
    const response = await $fetch('/api/contact/submit', {
      method: 'POST',
      body: form.value
    })

    if (!response.success) {
      throw new Error(response.message)
    }
    
    formStatus.value = {
      type: 'success',
      message: response.message || 'Message sent successfully! I\'ll get back to you soon.'
    }
    
    // Reset form
    form.value = {
      email: '',
      subject: '',
      message: ''
    }

    submitted.value = true
  } catch (error) {
    console.error('Error submitting form:', error)
    formStatus.value = {
      type: 'error',
      message: 'Failed to send message. Please try again later.'
    }
  } finally {
    submitting.value = false
  }
}
</script>
