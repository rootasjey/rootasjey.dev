<template>
  <div class="cv-wrapper w-[600px] mt-24 rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <!-- Header Section -->
    <section class="mb-9">
      <h1 class="font-600">{{ cv.name }}</h1>
      <h2 v-if="cv.tagline" class="color-gray-600 font-500 dark:color-gray-500">
        {{ cv.tagline }}
      </h2>
      <h2 v-if="cv.location" class="color-gray-400 dark:color-gray-600">{{ cv.location }}</h2>
    </section>

    <!-- Profile Section -->
    <section v-if="cv.profile" class="mb-6">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-2">
        <span class="i-ph-user-circle mr-2"></span>
        Profil
      </h2>
      <p class="text-size-4 text-gray-700 dark:text-gray-300 mb-4">
        {{ cv.profile.text }}
      </p>
    </section>

    <!-- Skills Section -->
    <section v-if="cv.skills?.categories?.length" class="mb-8">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-code mr-2"></span>
        Compétences Techniques
      </h2>
      <div class="grid gap-4 mb-4"
        :class="{
          'grid-cols-2': cv.skills.categories && cv.skills.categories.length > 1
        }"
      >
        <div v-for="category in cv.skills.categories" :key="category.title">
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2">{{ category.title }}</h3>
          <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
            <li v-for="skill in category.skills" :key="skill">{{ skill }}</li>
          </ul>
        </div>
      </div>
    </section>

    <!-- Work Experience Section -->
    <section v-if="cv.experiences?.length" class="workexperience mb-6">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-briefcase mr-2"></span>
        Expérience Professionnelle
      </h2>

      <div v-for="exp in cv.experiences" :key="exp.company + exp.startDate" class="mt-6">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">{{ exp.company }}</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">
            {{ formatDate(exp.startDate) }} - {{ exp.endDate ? formatDate(exp.endDate) : 'Present' }}
          </span>
        </div>
        <p v-if="exp.description" class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          {{ exp.description }}
        </p>
        <ul v-if="exp.highlights?.length" class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li v-for="(highlight, index) in exp.highlights" :key="index">{{ highlight }}</li>
        </ul>
        <div v-if="exp.tags?.length" class="tags flex flex-wrap gap-2 mt-2">
          <span v-for="tag in exp.tags" :key="tag">{{ tag }}</span>
        </div>
      </div>
    </section>

    <!-- Education Section -->
    <section v-if="cv.education?.length" class="mb-12">
      <h2 class="flex items-center text-lg font-500 text-gray-800 dark:text-gray-200 mb-2">
        <span class="i-ph-graduation-cap mr-2"></span>
        Education
      </h2>

      <div v-for="edu in cv.education" :key="edu.institution + edu.startDate">
        <div class="flex justify-between items-start mt-4">
          <h3 class="font-500 text-gray-800 dark:text-gray-200">{{ edu.degree }}</h3>
          <span class="text-sm text-gray-600 dark:text-gray-400">
            {{ formatDate(edu.startDate) }} - {{ edu.endDate ? formatDate(edu.endDate) : 'Present' }}
          </span>
        </div>
        <div class="text-gray-500 font-500 mb-2">{{ edu.institution }}</div>
        <p v-if="edu.description" class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          {{ edu.description }}
        </p>
        <p v-if="edu.courses?.length" class="text-size-3 font-500 text-gray-600 dark:text-gray-300 mb-3">
          {{ edu.courses.join(' • ') }}
        </p>
      </div>
    </section>

    <!-- Personal Projects Section -->
    <section v-if="cv.projects?.length" class="mb-12">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-3">
        <span class="i-ph-rocket-launch mr-2"></span>
        Projets Personnels
      </h2>

      <div class="flex flex-row flex-wrap justify-between">
        <div v-for="project in cv.projects" :key="project.name" class="w-1/2.4">
          <div class="flex justify-between items-start">
            <h3 class="font-500 text-gray-800 dark:text-gray-200">
              <a v-if="project.url" :href="project.url" target="_blank">{{ project.name }}</a>
              <span v-else>{{ project.name }}</span>
            </h3>
          </div>
          <p class="text-size-3 font-500 text-gray-600 dark:text-gray-300 mb-3">
            {{ project.description }}
          </p>
          <div v-if="project.tags?.length" class="tags flex flex-wrap gap-2 mt-2">
            <span v-for="tag in project.tags" :key="tag">{{ tag }}</span>
          </div>
        </div>
      </div>
    </section>
    
    <!-- Interests Section -->
    <section v-if="cv.interests?.length" class="mb-12">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-heart mr-2"></span>
        Centres d'intérêt
      </h2>
      <div class="grid gap-6"
        :class="{
          'grid-cols-2': cv.interests && cv.interests.length > 2,
        }"
      >
        <div v-for="interest in cv.interests" :key="interest.title">
          <h3 class="text-size-4 font-500 text-gray-800 dark:text-gray-200 flex items-center mb-2">
            <span v-if="interest.icon" :class="interest.icon" class="mr-2"></span>
            {{ interest.title }}
          </h3>
          <p class="interest-description text-size-3 text-gray-500 dark:text-gray-300" v-html="interest.description" />
        </div>
      </div>
    </section>

    <!-- Connect Section -->
    <section v-if="cv.contact" class="no-print">
      <h2 class="flex items-center text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-handshake mr-2"></span>
        Prenons contact
      </h2>
      <p class="text-gray-700 dark:text-gray-300 mb-6">
        Intéressé•e pour travailler ensemble ou en apprendre davantage sur mon parcours ? N'hésitez pas à me contacter via
        <ULink to="/contact" class="arrow"><span>ma page de contact</span></ULink> 
        ou via les liens ci-dessous.
      </p>
      
      <SocialLinks />
    </section>

    <!-- Footer -->
    <footer class="no-print mt-16 text-size-3">
      <div class="flex gap-4">
        <ULink to="/" class="footer-button">
          <span class="i-ph-house-simple text-size-3 mr-2"></span>
          <span class="font-500">Back to home</span>
        </ULink>
        <UButton btn="~"
          @click="scrollToTop"
          class="footer-button p-0 w-auto h-auto">
          <span class="i-ph-arrow-up-duotone text-size-3 mr-2 -mt-1"></span>
          <span class="font-500 text-size-3 relative -top-0.5">Back to top</span>
        </UButton>
        <ULink v-if="cv.language === 'fr'" to="/resume" class="footer-button">
          <span class="font-500">See this resume in english</span>
        </ULink>
      </div>

      <p class="text-gray-500 dark:text-gray-400">
        © <span class="font-600">{{ cv.name }}</span>
        <span class="mx-1">&middot;</span>
        <span class="font-600">{{ new Date().getFullYear() }}</span>
      </p>
    </footer>
  </div>
</template>

<script setup lang="ts">
import type { Resume } from '~/types/document'

const props = defineProps<{
  cv: Resume
}>()

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.getFullYear().toString()
}

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}
</script>

<style scoped>
.workexperience > div {
  padding-bottom: 1.5rem;
  border-bottom: 1px dashed rgba(var(--una-gray-200), 1);

  &:last-child {
    border-bottom: none;
  }
}

.dark .workexperience > div {
  padding-bottom: 1.5rem;
  border-bottom: 1px dashed rgba(var(--una-gray-600), 1);

  &:last-child {
    border-bottom: none;
  }
}

:deep(.interest-description) {
  li:before {
    content: "• ";
    font-weight: bold;
  }
}

.tags {
  span {
    padding: 0.25rem 0.5rem;
    border-radius: var(--una-radius);
    font-size: 0.75rem;
    line-height: 1rem;
    --un-text-opacity: 1;
    color: rgba(var(--una-gray-700), var(--un-text-opacity));
    --un-bg-opacity: 1;
    background-color: rgba(var(--una-gray-100), var(--un-bg-opacity));
  }
}

.dark .tags {
  span {
    --un-text-opacity: 1;
    color: rgba(var(--una-gray-300), var(--un-text-opacity));
    --un-bg-opacity: 1;
    background-color: rgba(var(--una-gray-800), var(--un-bg-opacity));
  }
}

.footer-button {
  display: block;
  color: rgba(var(--una-gray-500), 1);
  transition: all;
  
  &:hover {
    color: rgba(var(--una-gray-600), 1);
    text-decoration: underline;
    text-underline-offset: 4px;
    transform: scale(1.01);
  }
  
  &:active {
    transform: scale(0.99);
  }
}

.dark .footer-button {
  color: rgba(var(--una-gray-400), 1);

  &:hover {
    color: rgba(var(--una-gray-300), 1);
  }
}
</style>
