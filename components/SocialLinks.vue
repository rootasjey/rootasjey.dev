<template>
  <div class="socials">
    <ULink v-for="link in socialLinks" :to="link.to" target="_blank" rel="noopener noreferrer"
        class="social-btn">
      <UIcon :name="link.icon" />
      <span class="font-600 text-size-3">{{ link.name }}</span>
    </ULink>
  </div>
</template>

<script lang="ts" setup>
const socialLinks = [
  {
    icon: 'i-ph-github-logo',
    name: 'GitHub',
    to: 'https://github.com/rootasjey',
  },
  {
    icon: 'i-ph-instagram-logo',
    name: 'Instagram',
    to: 'https://www.instagram.com/rootasjey',
  },
  {
    icon: 'i-ph-linkedin-logo',
    name: 'LinkedIn',
    to: 'https://www.linkedin.com/in/jeremiecorpinot/',
  },
]
</script>

<style scoped>
.socials {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
}
</style>