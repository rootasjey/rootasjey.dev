<template>
  <div class="w-[600px] rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <!-- Header -->
    <header class="mt-12 mb-8">
      <div class="flex gap-2">
        <ULink to="/" class="hover:scale-102 active:scale-99 transition">
          <span class="i-ph-house-simple-duotone"></span>
        </ULink>
        <span>•</span>
        <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
          Reflexions
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
      <p class="text-gray-700 dark:text-gray-300">
        Thoughts and reflections on various topics
      </p>
      <div>
        <UProgress v-if="_isLoading" :indeterminate="true" size="sm" color="primary" />

        <!-- Create Post Button -->
        <div v-if="loggedIn">
          <UDialog v-model:open="_isCreateDialogOpen" title="Create Post" description="Add a new post with a description">
            <template #trigger>
              <UButton btn="text" size="xs" class="-ml-4 flex items-center gap-2 dark:text-amber-400">
                <span>Add a post</span>
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
    </header>

    <!-- Drafts Section -->
    <section v-if="loggedIn" class="mb-6">
      <UButton btn="text" class="p-0 flex gap-3 font-500 text-gray-800 dark:text-gray-200 mb-4"
        @click="_showDrafts = !_showDrafts">
        <span class="i-icon-park-outline:notebook-and-pen text-3"></span>
        <span class="text-3">Drafts</span>
        <span v-if="!_showDrafts" class="text-3">••• <i class="ml-2">(show)</i></span>
        <span v-else class="text-3">••• <i class="ml-2">(hide)</i></span>
      </UButton>
      <div class="flex flex-col gap-6">
        <div v-if="_showDrafts && drafts.length > 0" v-for="draft in drafts" :key="draft.id.toString()" class="border-b border-gray-200 dark:border-gray-800 pb-4">
          <ULink :to="`/reflexions/${draft.id}`" class="flex items-start gap-2">
            <h3 class="text-size-4 font-500 line-height-4.5 dark:text-gray-300">
              {{ draft.name }}
            </h3>
          </ULink>
          <p class="text-size-3 text-gray-700 dark:text-gray-400 mb-2">{{ draft.description }}</p>
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
    </section>

    <!-- Published Posts Section -->
    <section v-if="posts.length > 0" class="mb-12">
      <h2 class="text-3 font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-article mr-2"></span>
        Published
      </h2>
      <div class="flex flex-col gap-6">
        <div v-for="post in posts" :key="post.id.toString()" class="border-b border-gray-200 dark:border-gray-800 pb-4">
          <ULink :to="`/reflexions/${post.slug}`">
            <h3 class="text-size-3.5 font-600 text-gray-800 dark:text-gray-200">{{ post.name }}</h3>
          </ULink>
          <p class="text-size-3 text-gray-700 dark:text-gray-400 mb-2">{{ post.description }}</p>
          <div class="flex justify-between items-center">
            <span class="text-size-3 text-gray-500 dark:text-gray-600">
              {{ new Date(post.created_at).toLocaleString("fr", {
                month: "long",
                day: "numeric",
                year: "numeric",
              }) }}
            </span>
          </div>
        </div>
      </div>
    </section>

    <!-- Empty State -->
    <section v-if="posts?.length === 0 && drafts?.length === 0" class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-quotes mr-2"></span>
        A Thought to Ponder
      </h2>
      <div class="text-sm font-medium text-gray-500 dark:text-gray-400 mb-2">
        Because there's no published posts yet, here is a quote:
      </div>
      <div class="text-xl font-300 text-gray-600 dark:text-gray-400 italic">
        « Without leaps of imagination, or dreaming, we lose the excitement of possibilities. Dreaming, after all, is a
        form of planning. »
      </div>
      <div class="text-right text-gray-500 dark:text-gray-500 mt-2">
        — Gloria Steinem
      </div>
    </section>

    <Footer>
      <template #links>
        <ULink to="/projects" class="footer-button flex items-center gap-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors">
          <span class="i-ph-app-window text-size-3 -mt-1"></span>
          <span class="font-500 text-size-3 relative -top-0.5">See projects</span>
        </ULink>
      </template>
    </Footer>
  </div>
</template>

<script lang="ts" setup>
import type { CreatePostType, PostType } from '~/types/post'
const { loggedIn } = useUserSession()

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

const { data } = await useFetch("/api/posts")

// const posts = data.value ?? []
const posts = data.value as unknown as PostType[] ?? []

const createPost = async ({ name, description, category }: CreatePostType) => {
  _isCreateDialogOpen.value = false

  const { data } = await useFetch("/api/posts/create", {
    method: "POST",
    body: {
      name,
      description,
      category,
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
    const draftData = await $fetch("/api/posts/drafts")
  
    drafts.value = draftData as unknown as PostType[] ?? []
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
  
  const data = await $fetch("/api/posts/drafts")

  drafts.value = data as unknown as PostType[] ?? []
})
</script>
