<script setup lang="ts">
// Redirect to main admin page with projects tab
definePageMeta({
  middleware: 'admin'
})

// Redirect to admin page with projects tab
await navigateTo('/admin?tab=projects', { replace: true })
</script>

<template>
  <!-- This page redirects, so no content needed -->
  <div>Redirecting...</div>
</template>
