<template>
  <div class="container mx-auto p-8">
    <h1 class="text-3xl font-bold mb-8">Enhanced TipTap Editor Test</h1>
    
    <div class="mb-8">
      <h2 class="text-xl font-semibold mb-4">Features to Test:</h2>
      <ul class="list-disc list-inside space-y-2 mb-6">
        <li><strong>Heading Dropdown:</strong> H1-H6 and Paragraph options</li>
        <li><strong>Text Formatting:</strong> Bold, Italic, Strike, Underline, Highlight</li>
        <li><strong>Code Dropdown:</strong> Inline Code, Code Block, Block Quote</li>
        <li><strong>Lists:</strong> Bullet lists, Ordered lists, Task lists (checkboxes)</li>
        <li><strong>Text Alignment:</strong> Left, Center, Right, Justify</li>
        <li><strong>Links:</strong> Add/edit/remove links</li>
        <li><strong>Slash Commands:</strong> Type "/" to see enhanced commands</li>
      </ul>
    </div>

    <div class="border rounded-lg p-4 bg-white dark:bg-gray-900">
      <ClientOnly>
        <TiptapEditor
          v-model="editorContent"
          :can-edit="true"
          class="min-h-[400px]"
        />
        <template #fallback>
          <div class="min-h-[400px] flex items-center justify-center text-gray-500">
            Loading editor...
          </div>
        </template>
      </ClientOnly>
    </div>

    <div class="mt-8">
      <h3 class="text-lg font-semibold mb-4">Editor Content (JSON):</h3>
      <pre class="bg-gray-100 dark:bg-gray-800 p-4 rounded-lg overflow-auto text-sm">{{ JSON.stringify(editorContent, null, 2) }}</pre>
    </div>

    <div class="mt-8">
      <h3 class="text-lg font-semibold mb-4">Test Instructions:</h3>
      <ol class="list-decimal list-inside space-y-2">
        <li>Try the heading dropdown - select different heading levels</li>
        <li>Test text formatting - select text and use bold, italic, underline, highlight</li>
        <li><strong>NEW:</strong> Test the code dropdown - try inline code, code blocks, and block quotes</li>
        <li>Create different list types - bullet, numbered, and task lists</li>
        <li>Test text alignment options</li>
        <li>Add and edit links</li>
        <li>Use slash commands by typing "/" in the editor</li>
        <li>Check that the bubble menu appears when selecting text</li>
        <li>Verify that all features work on mobile (responsive design)</li>
      </ol>
    </div>
  </div>
</template>

<script setup lang="ts">
const editorContent = ref({
  type: "doc",
  content: [
    {
      type: "heading",
      attrs: { level: 1 },
      content: [{ type: "text", text: "Welcome to the Enhanced TipTap Editor!" }]
    },
    {
      type: "paragraph",
      content: [
        { type: "text", text: "This editor now includes many new features. Try selecting this text to see the enhanced bubble menu with:" }
      ]
    },
    {
      type: "bulletList",
      content: [
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [{ type: "text", text: "Heading dropdown (H1-H6)" }]
            }
          ]
        },
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [
                { type: "text", text: "Text formatting: " },
                { type: "text", text: "bold", marks: [{ type: "bold" }] },
                { type: "text", text: ", " },
                { type: "text", text: "italic", marks: [{ type: "italic" }] },
                { type: "text", text: ", " },
                { type: "text", text: "underline", marks: [{ type: "underline" }] },
                { type: "text", text: ", " },
                { type: "text", text: "highlight", marks: [{ type: "highlight" }] }
              ]
            }
          ]
        },
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [{ type: "text", text: "List management and text alignment" }]
            }
          ]
        }
      ]
    },
    {
      type: "paragraph",
      content: [
        { type: "text", text: "Try typing " },
        { type: "text", text: "/", marks: [{ type: "code" }] },
        { type: "text", text: " to see the enhanced slash commands!" }
      ]
    },
    {
      type: "heading",
      attrs: { level: 2 },
      content: [{ type: "text", text: "New Code Features" }]
    },
    {
      type: "paragraph",
      content: [
        { type: "text", text: "You can now use inline code like " },
        { type: "text", text: "console.log('Hello World')", marks: [{ type: "code" }] },
        { type: "text", text: " or create code blocks:" }
      ]
    },
    {
      type: "codeBlock",
      content: [
        { type: "text", text: "function greet(name) {\n  return `Hello, ${name}!`;\n}\n\nconsole.log(greet('World'));" }
      ]
    },
    {
      type: "paragraph",
      content: [
        { type: "text", text: "You can also create block quotes for important notes:" }
      ]
    },
    {
      type: "blockquote",
      content: [
        {
          type: "paragraph",
          content: [
            { type: "text", text: "This is a block quote. Perfect for highlighting important information, quotes, or notes." }
          ]
        }
      ]
    },
    {
      type: "taskList",
      content: [
        {
          type: "taskItem",
          attrs: { checked: false },
          content: [
            {
              type: "paragraph",
              content: [{ type: "text", text: "Test the task list feature" }]
            }
          ]
        },
        {
          type: "taskItem",
          attrs: { checked: true },
          content: [
            {
              type: "paragraph",
              content: [{ type: "text", text: "This task is completed!" }]
            }
          ]
        }
      ]
    }
  ]
})

// Set page title
useHead({
  title: 'Enhanced TipTap Editor Test'
})
</script>

<style scoped>
.container {
  max-width: 1200px;
}
</style>
