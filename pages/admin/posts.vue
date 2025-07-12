<script setup lang="ts">
// Redirect to main admin page with posts tab
definePageMeta({
  middleware: 'admin'
})

// Redirect to admin page with posts tab
await navigateTo('/admin?tab=posts', { replace: true })
</script>

<template>
  <!-- This page redirects, so no content needed -->
  <div>Redirecting...</div>
</template>
