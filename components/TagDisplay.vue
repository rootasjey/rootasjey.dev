<template>
  <div class="tag-display">
    <!-- Primary Tag Only (for narrow views) -->
    <div v-if="displayMode === 'primary-only' && primaryTag" class="primary-tag-only">
      <UBadge 
        :label="primaryTag.name" 
        :color="primaryTagColor"
        variant="subtle"
        size="sm"
      />
    </div>

    <!-- All Tags (for full views) -->
    <div v-else-if="displayMode === 'all' && tags.length > 0" class="all-tags">
      <div class="tags-container">
        <!-- Primary tag with special styling -->
        <UBadge 
          v-if="primaryTag"
          :label="primaryTag.name" 
          :color="primaryTagColor"
          closable
          size="sm"
          variant="solid"
          icon="i-ph-star-four-duotone"
          @click.self="$emit('tag:click', primaryTag)"
          @close="$emit('tag:remove', primaryTag)"
          class="primary-tag"
        />
        
        <!-- Secondary tags -->
        <UBadge 
          v-for="tag in secondaryTags"
          :key="tag.name"
          :label="tag.name" 
          :color="secondaryTagColor"
          closable
          variant="outline"
          size="sm"
          @click.self="$emit('tag:click', tag)"
          @close="$emit('tag:remove', tag)"
          class="secondary-tag"
        />
      </div>
      
      <!-- Show count if there are many tags -->
      <span v-if="showCount && secondaryTags.length > maxVisibleTags" class="tag-count">
        +{{ secondaryTags.length - maxVisibleTags }} more
      </span>
    </div>

    <!-- Primary + Count (for medium views) -->
    <div v-else-if="displayMode === 'primary-count' && primaryTag" class="primary-with-count">
      <UBadge 
        :label="primaryTag.name" 
        :color="primaryTagColor"
        variant="subtle"
        size="sm"
      />
      <span v-if="secondaryTags.length > 0" class="tag-count">
        +{{ secondaryTags.length }}
      </span>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { ApiTag } from '~/types/tag'

interface Props {
  tags: ApiTag[]
  displayMode?: 'primary-only' | 'all' | 'primary-count'
  primaryTagColor?: string
  secondaryTagColor?: string
  maxVisibleTags?: number
  showCount?: boolean
}

interface Emits {
  (e: 'tag:remove', tag: ApiTag): void
  (e: 'tag:click', tag: ApiTag): void
}

const props = withDefaults(defineProps<Props>(), {
  displayMode: 'all',
  primaryTagColor: 'blue',
  secondaryTagColor: 'gray',
  maxVisibleTags: 3,
  showCount: true
})

defineEmits<Emits>()

const primaryTag = computed(() => props.tags[0] || null)
const secondaryTags = computed(() => {
  const secondary = props.tags.slice(1)
  return props.maxVisibleTags > 0 ? secondary.slice(0, props.maxVisibleTags) : secondary
})
</script>

<style scoped>
.tag-display {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.tags-container {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.5rem;
}

.primary-tag {
  font-weight: 500;
}

.secondary-tag {
  opacity: 0.8;
}

.primary-tag, .secondary-tag {
  cursor: pointer;
transition: all 0.2s ease-in-out;
  outline-color: red;
  border-color: red;
  outline: 1px solid #322C44;
  
  &:hover {
    opacity: 1;
  transform: scale(1.02);
    outline: 1px solid rgb(59, 130, 246);
  }
  &:active {
    transform: scale(0.99);
  }
}

.tag-count {
  font-size: 0.75rem;
  color: rgb(107, 114, 128);
  margin-left: 0.25rem;
}

.primary-with-count {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}
</style>