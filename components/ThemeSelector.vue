<template>
  <div>
    <USelect
      v-model="selectedTheme"
      :items="themeOptions"
      value-key="label"
      item-key="label"
      size="xs"
      select="light:soft-rose dark:soft-blue"
      select-item="light:rose dark:blue"
      @update:model-value="onThemeChange"
    >
      <template #value="{ modelValue }">
        <span class="flex items-center gap-2">
          <UIcon :name="(modelValue as ThemeOption)?.icon" class="w-4 h-4" />
          {{ (modelValue as ThemeOption)?.label }}
        </span>
      </template>
      <template #item="{ item }">
        <span class="flex items-center gap-2">
          <UIcon :name="item.icon" class="w-4 h-4" />
          {{ item.label }}
        </span>
      </template>
    </USelect>
  </div>
</template>

<script setup lang="ts">
interface ThemeOption {
  label: string;
  value: string;
  icon: string;
}

const themeOptions: ThemeOption[] = [
  { label: 'System', value: 'system', icon: 'i-ph-monitor-duotone' },
  { label: 'Light', value: 'light', icon: 'i-ph-sun-duotone' },
  { label: 'Dark', value: 'dark', icon: 'i-ph-moon-duotone' },
]

function getInitialTheme(): ThemeOption {
  if (import.meta.client) {
    const saved = localStorage.getItem('theme')
    const found = themeOptions.find(opt => opt.value === saved)
    if (found) return found
    return themeOptions[0]
  }
  return themeOptions[0]
}

const selectedTheme = ref<ThemeOption>(getInitialTheme())

function onThemeChange(option: ThemeOption) {
  if (!import.meta.client) return
  selectedTheme.value = option
  localStorage.setItem('theme', option.value)
  
  if (option.value === 'system') {
    document.documentElement.classList.remove('dark', 'light')
    // Use system preference
    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.add('light')
    }
  } else {
    document.documentElement.classList.remove('dark', 'light')
    document.documentElement.classList.add(option.value)
  }
}

onMounted(() => {
  if (!import.meta.client) return
  // Apply theme on mount
  onThemeChange(selectedTheme.value)
  // Listen for system changes if system selected
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
    if (selectedTheme.value.value === 'system') {
      const found = themeOptions.find(opt => opt.value === 'system')
      if (found) onThemeChange(found)
    }
  })
})
</script>
