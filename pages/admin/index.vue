<template>
  <!-- Content is handled by the admin layout -->
  <div></div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'admin',
  middleware: 'admin'
})

useHead({
  title: "Admin Dashboard • root",
  meta: [
    {
      name: 'description',
      content: 'Admin dashboard for managing application content and users',
    },
  ],
})
</script>
