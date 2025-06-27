<template>
  <div class="frame">
    <article>
      <PostHeader
        v-if="postEditor.post"
        :post="postEditor.post.value"
        :can-edit="postEditor.canEdit.value"
        :available-tags="postEditor.availableTags.value"
        :available-statuses="postEditor.availableStatuses"
        :languages="postEditor.languages.value"
        :selected-primary-tag="postEditor.selectedPrimaryTag.value"
        :selected-language="postEditor.selectedLanguage.value"
        :saving="postEditor.saving.value"
        @update:post="postEditor.onHeaderFieldUpdate"
        @update:primaryTag="postEditor.onPrimaryTagUpdate"
        @update:language="postEditor.onLanguageUpdate"
        @uploadCover="postEditor.uploadCoverImage"
        @removeCover="postEditor.removeCoverImage"
        @showTagsDialog="postEditor.showTagsDialog.value = true"
      >
        <template #avatar="{ post }">
          <svg viewBox="0 0 36 36" fill="none" role="img" xmlns="http://www.w3.org/2000/svg" width="80" height="80"><mask :id="`avatar-mask-${post.id}`" maskUnits="userSpaceOnUse" x="0" y="0" width="36" height="36"><rect width="36" height="36" rx="72" fill="#FFFFFF"></rect></mask><g mask="url(#:ru4:)"><rect width="36" height="36" fill="#ff005b"></rect><rect x="0" y="0" width="36" height="36" transform="translate(9 -5) rotate(219 18 18) scale(1)" fill="#ffb238" rx="6"></rect><g transform="translate(4.5 -4) rotate(9 18 18)"><path d="M15 19c2 1 4 1 6 0" stroke="#000000" fill="none" stroke-linecap="round"></path><rect x="10" y="14" width="1.5" height="2" rx="1" stroke="none" fill="#000000"></rect><rect x="24" y="14" width="1.5" height="2" rx="1" stroke="none" fill="#000000"></rect></g></g></svg>
        </template>
      </PostHeader>

      <main v-if="postEditor.post.value?.article" class="md:w-xl pt-8 mx-auto">
        <client-only>
          <tiptap-editor 
            :can-edit="postEditor.canEdit.value" 
            :model-value="postEditor.post.value?.article" 
            @update:model-value="postEditor.onUpdateEditor" 
          />
        </client-only>
      </main>

      <div v-else-if="postEditor.loading.value" class="flex flex-col justify-center items-center h-60vh">
        <svg class="animate-spin mb-4" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10" stroke-opacity="0.2" />
          <path d="M12 2a10 10 0 0 1 10 10" />
        </svg>
        <span class="loading-dots text-lg font-medium text-gray-600 dark:text-gray-300">Loading</span>
      </div>
      <div v-else-if="postEditor.error.value" class="flex flex-col justify-center items-center max-w-lg mx-auto text-center min-h-60vh mt-16">
        <svg class="mb-4 text-amber-500" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10" stroke-opacity="0.2" />
          <line x1="15" y1="9" x2="9" y2="15" />
          <line x1="9" y1="9" x2="15" y2="15" />
        </svg>
        <span class="text-4xl font-400 font-body">{{ postEditor.error.value }}</span>
        <p class="mt-4 text-gray-600 dark:text-gray-300">Please try 
          <ULink class="hover:underline decoration-offset-4 mx-1"><UIcon name="i-ph-arrow-counter-clockwise-bold" />refreshing</ULink> 
          the page or check back later.
        </p>
        <p class="font-text text-lg mt-8 border-t pt-8">
          <span class="font-600 text-gray-400 dark:text-gray-300 ">In the meantime, here is a quote for the day:</span><br/>
          <q class="mt-4 text-4xl italic">The only limit to our realization of tomorrow is our doubts of today.</q>
          <br>
          <span class="text-sm text-gray-500">- Franklin D. Roosevelt</span>
        </p>
      </div>
      <div v-else class="flex justify-center items-center h-60vh">
        <!-- fallback, should not be visible -->
      </div>
    </article>

    <div class="mt-32 w-500px md:w-xl mx-auto">
      <Footer />
    </div>

    <PostTagsDialog
      :show="postEditor.showTagsDialog.value"
      :post-tags="postEditor.postTags.value"
      :suggested-tags="postEditor.suggestedTags.value"
      @update:show="(val: boolean) => postEditor.showTagsDialog.value = val"
      @save="postEditor.saveTagsEdit"
      @cancel="postEditor.cancelTagsEdit"
      @addSuggestedTag="postEditor.addSuggestedTag"
    />

    <PostToolbar
      :can-edit="postEditor.canEdit.value"
      :logged-in="postEditor.loggedIn.value"
      @goBack="$router.back()"
      @toggleEdit="postEditor.canEdit.value = !postEditor.canEdit"
      @exportJson="postEditor.exportPostToJson"
      @importJson="postEditor.triggerJsonImport"
    />

    <!-- Hidden file input for JSON import -->
    <input type="file" 
      ref="_jsonFileInput" 
      class="hidden" 
      accept="application/json" 
      @change="postEditor.handleJsonFileSelect" 
    />
  </div>
</template>

<script lang="ts" setup>
const postEditor = usePostEditor()

useHead({
  title: () => `root • ${postEditor.post.value?.name ?? 'Loading...'}`,
  meta: [
    {
      name: 'description',
      content: () => postEditor.post.value?.description ?? 'Loading post...',
    },
  ],
})
</script>

<style scoped>

.frame {
  padding: 0;
  padding-bottom: 38vh;
  display: flex;
  flex-direction: column;
  transition-property: all;
  overflow-y: auto;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);

  width: 100%;
  min-height: 100vh;
  background-color: #F1F1F1;
}

.dark .frame {
  background-color: #111;
}

.loading-dots::after {
  content: '.';
  animation: dots 1.2s steps(3, end) infinite;
}
@keyframes dots {
  0%, 20% { content: '.'; }
  40% { content: '..'; }
  60%, 100% { content: '...'; }
}
</style>
