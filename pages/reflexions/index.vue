
<template>
  <div class="container mx-auto px-4 py-8 relative mt-[15vh]">
    <PageHeader 
      title="Reflexions" 
      subtitle="A collection of my creative work"
    >
      <div>
        <UProgress v-if="_isLoading" :indeterminate="true" size="sm" color="primary" />
        <UButton v-if="getToken() && !_isLoading" btn="text" class="text-3"
          :label="_showDrafts ? 'Show only published posts' : 'Show drafts'" @click="_showDrafts = !_showDrafts" />
      </div>
    </PageHeader>

    <div v-if="_showDrafts && drafts.length > 0" class="flex flex-wrap gap-8 px-14 mb-16">
      <div v-for="draft in drafts" :key="draft.id.toString()" class="max-w-270px overflow-hidden">
        <ULink :to="`/reflexions/${draft.id}`" class="flex items-start gap-2">
          <span icon-base class="i-icon-park-outline:notebook-and-pen" />
          <UTooltip content="Go back" :_tooltip-content="{
            side: 'top',
          }">
            <template #default>
              <h1 class="text-size-4 font-500 line-height-4.5 whitespace-nowrap overflow-hidden text-ellipsis dark:text-gray-300">
                {{ draft.name }}
              </h1>
            </template>
            <template #content>
              <button @click="$router.push(`/reflexions/${draft.id}`)" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md
                border-1 border-dashed class="b-#3D3BF3">
                {{  draft.name }}
              </button>
            </template>
          </UTooltip>
        </ULink>
        <p class="text-size-3 text-gray-700 dark:text-gray-400">{{ draft.description }}</p>
        <div class="flex justify-between items-center">
          <span class="text-size-3 text-gray-500 dark:text-gray-500">
            {{ new Date(draft.updated_at).toLocaleString("fr", {
            month: "long",
            day: "numeric",
            year: "numeric",
            }) }}
          </span>
        </div>
      </div>
    </div>

    <div
      :class="posts.length > 1 ? 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 px-14' : 'grid grid-cols-1 gap-4 px-14'">
      <div v-for="post in posts" :key="post.id.toString()" class="max-w-xl">
        <ULink :to="`/reflexions/${post.id}`">
          <h1 class="text-6xl font-600">{{ post.name }}</h1>
        </ULink>
        <p class="text-gray-700 dark:text-gray-300">{{ post.description }}</p>
        <div class="flex justify-between items-center">
          <span class="text-size-3 text-gray-500 dark:text-gray-400">{{ new Date(post.created_at).toLocaleString("fr", {
            month: "long",
            day: "numeric",
            year: "numeric",
            }) }}</span>
        </div>
      </div>
    </div>

    <div v-if="posts?.length === 0 && drafts?.length === 0" class="flex flex-col items-center justify-center gap-0 max-w-xl mx-auto">
      <div class="text-sm font-medium text-gray-500 dark:text-gray-400">
        Because there's no published posts yet, here is a quote: <br />
      </div>
      <div class="text-2xl font-200 text-gray-400 dark:text-gray-500 text-center">
        « Without leaps of imagination, or dreaming, we lose the excitement of possibilities. Dreaming, after all, is a
        form of planning. » — Gloria Steinem
      </div>
    </div>

    <div v-if="getToken()" class="fixed left-0 bottom-12 flex justify-center w-100%">
      <UDialog v-model:open="_isCreateDialogOpen" title="Create Post" description="Add a new post with a description">
        <template #trigger>
          <UButton btn="solid-gray">
            Create Post
          </UButton>
        </template>

        <div class="grid gap-4 py-4">
          <div class="grid gap-2">
            <div class="grid grid-cols-3 items-center gap-4">
              <ULabel for="name">
                Name
              </ULabel>
              <UInput id="name" v-model="_name" :una="{
                inputWrapper: 'col-span-2',
              }" />
            </div>
            <div class="grid grid-cols-3 items-center gap-4">
              <ULabel for="description">
                Description
              </ULabel>
              <UInput id="description" v-model="_description" :una="{
                inputWrapper: 'col-span-2',
              }" />
            </div>
            <div class="grid grid-cols-3 items-center gap-4">
              <ULabel for="category">
                Category
              </ULabel>
              <div flex flex-row gap-2>
                <USelect id="category" :una="{
                }" v-model="_category" :items="_categories" placeholder="Select a category" />
                <UTooltip>
                  <template #default>
                    <UButton btn="outline" icon label="i-icon-park-outline:add-print" class=""
                      @click="toggleAddCategory" />
                  </template>
                  <template #content>
                    <button @click="toggleAddCategory" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1
                      rounded-md m-0 border-1 border-dashed class="b-#3D3BF3">
                      Add a new category
                    </button>
                  </template>
                </UTooltip>
              </div>
            </div>
          </div>
        </div>

        <template #footer>
          <UButton @click="createPost({ name: _name, description: _description, category: _category })" btn="solid"
            label="Create post" />
        </template>
      </UDialog>
    </div>
  </div>
</template>

<script lang="ts" setup>
import type { CreatePostType, PostType } from '~/types/post'
import { useAuth } from '~/composables/useAuth'

const { getValidToken, getToken } = useAuth()

useHead({
  title: "rootasjey • reflexions",
  meta: [
    {
      name: 'description',
      content: "A space for thoughts and insights",
    },
  ],
})

const _name = ref('')
const _description = ref('')
const _category = ref('')
const _isCreateDialogOpen = ref(false)
const _categories = ref([
  "Tech",
  "Development",
  "Cinema",
  "Literature",
  "Music",
])

const _isLoading = ref(true)
const _showDrafts = ref(false)
const drafts = ref<PostType[]>([])

const { data } = await useFetch("/api/posts", {
  headers: {
    "Authorization": await getValidToken(),
  },
})

const posts = data.value as PostType[] ?? []

const createPost = async ({ name, description, category }: CreatePostType) => {
  _isCreateDialogOpen.value = false

  const { data } = await useFetch("/api/posts/create", {
    method: "POST",
    body: {
      name,
      description,
      category,
    },
    headers: {
      "Authorization": await getValidToken(),
    },
  })
}

const toggleAddCategory = () => {
  // const category = prompt('Enter a new category')
  // if (category) {
  //   categories.value[category] = []
  // }
  // console.log(categories.value)
  // return category
}

const fetchDrafts = async () => {
  if (!_showDrafts.value) {
    _isLoading.value = false
    return
  }

  try {
    const data = await $fetch("/api/posts/drafts", {
      headers: {
        "Authorization": await getValidToken(),
      },
    })
  
    drafts.value = data as PostType[] ?? []
    _isLoading.value = false
  } catch (error) {
    console.error(error)
    _isLoading.value = false
  }
}

onMounted(() => {
  _showDrafts.value = localStorage.getItem('show_drafts') === 'true'
  fetchDrafts()
})

watch(_showDrafts, async (show) => {
  localStorage.setItem('show_drafts', show.toString())
  if (!show || _isLoading.value) {
    drafts.value = []
    return
  }
  
  const data = await $fetch("/api/posts/drafts", {
    headers: {
      "Authorization": await getValidToken(),
    },
  })

  drafts.value = data as PostType[] ?? []
})

</script>
