<template>
  <div class="frame">
    <header>
      <h1>Contact</h1>

      <h4>
        I'm a creative developer based in France, exploring the intersection of code and creativity.
        My work spans from web applications to interactive experiments, always with a focus on user experience
        and clean, maintainable code.
      </h4>
      <h4>
        Whether you're interested in collaborating on a project, have questions about my work,
        or just want to say hello, I'd love to hear from you.
        You can learn more <ULink to="/about" class="arrow font-400"><span>about me</span></ULink> and 
        <ULink to="/resume" class="arrow font-400"><span>my work experiences.</span></ULink>
      </h4>
    </header>
    
    <!-- Social Links -->
     <SocialLinks class="w-2xl mb-6" />

    <!-- Contact Form -->
    <section>
      <h2>
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
        
        <p v-if="formStatus && submitted" class="text-center" :class="formStatus.type === 'success' ? 'text-green-500' : 'text-red-500'">
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

    <Footer class="mt-24 w-2xl" />
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

<style scoped>
.frame {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  min-height: 100vh;
  padding-bottom: 12rem;

  > header {
    width: 42rem;
    margin-top: 3rem;
    margin-bottom: 3rem;
    text-align: center;
    padding: 0.5rem;
    
    @media (min-width: 768px) {
      padding: 2rem;
      margin-top: 6rem;
    }

    > h1 {
      font-family: "Pilcrow Rounded";
      font-size: 3.75rem;
      line-height: 1;
      font-weight: 600;
      --un-text-opacity: 1;
      color: rgba(var(--una-gray-800), var(--un-text-opacity));
      margin-bottom: 1.5rem;
    }

    > h4 {
      font-size: 1.25rem;
      font-weight: 300;
      margin-bottom: 1.5rem;
      --un-text-opacity: 1;
      color: rgba(var(--una-gray-800), var(--un-text-opacity));
      max-width: 42rem; /* 672px */
      margin-left: auto;
      margin-right: auto;
    }
  }

  > section {
    max-width: 42rem;
    margin-bottom: 3rem;
    width: 100%;

    > p:not(:last-child) {
      --un-text-opacity: 1;
      color: rgba(var(--una-gray-700), var(--un-text-opacity));
      margin-bottom: 1rem;
    }

    > h2 {
      font-size: 1.125rem;
      line-height: 1.75rem;
      font-weight: 500;
      display: flex;
      align-items: center;
      gap: 0.75rem;
      --un-text-opacity: 1;
      color: rgba(var(--una-gray-800), var(--un-text-opacity));
      margin-bottom: 1rem;
    }
  }
}

.dark .frame {
  > header {
    > h1, > h4 {
      color: rgba(var(--una-gray-200), 1);
    }
  }

  > section {
    > h2 {
      color: rgba(var(--una-gray-200), 1);
    }

    > p {
      color: rgba(var(--una-gray-300), 1);
    }
  }
}
</style>
