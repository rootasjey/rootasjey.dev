<template>
  <div class="p-6">
    <!-- Test Content -->
    <div class="mb-8">
      <h2 class="text-2xl font-600 font-body text-gray-800 dark:text-gray-200 mb-4">
        🎉 Admin Dashboard Working!
      </h2>
      <p class="text-gray-600 dark:text-gray-400">
        The admin layout is now properly loading. User: {{ user?.name || 'Not loaded' }}
      </p>
    </div>

    <!-- Welcome Section -->
    <div class="mb-8">
      <h2 class="text-2xl font-600 font-body text-gray-800 dark:text-gray-200 mb-4">
        Welcome back, {{ user?.name }}
      </h2>
      <p class="text-gray-600 dark:text-gray-400">
        Here's an overview of your application's content and activity.
      </p>
    </div>

    <!-- Stats Overview -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      <AdminStatCard
        title="Total Posts"
        :value="stats.posts.total"
        :loading="statsLoading"
        icon="i-ph-article"
        color="blue"
        :subtitle="`${stats.posts.published} published, ${stats.posts.drafts} drafts`"
      />
      
      <AdminStatCard
        title="Total Projects"
        :value="stats.projects.total"
        :loading="statsLoading"
        icon="i-ph-folder"
        color="green"
        :subtitle="`${stats.projects.active} active, ${stats.projects.archived} archived`"
      />
      
      <AdminStatCard
        title="Total Tags"
        :value="stats.tags.total"
        :loading="statsLoading"
        icon="i-ph-tag"
        color="purple"
        :subtitle="`${stats.tags.used} used, ${stats.tags.unused} unused`"
      />
      
      <AdminStatCard
        title="Total Users"
        :value="stats.users.total"
        :loading="statsLoading"
        icon="i-ph-users"
        color="orange"
        :subtitle="`${stats.users.admins} admins, ${stats.users.regular} users`"
      />
    </div>

    <!-- Quick Actions -->
    <div class="mb-8">
      <h3 class="text-lg font-600 text-gray-800 dark:text-gray-200 mb-4">
        Quick Actions
      </h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <UButton
          @click="navigateTo('/admin?tab=posts')"
          btn="soft-blue"
          size="lg"
          class="h-auto p-4 flex flex-col items-center gap-2 hover:scale-102 active:scale-99 transition"
        >
          <span class="i-ph-plus text-xl"></span>
          <span class="text-sm">Manage Posts</span>
        </UButton>
        
        <UButton
          @click="navigateTo('/admin?tab=projects')"
          btn="soft-green"
          size="lg"
          class="h-auto p-4 flex flex-col items-center gap-2 hover:scale-102 active:scale-99 transition"
        >
          <span class="i-ph-folder-plus text-xl"></span>
          <span class="text-sm">Manage Projects</span>
        </UButton>
        
        <UButton
          @click="navigateTo('/admin?tab=tags')"
          btn="soft-purple"
          size="lg"
          class="h-auto p-4 flex flex-col items-center gap-2 hover:scale-102 active:scale-99 transition"
        >
          <span class="i-ph-tag text-xl"></span>
          <span class="text-sm">Manage Tags</span>
        </UButton>
        
        <UButton
          @click="navigateTo('/admin?tab=users')"
          btn="soft-orange"
          size="lg"
          class="h-auto p-4 flex flex-col items-center gap-2 hover:scale-102 active:scale-99 transition"
        >
          <span class="i-ph-user-gear text-xl"></span>
          <span class="text-sm">Manage Users</span>
        </UButton>
      </div>
    </div>

    <!-- Recent Activity -->
    <div>
      <h3 class="text-lg font-600 text-gray-800 dark:text-gray-200 mb-4">
        Recent Activity
      </h3>
      
      <AdminRecentActivity 
        :activities="recentActivity"
        :loading="activityLoading"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
const { user } = useUserSession()

// Stats data
const stats = ref({
  posts: { total: 0, published: 0, drafts: 0, archived: 0 },
  projects: { total: 0, active: 0, archived: 0 },
  tags: { total: 0, used: 0, unused: 0 },
  users: { total: 0, admins: 0, regular: 0, moderators: 0 }
})

const statsLoading = ref(true)
const recentActivity = ref<any[]>([])
const activityLoading = ref(true)

// Fetch dashboard stats
const fetchStats = async () => {
  try {
    statsLoading.value = true
    const response = await $fetch('/api/admin/stats')
    stats.value = response
  } catch (error) {
    console.error('Error fetching admin stats:', error)
  } finally {
    statsLoading.value = false
  }
}

// Fetch recent activity
const fetchRecentActivity = async () => {
  try {
    activityLoading.value = true
    const response = await $fetch('/api/admin/activity')
    recentActivity.value = response
  } catch (error) {
    console.error('Error fetching recent activity:', error)
  } finally {
    activityLoading.value = false
  }
}

// Initialize data
onMounted(async () => {
  await Promise.all([
    fetchStats(),
    fetchRecentActivity()
  ])
})
</script>
