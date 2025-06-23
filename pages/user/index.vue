<template>
  <div class="w-full flex flex-col items-center min-h-screen">
    <!-- Hero Section -->
    <section class="w-[820px] mt-24 md:mt-42 mb-12 text-center p-2 md:p-8">
      <div class="flex items-center justify-center gap-3 mb-6">
        <h1 class="font-body text-6xl font-600 text-gray-800 dark:text-gray-200">
          User Profile
        </h1>
      </div>
      <h4 class="text-size-5 font-300 mb-6 text-gray-800 dark:text-gray-200 max-w-2xl mx-auto">
        Manage your personal information, view your stats, and explore your recent activities.
      </h4>
    </section>

    <!-- Loading State -->
    <section v-if="status === 'pending'" class="w-[820px] mb-12">
      <div class="flex flex-col items-center justify-center py-16">
        <span class="i-ph-spinner-gap animate-spin text-4xl text-gray-400 dark:text-gray-600 mb-6"></span>
        <p class="text-size-4 font-300 text-gray-600 dark:text-gray-400">Loading profile...</p>
      </div>
    </section>

    <!-- Not Logged In State -->
    <section v-else-if="!loggedIn" class="w-[820px] mb-12">
      <div class="flex flex-col items-center justify-center py-24">
        <div class="mb-8 opacity-50">
          <span class="i-ph-user-circle text-6xl text-gray-300 dark:text-gray-600"></span>
        </div>
        <h3 class="text-4xl font-600 text-gray-700 dark:text-gray-300 mb-4">
          Not signed in
        </h3>
        <p class="text-size-4 font-300 text-gray-500 dark:text-gray-400 text-center mb-8 max-w-md">
          Please sign in to view and manage your profile.
        </p>
      </div>
    </section>

    <section v-else class="w-[720px] flex flex-col gap-8 my-8">
      <UserInfo 
        v-if="user"
        :user="user" 
        :is-editing="isEditing" 
        :is-saving="isSaving"
        :edit-form="editForm"
        :profile-data="profileData"
        :form-errors="formErrors"
        @start-editing="startEditing" 
        @save-profile="saveProfile" 
        @cancel-editing="cancelEditing"
      />

      <UserStatistics :user-stats="userStats" />
      <UserRecentActivities :recent-activity="recentActivity" />
      <UserAccountSettings @sign-out="handleSignOut" />
    </section>

    <Footer class="w-[720px] mt-24 mb-36" />
  </div>
</template>

<script lang="ts" setup>
import type { User } from '#auth-utils'

const { loggedIn, user, clear } = useUserSession()
const { toast } = useToast()

// Loading status for async fetches
const status = ref<'pending' | 'done'>('pending')

// Profile editing state
const isEditing = ref(false)
const isSaving = ref(false)
const profileData: Ref<User> = ref({
  id: 0,
  created_at: new Date().toISOString(),
  updated_at: new Date().toISOString(),
  name: '',
  email: '',
  biography: '',
  job: '',
  location: '',
  language: '',
  role: '',
  socials: '',
})

const getInitFormData = () => ({
  biography: '',
  email: '',
  job: '',
  location: '',
  language: '',
  name: '',
})

// Form data and validation
const editForm = ref(getInitFormData())

const getInitFormErrors = () => ({
  name: '',
  email: '',
  biography: '',
  location: '',
})

const formErrors: Ref<Record<"name" | "email" | "biography" | "location", string>> = ref(getInitFormErrors())

const userStats = ref({
  totalPosts: 0,
  totalProjects: 0,
  totalExperiments: 0,
})

// Recent activity mock data
const recentActivity = ref([
  {
    id: 1,
    icon: 'i-ph-upload',
    color: '#3B82F6',
    description: 'Uploaded 3 new images',
    timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000).toString() // 2 hours ago
  },
  {
    id: 2,
    icon: 'i-ph-folder-plus',
    color: '#10B981',
    description: 'Created new collection "Nature"',
    timestamp: new Date(Date.now() - 24 * 60 * 60 * 1000).toString() // 1 day ago
  },
  {
    id: 3,
    icon: 'i-ph-pencil',
    color: '#F59E0B',
    description: 'Updated image metadata',
    timestamp: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toString() // 3 days ago
  }
])

const fetchUserStats = async () => {
  if (!loggedIn.value) return
  
  try {
    const { data } = await $fetch('/api/user/stats')
    if (data) {
      userStats.value = data
    }
  } catch (error) {
    console.error('Error fetching user stats:', error)
  }
}

const handleSignOut = async () => {
  try {
    await clear()
    toast({
      title: 'Signed Out',
      description: 'You have been successfully signed out.',
      toast: 'soft-success',
      duration: 3000
    })
    await navigateTo('/')
  } catch (error) {
    console.error('Error signing out:', error)
    toast({
      title: 'Error',
      description: 'Failed to sign out. Please try again.',
      toast: 'soft-error',
      duration: 3000
    })
  }
}

const fetchUserProfile = async () => {
  if (!loggedIn.value) return
  
  try {
    const response = await $fetch('/api/user/profile')
    if (response.success) {
      profileData.value = response.data
    }
  } catch (error) {
    console.error('Error fetching user profile:', error)
  }
}

const startEditing = () => {
  if (!profileData.value) return
  
  editForm.value = {
    name: profileData.value.name || '',
    email: profileData.value.email || '',
    biography: profileData.value.biography || '',
    job: profileData.value.job || '',
    location: profileData.value.location || '',
    language: profileData.value.language || ''
  }
  
  formErrors.value = getInitFormErrors()
  isEditing.value = true
}

const cancelEditing = () => {
  isEditing.value = false
  formErrors.value = getInitFormErrors()
}

const saveProfile = async () => {
  if (isSaving.value) return
  
  isSaving.value = true
  formErrors.value = getInitFormErrors()
  
  try {
    const response = await $fetch('/api/user/profile', {
      method: 'PUT',
      body: editForm.value
    })
    
    if (response.success) {
      profileData.value = response.data
      isEditing.value = false
      
      toast({
        title: 'Profile Updated',
        description: 'Your profile has been successfully updated.',
        toast: 'soft-success',
        duration: 3000
      })
    }
  } catch (error: any) {
    console.error('Error updating profile:', error)
    
    if (error.status === 400 && error.data) {
      // Handle validation errors
      const errors: Record<string, any> = {}
      error.data.forEach((issue: any) => {
        errors[issue.path[0]] = issue.message
      })
      formErrors.value = errors
    } else if (error.status === 409) {
      // Handle unique constraint violations
      toast({
        title: 'Update Failed',
        description: error.statusMessage,
        toast: 'soft-error',
        duration: 5000
      })
    } else {
      toast({
        title: 'Error',
        description: 'Failed to update profile. Please try again.',
        toast: 'soft-error',
        duration: 5000
      })
    }
  } finally {
    isSaving.value = false
  }
}

onMounted(async () => {
  if (loggedIn.value) {
    status.value = 'pending'
    await Promise.all([fetchUserProfile(), fetchUserStats()])
    status.value = 'done'
  } else {
    status.value = 'done'
  }
})

watch(loggedIn, async (newValue) => {
  if (newValue) {
    status.value = 'pending'
    await Promise.all([fetchUserProfile(), fetchUserStats()])
    status.value = 'done'
    return
  }

  profileData.value = {
    biography: '',
    created_at: '',
    email: '',
    id: 0,
    job: '',
    location: '',
    language: '',
    name: '',
    role: '',
    socials: '',
    updated_at: '',
  }

  userStats.value = {
    totalPosts: 0,
    totalProjects: 0,
    totalExperiments: 0,
  }
})
</script>

<style scoped>
</style>