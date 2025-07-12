import tippy from 'tippy.js';
import { VueRenderer } from '@tiptap/vue-3'
import CommandsList from './CommandsList.vue';

export default {
  items: ({ query }: { query: string }) => {
    return [
      {
        title: 'Heading 1',
        icon: 'i-icon-park-outline:h1',
        command: ({ editor, range }: { editor: any; range: any }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .setNode('heading', { level: 1 })
            .run()
        },
      },
      {
        title: 'Heading 2',
        icon: 'i-icon-park-outline:h2',
        command: ({ editor, range }: { editor: any; range: any }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .setNode('heading', { level: 2 })
            .run()
        },      },
      {
        title: 'Bold',
        icon: 'i-icon-park-outline:text-bold',
        command: ({ editor, range }: { editor: any; range: any }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .setMark('bold')
            .run()
        },
      },
      {
        title: 'Italic',
        icon: 'i-icon-park-outline:text-italic',
        command: ({ editor, range }: { editor: any; range: any }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .setMark('italic')
            .run()
        },
      },
      {
        title: 'Underline',
        icon: 'i-lucide-underline',
        command: ({ editor, range }: { editor: any; range: any }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .setMark('underline')
            .run()
        },
      },
      {
        title: 'Highlight',
        icon: 'i-lucide-highlighter',
        command: ({ editor, range }: { editor: any; range: any }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .setMark('highlight')
            .run()
        },
      },
      {
        title: 'Bullet List',
        icon: 'i-lucide-list',
        command: ({ editor, range }: { editor: any; range: any }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .toggleBulletList()
            .run()
        },
      },
      {
        title: 'Numbered List',
        icon: 'i-lucide-list-ordered',
        command: ({ editor, range }: { editor: any; range: any }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .toggleOrderedList()
            .run()
        },
      },
      {
        title: 'Task List',
        icon: 'i-lucide-list-checks',
        command: ({ editor, range }: { editor: any; range: any }) => {
          editor
            .chain()
            .focus()
            .deleteRange(range)
            .toggleTaskList()
            .run()
        },
      },
      {
        title: "Image",
        icon: "i-icon-park-outline:upload-picture",
        command: ({ editor, range }: { editor: any; range: any }) => {
          const input = document.createElement('input')
          input.type = 'file'
          input.accept = 'image/*'

          input.onchange = async (event) => {
            const file = (event.target as HTMLInputElement).files?.[0]
            if (!file) return

            const reader = new FileReader()
            reader.onload = async () => {
              try {
                const { image } = await $fetch(`/api/posts/${route.params.id}/upload-image`, {
                  method: 'POST',
                  body: {
                    file: reader.result,
                    fileName: file.name,
                    type: file.type,
                    placement: "content",
                  },
                  headers: {
                    "Authorization": await useCurrentUser().value?.getIdToken?.() ?? "",
                  },
                })

                if (image.src) {
                  editor
                    .chain()
                    .focus()
                    .deleteRange(range)
                    .setImage({ src: image.src, alt: image.alt })
                    .run()
                }
              } catch (error) {
                console.error('Error uploading image:', error)
              }
            }
            reader.readAsDataURL(file)
          }

          input.click()
        },
      }
    ].filter(item => item.title.toLowerCase().startsWith(query.toLowerCase())).slice(0, 10)
  },
  render: () => {
    let component: VueRenderer
    let popup: { destroy: () => void }[]

    return {
      onStart: (props: { editor: any; clientRect: any }) => {
        component = new VueRenderer(CommandsList, {
          props,
          editor: props.editor,
        })

        if (!props.clientRect) {
          return
        }

        // @ts-ignore
        popup = tippy('body', {
          getReferenceClientRect: props.clientRect,
          appendTo: () => document.body,
          content: component.element,
          showOnCreate: true,
          interactive: true,
          trigger: 'manual',
          placement: 'bottom-start',
        })
      },

      onUpdate(props: { clientRect: any }) {
        component.updateProps(props)

        if (!props.clientRect) {
          return
        }

        // @ts-ignore
        popup[0].setProps({
          getReferenceClientRect: props.clientRect,
        })
      },

      onKeyDown(props: { event: { key: string } }) {
        if (props.event.key === 'Escape') {
          // @ts-ignore
          popup[0].hide()
          return true
        }

        return component.ref?.onKeyDown(props)
      },

      onExit() {
        popup[0].destroy()
        component.destroy()
      },
    }
  },
}
