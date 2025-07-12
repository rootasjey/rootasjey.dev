<template>
  <UDropdownMenu
    :items="codeItems"
  >
    <UButton
      btn="~"
      class="p-0"
      :class="{ 'is-active': isCodeActive }"
    >
      <div class="flex items-center gap-1">
        <UIcon :name="currentCodeIcon" />
        <UIcon name="i-ph-caret-down" />
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

const codeItems = computed(() => [
  {
    label: 'Inline Code',
    leading: 'i-lucide-code',
    onclick: () => props.editor?.chain().focus().toggleCode().run(),
    active: props.editor?.isActive('code')
  },
  {
    label: 'Code Block',
    leading: 'i-lucide-code-2',
    onclick: () => props.editor?.chain().focus().toggleCodeBlock().run(),
    active: props.editor?.isActive('codeBlock')
  },
  {
    label: 'Block Quote',
    leading: 'i-lucide-quote',
    onclick: () => props.editor?.chain().focus().toggleBlockquote().run(),
    active: props.editor?.isActive('blockquote')
  }
])

const currentCodeIcon = computed(() => {
  if (!props.editor) return 'i-lucide-code'
  
  if (props.editor.isActive('code')) return 'i-lucide-code'
  if (props.editor.isActive('codeBlock')) return 'i-lucide-code-2'
  if (props.editor.isActive('blockquote')) return 'i-lucide-quote'
  
  return 'i-lucide-code'
})

const isCodeActive = computed(() => {
  return props.editor?.isActive('code') || 
         props.editor?.isActive('codeBlock') || 
         props.editor?.isActive('blockquote') || 
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
