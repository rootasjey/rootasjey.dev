<template>
  <div class="space-y-6">
    <!-- Topic Information -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div>
        <ULabel for="create-name" class="mb-2">Topic Name *</ULabel>
        <UInput
          id="create-name"
          v-model="form.name"
          placeholder="Enter topic name"
          :disabled="isSaving"
          required
        />
      </div>
      
      <div>
        <ULabel for="create-icon" class="mb-2">Icon</ULabel>
        <UInput
          id="create-icon"
          v-model="form.icon"
          placeholder="e.g., i-ph-code"
          :disabled="isSaving"
        />
      </div>
    </div>

    <div>
      <ULabel for="create-description" class="mb-2">Description</ULabel>
      <UInput
        id="create-description"
        v-model="form.description"
        placeholder="Enter topic description"
        :disabled="isSaving"
      />
    </div>

    <div>
      <ULabel for="create-difficulty" class="mb-2">Difficulty</ULabel>
      <USelect
        id="create-difficulty"
        v-model="form.difficulty"
        :items="difficultyOptions"
        :disabled="isSaving"
      />
    </div>

    <!-- Card Pairs Section -->
    <div>
      <div class="flex items-center justify-between mb-4">
        <ULabel class="text-lg font-600">Card Pairs *</ULabel>
        <UButton
          @click="addCardPair"
          btn="soft-blue"
          size="sm"
          leading="i-ph-plus"
          :disabled="isSaving"
        >
          Add Pair
        </UButton>
      </div>

      <!-- Card Pairs List -->
      <div class="space-y-4">
        <div
          v-for="(pair, index) in form.cardPairs"
          :key="index"
          class="border border-gray-200 dark:border-gray-700 rounded-lg p-4 bg-gray-50 dark:bg-gray-800/50"
        >
          <div class="flex items-center justify-between mb-3">
            <h4 class="font-600 text-gray-800 dark:text-gray-200">Pair {{ index + 1 }}</h4>
            <UButton
              @click="removeCardPair(index)"
              btn="ghost-red"
              size="sm"
              leading="i-ph-trash"
              :disabled="isSaving"
            >
              Remove
            </UButton>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <!-- Card 1 -->
            <div class="space-y-2">
              <ULabel class="text-sm font-500">Card 1 *</ULabel>
              <UInput
                v-model="pair.pair1.text"
                placeholder="Card 1 text"
                :disabled="isSaving"
                required
              />
              <UInput
                v-model="pair.pair1.icon"
                placeholder="Card 1 icon (e.g., i-ph-star)"
                :disabled="isSaving"
                required
              />
            </div>

            <!-- Card 2 -->
            <div class="space-y-2">
              <ULabel class="text-sm font-500">Card 2 *</ULabel>
              <UInput
                v-model="pair.pair2.text"
                placeholder="Card 2 text"
                :disabled="isSaving"
                required
              />
              <UInput
                v-model="pair.pair2.icon"
                placeholder="Card 2 icon (e.g., i-ph-heart)"
                :disabled="isSaving"
                required
              />
            </div>
          </div>

          <!-- Fact -->
          <div>
            <ULabel class="text-sm font-500 mb-2">Fun Fact *</ULabel>
            <UInput
              v-model="pair.fact"
              type="textarea"
              placeholder="Enter an interesting fact about this pair..."
              :rows="2"
              :disabled="isSaving"
              required
            />
          </div>
        </div>

        <!-- Empty state for card pairs -->
        <div v-if="form.cardPairs.length === 0" class="text-center py-8 border-2 border-dashed border-gray-300 dark:border-gray-600 rounded-lg">
          <div class="text-4xl mb-2">🃏</div>
          <p class="text-gray-600 dark:text-gray-400 mb-4">Add card pairs to create your topic</p>
          <UButton
            @click="addCardPair"
            btn="soft-blue"
            leading="i-ph-plus"
            :disabled="isSaving"
          >
            Add First Pair
          </UButton>
        </div>
      </div>
    </div>

    <!-- JSON Editor (Advanced) -->
    <UCollapsible>
      <UCollapsibleTrigger class="flex items-center gap-2 text-sm font-500 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200">
        <span class="i-ph-code"></span>
        Advanced: Edit JSON directly
      </UCollapsibleTrigger>
      <UCollapsibleContent class="mt-4">
        <ULabel class="mb-2">Card Pairs JSON</ULabel>
        <UInput
          v-model="jsonInput"
          type="textarea"
          placeholder="Edit card pairs as JSON..."
          :rows="10"
          class="font-mono text-sm"
          :disabled="isSaving"
          @blur="parseJsonInput"
        />
        <p class="text-xs text-gray-500 mt-2">
          Edit the JSON directly for advanced users. Changes will be applied when you click outside the textarea.
        </p>
      </UCollapsibleContent>
    </UCollapsible>

    <!-- Validation Errors -->
    <div v-if="validationErrors.length > 0" class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
      <h4 class="font-600 text-red-800 dark:text-red-200 mb-2">Please fix the following errors:</h4>
      <ul class="list-disc list-inside text-sm text-red-700 dark:text-red-300 space-y-1">
        <li v-for="error in validationErrors" :key="error">{{ error }}</li>
      </ul>
    </div>

    <!-- Action Buttons -->
    <div class="flex gap-2 justify-end pt-4 border-t border-gray-200 dark:border-gray-700">
      <UButton
        @click="$emit('cancel')"
        btn="ghost-gray"
        :disabled="isSaving"
      >
        Cancel
      </UButton>
      <UButton
        @click="handleSave"
        btn="solid-blue"
        leading="i-ph-plus"
        :loading="isSaving"
        :disabled="!isFormValid"
      >
        Create Topic
      </UButton>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { TopicData } from '~/types/paired'

// Emits
const emit = defineEmits<{
  save: [topicData: TopicData & { name: string }]
  cancel: []
}>()

// Reactive state
const isSaving = ref(false)
const jsonInput = ref('[]')

// Form data
const form = ref<TopicData & { name: string }>({
  name: '',
  description: '',
  difficulty: 'medium',
  icon: 'i-ph-cards',
  cardPairs: []
})

// Difficulty options
const difficultyOptions = [
  { label: 'Easy', value: 'easy' },
  { label: 'Medium', value: 'medium' },
  { label: 'Hard', value: 'hard' }
]

// Validation
const validationErrors = computed(() => {
  const errors: string[] = []
  
  if (!form.value.name.trim()) {
    errors.push('Topic name is required')
  }
  
  if (form.value.cardPairs.length === 0) {
    errors.push('At least one card pair is required')
  }
  
  form.value.cardPairs.forEach((pair, index) => {
    if (!pair.pair1.text.trim()) {
      errors.push(`Pair ${index + 1}: Card 1 text is required`)
    }
    if (!pair.pair1.icon.trim()) {
      errors.push(`Pair ${index + 1}: Card 1 icon is required`)
    }
    if (!pair.pair2.text.trim()) {
      errors.push(`Pair ${index + 1}: Card 2 text is required`)
    }
    if (!pair.pair2.icon.trim()) {
      errors.push(`Pair ${index + 1}: Card 2 icon is required`)
    }
    if (!pair.fact.trim()) {
      errors.push(`Pair ${index + 1}: Fun fact is required`)
    }
  })
  
  return errors
})

const isFormValid = computed(() => validationErrors.value.length === 0)

// Update JSON input
const updateJsonInput = () => {
  jsonInput.value = JSON.stringify(form.value.cardPairs, null, 2)
}

// Parse JSON input
const parseJsonInput = () => {
  try {
    const parsed = JSON.parse(jsonInput.value)
    if (Array.isArray(parsed)) {
      form.value.cardPairs = parsed
    }
  } catch (error) {
    // Invalid JSON, revert to current form data
    updateJsonInput()
  }
}

// Add card pair
const addCardPair = () => {
  form.value.cardPairs.push({
    pair1: { text: '', icon: '' },
    pair2: { text: '', icon: '' },
    fact: ''
  })
  updateJsonInput()
}

// Remove card pair
const removeCardPair = (index: number) => {
  form.value.cardPairs.splice(index, 1)
  updateJsonInput()
}

// Handle save
const handleSave = async () => {
  if (!isFormValid.value) return
  
  isSaving.value = true
  try {
    emit('save', {
      name: form.value.name.trim(),
      description: form.value.description.trim(),
      difficulty: form.value.difficulty,
      icon: form.value.icon.trim() || 'i-ph-cards',
      cardPairs: form.value.cardPairs
    })
  } finally {
    isSaving.value = false
  }
}

// Watch for card pairs changes to update JSON
watch(() => form.value.cardPairs, updateJsonInput, { deep: true })

// Initialize with one empty card pair
onMounted(() => {
  addCardPair()
})
</script>
