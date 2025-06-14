<template>
  <div class="frame">
    <header class="mt-12 mb-8">
      <div class="flex gap-2">
        <ULink to="/" class="hover:scale-102 active:scale-99 transition">
          <span class="i-ph-house-simple-duotone"></span>
        </ULink>
        <span>•</span>
        <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
          User Profile
        </h1>
      </div>
      <div class="w-40 flex text-center justify-center my-2">
        <div class="w-full h-2">
          <svg viewBox="0 0 300 10" preserveAspectRatio="none">
            <path d="M 0 5 Q 15 0, 30 5 T 60 5 T 90 5 T 120 5 T 150 5 T 180 5 T 210 5 T 240 5 T 270 5 T 300 5"
              stroke="currentColor" fill="none" class="text-gray-300 dark:text-gray-700" stroke-width="1" />
          </svg>
        </div>
      </div>
    </header>

    <UserInfo 
      v-if="loggedIn && user" 
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
    <UserStatistics v-if="loggedIn"  :user-stats="userStats" />
    <UserRecentActivities v-if="loggedIn" :recent-activity="recentActivity" />
    <UserAccountSettings v-if="loggedIn" @sign-out="handleSignOut" />
    <UserNoLoggedIn v-if="!loggedIn" />
    <Footer />
  </div>
</template>

<script lang="ts" setup>
import type { User } from '#auth-utils'

const { loggedIn, user, clear } = useUserSession()
const { toast } = useToast()

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

onMounted(() => {
  if (loggedIn.value) {
    fetchUserProfile()
    fetchUserStats()
  }
})

watch(loggedIn, (newValue) => {
  if (newValue) {
    fetchUserProfile()
    fetchUserStats()
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
.frame {
  width: 600px;
  border-radius: 0.75rem;
  padding: 2rem;
  padding-bottom: 38vh;
  display: flex;
  flex-direction: column;
  transition-property: all;
  transition-duration: 500ms;
  overflow-y: auto;
}

@media (max-width: 768px) {
  .frame {
    width: 100%;
    padding: 1rem;
  }
}
</style>