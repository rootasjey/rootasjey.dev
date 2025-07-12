<template>
  <UDropdownMenu
    :items="listItems"
  >
    <UButton
      btn="~"
      class="p-0"
      :class="{ 'is-active': isListActive }"
    >
      <div class="flex items-center gap-1">
        <UIcon :name="currentListIcon" />
        <span>{{ currentListLabel }}</span>
        <UIcon name="i-lucide-chevron-down text-xs" />
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

const listItems = computed(() => [
  {
    label: 'Bullet List',
    leading: 'i-lucide-list',
    onclick: () => props.editor?.chain().focus().toggleBulletList().run(),
    active: props.editor?.isActive('bulletList')
  },
  {
    label: 'Ordered List',
    leading: 'i-lucide-list-ordered',
    onclick: () => props.editor?.chain().focus().toggleOrderedList().run(),
    active: props.editor?.isActive('orderedList')
  },
  {
    label: 'Task List',
    leading: 'i-lucide-list-checks',
    onclick: () => props.editor?.chain().focus().toggleTaskList().run(),
    active: props.editor?.isActive('taskList')
  }
])

const currentListIcon = computed(() => {
  if (!props.editor) return 'i-lucide-list'
  
  if (props.editor.isActive('bulletList')) return 'i-lucide-list'
  if (props.editor.isActive('orderedList')) return 'i-lucide-list-ordered'
  if (props.editor.isActive('taskList')) return 'i-lucide-list-checks'
  
  return 'i-lucide-list'
})

const currentListLabel = computed(() => {
  if (!props.editor) return 'List'
  
  if (props.editor.isActive('bulletList')) return 'Bullet'
  if (props.editor.isActive('orderedList')) return 'Ordered'
  if (props.editor.isActive('taskList')) return 'Task'
  
  return 'List'
})

const isListActive = computed(() => {
  return props.editor?.isActive('bulletList') || 
         props.editor?.isActive('orderedList') || 
         props.editor?.isActive('taskList') || 
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
