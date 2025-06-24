<template>
  <div v-if="hasVisibleItems" class="relative">
    <UDropdownMenu 
      :items="formattedMenuItems"
      :size="size"
      menu-label=""
      :_dropdown-menu-content="dropdownContentProps"
      :_dropdown-menu-trigger="dropdownTriggerProps"
      @select="handleMenuSelect"
    >
      <!-- Custom trigger slot if needed -->
      <template v-if="$slots.trigger" #trigger>
        <slot name="trigger" :post="post" :is-loading="isLoading" />
      </template>
    </UDropdownMenu>

    <!-- Loading overlay -->
    <div 
      v-if="isLoading" 
      class="absolute inset-0 bg-white/50 dark:bg-gray-900/50 rounded-md flex items-center justify-center"
    >
      <span class="i-lucide-loader-2 animate-spin text-sm text-gray-500" />
    </div>
  </div>
</template>

<script setup lang="ts">
import type { PostType } from '~/types/post'

interface MenuItem {
  label: string
  icon?: string
  shortcut?: string
  onClick?: () => void | Promise<void>
  disabled?: boolean
  destructive?: boolean
  separator?: boolean
  visible?: boolean
  loading?: boolean
}

interface PostMenuProps {
  post: PostType
  size?: 'xs' | 'sm' | 'md' | 'lg'
  align?: 'start' | 'center' | 'end'
  side?: 'top' | 'right' | 'bottom' | 'left'
  customItems?: MenuItem[]
  showDefaultItems?: boolean
  variant?: 'default' | 'minimal' | 'compact'
  disabled?: boolean
}

interface PostMenuEmits {
  (e: 'edit', post: PostType): void
  (e: 'delete', post: PostType): void
  (e: 'publish', post: PostType): void
  (e: 'unpublish', post: PostType): void
  (e: 'duplicate', post: PostType): void
  (e: 'archive', post: PostType): void
  (e: 'share', post: PostType): void
  (e: 'export', post: PostType): void
  (e: 'view-stats', post: PostType): void
  (e: 'menu-action', action: string, post: PostType): void
}

const props = withDefaults(defineProps<PostMenuProps>(), {
  size: 'xs',
  align: 'end',
  side: 'bottom',
  customItems: () => [],
  showDefaultItems: true,
  variant: 'default',
  disabled: false
})

const emit = defineEmits<PostMenuEmits>()

// State
const isLoading = ref(false)
const loadingAction = ref<string | null>(null)

// Computed properties
const isDraft = computed(() => props.post.status === 'draft')
const isPublished = computed(() => props.post.status === 'published')
const isArchived = computed(() => props.post.status === 'archived')

// Default menu items based on post state and user permissions
const defaultMenuItems = computed((): MenuItem[] => {
  const items: MenuItem[] = []

  // View/Edit actions
  items.push({
    label: 'Edit',
    icon: 'i-lucide-edit-3',
    shortcut: 'E',
    onClick: () => handleEdit(),
    visible: true,
  })

  // Publishing actions
  if (isDraft.value) {
    items.push({
      label: 'Publish',
      icon: 'i-lucide-send',
      shortcut: 'P',
      onClick: () => handlePublish(),
      visible: true,
    })
  } else if (isPublished.value) {
    items.push({
      label: 'Unpublish',
      icon: 'i-lucide-eye-off',
      onClick: () => handleUnpublish(),
      visible: true,
    })
  }

  // Separator
  items.push({ separator: true, visible: true, label: '' })

  // Content actions
  items.push({
    label: 'Duplicate',
    icon: 'i-lucide-copy',
    shortcut: 'D',
    onClick: () => handleDuplicate(),
    visible: true,
  })

  if (isPublished.value) {
    items.push({
      label: 'Share',
      icon: 'i-lucide-share-2',
      onClick: () => handleShare(),
      visible: true,
    })

    items.push({
      label: 'View Stats',
      icon: 'i-lucide-bar-chart-3',
      onClick: () => handleViewStats(),
      visible: true,
    })
  }

  // Separator
  items.push({ separator: true, visible: true, label: '' })

  // Export actions
  items.push({
    label: 'Export',
    icon: 'i-lucide-download',
    onClick: () => handleExport(),
    visible: true,
  })

  // Archive (for published posts)
  if (isPublished.value) {
    items.push({
      label: 'Archive',
      icon: 'i-lucide-archive',
      onClick: () => handleArchive(),
      visible: true,
    })
  }

  // Separator before destructive actions
  items.push({ separator: true, visible: true, label: '' })

  // Destructive actions
  items.push({
    label: 'Delete',
    icon: 'i-lucide-trash-2',
    shortcut: '⌫',
    onClick: () => handleDelete(),
    destructive: true,
    visible: true,
  })

  return items
})

// Combine default and custom items
const allMenuItems = computed((): MenuItem[] => {
  const items: MenuItem[] = []
  
  if (props.showDefaultItems) {
    items.push(...defaultMenuItems.value)
  }
  
  if (props.customItems.length > 0) {
    if (items.length > 0) {
      items.push({ separator: true, visible: true, label: '' })
    }
    items.push(...props.customItems)
  }
  
  return items
})

// Filter visible items and format for UDropdownMenu
const formattedMenuItems = computed(() => {
  return allMenuItems.value
    .filter(item => item.visible !== false)
    .map(item => {
      if (item.separator) {
        return {}
      }

      return {
        label: item.label,
        // icon: item.icon,
        shortcut: item.shortcut,
        disabled: item.disabled || props.disabled || (loadingAction.value === item.label),
        destructive: item.destructive,
        loading: loadingAction.value === item.label,
        onClick: item.onClick,
        class: [
          item.destructive ? 'text-red-600 dark:text-red-400' : '',
          item.disabled ? 'opacity-50 cursor-not-allowed' : '',
          loadingAction.value === item.label ? 'opacity-75' : ''
        ].filter(Boolean).join(' ')
      }
    })
})

const hasVisibleItems = computed(() => {
  return formattedMenuItems.value.some(item => typeof item.label !== "undefined")
})

// Dropdown styling based on variant
const dropdownContentProps = computed(() => {
  const baseProps = {
    align: props.align,
    side: props.side,
  }

  switch (props.variant) {
    case 'minimal':
      return {
        ...baseProps,
        class: 'w-40 py-1'
      }
    case 'compact':
      return {
        ...baseProps,
        class: 'w-44 py-1'
      }
    default:
      return {
        ...baseProps,
        class: 'w-52 py-2'
      }
  }
})

const dropdownTriggerProps = computed(() => {
  const baseProps = {
    icon: true,
    square: true,
    'aria-label': `Post actions for ${props.post.name}`,
    disabled: props.disabled
  }

  switch (props.variant) {
    case 'minimal':
      return {
        ...baseProps,
        class: 'p-1 w-6 h-6 shadow-none ring-0 hover:bg-gray-100 dark:hover:bg-gray-800 hover:scale-105 active:scale-95 transition-all',
        label: 'i-lucide-more-horizontal'
      }
    case 'compact':
      return {
        ...baseProps,
        class: 'p-1 w-7 h-7 hover:bg-gray-100 dark:hover:bg-gray-800 hover:scale-105 active:scale-95 transition-all',
        label: 'i-lucide-more-vertical'
      }
    default:
      return {
        ...baseProps,
        class: 'p-1 w-8 h-8 hover:bg-transparent hover:scale-110 active:scale-99 transition-all',
        label: 'i-lucide-ellipsis-vertical'
      }
  }
})

// Action handlers with loading states
const executeWithLoading = async (action: string, handler: () => void | Promise<void>) => {
  if (isLoading.value) return

  isLoading.value = true
  loadingAction.value = action

  try {
    await handler()
  } catch (error) {
    console.error(`Failed to execute ${action}:`, error)
    // Emit error event if needed
    emit('menu-action', `${action}-error`, props.post)
  } finally {
    isLoading.value = false
    loadingAction.value = null
  }
}

const handleEdit = () => {
  executeWithLoading('edit', () => {
    emit('edit', props.post)
  })
}

const handleDelete = () => {
  executeWithLoading('delete', () => {
    emit('delete', props.post)
  })
}

const handlePublish = () => {
  executeWithLoading('publish', () => {
    emit('publish', props.post)
  })
}

const handleUnpublish = () => {
  executeWithLoading('unpublish', () => {
    emit('unpublish', props.post)
  })
}

const handleDuplicate = () => {
  executeWithLoading('duplicate', () => {
    emit('duplicate', props.post)
  })
}

const handleArchive = () => {
  executeWithLoading('archive', () => {
    emit('archive', props.post)
  })
}

const handleShare = () => {
  executeWithLoading('share', () => {
    emit('share', props.post)
  })
}

const handleExport = () => {
  executeWithLoading('export', () => {
    emit('export', props.post)
  })
}

const handleViewStats = () => {
  executeWithLoading('view-stats', () => {
    emit('view-stats', props.post)
  })
}

const handleMenuSelect = (item: any) => {
  if (item.onClick) {
    item.onClick()
  }
}

// Keyboard shortcuts
const handleKeydown = (event: KeyboardEvent) => {
  if (!hasVisibleItems.value || isLoading.value) return

  const shortcutItem = allMenuItems.value.find(item => 
    item.shortcut && 
    event.key.toLowerCase() === item.shortcut.toLowerCase() &&
    item.visible !== false &&
    !item.disabled
  )

  if (shortcutItem && shortcutItem.onClick) {
    event.preventDefault()
    shortcutItem.onClick()
  }
}

// Expose methods for parent component
defineExpose({
  isLoading: readonly(isLoading),
  hasVisibleItems,
  executeAction: executeWithLoading
})

// onMounted(() => {
//   document.addEventListener('keydown', handleKeydown)
// })

// onUnmounted(() => {
//   document.removeEventListener('keydown', handleKeydown)
// })
</script>