import type { PostType } from '~/types/post'

export function usePostEditor() {
  const { loggedIn, user } = useUserSession()
  const route = useRoute()
  const saving = ref<boolean>()
  let articleTimer: NodeJS.Timeout
  let updatePostMetaTimer: NodeJS.Timeout
  const fileInput = ref<HTMLInputElement>()
  const jsonFileInput = ref<HTMLInputElement>()
  const post = ref<PostType | undefined>(undefined)
  const canEdit = ref(false)

  // Tags management
  const { allTags, addTag, getSuggestedTags, getPrimaryTag, getSecondaryTags } = useTags()
  const showTagsDialog = ref(false)
  const postTags = ref<string[]>([])
  const selectedPrimaryTag = ref('')

  const languages = ref([
    { label: 'English', value: 'en' },
    { label: 'Français', value: 'fr' },
  ])
  
  const availableStatuses = [
    { label: 'Draft', value: 'draft' },
    { label: 'Published', value: 'published' },
    { label: 'Archived', value: 'archived' },
  ]

  const selectedLanguage = ref(languages.value[0])

  // Initialize tags from post
  if (post.value?.tags) {
    postTags.value = [...post.value.tags]
    selectedPrimaryTag.value = getPrimaryTag(post.value.tags) || ''
  }

  // Loading and error state
  const loading = ref(true)
  const error = ref<string | null>(null)

  const fetchPost = async () => {
    loading.value = true
    error.value = null
    try {
      const fetchedPost = await $fetch<PostType>(`/api/posts/${route.params.slug}`)
      post.value = fetchedPost
      selectedLanguage.value = languages.value.find(l => l.value === fetchedPost.language) ?? languages.value[0]
      canEdit.value = fetchedPost.user_id === user.value?.id

      if (fetchedPost.tags) {
        postTags.value = [...fetchedPost.tags]
        selectedPrimaryTag.value = getPrimaryTag(fetchedPost.tags) || ''
      }
      if (!fetchedPost) {
        error.value = 'Post not found.'
      }
    } catch (err) {
      error.value = 'Failed to load post data. Please try again later.'
      useToast().toast({
        title: 'Error',
        description: error.value,
        showProgress: true,
        leading: 'i-lucide-x',
        progress: 'warning',
      })
    } finally {
      loading.value = false
    }
  }

  const initializePost = async () => {
    if (route.params.slug) {
      await fetchPost()
      return
    }
    error.value = 'Post slug is required to load post data.'
    useToast().toast({
      title: 'Error',
      description: error.value,
      showProgress: true,
      leading: 'i-lucide-x',
      progress: 'warning',
    })
    loading.value = false
  }
  initializePost()

  // Computed properties for tags
  const availableTags = computed(() => allTags.value.map(tag => ({ label: tag, value: tag })))
  const primaryTag = computed(() => getPrimaryTag(post.value?.tags || []))
  const secondaryTags = computed(() => getSecondaryTags(post.value?.tags || []))
  const suggestedTags = computed(() => {
    if (!post.value?.name && !post.value?.description) return []
    const content = `${post.value?.name || ''} ${post.value?.description || ''}`.toLowerCase()
    return getSuggestedTags(content, 5).filter(tag => !postTags.value.includes(tag))
  })

  // Tags management methods
  const addSuggestedTag = (tag: string) => {
    if (!postTags.value.includes(tag)) {
      postTags.value.push(tag)
    }
  }
  
  const cancelTagsEdit = () => {
    if (post.value?.tags) {
      postTags.value = [...post.value.tags]
    }
    showTagsDialog.value = false
  }
  
  const saveTagsEdit = async () => {
    if (!post.value) return
    try {
      saving.value = true
      post.value.tags = [...postTags.value]
      selectedPrimaryTag.value = getPrimaryTag(postTags.value) || ''
      postTags.value.forEach(tag => {
        if (!allTags.value.includes(tag)) addTag(tag)
      })
      await updatePost()
      showTagsDialog.value = false
      useToast().toast({
        title: 'Tags updated',
        description: 'Post tags have been successfully updated',
        showProgress: true,
        leading: 'i-lucide-check',
        progress: 'success',
      })
    } catch (error) {
      useToast().toast({
        title: 'Update failed',
        description: 'Failed to update post tags',
        showProgress: true,
        leading: 'i-lucide-x',
        progress: 'warning',
      })
    } finally {
      saving.value = false
    }
  }

  // Export/import
  const exportPostToJson = () => {
    if (!post.value) return
    const exportData = {
      id: post.value.id,
      name: post.value.name,
      slug: post.value.slug,
      description: post.value.description,
      article: post.value.article,
      tags: post.value.tags,
      language: post.value.language,
      status: post.value.status,
      created_at: post.value.created_at,
      updated_at: post.value.updated_at,
      image: post.value.image,
    }
    const jsonString = JSON.stringify(exportData, null, 2)
    const blob = new Blob([jsonString], { type: 'application/json' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `${post.value.slug || post.value.id}-${new Date().toISOString().split('T')[0]}.json`
    document.body.appendChild(a)
    a.click()
    setTimeout(() => {
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
    }, 0)
  }
  
  const triggerJsonImport = () => {
    if (!canEdit.value) return
    jsonFileInput.value?.click()
  }
  
  const handleJsonFileSelect = async (event: Event) => {
    const file = (event.target as HTMLInputElement).files?.[0]
    if (!file || !post.value || !canEdit.value) return
    try {
      saving.value = true
      const fileContent = await file.text()
      const importedData = JSON.parse(fileContent)
      if (importedData.name) post.value.name = importedData.name
      if (importedData.description) post.value.description = importedData.description
      if (importedData.tags && Array.isArray(importedData.tags)) {
        post.value.tags = importedData.tags
        postTags.value = [...importedData.tags]
        selectedPrimaryTag.value = getPrimaryTag(importedData.tags) || ''
        importedData.tags.forEach((tag: string) => {
          if (!allTags.value.includes(tag)) addTag(tag)
        })
      }
      if (importedData.language) {
        post.value.language = importedData.language
        selectedLanguage.value = languages.value.find(l => l.value === importedData.language) ?? languages.value[0]
      }
      if (importedData.article) {
        post.value.article = importedData.article
        await updatePostArticle(importedData.article)
      }
      await updatePost()
      useToast().toast({
        title: 'Import successful',
        description: 'The post has been updated with the imported data',
        showProgress: true,
        leading: 'i-lucide-check',
        progress: 'success',
      })
    } catch (error) {
      useToast().toast({
        title: 'Import failed',
        description: 'Failed to import the JSON file. Please check the file format.',
        showProgress: true,
        leading: 'i-lucide-x',
        progress: 'warning',
      })
    } finally {
      saving.value = false
      if (jsonFileInput.value) jsonFileInput.value.value = ''
    }
  }

  // Editor
  const onUpdateEditor = (value: Object) => {
    clearTimeout(articleTimer)
    articleTimer = setTimeout(() => updatePostArticle(value), 2000)
  }
  const updatePostArticle = async (value: Object) => {
    await $fetch(`/api/posts/${route.params.slug}/article`, {
      method: 'PUT',
      body: { article: value },
    })
  }

  // Watchers
  watch(
    [
      () => post.value?.name,
      () => post.value?.description,
      () => post.value?.tags,
      () => post.value?.slug,
      () => post.value?.status,
      () => selectedLanguage.value,
      () => selectedPrimaryTag.value,
    ],
    () => {
      clearTimeout(updatePostMetaTimer)
      updatePostMetaTimer = setTimeout(updatePost, 2000)
    },
  )
  watch(selectedPrimaryTag, (newPrimaryTag) => {
    if (!post.value || !canEdit.value) return
    const currentTags = post.value.tags || []
    const secondaryTags = getSecondaryTags(currentTags)
    const newTags = newPrimaryTag ? [newPrimaryTag, ...secondaryTags] : secondaryTags
    post.value.tags = newTags
    postTags.value = [...newTags]
  })

  // Update post meta
  const updatePost = async () => {
    saving.value = true
    const { post: updatedPost } = await $fetch<{ post: PostType }>(
      `/api/posts/${route.params.slug}/`, {
        method: 'PUT',
        body: {
          tags: post.value?.tags,
          description: post.value?.description,
          language: selectedLanguage.value.value,
          name: post.value?.name,
          slug: post.value?.slug,
          status: post.value?.status,
        },
      },
    )
    saving.value = false
    if (!post.value) return
    post.value.updated_at = updatedPost.updated_at
  }

  // Cover image
  const removeCoverImage = async () => {
    const { success } = await $fetch(`/api/posts/${route.params.slug}/cover`, { method: 'DELETE' })
    if (success && post.value?.image) {
      post.value.image.src = ''
      post.value.image.alt = ''
    }
  }
  const uploadCoverImage = () => {
    fileInput.value?.click()
  }
  const handleCoverSelect = async (event: Event) => {
    const file = (event.target as HTMLInputElement).files?.[0]
    if (!file) return
    try {
      saving.value = true
      const formData = new FormData()
      formData.append('file', file)
      formData.append('fileName', file.name)
      formData.append('type', file.type)
      const { image } = await $fetch(`/api/posts/${route.params.slug}/cover`, {
        method: 'POST',
        body: formData,
      })
      if (post.value && image.src) {
        post.value.image.src = image.src
        post.value.image.alt = image.alt
      }
    } catch (error) {
      // eslint-disable-next-line no-console
      console.error('Error uploading image:', error)
    } finally {
      saving.value = false
    }
  }

  // Handlers for header events
  function onHeaderFieldUpdate<K extends keyof PostType>({ field, value }: { field: K, value: PostType[K] }) {
    if (!post.value) return
    post.value[field] = value
  }
  function onPrimaryTagUpdate(val: string) {
    selectedPrimaryTag.value = val
  }
  function onLanguageUpdate(val: any) {
    selectedLanguage.value = val
    if (post.value) post.value.language = val.value
  }

  return {
    // State
    post,
    loggedIn,
    canEdit,
    saving,
    showTagsDialog,
    postTags,
    selectedPrimaryTag,
    languages,
    availableStatuses,
    selectedLanguage,

    // Computed
    availableTags,
    primaryTag,
    secondaryTags,
    suggestedTags,

    // Methods - Tags
    addSuggestedTag,
    cancelTagsEdit,
    saveTagsEdit,

    // Methods - Import/Export
    exportPostToJson,
    triggerJsonImport,
    handleJsonFileSelect,

    // Methods - Editor
    onUpdateEditor,

    // Methods - Cover Image
    removeCoverImage,
    uploadCoverImage,
    handleCoverSelect,

    // Methods - Header Events
    onHeaderFieldUpdate,
    onPrimaryTagUpdate,
    onLanguageUpdate,
    // Loading and error
    loading,
    error,
  }
}
