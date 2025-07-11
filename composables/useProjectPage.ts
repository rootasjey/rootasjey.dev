import type { ApiTag } from '~/types/tag'
import type { Project } from '~/types/project'

export function useProjectPage(slug: string) {
  const { loggedIn, user } = useUserSession()
  const tagsStore = useTagStore()

  // Initialize tags store
  tagsStore.initialize()

  const fileInput = ref<HTMLInputElement | null>(null)
  const isUploading = ref(false)
  let _articleTimer: NodeJS.Timeout
  const saving = ref(false)
  const showTagsDialog = ref(false)

  const projectTags = ref<ApiTag[]>([])

  // Project, loading, and error state
  const project = ref<Project | undefined>(undefined)
  const loading = ref(true)
  const error = ref<string | null>(null)



  // Fetch project data and tags
  const fetchProject = async () => {
    loading.value = true
    error.value = null
    try {
      await tagsStore.fetchTags()
      const data = await $fetch(`/api/projects/${slug}`)
      project.value = data as unknown as Project
      // Fetch tags for this project from API
      const apiTags = await tagsStore.fetchProjectTags(project.value.id)
      projectTags.value = apiTags

    } catch (err: any) {
      error.value = err?.message || 'Failed to load project.'
      project.value = undefined
    } finally {
      loading.value = false
    }
  }

  // Fetch on composable init
  fetchProject()

  const canEdit = ref<boolean>(loggedIn.value && project.value?.user?.id === user.value?.id)

  const openFilePicker = () => fileInput.value?.click()

  const removeImage = async () => {
    if (!project.value || !project.value.image) return
    project.value.image.src = ''
    project.value.image.alt = ''
    const response = await $fetch(`/api/projects/${slug}/cover`, { method: 'DELETE' })
    if (!response.success) console.error('Failed to remove image, ', response.error)
  }

  const handleCoverSelect = async (event: Event) => {
    if (!canEdit.value) return
    if (!project.value) return

    const target = event.target as HTMLInputElement
    const file = target.files?.[0]
    if (!file) return
    isUploading.value = true
    try {
      const formData = new FormData()
      formData.append('file', file)
      formData.append('fileName', file.name)
      formData.append('type', file.type)
      const response = await $fetch(`/api/projects/${slug}/cover`, { method: 'POST', body: formData })
      if (response.success) {
        project.value.image.src = response.image.src
        project.value.image.alt = response.image.alt
      }
    } catch (error) {
      console.error('Error uploading image:', error)
      alert('Failed to upload image. Please try again.')
    } finally {
      isUploading.value = false
      if (fileInput.value) fileInput.value.value = ''
    }
  }

  const onUpdateEditor = (value: Object) => {
    clearTimeout(_articleTimer)
    _articleTimer = setTimeout(() => updateProjectArticle(value), 2000)
  }

  const updateProjectArticle = async (value: Object) => {
    await $fetch(`/api/projects/${slug}/article`, { method: 'PUT', body: { article: value } })
  }

  const exportProjectToJson = () => {
    if (!project.value) return
    const exportData = {
      tags: project.value.tags,
      company: project.value.company,
      article: project.value.article,
      created_at: project.value.createdAt,
      description: project.value.description,
      id: project.value.id,
      image: project.value.image,
      links: project.value.links,
      name: project.value.name,
      slug: project.value.slug,
      user_id: project.value.user?.id,
      user_name: project.value.user?.name,
      user_avatar: project.value.user?.avatar,
      updated_at: project.value.updated_at,
      status: project.value.status,
    }
    const jsonString = JSON.stringify(exportData, null, 2)
    const blob = new Blob([jsonString], { type: 'application/json' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `${project.value.slug || project.value.id}-${new Date().toISOString().split('T')[0]}.json`
    document.body.appendChild(a)
    a.click()
    setTimeout(() => {
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
    }, 0)
  }

  const availableTags = computed(() => tagsStore.allTags.map((tag: ApiTag) => ({ label: tag.name, value: tag.id, tag })))


  // Tag management methods
  const saveTagsEdit = async () => {
    if (!project.value) return
    try {
      saving.value = true
      await tagsStore.assignProjectTags(project.value.id, projectTags.value.map((t: ApiTag) => t.id))
      project.value.tags = [...projectTags.value]

      showTagsDialog.value = false
      useToast().toast({
        title: 'Tags updated',
        description: 'Project tags have been successfully updated',
        showProgress: true,
        leading: 'i-lucide-check',
        progress: 'success',
      })
    } catch (error) {
      useToast().toast({
        title: 'Update failed',
        description: 'Failed to update project tags',
        showProgress: true,
        leading: 'i-lucide-x',
        progress: 'warning',
      })
    } finally {
      saving.value = false
    }
  }

  const toggleCanEdit = () => {
    if (!loggedIn.value || !project.value) return
    canEdit.value = !canEdit.value
  }

  const updateProject = async (payload: Project) => {
    if (!project.value) return
    project.value = payload

    try {
      await $fetch(`/api/projects/${payload.id}`, { method: 'PUT', body: payload })
    }
    catch (error) {
      console.error('Failed to update project:', error)
      alert('Failed to save changes. Please try again.')
    }
    finally {
      saving.value = false
    }
  }

  const updateSlug = (newSlug: string) => {
    if (!project.value) return
    project.value.slug = newSlug
    updateProject(project.value)
  }

  const formatDate = (date: string | Date): string => {
    if (!date) return 'Unknown Date'
    const dateObj = new Date(date)
    const options: Intl.DateTimeFormatOptions = {
      year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit',
    }
    return dateObj.toLocaleString('fr', options)
  }

  return {
    // State
    loggedIn,
    user,
    fileInput,
    isUploading,
    saving,
    showTagsDialog,

    projectTags,
    project,
    canEdit,
    loading,
    error,

    // Computed
    availableTags,


    // Methods
    saveTagsEdit,
    exportProjectToJson,
    fetchProject,
    formatDate,
    handleCoverSelect,
    openFilePicker,
    onUpdateEditor,
    removeImage,
    toggleCanEdit,
    updateSlug,
  }
}
