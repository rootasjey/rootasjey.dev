<template>
  <div class="min-h-screen w-full bg-gray-50 dark:bg-gray-900">
    <Header />

    <div class="flex pt-16">
      <!-- Left Sidebar Navigation -->
      <aside class="w-64 h-86% rounded-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 fixed left-2 top-22 z-10">
        <!-- Admin Header -->
        <header class="p-6 border-b border-gray-200 dark:border-gray-700">
          <div>
            <h1 class="text-xl font-700 font-body text-gray-800 dark:text-gray-200 mb-1">
              Admin Dashboard
            </h1>
            <p class="text-sm text-gray-600 dark:text-gray-400">
              Manage your content
            </p>
          </div>
        </header>

        <!-- Sidebar Navigation -->
        <nav class="p-4">
          <ul class="space-y-2">
            <li v-for="tab in adminTabs" :key="tab.value">
              <button
                @click="activeTab = tab.value"
                :class="[
                  'w-full px-4 py-3 rounded-lg text-sm font-medium transition-colors flex items-center gap-3 text-left',
                  activeTab === tab.value
                    ? 'bg-gray-100 dark:bg-gray-700 text-gray-900 dark:text-gray-100'
                    : 'text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700'
                ]"
              >
                <span :class="tab.icon" class="text-lg"></span>
                {{ tab.label }}
              </button>
            </li>
          </ul>
        </nav>

        <!-- Back to Site Button -->
        <div class="absolute bottom-6 left-4 right-4">
          <UButton
            to="/"
            btn="ghost-gray"
            size="sm"
            class="w-full hover:scale-102 active:scale-99 transition"
          >
            <span class="i-ph-house-simple mr-2"></span>
            Back to Site
          </UButton>
        </div>
      </aside>

      <!-- Main Content Area -->
      <main class="flex-1 ml-64">
        <div class="p-6">
          <!-- Tab Content -->
          <div class="bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 min-h-[600px]">
            <!-- Debug info -->
            <div class="p-4 border-b border-gray-200 dark:border-gray-700 text-sm text-gray-500">
              Active tab: {{ activeTab }} | Route: {{ route.path }} | Query: {{ JSON.stringify(route.query) }}
            </div>

            <AdminDashboardSection v-if="activeTab === 'dashboard'" />
            <AdminPostsSection v-else-if="activeTab === 'posts'" />
            <AdminProjectsSection v-else-if="activeTab === 'projects'" />
            <AdminTagsSection v-else-if="activeTab === 'tags'" />
            <AdminUsersSection v-else-if="activeTab === 'users'" />

            <!-- Fallback content -->
            <div v-if="!['dashboard', 'posts', 'projects', 'tags', 'users'].includes(activeTab)" class="p-6">
              <h3 class="text-lg font-600 text-gray-800 dark:text-gray-200 mb-2">Unknown Tab</h3>
              <p class="text-gray-600 dark:text-gray-400">Tab "{{ activeTab }}" not found.</p>
            </div>
          </div>

          <!-- Slot for any additional admin content (hidden for main admin page) -->
          <div v-if="!isTabRoute" class="mt-6 bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 min-h-[600px]">
            <slot />
          </div>
        </div>
      </main>
    </div>

    <UToaster />
  </div>
</template>

<script setup lang="ts">
const route = useRoute()

// Admin navigation tabs
const adminTabs = [
  {
    label: 'Dashboard',
    value: 'dashboard',
    icon: 'i-ph-squares-four'
  },
  {
    label: 'Posts',
    value: 'posts',
    icon: 'i-ph-article'
  },
  {
    label: 'Projects',
    value: 'projects',
    icon: 'i-ph-folder'
  },
  {
    label: 'Tags',
    value: 'tags',
    icon: 'i-ph-tag'
  },
  {
    label: 'Users',
    value: 'users',
    icon: 'i-ph-users'
  }
]

// Active tab management using query parameters
const activeTab = computed({
  get: () => {
    const tab = route.query.tab as string
    return ['dashboard', 'posts', 'projects', 'tags', 'users'].includes(tab) ? tab : 'dashboard'
  },
  set: (value: string) => {
    navigateTo({
      path: '/admin',
      query: { tab: value }
    })
  }
})

// Check if current route should show tabs (only admin routes)
const isTabRoute = computed(() => {
  return route.path === '/admin'
})
</script>


