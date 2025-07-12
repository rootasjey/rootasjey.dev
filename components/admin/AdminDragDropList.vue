<template>
  <div class="space-y-2">
    <div
      v-for="(item, index) in localItems"
      :key="getItemKey(item)"
      :class="[
        'relative bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg transition-all duration-200',
        {
          'shadow-lg scale-105 z-10': draggedIndex === index,
          'opacity-50': draggedIndex !== null && draggedIndex !== index,
          'border-blue-300 dark:border-blue-600': dropTargetIndex === index
        }
      ]"
      :draggable="!disabled"
      @dragstart="handleDragStart(index, $event)"
      @dragend="handleDragEnd"
      @dragover="handleDragOver(index, $event)"
      @dragleave="handleDragLeave"
      @drop="handleDrop(index, $event)"
    >
      <!-- Drag Handle -->
      <div
        v-if="!disabled"
        class="absolute left-2 top-1/2 -translate-y-1/2 cursor-grab active:cursor-grabbing text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 transition-colors"
        @mousedown="handleMouseDown"
      >
        <div class="i-ph-dots-six-vertical text-lg"></div>
      </div>

      <!-- Item Content -->
      <div :class="{ 'ml-8': !disabled, 'ml-4': disabled }" class="p-4">
        <slot :item="item" :index="index" :is-dragging="draggedIndex === index">
          <!-- Default content if no slot provided -->
          <div class="flex items-center justify-between">
            <div>
              <h4 class="font-600 text-gray-800 dark:text-gray-200">
                {{ getItemTitle(item) }}
              </h4>
              <p v-if="getItemDescription(item)" class="text-sm text-gray-500 dark:text-gray-400">
                {{ getItemDescription(item) }}
              </p>
            </div>
            
            <div class="flex items-center gap-2">
              <slot name="actions" :item="item" :index="index" />
            </div>
          </div>
        </slot>
      </div>

      <!-- Drop Indicator -->
      <div
        v-if="dropTargetIndex === index && draggedIndex !== null && draggedIndex !== index"
        class="absolute inset-0 border-2 border-dashed border-blue-400 dark:border-blue-500 rounded-lg pointer-events-none"
      >
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-blue-100 dark:bg-blue-900 text-blue-600 dark:text-blue-300 px-3 py-1 rounded-full text-sm font-600">
          Drop here
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-if="localItems.length === 0" class="text-center py-8">
      <div class="i-ph-list text-4xl text-gray-400 mb-4"></div>
      <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
        No items to display
      </h3>
      <p class="text-gray-500 dark:text-gray-400">
        Items will appear here when added.
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  items: any[]
  disabled?: boolean
  itemKey?: string
  itemTitle?: string
  itemDescription?: string
}

interface Emits {
  (e: 'update:items', items: any[]): void
  (e: 'reorder', { from, to }: { from: number; to: number }): void
  (e: 'drag-start', { item, index }: { item: any; index: number }): void
  (e: 'drag-end', { item, index }: { item: any; index: number }): void
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  itemKey: 'id',
  itemTitle: 'name',
  itemDescription: 'description'
})

const emit = defineEmits<Emits>()

// Local state
const localItems = ref([...props.items])
const draggedIndex = ref<number | null>(null)
const dropTargetIndex = ref<number | null>(null)

// Watch for external changes to items
watch(() => props.items, (newItems) => {
  localItems.value = [...newItems]
}, { deep: true })

// Helper functions
const getItemKey = (item: any) => {
  return item[props.itemKey] || item.id || Math.random()
}

const getItemTitle = (item: any) => {
  return item[props.itemTitle] || item.name || item.title || 'Untitled'
}

const getItemDescription = (item: any) => {
  return item[props.itemDescription] || item.description || ''
}

// Drag and drop handlers
const handleMouseDown = (event: MouseEvent) => {
  // Prevent text selection during drag
  event.preventDefault()
}

const handleDragStart = (index: number, event: DragEvent) => {
  if (props.disabled) return
  
  draggedIndex.value = index
  
  if (event.dataTransfer) {
    event.dataTransfer.effectAllowed = 'move'
    event.dataTransfer.setData('text/plain', index.toString())
  }
  
  emit('drag-start', { item: localItems.value[index], index })
}

const handleDragEnd = () => {
  if (draggedIndex.value !== null) {
    emit('drag-end', { 
      item: localItems.value[draggedIndex.value], 
      index: draggedIndex.value 
    })
  }
  
  draggedIndex.value = null
  dropTargetIndex.value = null
}

const handleDragOver = (index: number, event: DragEvent) => {
  if (props.disabled || draggedIndex.value === null) return
  
  event.preventDefault()
  
  if (event.dataTransfer) {
    event.dataTransfer.dropEffect = 'move'
  }
  
  dropTargetIndex.value = index
}

const handleDragLeave = () => {
  dropTargetIndex.value = null
}

const handleDrop = (targetIndex: number, event: DragEvent) => {
  if (props.disabled || draggedIndex.value === null) return
  
  event.preventDefault()
  
  const sourceIndex = draggedIndex.value
  
  if (sourceIndex !== targetIndex) {
    // Reorder items
    const newItems = [...localItems.value]
    const [draggedItem] = newItems.splice(sourceIndex, 1)
    newItems.splice(targetIndex, 0, draggedItem)
    
    localItems.value = newItems
    
    // Emit events
    emit('update:items', newItems)
    emit('reorder', { from: sourceIndex, to: targetIndex })
  }
  
  draggedIndex.value = null
  dropTargetIndex.value = null
}
</script>

<style scoped>
/* Custom drag cursor styles */
[draggable="true"] {
  cursor: grab;
}

[draggable="true"]:active {
  cursor: grabbing;
}

/* Smooth transitions for drag states */
.transition-all {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 200ms;
}
</style>
