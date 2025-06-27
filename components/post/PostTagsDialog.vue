<template>
  <UDialog v-model:open="showLocal" title="Manage Post Tags" description="Edit tags for this post">
    <div class="space-y-4">
      <!-- Tag Input Component -->
      <TagInput
        v-model="postTagsLocal"
        placeholder="Add tags..."
      />
      <!-- Quick Tag Suggestions -->
      <div v-if="suggestedTags && suggestedTags.length > 0">
        <h4 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Suggested Tags</h4>
        <div class="flex flex-wrap gap-2">
          <UButton
            v-for="tag in suggestedTags"
            :key="tag"
            btn="outline"
            size="xs"
            @click="onAddSuggestedTag(tag)"
            :disabled="postTagsLocal.includes(tag)"
          >
            {{ tag }}
          </UButton>
        </div>
      </div>
    </div>
    <template #footer>
      <div class="flex gap-2 justify-end">
        <UButton 
          @click="onCancel" 
          btn="outline" 
          label="Cancel"
        />
        <UButton 
          @click="onSave" 
          btn="solid"
          label="Save Tags" 
        />
      </div>
    </template>
  </UDialog>
</template>

<script lang="ts" setup>
import { ref, watch, toRefs } from 'vue'

const props = defineProps({
  show: Boolean,
  postTags: { type: Array as PropType<string[]>, default: () => [] },
  suggestedTags: { type: Array as PropType<string[]>, default: () => [] },
})
const emit = defineEmits(['update:show', 'save', 'cancel', 'addSuggestedTag'])

const { show, postTags } = toRefs(props)
const showLocal = ref(show.value)
const postTagsLocal = ref([...postTags.value])

watch(show, (val) => {
  showLocal.value = val
})
watch(showLocal, (val) => {
  emit('update:show', val)
})
watch(postTags, (val) => {
  postTagsLocal.value = [...val]
})

function onSave() {
  emit('save', postTagsLocal.value)
  showLocal.value = false
}
function onCancel() {
  emit('cancel')
  showLocal.value = false
}
function onAddSuggestedTag(tag: string) {
  emit('addSuggestedTag', tag)
}
</script>
