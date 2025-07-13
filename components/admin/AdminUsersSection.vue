<template>
  <div class="p-6">
    <div class="flex items-center justify-between mb-6">
      <div>
        <h2 class="text-2xl font-600 font-body text-gray-800 dark:text-gray-200 mb-2">
          Users Management
        </h2>
        <p class="text-gray-600 dark:text-gray-400">
          Manage user accounts and permissions
        </p>
      </div>
      
      <div class="flex items-center gap-3">
        <!-- Search -->
        <UInput
          v-model="searchQuery"
          placeholder="Search users..."
          leading="i-ph-magnifying-glass"
          class="w-64"
        />
        
        <!-- Role Filter -->
        <USelect
          v-model="roleFilter"
          :items="roleOptions"
          placeholder="All Roles"
          class="w-32"
        />
      </div>
    </div>

    <!-- User Statistics -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
      <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
        <div class="flex items-center justify-between">
          <div class="i-ph-users text-blue-500 text-xl"></div>
          <div class="text-2xl font-700 text-gray-800 dark:text-gray-200">
            {{ stats.total }}
          </div>
        </div>
        <div class="text-sm text-gray-600 dark:text-gray-400 mt-2">
          Total Users
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
        <div class="flex items-center justify-between">
          <div class="i-ph-crown text-purple-500 text-xl"></div>
          <div class="text-2xl font-700 text-gray-800 dark:text-gray-200">
            {{ stats.admins }}
          </div>
        </div>
        <div class="text-sm text-gray-600 dark:text-gray-400 mt-2">
          Admins
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
        <div class="flex items-center justify-between">
          <div class="i-ph-shield text-orange-500 text-xl"></div>
          <div class="text-2xl font-700 text-gray-800 dark:text-gray-200">
            {{ stats.moderators }}
          </div>
        </div>
        <div class="text-sm text-gray-600 dark:text-gray-400 mt-2">
          Moderators
        </div>
      </div>
      
      <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-4">
        <div class="flex items-center justify-between">
          <div class="i-ph-user text-green-500 text-xl"></div>
          <div class="text-2xl font-700 text-gray-800 dark:text-gray-200">
            {{ stats.regular }}
          </div>
        </div>
        <div class="text-sm text-gray-600 dark:text-gray-400 mt-2">
          Regular Users
        </div>
      </div>
    </div>

    <!-- Users Table -->
    <div class="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden">
      <div class="p-4 border-b border-gray-200 dark:border-gray-700">
        <h3 class="font-600 text-gray-800 dark:text-gray-200">
          All Users
        </h3>
      </div>
      
      <div v-if="loading" class="p-4">
        <div class="space-y-4">
          <div v-for="i in 5" :key="i" class="animate-pulse flex items-center gap-4">
            <div class="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-full"></div>
            <div class="flex-1 space-y-2">
              <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/4"></div>
              <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded w-1/3"></div>
            </div>
            <div class="h-6 w-16 bg-gray-200 dark:bg-gray-700 rounded"></div>
          </div>
        </div>
      </div>
      
      <div v-else-if="filteredUsers.length === 0" class="p-8 text-center">
        <div class="i-ph-users text-4xl text-gray-400 mb-4"></div>
        <h3 class="text-lg font-600 text-gray-700 dark:text-gray-300 mb-2">
          No Users Found
        </h3>
        <p class="text-gray-500 dark:text-gray-400">
          {{ searchQuery ? 'Try adjusting your search terms.' : 'No users match the selected filters.' }}
        </p>
      </div>
      
      <div v-else class="divide-y divide-gray-200 dark:divide-gray-700">
        <div 
          v-for="user in filteredUsers" 
          :key="user.id"
          class="p-4 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors"
        >
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-4">
              <!-- User Avatar -->
              <div class="w-12 h-12 bg-gray-200 dark:bg-gray-700 rounded-full flex items-center justify-center">
                <span class="text-lg font-600 text-gray-600 dark:text-gray-300">
                  {{ user.name.charAt(0).toUpperCase() }}
                </span>
              </div>
              
              <!-- User Info -->
              <div>
                <div class="flex items-center gap-2">
                  <h4 class="font-600 text-gray-800 dark:text-gray-200">
                    {{ user.name }}
                  </h4>
                  <span 
                    :class="getRoleBadgeClass(user.role)"
                    class="px-2 py-1 text-xs font-500 rounded-full"
                  >
                    {{ user.role }}
                  </span>
                </div>
                <p class="text-sm text-gray-500 dark:text-gray-400">
                  {{ user.email }}
                </p>
                <p class="text-xs text-gray-400">
                  Joined {{ formatDate(user.created_at) }}
                </p>
              </div>
            </div>
            
            <!-- Actions -->
            <div class="flex items-center gap-2">
              <UDropdownMenu :items="getUserMenuItems(user)">
                <UButton
                  icon
                  btn="ghost-gray"
                  size="xs"
                  class="i-ph-dots-three-vertical"
                />
              </UDropdownMenu>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Role Change Dialog -->
    <UDialog v-model:open="showRoleDialog" title="Change User Role" :description="`Change role for ${selectedUser?.name}`">
      <div class="space-y-4">
        <div>
          <ULabel for="new-role">New Role</ULabel>
          <USelect
            id="new-role"
            v-model="newRole"
            :items="roleOptions.filter(r => r.value !== 'all')"
            placeholder="Select role"
          />
        </div>
        
        <div class="p-4 bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-lg">
          <div class="flex items-start gap-3">
            <div class="i-ph-warning text-yellow-500 text-lg flex-shrink-0 mt-0.5"></div>
            <div>
              <h4 class="font-600 text-yellow-800 dark:text-yellow-200 mb-1">
                Role Change Warning
              </h4>
              <p class="text-sm text-yellow-700 dark:text-yellow-300">
                Changing a user's role will affect their permissions and access to admin features.
              </p>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <div class="flex gap-2 justify-end">
          <UButton 
            @click="showRoleDialog = false" 
            btn="ghost-gray" 
            label="Cancel"
          />
          <UButton 
            @click="handleChangeRole" 
            btn="soft-orange"
            :loading="isChangingRole"
            :disabled="!newRole || isChangingRole"
            label="Change Role"
          />
        </div>
      </template>
    </UDialog>
  </div>
</template>

<script setup lang="ts">
import type { User } from '#auth-utils'
import type { UserRoleStats } from '~/types/user'

// Data
const searchQuery = ref('')
const roleFilter = ref('all')
const users = ref<User[]>([])
const loading = ref(true)
const showRoleDialog = ref(false)
const isChangingRole = ref(false)
const selectedUser = ref<User | null>(null)
const newRole = ref('')

const stats: Ref<UserRoleStats> = ref({
  total: 0,
  admins: 0,
  moderators: 0,
  regular: 0
})

const roleOptions = [
  { label: 'All Roles', value: 'all' },
  { label: 'Admin', value: 'admin' },
  { label: 'Moderator', value: 'moderator' },
  { label: 'User', value: 'user' }
]

// Computed
const filteredUsers = computed(() => {
  let filtered = users.value
  
  // Filter by search query
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(user => 
      user.name.toLowerCase().includes(query) ||
      user.email.toLowerCase().includes(query)
    )
  }
  
  // Filter by role
  if (roleFilter.value !== 'all') {
    filtered = filtered.filter(user => user.role === roleFilter.value)
  }
  
  return filtered
})

// Methods
const getRoleBadgeClass = (role: string) => {
  const roleMap: { [key: string]: string } = {
    admin: 'bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-200',
    moderator: 'bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-200',
    user: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200'
  }
  return roleMap[role] || 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200'
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString()
}

const getUserMenuItems = (user: User) => [
  {
    label: 'View Profile',
    onClick: () => handleViewUser(user)
  },
  {
    label: 'Change Role',
    onClick: () => handleChangeUserRole(user)
  },
  {},
  {
    label: 'Delete User',
    onClick: () => handleDeleteUser(user)
  }
]

// Handlers
const handleViewUser = (user: User) => {
  console.log('View user:', user)
}

const handleChangeUserRole = (user: User) => {
  selectedUser.value = user
  newRole.value = user.role
  showRoleDialog.value = true
}

const handleChangeRole = async () => {
  if (!selectedUser.value || !newRole.value) return
  
  try {
    isChangingRole.value = true
    await $fetch(`/api/admin/users/${selectedUser.value.id}/role`, {
      method: 'PUT',
      body: { role: newRole.value }
    })
    
    showRoleDialog.value = false
    selectedUser.value = null
    newRole.value = ''
    await fetchUsers()
  } catch (error) {
    console.error('Error changing user role:', error)
  } finally {
    isChangingRole.value = false
  }
}

const handleDeleteUser = (user: User) => {
  console.log('Delete user:', user)
}

// Data fetching
const fetchUsers = async () => {
  try {
    loading.value = true
    const response = await $fetch('/api/admin/users')
    users.value = (response.users as unknown as User[]) || []
    stats.value = (response.stats as UserRoleStats) || { total: 0, admins: 0, moderators: 0, regular: 0 }
  } catch (error) {
    console.error('Error fetching users:', error)
  } finally {
    loading.value = false
  }
}

// Initialize
onMounted(() => {
  fetchUsers()
})
</script>
