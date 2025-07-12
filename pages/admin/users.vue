<script setup lang="ts">
// Redirect to main admin page with users tab
definePageMeta({
  middleware: 'admin'
})

// Redirect to admin page with users tab
await navigateTo('/admin?tab=users', { replace: true })
</script>

<template>
  <!-- This page redirects, so no content needed -->
  <div>Redirecting...</div>
</template>
