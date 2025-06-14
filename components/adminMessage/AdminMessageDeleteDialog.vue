<template>
  <UDialog 
    :open="isOpen"
    @update:open="$emit('close')"

    title="Delete Message"
    description="This action cannot be undone."
    :ui="{ width: 'sm:max-w-2xl' }"
    :_dialog-close="{
      btn: 'solid-gray',
    }"
  >
    <div class="py-2">
      <p class="text-size-4 text-gray-600 dark:text-gray-400 mb-4">
        Are you sure you want to delete "<strong>{{ subject }} message</strong>"?
      </p>
      
      <div class="mt-6 flex justify-end gap-2 border-t b-dashed border-gray-200 dark:border-gray-800 pt-4">
        <UButton 
          btn="ghost-gray" 
          @click="$emit('close')"
        >
          Cancel
        </UButton>
        <UButton 
          btn="solid-black" 
          @click="$emit('confirm', messageId)"
        >
          <span>Delete message</span>
        </UButton>
      </div>
    </div>
  </UDialog>
</template>

<script lang="ts" setup>
interface Props {
  isOpen: boolean
  messageId: number
  subject: string
}

interface Emits {
  (e: 'close'): void
  (e: 'confirm', messageId: number): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()
</script>