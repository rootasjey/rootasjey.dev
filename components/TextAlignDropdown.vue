<template>
  <UDropdownMenu
    :items="alignItems"
  >
    <UButton
      btn="~"
      class="p-0"
      :class="{ 'is-active': isAlignActive }"
    >
      <div class="flex items-center gap-1">
        <div :class="currentAlignIcon"></div>
        <span>{{ currentAlignLabel }}</span>
        <div class="i-lucide-chevron-down text-xs"></div>
      </div>
    </UButton>
  </UDropdownMenu>
</template>

<script setup lang="ts">
import type { Editor } from '@tiptap/vue-3'

interface Props {
  editor: Editor | null
}

const props = defineProps<Props>()

const alignItems = computed(() => [
  {
    label: 'Align Left',
    leading: 'i-lucide-align-left',
    onclick: () => props.editor?.chain().focus().setTextAlign('left').run(),
    active: props.editor?.isActive({ textAlign: 'left' })
  },
  {
    label: 'Align Center',
    leading: 'i-lucide-align-center',
    onclick: () => props.editor?.chain().focus().setTextAlign('center').run(),
    active: props.editor?.isActive({ textAlign: 'center' })
  },
  {
    label: 'Align Right',
    leading: 'i-lucide-align-right',
    onclick: () => props.editor?.chain().focus().setTextAlign('right').run(),
    active: props.editor?.isActive({ textAlign: 'right' })
  },
  {
    label: 'Justify',
    leading: 'i-lucide-align-justify',
    onclick: () => props.editor?.chain().focus().setTextAlign('justify').run(),
    active: props.editor?.isActive({ textAlign: 'justify' })
  }
])

const currentAlignIcon = computed(() => {
  if (!props.editor) return 'i-lucide-align-left'
  
  if (props.editor.isActive({ textAlign: 'left' })) return 'i-lucide-align-left'
  if (props.editor.isActive({ textAlign: 'center' })) return 'i-lucide-align-center'
  if (props.editor.isActive({ textAlign: 'right' })) return 'i-lucide-align-right'
  if (props.editor.isActive({ textAlign: 'justify' })) return 'i-lucide-align-justify'
  
  return 'i-lucide-align-left'
})

const currentAlignLabel = computed(() => {
  if (!props.editor) return 'Align'
  
  if (props.editor.isActive({ textAlign: 'left' })) return 'Left'
  if (props.editor.isActive({ textAlign: 'center' })) return 'Center'
  if (props.editor.isActive({ textAlign: 'right' })) return 'Right'
  if (props.editor.isActive({ textAlign: 'justify' })) return 'Justify'
  
  return 'Align'
})

const isAlignActive = computed(() => {
  return props.editor?.isActive({ textAlign: 'left' }) || 
         props.editor?.isActive({ textAlign: 'center' }) || 
         props.editor?.isActive({ textAlign: 'right' }) || 
         props.editor?.isActive({ textAlign: 'justify' }) || 
         false
})
</script>

<style scoped>
button {
  background-color: unset;
  padding: 0.2rem 0.6rem;
  border-radius: 0.5rem;
  transition: all 0.2s ease;
  border: 1px solid transparent;

  &:hover {
    background-color: rgba(80, 70, 229, 0.1);
    border-color: rgba(80, 70, 229, 0.2);
  }

  &.is-active {
    background-color: #5046E5;
    color: #fff;
    border-color: #5046E5;

    &:hover {
      background-color: #635ade;
      border-color: #635ade;
    }
  }
}
</style>
