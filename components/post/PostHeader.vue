<template>
  <header v-if="post" class="mt-24 w-full text-center flex flex-col justify-center items-center">
    <div class="w-md mt-2">
      <UInput v-model="post.name"
        class="font-text text-xl font-800 min-h-0 mb-2 p-0 overflow-y-hidden shadow-none text-align-center"
        :readonly="!canEdit" input="~" label="Name" type="textarea" :rows="1" autoresize
        @update:model-value="val => emitUpdate('name', val)" />

      <UInput v-model="post.description"
        class="font-text text-gray-700 dark:text-gray-300 shadow-none text-align-center"
        :readonly="!canEdit" input="~" label="Description" type="textarea"
        autoresize placeholder="Write a brief description of your post" 
        @update:model-value="val => emitUpdate('description', val)" />
      
      <div class="flex items-center gap-2 mt-2 justify-center">
        <!-- Primary Tag Display/Edit -->
        <div v-if="!canEdit && primaryTag" class="px-2 py-1 rounded-full text-xs bg-blue-100 dark:bg-blue-900 shadow-sm">
          {{ primaryTag }}
        </div>

        <div class="max-w-40" v-if="canEdit">
          <USelect v-model="selectedPrimaryTagLocal" :items="availableTags || []" item-key="name" placeholder="Primary tag">
            <template #trigger>
              <UIcon name="i-lucide-tag" v-if="selectedPrimaryTagLocal" />
              <UIcon name="i-lucide-plus" v-else />
            </template>
          </USelect>
        </div>

        <!-- Status Control -->
        <div class="max-w-20">
          <USelect v-if="canEdit" v-model="post.status" :items="availableStatuses || []" item-key="label"
            @update:model-value="val => emitUpdate('status', val)">
            <template #trigger>
              <UIcon name="i-icon-park-outline:preview-close" v-if="post.status === 'draft'" />
              <UIcon name="i-icon-park-outline:preview-open" v-else-if="post.status === 'published'" />
              <UIcon name="i-ph-archive" v-else />
            </template>
          </USelect>
        </div>

        <!-- Language Selection -->
        <USelect v-if="canEdit"
          :items="languages || []" 
          v-model="selectedLanguageLocal" 
          item-key="label"
          value-key="label"
          label="Choose the post language"
          @update:model-value="val => emit('update:language', val)"
        >
          <template #label="{ label }">
            <div class="flex items-center gap-2">
              <UIcon name="i-ph-globe-stand" />
              <span>{{ label }}</span>
            </div>
          </template>
        </USelect>

        <!-- Cover Image Upload -->
        <UTooltip v-if="!post.image?.src && canEdit">
          <template #default>
            <UButton @click="emit('uploadCover')" :disabled="!canEdit" btn="outline-gray">
              <div class="i-icon-park-outline:upload-picture"></div>
            </UButton>
          </template>

          <template #content>
            <div class="px-2 py-1">
              <p>Upload a cover image for your post.</p>
            </div>
          </template>
        </UTooltip>

        <!-- Slug Editor -->
        <UPopover v-if="canEdit" :disabled="!canEdit">
          <template #trigger>
            <UButton v-if="canEdit" btn="outline-white" leading="i-icon-park-outline:edit" label="edit slug" />
          </template>
          <template #default>
            <div>
              <div class="space-y-1">
                <h4 class="font-medium leading-none">
                  Update slug
                </h4>
                <p class="text-xs text-muted">
                  The slug is the part of the URL that identifies the post.
                </p>
              </div>
              <UInput v-model="post.slug" label="Slug" class="mt-2"
                @update:model-value="val => emitUpdate('slug', val)" />
            </div>
          </template>
        </UPopover>

        <!-- Tags Management Button -->
        <UTooltip v-if="canEdit">
          <template #default>
            <UButton @click="emit('showTagsDialog')" :disabled="!canEdit" btn="outline-gray">
              <div class="i-lucide-tags"></div>
            </UButton>
          </template>

          <template #content>
            <div class="px-2 py-1">
              <p>Manage post tags</p>
            </div>
          </template>
        </UTooltip>
      </div>

      <!-- Secondary Tags Display -->
      <div v-if="secondaryTags.length > 0" class="flex flex-wrap gap-2 mt-3 justify-center">
        <UBadge
          v-for="tag in secondaryTags"
          :key="tag.name"
          variant="outline"
          color="gray"
          size="sm"
        >
          {{ tag }}
        </UBadge>
      </div>
    </div>

    <div class="w-md mt-4 flex justify-between pt-4 border-t-2 dark:border-gray-800">
      <div class="flex gap-4 items-center">
        <div class="w-8 h-8 bg-gradient-to-br from-blue-400 to-purple-500 rounded-full flex items-center justify-center">
          <!-- Avatar SVG -->
          <slot name="avatar" :post="post" />
        </div>
        <div class="text-align-start flex flex-col">
          <h4>{{ post.user?.name }}</h4>
          <span class="text-size-3 text-gray-500 dark:text-gray-400">
            {{ formatPublishedDate(post.publishedAt ?? post.updatedAt) }}
          </span>

          <div class="flex items-center gap-2 justify-center">
            <span class="text-size-3 text-gray-500 dark:text-gray-500 dark:hover:text-gray-200 transition">
              Last updated on {{ formatUpdatedDate(post.updatedAt ?? post.createdAt) }}
            </span>
            <UIcon :name="saving === undefined ? '' : saving ? 'i-loading' : 'i-check'"
              :class="saving ? 'animate-spin text-muted' : 'text-lime-300'" />
          </div>
        </div>
      </div>

      <div class="flex">
        <UButton 
          icon
          label="i-ph-chat"
          btn="ghost-gray"
          class="hover:scale-102 active:scale-99 transition"
        />
        <UButton 
          icon
          label="i-lucide-share"
          btn="ghost-gray"
          class="hover:scale-102 active:scale-99 transition"
        />
      </div>
    </div>

    <!-- Cover Image Display -->
    <div v-if="post.image?.src" class="relative group">
      <NuxtImg 
        provider="hubblob"
        :src="`/${post.image.src}/original.${post.image.ext}`" 
        class="w-full h-80 object-cover rounded-lg mt-4" 
      />
      <div class="flex gap-2 absolute top-1 right-1">
        <UButton v-if="canEdit" icon @click="emit('uploadCover')" btn="~" label="i-icon-park-outline:upload-picture"
          class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />

        <UButton v-if="canEdit" icon @click="emit('removeCover')" btn="~" label="i-icon-park-outline:delete"
          class="btn-glowing cursor-pointer opacity-0 group-hover:opacity-100 transition-all" />
      </div>
    </div>
    
    <div v-else class="mb-8 mt-8 w-md">
      <div class="border-b b-dashed b-b-amber"></div>
      <div class="border-b b-dashed b-b-blue relative top-2"></div>
    </div>
  </header>
</template>

<script lang="ts" setup>
import { ref, computed, watch } from 'vue'
import type { Post } from '~/types/post'
import type { ApiTag } from '~/types/tag'

type LabelValue = {
  label: string;
  value: string;
}

interface Props {
  post?: Post;
  canEdit: boolean;
  availableTags: ApiTag[];
  availableStatuses: LabelValue[];
  languages: LabelValue[];
  selectedPrimaryTag: ApiTag | null;
  selectedLanguage: LabelValue | null;
  saving?: boolean;
}

const props = defineProps<Props>()
const emit = defineEmits([
  'update:post',
  'update:primaryTag',
  'update:language',
  'uploadCover',
  'removeCover',
  'showTagsDialog',
])

const selectedPrimaryTagLocal = ref(props.selectedPrimaryTag)
const selectedLanguageLocal = ref(props.selectedLanguage)

watch(selectedPrimaryTagLocal, (val) => {
  emit('update:primaryTag', val)
})
watch(selectedLanguageLocal, (val) => {
  emit('update:language', val)
})

function emitUpdate(field: string, value: any) {
  emit('update:post', { field, value })
}

const primaryTag = computed(() => {
  return props.post?.tags?.[0] || ''
})
const secondaryTags = computed(() => {
  return Array.isArray(props.post?.tags) ? props.post.tags.slice(1) : []
})

function formatPublishedDate(date: string | Date): string {
  if (!date) return 'Unknown Date'
  const dateObj = new Date(date)
  const options: Intl.DateTimeFormatOptions = { 
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }
  return dateObj.toLocaleString('fr', options)
}
function formatUpdatedDate(date: string | Date): string {
  if (!date) return 'Unknown Date'
  const dateObj = new Date(date)
  const options: Intl.DateTimeFormatOptions = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  }
  return dateObj.toLocaleString('fr', options)
}
</script>
