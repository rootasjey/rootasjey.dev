<template>
  <div v-if="tags.length > 0">
    <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Tags</h4>
    <div class="flex flex-wrap gap-2">
      <UBadge
        v-for="tag in tags"
        :key="tag.id"
        :badge="tag.isUsed ? 'soft-green' : 'soft-gray'"
        size="xs"
        closable
        class="cursor-pointer rounded-full"
        @click.self="$emit('edit', tag)"
        @close="$emit('delete', tag)"
      >
        {{ tag.isUsed ? `${tag.name} (${tag.count})` : tag.name }}
      </UBadge>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { TagWithUsage } from '~/types/tag'

interface Props {
  tags: TagWithUsage[]
}

interface Emits {
  (e: 'edit', tag: TagWithUsage): void
  (e: 'delete', tag: TagWithUsage): void
}

defineProps<Props>()
defineEmits<Emits>()
</script>
