<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700">
    <div class="p-6">
      <div v-if="loading" class="space-y-4">
        <div v-for="i in 5" :key="i" class="animate-pulse flex items-center gap-4">
          <div class="w-10 h-10 bg-gray-200 dark:bg-gray-700 rounded-full"></div>
          <div class="flex-1 space-y-2">
            <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-3/4"></div>
            <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded w-1/2"></div>
          </div>
          <div class="h-3 w-16 bg-gray-200 dark:bg-gray-700 rounded"></div>
        </div>
      </div>

      <div v-else-if="activities.length === 0" class="text-center py-8">
        <div class="i-ph-clock text-4xl text-gray-400 mb-4"></div>
        <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
          No Recent Activity
        </h3>
        <p class="text-gray-500 dark:text-gray-400">
          Activity will appear here as content is created and updated.
        </p>
      </div>

      <div v-else class="space-y-4">
        <div 
          v-for="activity in activities" 
          :key="`${activity.type}-${activity.id}`"
          class="flex items-center gap-4 p-3 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          <!-- Activity Icon -->
          <div class="flex-shrink-0">
            <div 
              :class="[activity.icon, getColorClass(activity.color)]"
              class="w-10 h-10 rounded-full flex items-center justify-center text-white text-lg"
            >
            </div>
          </div>

          <!-- Activity Details -->
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1">
              <h4 class="text-sm font-600 text-gray-800 dark:text-gray-200 truncate">
                {{ activity.title }}
              </h4>
              <span 
                :class="getStatusBadgeClass(activity.status)"
                class="px-2 py-1 text-xs font-500 rounded-full"
              >
                {{ activity.status }}
              </span>
            </div>
            
            <p class="text-xs text-gray-500 dark:text-gray-400">
              {{ getActivityDescription(activity) }}
            </p>
          </div>

          <!-- Timestamp -->
          <div class="flex-shrink-0 text-xs text-gray-400">
            {{ formatRelativeTime(activity.created_at) }}
          </div>
        </div>
      </div>
    </div>

    <!-- View All Link -->
    <div v-if="!loading && activities.length > 0" class="border-t border-gray-200 dark:border-gray-700 p-4">
      <UButton
        btn="ghost-gray"
        size="sm"
        class="w-full justify-center"
        @click="$emit('view-all')"
      >
        View All Activity
        <span class="i-ph-arrow-right ml-2"></span>
      </UButton>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Activity {
  type: 'post' | 'project' | 'user'
  id: number
  title: string
  status: string
  created_at: string
  updated_at: string
  action: string
  icon: string
  color: string
}

interface Props {
  activities: Activity[]
  loading?: boolean
}

interface Emits {
  (e: 'view-all'): void
}

const props = withDefaults(defineProps<Props>(), {
  loading: false
})

const emit = defineEmits<Emits>()

const getColorClass = (color: string) => {
  const colorMap = {
    blue: 'bg-blue-500',
    green: 'bg-green-500',
    purple: 'bg-purple-500',
    orange: 'bg-orange-500',
    red: 'bg-red-500'
  }
  return colorMap[color] || 'bg-gray-500'
}

const getStatusBadgeClass = (status: string) => {
  const statusMap = {
    // Post statuses
    published: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200',
    draft: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200',
    archived: 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200',
    // Project statuses
    active: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200',
    completed: 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200',
    'on-hold': 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200',
    // User roles
    admin: 'bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-200',
    user: 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200',
    moderator: 'bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-200'
  }
  return statusMap[status] || 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200'
}

const getActivityDescription = (activity: Activity) => {
  const typeMap = {
    post: 'Post',
    project: 'Project', 
    user: 'User'
  }
  
  const actionMap = {
    created: 'was created',
    updated: 'was updated',
    registered: 'registered'
  }
  
  return `${typeMap[activity.type]} ${actionMap[activity.action] || activity.action}`
}

const formatRelativeTime = (dateString: string) => {
  const date = new Date(dateString)
  const now = new Date()
  const diffInSeconds = Math.floor((now.getTime() - date.getTime()) / 1000)
  
  if (diffInSeconds < 60) return 'Just now'
  if (diffInSeconds < 3600) return `${Math.floor(diffInSeconds / 60)}m ago`
  if (diffInSeconds < 86400) return `${Math.floor(diffInSeconds / 3600)}h ago`
  if (diffInSeconds < 604800) return `${Math.floor(diffInSeconds / 86400)}d ago`
  
  return date.toLocaleDateString()
}
</script>
