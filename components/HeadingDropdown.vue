<template>
  <UDropdownMenu
    :items="headingItems"
  >
    <UButton
      btn="~"
      class="p-0"
      :class="{ 'is-active': isHeadingActive }"
    >
      <div class="flex items-center gap-1">
        <UIcon :name="currentHeadingIcon" />
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

const headingItems = computed(() => [
  {
    label: 'Paragraph',
    leading: 'i-lucide-pilcrow',
    onclick: () => props.editor?.chain().focus().setNode('paragraph').run(),
    active: !props.editor?.isActive('heading')
  },
  {
    label: 'Heading 1',
    leading: 'i-lucide-heading-1',
    onclick: () => toggleHeading(props.editor, 1),
    active: props.editor?.isActive('heading', { level: 1 })
  },
  {
    label: 'Heading 2',
    leading: 'i-lucide-heading-2',
    onclick: () => toggleHeading(props.editor, 2),
    active: props.editor?.isActive('heading', { level: 2 })
  },
  {
    label: 'Heading 3',
    leading: 'i-lucide-heading-3',
    onclick: () => toggleHeading(props.editor, 3),
    active: props.editor?.isActive('heading', { level: 3 })
  },
  {
    label: 'Heading 4',
    leading: 'i-lucide-heading-4',
    onclick: () => toggleHeading(props.editor, 4),
    active: props.editor?.isActive('heading', { level: 4 })
  },
  {
    label: 'Heading 5',
    leading: 'i-lucide-heading-5',
    onclick: () => toggleHeading(props.editor, 5),
    active: props.editor?.isActive('heading', { level: 5 })
  },
  {
    label: 'Heading 6',
    leading: 'i-lucide-heading-6',
    onclick: () => toggleHeading(props.editor, 6),
    active: props.editor?.isActive('heading', { level: 6 })
  }
])

const currentHeadingIcon = computed(() => {
  if (!props.editor) return 'i-lucide-pilcrow'
  
  if (props.editor.isActive('heading', { level: 1 })) return 'i-lucide-heading-1'
  if (props.editor.isActive('heading', { level: 2 })) return 'i-lucide-heading-2'
  if (props.editor.isActive('heading', { level: 3 })) return 'i-lucide-heading-3'
  if (props.editor.isActive('heading', { level: 4 })) return 'i-lucide-heading-4'
  if (props.editor.isActive('heading', { level: 5 })) return 'i-lucide-heading-5'
  if (props.editor.isActive('heading', { level: 6 })) return 'i-lucide-heading-6'
  
  return 'i-lucide-pilcrow'
})

const isHeadingActive = computed(() => {
  return props.editor?.isActive('heading') || false
})

type Level = 1 | 2 | 3 | 4 | 5 | 6

const toggleHeading = (editor: Editor | null, level: Level) => {
  if (!editor) return

  if (editor.isActive("heading", { level })) {
    editor.chain().focus().setNode("paragraph").run()
  } else {
    editor.chain().focus().toggleNode("heading", "paragraph", { level }).run()
  }
}
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
