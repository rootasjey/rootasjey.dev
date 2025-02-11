<template>
  <div class="min-h-screen w-full flex items-center justify-center">
    <div class="">
      <NuxtPage />
    </div>
  </div>
</template>

<script lang="ts" setup>
import '@una-ui/preset/una.css'
</script>

<style>
html {
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
}

body {
  margin: 0;
  padding: 0;
}

.card-wrapper {
  position: relative;
  padding: 2px;
  border-radius: 0.95rem;
  background: linear-gradient(
    45deg,
    #BFECFF,
    #CDC1FF,
    #FFF6E3,
    #FFCCEA,
    #EEEEEE
  );
  background-size: 200% 200%;
  animation: gradientBorder 15s ease infinite;
  box-shadow: 0 10px 50px rgba(61, 59, 243, 0.1);
  transition: all 0.3s ease;
}

.card-wrapper > div {
  margin: 0;
}

.select-default-variant {
  width: fit-content;
}

[tooltip~="black"] {
  border: none;
}

.tooltip-content {
  padding: 0px;
}

@keyframes gradientBorder {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}
</style>