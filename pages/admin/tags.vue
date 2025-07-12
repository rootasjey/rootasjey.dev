<script setup lang="ts">
// Redirect to main admin page with tags tab
definePageMeta({
  middleware: 'admin'
})

// Redirect to admin page with tags tab
await navigateTo('/admin?tab=tags', { replace: true })
</script>

<template>
  <!-- This page redirects, so no content needed -->
  <div>Redirecting...</div>
</template>
