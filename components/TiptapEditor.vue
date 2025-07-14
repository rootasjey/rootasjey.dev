<template>
  <div>
    <bubble-menu :editor="editor" :tippy-options="{ duration: 100, maxWidth: 'none' }" v-if="editor">
      <div class="bubble-menu">
        <!-- Heading Dropdown -->
        <HeadingDropdown :editor="editor" />

        <!-- Text Formatting -->
        <div class="separator"></div>
        <UButton @click="editor.chain().focus().toggleBold().run()" :class="{ 'is-active': editor.isActive('bold') }"
          icon btn="~" label="i-lucide-bold" />
        <UButton @click="editor.chain().focus().toggleItalic().run()"
          :class="{ 'is-active': editor.isActive('italic') }" icon btn="~" label="i-lucide-italic" />
        <UButton @click="editor.chain().focus().toggleStrike().run()"
          :class="{ 'is-active': editor.isActive('strike') }" icon btn="~" label="i-lucide-strikethrough" />
        <UButton @click="editor.chain().focus().toggleUnderline().run()"
          :class="{ 'is-active': editor.isActive('underline') }" icon btn="~" label="i-lucide-underline" />
        <UButton @click="editor.chain().focus().toggleHighlight().run()"
          :class="{ 'is-active': editor.isActive('highlight') }" icon btn="~" label="i-lucide-highlighter" />

        <!-- Code Controls -->
        <div class="separator"></div>
        <CodeDropdown :editor="editor" />

        <!-- Link -->
        <div class="separator"></div>
        <UPopover :popper-class="['!p-2']">
          <template #trigger>
            <UButton icon btn="~" label="i-ph-link" :class="{ 'is-active': editor.isActive('link') }" @click="onOpenLinkPopover" />
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

        <!-- List Controls -->
        <div class="separator"></div>
        <ListDropdown :editor="editor" />

        <!-- Text Alignment -->
        <div class="separator"></div>
        <TextAlignDropdown :editor="editor" />
      </div>
    </bubble-menu>

    <!-- Drag Handle -->
    <DragHandle :editor="editor" v-if="editor && canEdit" :tippy-options="{ placement: 'left' }">
      <div class="drag-handle hover:scale-120 active:scale-99 transition-all">
        <UIcon name="i-ph-dots-six-vertical-light" 
          class="text-gray-400 hover:text-gray-600 dark:hover:text-black transition-colors" 
        />
      </div>
    </DragHandle>

    <editor-content :editor="editor" class="mt-8" />
  </div>
</template>

<script setup lang="ts">
import StarterKit from '@tiptap/starter-kit'
import { BubbleMenu, Editor, EditorContent } from '@tiptap/vue-3'
import Link from '@tiptap/extension-link'
import Image from '@tiptap/extension-image'
import Underline from '@tiptap/extension-underline'
import Highlight from '@tiptap/extension-highlight'
import TaskList from '@tiptap/extension-task-list'
import TaskItem from '@tiptap/extension-task-item'
import TextAlign from '@tiptap/extension-text-align'
import Code from '@tiptap/extension-code'
import CodeBlock from '@tiptap/extension-code-block'
import Blockquote from '@tiptap/extension-blockquote'
import { DragHandle } from '@tiptap/extension-drag-handle-vue-3'
import SlashCommands from './commands/commands'
import suggestion from './commands/suggestion'
import CodeDropdown from './CodeDropdown.vue'
import HeadingDropdown from './HeadingDropdown.vue'
import ListDropdown from './ListDropdown.vue'
import TextAlignDropdown from './TextAlignDropdown.vue'

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
        color: '#FFCB61',
        width: 4,
      },
      // Disable the built-in code, codeBlock, and blockquote from StarterKit
      // so we can use our own configurations
      code: false,
      codeBlock: false,
      blockquote: false,
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
    Underline,
    Highlight.configure({
      multicolor: true,
    }),
    TaskList,
    TaskItem.configure({
      nested: true,
    }),
    TextAlign.configure({
      types: ['heading', 'paragraph'],
    }),
    Code,
    CodeBlock.configure({
      HTMLAttributes: {
        class: 'code-block',
      },
    }),
    Blockquote,
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
  padding: 0 24px;

  ::selection {
    color: white;
    background-color: #1F1F1F;
  }
  
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

  /* Task list styles */
  ul[data-type="taskList"] {
    list-style: none;
    padding: 0;
    margin-left: 0;

    li {
      display: flex;
      align-items: center;
      margin: 0.5rem 0;

      > label {
        flex: 0 0 auto;
        margin-right: 0.5rem;
        user-select: none;
        cursor: pointer;
      }

      > div {
        flex: 1 1 auto;
      }

      input[type="checkbox"] {
        cursor: pointer;
        margin: 0;
        width: 1rem;
        height: 1rem;
        accent-color: #5046E5;
      }

      &[data-checked="true"] {
        > div {
          text-decoration: line-through;
          opacity: 0.6;
        }
      }
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
    line-height: 1.6;
    margin-bottom: 1rem;

    &:last-child {
      margin-bottom: 0;
    }
  }

  /* Code and preformatted text styles */
  code {
    background-color: #F3F4F6;
    border: 1px solid #E5E7EB;
    border-radius: 0.375rem;
    color: #DC2626;
    font-size: 0.875rem;
    font-family: 'JetBrainsMono', 'Monaco', 'Consolas', monospace;
    padding: 0.125rem 0.375rem;
    font-weight: 500;
  }

  pre {
    background: #1F2937;
    border: 1px solid #374151;
    border-radius: 0.5rem;
    color: #F9FAFB;
    font-family: 'JetBrainsMono', 'Monaco', 'Consolas', monospace;
    margin: 1.5rem 0;
    padding: 1rem;
    overflow-x: auto;
    position: relative;
    box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);

    code {
      background: none;
      border: none;
      color: inherit;
      font-size: 0.875rem;
      padding: 0;
      font-weight: 400;
    }
  }

  /* Code block specific styling */
  .code-block {
    background: #1F2937;
    border: 1px solid #374151;
    border-radius: 0.5rem;
    color: #F9FAFB;
    font-family: 'JetBrainsMono', 'Monaco', 'Consolas', monospace;
    margin: 1.5rem 0;
    padding: 1rem;
    overflow-x: auto;
    position: relative;
    box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);

    &:before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 3px;
      background: linear-gradient(90deg, #5046E5, #8B5CF6);
      border-radius: 0.5rem 0.5rem 0 0;
    }
  }

  blockquote {
    background: #F8FAFC;
    border: 1px solid #E2E8F0;
    border-left: 4px solid #5046E5;
    border-radius: 0 0.375rem 0.375rem 0;
    margin: 1.5rem 0;
    padding: 1rem 1.25rem;
    position: relative;
    font-style: italic;
    color: #475569;

    &:before {
      content: '"';
      position: absolute;
      top: 0.5rem;
      left: 0.75rem;
      font-size: 2rem;
      color: #5046E5;
      opacity: 0.3;
      font-family: serif;
      line-height: 1;
    }

    p {
      margin: 0;
      padding-left: 1.5rem;
    }
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

  /* Text formatting styles */
  u {
    text-decoration: underline;
    text-decoration-color: #5046E5;
    text-decoration-thickness: 2px;
    text-underline-offset: 2px;
  }

  mark {
    background-color: #FEF08A;
    color: #1F2937;
    padding: 0.1em 0.2em;
    border-radius: 0.25rem;
  }

  /* Text alignment styles */
  .tiptap [style*="text-align: left"] {
    text-align: left;
  }

  .tiptap [style*="text-align: center"] {
    text-align: center;
  }

  .tiptap [style*="text-align: right"] {
    text-align: right;
  }

  .tiptap [style*="text-align: justify"] {
    text-align: justify;
  }
}

.dark .tiptap {
  ::selection {
    color: #1F1F1F;
    background-color: #FFF;
  }

  p {
    color: #ABADBA;
  }

  mark {
    background-color: #FCD34D;
    color: #1F2937;
  }

  u {
    text-decoration-color: #8B5CF6;
  }

  ul[data-type="taskList"] li input[type="checkbox"] {
    accent-color: #8B5CF6;
  }

  code {
    background-color: #374151;
    border-color: #4B5563;
    color: #F87171;
  }

  blockquote {
    background: #1F2937;
    border-color: #374151;
    border-left-color: #8B5CF6;
    color: #D1D5DB;

    &:before {
      color: #8B5CF6;
    }

    p {
      color: #D1D5DB;
    }
  }

  .code-block {
    background: #111827;
    border-color: #374151;
    color: #F9FAFB;

    &:before {
      background: linear-gradient(90deg, #8B5CF6, #A855F7);
    }
  }

  pre {
    background: #111827;
    border-color: #374151;
    color: #F9FAFB;
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
  align-items: center;
  gap: 0.6rem;
  padding: 0.2rem 0.8rem;

  .separator {
    width: 1px;
    height: 1.5rem;
    background-color: var(--c-border);
    margin: 0 0.2rem;
  }

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

  /* Responsive adjustments */
  @media (max-width: 768px) {
    flex-wrap: wrap;
    max-width: 90vw;

    .separator {
      display: none;
    }
  }
}

/* Drag Handle Styles */
.drag-handle {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  cursor: grab;
  border-radius: 4px;
  transition: all 0.2s ease;

  &:hover {
    background-color: rgba(0, 0, 0, 0.1);
  }

  &:active {
    cursor: grabbing;
  }
}

.dark .drag-handle {
  &:hover {
    background-color: rgba(255, 255, 255, 0.9);
  }
}
</style>
