<template>
  <div class="frame">
    <article class="max-w-4xl mx-auto px-4 py-2 my-24 space-y-8">
      <ProjectHeader
        v-if="projectPage.project.value"
        :project="projectPage.project.value"
        :can-edit="projectPage.canEdit.value"
        :saving="projectPage.saving?.value"
        @open-file-picker="projectPage.openFilePicker"
        @remove-image="projectPage.removeImage"
        @show-tags-dialog="() => (projectPage.showTagsDialog.value = true)"
        @update-slug="projectPage.updateSlug"
      />

      <div v-if="projectPage.project.value?.article" 
        class="w-500px pt-8 mx-auto text-gray-700 dark:text-gray-300">
        <tiptap-editor 
          :can-edit="projectPage.canEdit.value" 
          :model-value="projectPage.project.value?.article" 
          @update:model-value="projectPage.onUpdateEditor" 
        />
      </div>
      
      <div v-else-if="projectPage.loading.value || projectPage.error.value">
        <LoadingOrErrorState :loading="projectPage.loading.value" :error="projectPage.error.value" />
      </div>
      <div v-else class="flex justify-center items-center h-60vh">
        <!-- fallback, should not be visible -->
      </div>
    </article>

    <div class="w-500px mx-auto">
      <Footer />
    </div>
    
    <ProjectEditToolbar
      v-if="projectPage.project.value"
      :project="projectPage.project.value"
      :can-edit="projectPage.canEdit.value"
      :logged-in="projectPage.loggedIn.value"
      @go-back="$router.back()"
      @toggle-can-edit="projectPage.toggleCanEdit"
      @export-project-to-json="projectPage.exportProjectToJson"
      @open-file-picker="projectPage.openFilePicker"
      @handle-cover-select="projectPage.handleCoverSelect"
    />
  </div>
</template>

<script lang="ts" setup>
const route = useRoute()
const slug = route.params.slug as string
const projectPage = useProjectPage(slug)
</script>

<style scoped>
.frame {
  border-radius: 0.75rem;
  padding: 2rem;
  padding-bottom: 38vh;
  display: flex;
  flex-direction: column;
  transition-property: all;
  transition-duration: 500ms;
  overflow-y: auto;

  background-color: #f1f1f1;
  width: 100%;
  min-height: 100vh;
}

.dark .frame {
  background-color: #000;
}
</style>
