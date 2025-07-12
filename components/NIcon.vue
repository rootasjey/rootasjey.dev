<template>
  <UIcon :name="name" v-bind="$attrs" />
</template>

<script setup lang="ts">
interface Props {
  name: string
}

defineProps<Props>()
</script>
