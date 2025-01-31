<template>
  <div>
    <bubble-menu :editor="editor" :tippy-options="{ duration: 100 }" v-if="editor">
      <div class="bubble-menu">
        <UButton @click="editor.chain().focus().toggleBold().run()" :class="{ 'is-active': editor.isActive('bold') }"
          icon btn="~" label="i-icon-park-outline:text-bold" />
        <UButton @click="editor.chain().focus().toggleItalic().run()"
          :class="{ 'is-active': editor.isActive('italic') }" icon btn="~" label="i-icon-park-outline:text-italic" />
        <UButton @click="editor.chain().focus().toggleStrike().run()"
          :class="{ 'is-active': editor.isActive('strike') }" icon btn="~" label="i-icon-park-outline:strikethrough" />

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
    type: String,
    required: false,
    default: "<p>I'm running Tiptap with Vue.js. 🎉</p>",
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
  content: JSON.parse(props.modelValue),
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

onBeforeUnmount(() => {
  editor.destroy()
})

</script>

<style>
.tiptap:focus-visible {
  outline: 2px dashed rgb(var(--una-primary));
  border-radius: 0.25rem;
  outline-offset: 0.60rem;
}

.tiptap {
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
  }

  h1,
  h2 {
    margin-top: 2rem;
    margin-bottom: 1.5rem;
  }

  h1 {
    font-size: 3rem;
  }

  h2 {
    font-size: 2.0rem;
  }

  h3 {
    font-size: 1.1rem;
  }

  h4,
  h5,
  h6 {
    font-size: 1rem;
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
      background-color: var(--c-border);
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
