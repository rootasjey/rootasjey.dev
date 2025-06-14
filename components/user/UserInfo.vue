<template>
  <section class="mb-12">
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200">
        <span class="i-ph-user-circle mr-2"></span>
        <span class="font-600">{{ user?.name }}</span>
      </h2>
      <UButton 
        v-if="!isEditing"
        btn="soft-blue"
        size="sm"
        class="px-6"
        @click="$emit('startEditing')"
      >
        <span class="i-ph-pencil"></span>
        Edit Profile
      </UButton>
    </div>
    
    <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-6 mb-6">
      <!-- View Mode -->
      <div v-if="!isEditing" class="flex items-center gap-4">
        <div class="w-16 h-16 bg-gradient-to-br from-blue-400 to-purple-500 rounded-full flex items-center justify-center">
          <span class="i-ph-user text-white text-2xl"></span>
        </div>
        <div class="flex-1">
          <h3 class="text-md font-600 text-gray-800 dark:text-gray-200">
            {{ profileData?.email || 'User' }}
          </h3>
          <p class="text-size-3.5 text-gray-500 dark:text-gray-400">
            Member since {{ formatDate(profileData?.created_at || '') }}
          </p>
          <div v-if="profileData?.biography" class="mt-2">
            <p class="text-sm text-gray-600 dark:text-gray-300">{{ profileData.biography }}</p>
          </div>
          <div v-if="profileData?.job || profileData?.location" class="mt-2 flex gap-4 text-sm text-gray-500 dark:text-gray-400">
            <span v-if="profileData?.job">
              <span class="i-ph-briefcase mr-1"></span>{{ profileData.job }}
            </span>
            <span v-if="profileData?.location">
              <span class="i-ph-map-pin mr-1"></span>{{ profileData.location }}
            </span>
          </div>
        </div>
      </div>

      <!-- Edit Mode -->
      <form v-else @submit.prevent="$emit('saveProfile')" class="space-y-4">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-500 text-gray-700 dark:text-gray-300 mb-1">Name</label>
            <input
              v-model="editForm.name"
              type="text"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100"
              :class="{ 'border-red-500': formErrors.name }"
            />
            <p v-if="formErrors.name" class="text-red-500 text-xs mt-1">{{ formErrors.name }}</p>
          </div>
          
          <div>
            <label class="block text-sm font-500 text-gray-700 dark:text-gray-300 mb-1">Email</label>
            <input
              v-model="editForm.email"
              type="email"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100"
              :class="{ 'border-red-500': formErrors.email }"
            />
            <p v-if="formErrors.email" class="text-red-500 text-xs mt-1">{{ formErrors.email }}</p>
          </div>
        </div>

        <div>
          <label class="block text-sm font-500 text-gray-700 dark:text-gray-300 mb-1">Biography</label>
          <textarea
            v-model="editForm.biography"
            rows="3"
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100"
            :class="{ 'border-red-500': formErrors.biography }"
            placeholder="Tell us about yourself..."
          ></textarea>
          <p v-if="formErrors.biography" class="text-red-500 text-xs mt-1">{{ formErrors.biography }}</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-500 text-gray-700 dark:text-gray-300 mb-1">Job Title</label>
            <input
              v-model="editForm.job"
              type="text"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100"
              placeholder="e.g. Software Developer"
            />
          </div>
          
          <div>
            <label class="block text-sm font-500 text-gray-700 dark:text-gray-300 mb-1">Location</label>
            <input
              v-model="editForm.location"
              type="text"
              class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100"
              placeholder="e.g. New York, USA"
            />
          </div>
        </div>

        <div>
          <label class="block text-sm font-500 text-gray-700 dark:text-gray-300 mb-1">Language</label>
          <select
            v-model="editForm.language"
            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100"
          >
            <option value="">Select Language</option>
            <option value="en">English</option>
            <option value="fr">French</option>
            <option value="es">Spanish</option>
            <option value="de">German</option>
            <option value="it">Italian</option>
          </select>
        </div>

        <div class="flex gap-3 pt-4">
          <UButton 
            type="button"
            btn="soft-gray"
            size="sm"
            class="border b-dashed border-gray-300 dark:border-gray-600"
            @click="$emit('cancelEditing')"
            :disabled="isSaving"
          >
            <span class="i-ph-x"></span>
            Cancel
          </UButton>

          <UButton 
            type="submit"
            btn="soft"
            size="sm"
            :disabled="isSaving"
          >
            <span v-if="isSaving" class="i-ph-spinner animate-spin"></span>
            <span v-else class="i-ph-check"></span>
            {{ isSaving ? 'Saving...' : 'Save Changes' }}
          </UButton>
        </div>
      </form>
    </div>
  </section>
</template>

<script lang="ts" setup>
import type { User } from '#auth-utils'

interface Props {
  isEditing: boolean
  isSaving: boolean
  formErrors: Record<string, string>
  editForm: {
    name: string
    email: string
    biography: string
    job: string
    location: string
    language: string
  }
  profileData: {
    name: string
    email: string
    biography: string
    job: string
    location: string
    language: string
    created_at: string
    updated_at: string
  }
  user: User
}

interface Emit {
  (e: "cancelEditing"): void
  (e: "startEditing"): void
  (e: "saveProfile"): void
}

const props = defineProps<Props>()
defineEmits<Emit>()

const formatDate = (date: string | Date) => {
  if (!date) return 'Unknown'
  return new Date(date).toLocaleDateString('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

</script>