<template>
  <div>
    <bubble-menu :editor="editor" :tippy-options="{ duration: 100, maxWidth: 'none' }" v-if="editor">
      <div class="bubble-menu">
        <UButton 
          @click="() => toggleHeading(editor, 1)" 
          :class="{ 'is-active': editor.isActive('heading', { level: 1 }) }"
          icon btn="~" label="i-lucide-heading-1" 
        />
        <UButton 
          @click="() => toggleHeading(editor, 2)" 
          :class="{ 'is-active': editor.isActive('heading', { level: 2 }) }"
          icon btn="~" label="i-lucide-heading-2" 
        />
        <UButton 
          @click="() => toggleHeading(editor, 3)" 
          :class="{ 'is-active': editor.isActive('heading', { level: 3 }) }"
          icon btn="~" label="i-lucide-heading-3" 
        />
        <UButton 
          @click="() => toggleHeading(editor, 4)" 
          :class="{ 'is-active': editor.isActive('heading', { level: 4 }) }"
          icon btn="~" label="i-lucide-heading-4" 
        />
        <UButton @click="editor.chain().focus().toggleBold().run()" :class="{ 'is-active': editor.isActive('bold') }"
          icon btn="~" label="i-lucide-bold" />
        <UButton @click="editor.chain().focus().toggleItalic().run()"
          :class="{ 'is-active': editor.isActive('italic') }" icon btn="~" label="i-lucide-italic" />
        <UButton @click="editor.chain().focus().toggleStrike().run()"
          :class="{ 'is-active': editor.isActive('strike') }" icon btn="~" label="i-lucide-strikethrough" />

        <UPopover :popper-class="['!p-2']">
          <template #trigger>
            <UButton icon btn="~" label="i-icon-park-outline:link" :class="{ 'is-active': editor.isActive('link') }" @click="onOpenLinkPopover" />
          </template>

          <div class="flex flex-col gap-2 min-w-[200px] p-2">
            <UInput v-model="linkUrl" placeholder="Enter URL..." @keydown.enter.prevent.stop="setLink" />
            <div class="flex gap-2">
              <UButton size="sm" color="primary" @click="setLink" 
                :label="editor.isActive('link') ? 'Update link' : 'Add link'" 
                btn="soft" 
              />
              <UButton v-if="editor.isActive('link')" size="sm" color="gray"
                @click="editor.chain().focus().unsetLink().run()" label="Remove link" btn="soft" />
            </div>
          </div>
        </UPopover>
      </div>
    </bubble-menu>
    <editor-content :editor="editor" class="mt-8" />
  </div>
</template>

<script setup lang="ts">
import StarterKit from '@tiptap/starter-kit'
import { BubbleMenu, Editor, EditorContent } from '@tiptap/vue-3'
import Link from '@tiptap/extension-link'
import Image from '@tiptap/extension-image'
import SlashCommands from './commands/commands'
import suggestion from './commands/suggestion'

type Level = 1 | 2 | 3 | 4 | 5 | 6

const props = defineProps({
  canEdit: {
    type: Boolean,
    required: false,
    default: false,
    validator: (value) => {
      return typeof value === "boolean"
    },
  },
  modelValue: {
    type: Object,
    required: false,
    default: {
      "type": "doc",
      "content": [
        { 
          "type": "paragraph", 
          "content": [
            { 
              "type": "text", 
              "text": "I\'m running Tiptap with Vue.js. 🎉" 
            }
          ]
        }
      ]
    },
  },
})

const emit = defineEmits(["update:modelValue"])

const editor = new Editor({
  editable: props.canEdit,
  extensions: [
    StarterKit.configure({
      dropcursor: {
        color: '#000',
        width: 4,
      },
    }),
    SlashCommands.configure({
      suggestion,
    }),
    Image.configure({
      inline: true,
    }),
    Link.configure({
      openOnClick: true,
      linkOnPaste: true,
      HTMLAttributes: {
        target: "_blank",
        rel: "noopener noreferrer",
      },
    }),
  ],
  content: typeof props.modelValue === "string" ? JSON.parse(props.modelValue) : props.modelValue,
  onUpdate: () => {
    emit("update:modelValue", editor.getJSON())
  },
})

const linkUrl = ref('')

const onOpenLinkPopover = () => {
  linkUrl.value = editor.getAttributes('link').href
}

const setLink = () => {
  if (linkUrl.value === '') {
    editor.chain().focus().unsetLink().run()
    return
  }

  editor.chain().focus().setLink({ href: linkUrl.value }).run()
  linkUrl.value = ''
}

const toggleHeading = (editor: Editor | null, level: Level) => {
  if (!editor) return

  if (editor.isActive("heading", { level })) {
    editor.chain().focus().setNode("paragraph").run()
  } else {
    editor.chain().focus().toggleNode("heading", "paragraph", { level }).run()
  }
}

onBeforeUnmount(() => {
  editor.destroy()
})

</script>

<style>
.tiptap:focus-visible {
  outline: 1px dashed transparent;
  border-radius: 0rem;
  outline-offset: 1.20rem;
}

.dark .tiptap:focus-visible {
  outline: 1px dashed transparent;
  border-radius: 0rem;
}

.tiptap {
  transition: all 0.3s ease;
  
  :first-child {
    margin-top: 0;
  }

  /* List styles */
  ul,
  ol {
    padding: 0 1rem;
    margin: 1.25rem 1rem 1.25rem 0.4rem;

    li p {
      margin-top: 0.25em;
      margin-bottom: 0.25em;
    }
  }

  ol {
    list-style: decimal-leading-zero;
    margin-left: 1.75rem;
  }
  
  ul {
    list-style: disc;
  }

  /* Heading styles */
  h1,
  h2,
  h3,
  h4,
  h5,
  h6 {
    line-height: 1.1;
    margin-top: 2.5rem;
    text-wrap: pretty;
    font-family: "Khand";
  }

  h1,
  h2 {
    margin-top: 2rem;
    margin-bottom: 1.5rem;
  }

  h1 {
    font-size: 4rem;
    font-weight: 700;
  }

  h2 {
    font-size: 3.0rem;
  }

  h3 {
    font-size: 1.5rem; /* 24px */
    font-weight: 600;
  }

  h4,
  h5,
  h6 {
    font-size: 1rem;
  }

  /* Paragraph styles */
  p {
    color: #1E1E2E;
  }

  /* Code and preformatted text styles */
  code {
    background-color: var(--purple-light);
    border-radius: 0.4rem;
    color: var(--black);
    font-size: 0.85rem;
    padding: 0.25em 0.3em;
  }

  pre {
    background: var(--black);
    border-radius: 0.5rem;
    color: var(--white);
    font-family: 'JetBrainsMono', monospace;
    margin: 1.5rem 0;
    padding: 0.75rem 1rem;

    code {
      background: none;
      color: inherit;
      font-size: 0.8rem;
      padding: 0;
    }
  }

  blockquote {
    border-left: 3px solid var(--gray-3);
    margin: 1.5rem 0;
    padding-left: 1rem;
  }

  hr {
    border: none;
    border-top: 1px solid var(--gray-2);
    margin: 2rem 0;
  }

  img {
    display: block;
    height: auto;
    margin: 1.5rem 0;
    max-width: 100%;

    &.ProseMirror-selectednode {
      outline: 3px solid var(--purple);
    }
  }

  a {
    color: #6466F1;
    cursor: pointer;

    &:hover {
      color: #64e1f1;
    }
  }
}

.dark .tiptap {
  p {
    color: #ABADBA;
  }
}

</style>

<style scoped>
.bubble-menu {
  background-color: var(--c-background);
  border: 1px solid var(--c-border);
  border-radius: 0.7rem;
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.2);
  display: flex;
  flex-direction: row;
  gap: 0.6rem;
  padding: 0.2rem 0.8rem;

  button {
    background-color: unset;
    padding: 0.2rem 0.6rem;
    border-radius: 0.5rem;
    transition: background-color 0.3s ease;

    &:hover {
      background-color: transparent;
      /* background-color: var(--c-border); */
    }

    &.is-active {
      background-color: #5046E5;
      color: #fff;

      &:hover {
        background-color: #635ade;
      }
    }
  }
}
</style>
