<template>
  <div class="min-h-screen px-4 pb-[38vh] pt-8 md:pt-16">
    <div class="container mx-auto max-w-6xl">
      <div class="mt-24 flex justify-center items-center gap-3 mb-2">
        <h1 class="font-body text-6xl font-600 text-gray-800 dark:text-gray-200">
          Documents
        </h1>
      </div>

      <!-- Tabs -->
      <div class="w-full max-w-5xl mx-auto">
        <UTabs
          :model-value="activeTab"
          :default-value="activeTab"
          class="w-full"
          @update:model-value="handleTabChange"
        >
          <UTabsList class="mb-6 mx-auto grid grid-cols-2">
            <UTabsTrigger value="resumes" :leading="'i-ph-file-text-duotone'">
              Resumes / CVs
              <UBadge v-if="resumeCount" variant="soft" color="blue" size="xs" class="ml-2">{{ resumeCount }}</UBadge>
            </UTabsTrigger>
            <UTabsTrigger value="letters" :leading="'i-ph-envelope-duotone'">
              Cover Letters
              <UBadge v-if="lettersCount" variant="soft" color="violet" size="xs" class="ml-2">{{ lettersCount }}</UBadge>
            </UTabsTrigger>
          </UTabsList>

          <!-- Resumes Tab -->
          <UTabsContent value="resumes">
            <section class="bg-white dark:bg-neutral-900 rounded-xl p-6">
              <LoadingOrErrorState 
                v-if="pendingResumes || errorResumes"
                :loading="pendingResumes" 
                :error="errorResumes?.message || null" 
              />

              <template v-else>
                <div v-if="!resumeCount" class="text-center py-12">
                  <p class="text-gray-500 dark:text-gray-400">No resumes available yet.</p>
                </div>

                <template v-else>
                  <div class="flex flex-col gap-4 mb-6 md:flex-row md:items-center md:justify-between">
                    <div class="grid gap-3 sm:grid-cols-[minmax(12rem,1fr)_minmax(16rem,1fr)]">
                      <USelect
                        v-model="resumeLanguage"
                        :items="languageOptions"
                        item-key="label"
                        value-key="label"
                        placeholder="Filter by language"
                        class="w-full"
                      />
                      <UInput
                        v-model="resumeSearch"
                        icon="i-ph-magnifying-glass"
                        placeholder="Search resumes"
                        class="w-full"
                        autocomplete="off"
                      />
                    </div>
                    <div class="text-sm text-gray-500 dark:text-gray-400">
                      Showing {{ filteredResumes.length }} of {{ resumeCount }}
                    </div>
                  </div>

                  <div v-if="filteredResumes.length === 0" class="text-center py-12">
                    <p class="text-gray-500 dark:text-gray-400">No resumes match the current filters.</p>
                  </div>

                  <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                    <DocumentCard
                      v-for="resume in filteredResumes"
                      :key="resume.id"
                      :to="`/documents/cv/${resume.slug}`"
                      :title="resume.title"
                      :subtitle="resume.subtitle"
                      :badge="resume.type"
                      :language="resume.language"
                      :updated-at="resume.updatedAt"
                      :linked-count="resume.linkedLetters?.length"
                      class="hover:scale-101 hover:shadow-xl active:shadow-none active:scale-99"
                    />
                  </div>
                </template>
              </template>
            </section>
          </UTabsContent>

          <!-- Letters Tab -->
          <UTabsContent value="letters">
            <section class="bg-white dark:bg-neutral-900 rounded-xl p-6">
              <LoadingOrErrorState 
                v-if="pendingLetters || errorLetters"
                :loading="pendingLetters" 
                :error="errorLetters?.message || null" 
              />

              <template v-else>
                <div v-if="!lettersCount" class="text-center py-12">
                  <p class="text-gray-500 dark:text-gray-400">No cover letters available yet.</p>
                </div>

                <template v-else>
                  <div class="flex flex-col gap-4 mb-6 md:flex-row md:items-center md:justify-between">
                    <div class="grid gap-3 sm:grid-cols-[minmax(12rem,1fr)_minmax(14rem,1fr)_minmax(14rem,1fr)]">
                      <USelect
                        v-model="letterLanguage"
                        :items="languageOptions"
                        item-key="label"
                        value-key="label"
                        placeholder="Filter by language"
                        class="w-full"
                      />
                      <UInput
                        v-model="letterCompany"
                        icon="i-ph-buildings"
                        placeholder="Filter by company"
                        class="w-full"
                        autocomplete="off"
                      />
                      <UInput
                        v-model="letterRole"
                        icon="i-ph-briefcase"
                        placeholder="Filter by role"
                        class="w-full"
                        autocomplete="off"
                      />
                    </div>
                    <div class="text-sm text-gray-500 dark:text-gray-400">
                      Showing {{ filteredLetters.length }} of {{ lettersCount }}
                    </div>
                  </div>

                  <div v-if="filteredLetters.length === 0" class="text-center py-12">
                    <p class="text-gray-500 dark:text-gray-400">No cover letters match the current filters.</p>
                  </div>

                  <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                    <DocumentCard
                      v-for="letter in filteredLetters"
                      :key="letter.id"
                      :to="`/documents/letters/${letter.slug}`"
                      :title="letter.title"
                      :subtitle="buildLetterSubtitle(letter)"
                      :language="letter.language"
                      :updated-at="letter.updatedAt"
                      class="hover:scale-101 hover:shadow-xl active:shadow-none active:scale-99"
                    />
                  </div>
                </template>
              </template>
            </section>
          </UTabsContent>
        </UTabs>
      </div>

      <!-- Footer -->
      <footer class="mt-16 text-center">
        <ULink to="/" class="inline-flex items-center gap-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300">
          <span class="i-ph-arrow-left"></span>
          <span>Back to home</span>
        </ULink>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import type { Resume, CoverLetter } from '~/types/document'
import DocumentCard from '~/components/document/DocumentCard.vue'

type TabKey = 'resumes' | 'letters'
type LanguageFilter = 'all' | 'en' | 'fr'

const TAB_STORAGE_KEY = 'documents-active-tab'

const languageOptions: Array<{ label: string; value: LanguageFilter }> = [
  { label: 'All languages', value: 'all' },
  { label: 'Français', value: 'fr' },
  { label: 'English', value: 'en' },
]

const parseTab = (value: unknown): TabKey | null => {
  const candidate = Array.isArray(value) ? value[0] : value

  if (candidate === 'resumes' || candidate === 'letters') {
    return candidate
  }

  return null
}

const route = useRoute()
const router = useRouter()

const initialTab = parseTab(route.query.tab) ?? 'resumes'
const activeTab = ref<TabKey>(initialTab)
const resumeLanguage = ref<{ label: string; value: LanguageFilter }>({ label: 'All languages', value: 'all' })
const resumeSearch = ref('')
const letterLanguage = ref<{ label: string; value: LanguageFilter }>({ label: 'All languages', value: 'all' })
const letterCompany = ref('')
const letterRole = ref('')

const buildLetterSubtitle = (letter: CoverLetter) => {
  const role = letter.position || 'Position'
  return letter.companyName ? `${role} at ${letter.companyName}` : role
}

const handleTabChange = (value: string | number) => {
  if (typeof value !== 'string') {
    return
  }

  const parsed = parseTab(value)
  if (!parsed) {
    return
  }

  if (parsed !== activeTab.value) {
    activeTab.value = parsed
  }
}

definePageMeta({
  title: 'Documents - Resumes & Cover Letters',
  description: 'Browse my professional resumes and cover letters',
})

// Fetch resumes
const { data: resumes, pending: pendingResumes, error: errorResumes } = await useFetch<Resume[]>('/api/documents/resumes', {
  default: () => [],
})

// Fetch cover letters
const { data: letters, pending: pendingLetters, error: errorLetters } = await useFetch<CoverLetter[]>('/api/documents/letters', {
  default: () => [],
})

const resumeCount = computed(() => resumes.value?.length ?? 0)
const lettersCount = computed(() => letters.value?.length ?? 0)

const filteredResumes = computed(() => {
  const listed = (resumes.value ?? []) as Resume[]
  const language = resumeLanguage.value
  const query = resumeSearch.value.trim().toLowerCase()

  return listed.filter((resume) => {
    const matchesLanguage = language.value === 'all' || resume.language === language.value
    if (!matchesLanguage) {
      return false
    }

    if (!query) {
      return true
    }

    const haystack = [
      resume.title,
      resume.subtitle,
      resume.type,
      resume.tagline,
    ]

    return haystack.some((field) => field?.toLowerCase().includes(query))
  })
})

const filteredLetters = computed(() => {
  const listed = (letters.value ?? []) as CoverLetter[]
  const language = letterLanguage.value
  const companyQuery = letterCompany.value.trim().toLowerCase()
  const roleQuery = letterRole.value.trim().toLowerCase()

  return listed.filter((letter) => {
    const matchesLanguage = language.value === 'all' || letter.language === language.value
    if (!matchesLanguage) {
      return false
    }

    const matchesCompany = !companyQuery || (letter.companyName ?? '').toLowerCase().includes(companyQuery)
    const matchesRole = !roleQuery || (letter.position ?? '').toLowerCase().includes(roleQuery)

    return matchesCompany && matchesRole
  })
})

const updateRouteForTab = (tab: TabKey) => {
  if (!import.meta.client) {
    return
  }

  const current = parseTab(route.query.tab)

  if (tab === 'resumes') {
    if (!('tab' in route.query)) {
      return
    }

    const { tab: _tab, ...rest } = route.query as Record<string, string | string[]>
    router.replace({ query: rest })
    return
  }

  if (current === tab) {
    return
  }

  router.replace({
    query: {
      ...route.query,
      tab,
    },
  })
}

onMounted(() => {
  const storedTab = parseTab(window.localStorage.getItem(TAB_STORAGE_KEY))
  const queryTab = parseTab(route.query.tab)

  if (!queryTab && storedTab && storedTab !== activeTab.value) {
    activeTab.value = storedTab
  }

  watch(
    () => route.query.tab,
    (tab) => {
      const parsed = parseTab(tab)
      if (parsed) {
        if (parsed !== activeTab.value) {
          activeTab.value = parsed
        }
      } else if (activeTab.value !== 'resumes') {
        activeTab.value = 'resumes'
      }
    }
  )

  watch(activeTab, (tab) => {
    if (window.localStorage.getItem(TAB_STORAGE_KEY) !== tab) {
      window.localStorage.setItem(TAB_STORAGE_KEY, tab)
    }

    updateRouteForTab(tab)
  })
})

useHead({
  title: 'Documents - Resumes & Cover Letters',
  meta: [
    {
      name: 'description',
      content: 'Browse my professional resumes and cover letters',
    },
  ],
})
</script>

<style scoped>
section {
  box-sizing: border-box;
}
</style>
