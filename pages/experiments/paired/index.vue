<template>
  <div class="w-full flex flex-col items-center min-h-screen">
    <!-- Hero Section -->
    <section class="w-full max-w-4xl mt-24 md:mt-32 mb-16 text-center px-4">
      <h1 class="font-body text-4xl md:text-5xl font-600 mb-4 text-gray-800 dark:text-gray-200">
        Paired
      </h1>
      <h4 class="text-size-5 font-300 mb-8 text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
        Match pairs of cards by finding their connections. Flip cards to reveal their content and discover fascinating facts along the way.
      </h4>
    </section>

    <!-- Game Section -->
    <section class="w-full max-w-4xl px-4 mb-16">
      <div class="flex flex-col items-center justify-center">
        <!-- Topic Selection -->
        <div v-if="!gameStarted" class="topic-selection mb-8 w-full">
          <h3 class="text-xl font-600 text-gray-800 dark:text-gray-200 mb-4 text-center">
            Choose a Topic
          </h3>

          <div v-if="loadingTopics" class="text-center py-8">
            <div class="animate-spin w-8 h-8 border-2 border-blue-500 border-t-transparent rounded-full mx-auto mb-2"></div>
            <p class="text-gray-600 dark:text-gray-400">Loading topics...</p>
          </div>

          <div v-else-if="topics.length === 0" class="text-center py-8">
            <p class="text-gray-600 dark:text-gray-400 mb-4">No topics available</p>
            <UButton @click="seedInitialData" btn="outline-blue">
              Seed Initial Data
            </UButton>
          </div>

          <div v-else>
            <!-- Start Game Button (moved above topic cards) -->
            <UButton
              @click="startGame"
              :disabled="!selectedTopic || loadingGame"
              btn="~"
              class="w-full mb-6 light:btn-glowing dark:bg-[#426AFE]"
              leading="i-ph-play"
            >
              <span v-if="loadingGame">Loading...</span>
              <span v-else>Start Game</span>
            </UButton>

            <!-- Topic Cards with responsive layout -->
            <div class="space-y-3 md:grid md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-3 md:gap-4 md:space-y-0">
              <div
                v-for="topic in topics"
                :key="topic.id"
                class="topic-card cursor-pointer p-4 rounded-lg border-2 transition-all duration-200 hover:shadow-md relative"
                :class="selectedTopic?.id === topic.id
                  ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/20'
                  : 'border-gray-200 dark:border-gray-700 bg-white dark:bg-black hover:border-gray-300 dark:hover:border-gray-600'"
                @click="selectedTopic = topic"
              >
                <div class="flex items-center gap-3">
                  <span :class="topic.icon" class="text-2xl text-blue-600 dark:text-blue-400"></span>
                  <div class="flex-1">
                    <h4 class="font-semibold text-gray-800 dark:text-gray-200">{{ topic.name }}</h4>
                    <p class="text-sm text-gray-600 dark:text-gray-400">{{ topic.description }}</p>
                    <div class="flex items-center gap-4 mt-1">
                      <span class="text-xs text-gray-500 dark:text-gray-500">{{ topic.cardCount }} pairs</span>
                      <span class="text-xs font-500 px-3 py-1 rounded-full bg-gray-100 dark:bg-gray-900 text-gray-600 dark:text-gray-400">
                        {{ topic.difficulty }}
                      </span>
                    </div>
                  </div>

                  <!-- Play button for selected topic -->
                  <div
                    v-if="selectedTopic?.id === topic.id"
                    class="play-button flex items-center justify-center w-6 h-full bg-blue-500 hover:bg-blue-600 dark:bg-blue-600 dark:hover:bg-blue-700 text-white rounded-r-md transition-colors duration-200 absolute right-0 top-0 cursor-pointer"
                    @click.stop="startGame"
                  >
                    <span class="i-ph-play text-sm"></span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Game Stats -->
        <div v-if="gameStarted" class="flex gap-6 mb-6 text-center">
          <div class="stat-item">
            <div class="text-2xl font-600 text-gray-800 dark:text-gray-200">{{ moves }}</div>
            <div class="text-sm text-gray-600 dark:text-gray-400">Moves</div>
          </div>
          <div class="stat-item">
            <div class="text-2xl font-600 text-gray-800 dark:text-gray-200">{{ matchedPairs }}</div>
            <div class="text-sm text-gray-600 dark:text-gray-400">Pairs</div>
          </div>
          <div class="stat-item">
            <div class="text-2xl font-600 text-gray-800 dark:text-gray-200">{{ formatTime(elapsedTime) }}</div>
            <div class="text-sm text-gray-600 dark:text-gray-400">Time</div>
          </div>
        </div>

        <!-- Game Grid -->
        <div v-if="gameStarted" class="game-container mb-6 rounded-lg shadow-lg">
          <div class="grid grid-cols-4 gap-3 p-4">
            <div
              v-for="(card, index) in cards"
              :key="`card-${index}`"
              class="card"
              :class="{ 
                'flipped': card.isFlipped || card.isMatched,
                'matched': card.isMatched,
                'disabled': isProcessing || gameWon
              }"
              @click="flipCard(index)"
            >
              <!-- Card Back -->
              <div class="card-face card-back">
                <div class="card-number">{{ index + 1 }}</div>
              </div>
              <!-- Card Front -->
              <div class="card-face card-front">
                <div class="card-content">
                  <div class="card-icon" :class="card.icon"></div>
                  <div class="card-text">{{ card.text }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Controls -->
        <div v-if="gameStarted" class="controls flex flex-wrap gap-4 justify-center mb-8">
          <UButton
            @click="backToTopicSelection"
            btn="outline-gray"
            leading="i-ph-arrow-left"
          >
            Back to Topics
          </UButton>

          <UButton
            @click="resetGame"
            btn="outline-gray"
            leading="i-ph-arrow-clockwise"
          >
            New Game
          </UButton>

          <UButton
            @click="shuffleCards"
            btn="outline-gray"
            leading="i-ph-shuffle"
            :disabled="gameWon"
          >
            Shuffle
          </UButton>
        </div>

        <!-- Fun Fact Display -->
        <div
          v-if="gameStarted && currentFact"
          class="fact-display bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4 mb-8 max-w-2xl"
        >
          <div class="flex items-start gap-3">
            <span class="i-ph-lightbulb text-blue-600 dark:text-blue-400 text-xl flex-shrink-0 mt-1"></span>
            <div class="flex-1">
              <h4 class="font-semibold text-blue-800 dark:text-blue-200 mb-2">Did you know?</h4>
              <p class="text-blue-700 dark:text-blue-300 text-sm leading-relaxed">{{ currentFact }}</p>
            </div>
            <button
              @click="currentFact = ''"
              class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-200 transition-colors flex-shrink-0"
              aria-label="Close fun fact"
            >
              <span class="i-ph-x text-lg"></span>
            </button>
          </div>
        </div>

        <!-- Win Message -->
        <div
          v-if="gameStarted && gameWon"
          class="win-message bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-lg p-6 text-center max-w-md"
        >
          <div class="text-4xl mb-3">🎉</div>
          <h3 class="text-xl font-600 text-green-800 dark:text-green-200 mb-2">Congratulations!</h3>
          <p class="text-green-700 dark:text-green-300 mb-4">
            You completed the game in {{ moves }} moves and {{ formatTime(elapsedTime) }}!
          </p>
          <UButton
            @click="resetGame"
            btn="~"
            class="light:btn-glowing dark:bg-[#426AFE]"
            leading="i-ph-play"
          >
            Play Again
          </UButton>
        </div>
      </div>
    </section>

    <!-- Game Story Section -->
    <section class="w-full max-w-4xl px-4 mb-16">
      <div class="explanations border b-transparent bg-gray-50 dark:bg-[#111] dark:hover:b-gray-600 rounded-lg p-6">
        <h3 class="text-2xl font-600 text-gray-800 dark:text-gray-200 mb-4">
          <span class="i-ph-cards mr-2"></span>
          The Memory Challenge
        </h3>
        
        <p class="text-gray-700 dark:text-gray-300 mb-6 leading-relaxed">
          Memory card games have been fascinating humans for centuries, challenging our ability to remember patterns and locations. 
          This digital version pairs programming concepts with their real-world applications, creating connections that help reinforce learning.
        </p>

        <h4 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-3">How to Play</h4>
        <ul class="text-gray-700 dark:text-gray-300 mb-6 space-y-2">
          <li>Click any card to reveal its content</li>
          <li>Click a second card to find its match</li>
          <li>If the cards match, they stay revealed and you learn a fun fact</li>
          <li>If they don't match, they flip back after a brief moment</li>
          <li>Continue until all pairs are matched</li>
        </ul>

        <h4 class="text-lg font-semibold text-gray-800 dark:text-gray-200 mb-3">Learning Through Play</h4>
        <p class="text-gray-700 dark:text-gray-300 leading-relaxed">
          Each successful match reveals interesting facts about programming, technology, and computer science. 
          The game combines the satisfaction of pattern recognition with the joy of discovery, making learning both engaging and memorable.
        </p>
      </div>
    </section>

    <Footer class="mt-24 mb-42" />
  </div>
</template>

<script lang="ts" setup>
import type { Card, CardPair, Topic } from '~/types/paired'

// SEO
useHead({
  title: "Paired • experiments • rootasjey",
  meta: [
    {
      name: 'description',
      content: "A memory card matching game that teaches programming concepts through play",
    },
  ],
})

// Game state
const cards = ref<Card[]>([])
const flippedCards = ref<number[]>([])
const moves = ref(0)
const matchedPairs = ref(0)
const isProcessing = ref(false)
const gameWon = ref(false)
const currentFact = ref('')
const startTime = ref<number | null>(null)
const elapsedTime = ref(0)
const timerInterval = ref<NodeJS.Timeout | null>(null)

// Topic selection state
const topics = ref<Topic[]>([])
const selectedTopic = ref<Topic | null>(null)
const loadingTopics = ref(false)
const loadingGame = ref(false)
const gameStarted = ref(false)
const currentCardPairs = ref<CardPair[]>([])

// Card data - programming concepts and their applications
const cardPairs = [
  {
    pair1: { text: "Algorithm", icon: "i-ph-flow-arrow" },
    pair2: { text: "Recipe", icon: "i-ph-cooking-pot" },
    fact: "Algorithms are like recipes - they're step-by-step instructions to solve a problem or complete a task."
  },
  {
    pair1: { text: "Variable", icon: "i-ph-package" },
    pair2: { text: "Container", icon: "i-ph-archive-box" },
    fact: "Variables in programming are like labeled containers that store different types of data."
  },
  {
    pair1: { text: "Function", icon: "i-ph-function" },
    pair2: { text: "Machine", icon: "i-ph-gear" },
    fact: "Functions are like machines - you put something in (input), it processes it, and gives you something back (output)."
  },
  {
    pair1: { text: "Loop", icon: "i-ph-arrow-clockwise" },
    pair2: { text: "Repeat", icon: "i-ph-repeat" },
    fact: "Loops allow computers to repeat tasks efficiently, just like how you might repeat a daily routine."
  },
  {
    pair1: { text: "Database", icon: "i-ph-database" },
    pair2: { text: "Library", icon: "i-ph-books" },
    fact: "Databases organize and store information systematically, much like how libraries organize books."
  },
  {
    pair1: { text: "API", icon: "i-ph-plugs-connected" },
    pair2: { text: "Waiter", icon: "i-ph-user-circle" },
    fact: "APIs are like waiters - they take your request, communicate with the kitchen (server), and bring back what you ordered."
  },
  {
    pair1: { text: "Bug", icon: "i-ph-bug" },
    pair2: { text: "Error", icon: "i-ph-warning" },
    fact: "The term 'bug' in programming comes from an actual moth found in a computer relay in 1947 by Grace Hopper."
  },
  {
    pair1: { text: "Cloud", icon: "i-ph-cloud" },
    pair2: { text: "Internet", icon: "i-ph-globe" },
    fact: "Cloud computing means using someone else's computer over the internet instead of your own local machine."
  }
]

// Game functions
const initializeGame = () => {
  // Use current card pairs (dynamic) or fallback to hardcoded for backward compatibility
  const pairsToUse = currentCardPairs.value.length > 0 ? currentCardPairs.value : cardPairs

  // Create card pairs
  const gameCards: Card[] = []

  pairsToUse.forEach((pair, index) => {
    // Add first card of the pair
    gameCards.push({
      id: index * 2,
      text: pair.pair1.text,
      icon: pair.pair1.icon,
      pairId: index,
      isFlipped: false,
      isMatched: false,
      fact: pair.fact
    })

    // Add second card of the pair
    gameCards.push({
      id: index * 2 + 1,
      text: pair.pair2.text,
      icon: pair.pair2.icon,
      pairId: index,
      isFlipped: false,
      isMatched: false,
      fact: pair.fact
    })
  })

  // Shuffle the cards
  cards.value = shuffleArray(gameCards)

  // Reset game state
  flippedCards.value = []
  moves.value = 0
  matchedPairs.value = 0
  isProcessing.value = false
  gameWon.value = false
  currentFact.value = ''
  startTime.value = null
  elapsedTime.value = 0

  // Clear any existing timer
  if (timerInterval.value) {
    clearInterval(timerInterval.value)
    timerInterval.value = null
  }
}

const shuffleArray = <T>(array: T[]): T[] => {
  const shuffled = [...array]
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]]
  }
  return shuffled
}

const flipCard = (index: number) => {
  if (isProcessing.value || cards.value[index].isFlipped || cards.value[index].isMatched || gameWon.value) {
    return
  }

  // Start timer on first move
  if (startTime.value === null) {
    startTime.value = Date.now()
    timerInterval.value = setInterval(() => {
      if (startTime.value) {
        elapsedTime.value = Math.floor((Date.now() - startTime.value) / 1000)
      }
    }, 1000)
  }

  // Flip the card
  cards.value[index].isFlipped = true
  flippedCards.value.push(index)

  // Check if we have two flipped cards
  if (flippedCards.value.length === 2) {
    moves.value++
    isProcessing.value = true

    const [firstIndex, secondIndex] = flippedCards.value
    const firstCard = cards.value[firstIndex]
    const secondCard = cards.value[secondIndex]

    // Check if cards match
    if (firstCard.pairId === secondCard.pairId) {
      // Match found!
      setTimeout(() => {
        firstCard.isMatched = true
        secondCard.isMatched = true
        matchedPairs.value++

        // Show fun fact
        currentFact.value = firstCard.fact

        // Check if game is won
        const pairsToUse = currentCardPairs.value.length > 0 ? currentCardPairs.value : cardPairs
        if (matchedPairs.value === pairsToUse.length) {
          gameWon.value = true
          if (timerInterval.value) {
            clearInterval(timerInterval.value)
            timerInterval.value = null
          }
        }

        flippedCards.value = []
        isProcessing.value = false
      }, 1000)
    } else {
      // No match - flip cards back
      setTimeout(() => {
        firstCard.isFlipped = false
        secondCard.isFlipped = false
        flippedCards.value = []
        isProcessing.value = false
      }, 1500)
    }
  }
}

const resetGame = () => {
  initializeGame()
}

const shuffleCards = () => {
  if (gameWon.value) return

  // Keep matched cards in place, shuffle only unmatched cards
  const unmatchedCards = cards.value.filter(card => !card.isMatched)
  const matchedCards = cards.value.filter(card => card.isMatched)

  // Reset unmatched cards
  unmatchedCards.forEach(card => {
    card.isFlipped = false
  })

  // Shuffle unmatched cards
  const shuffledUnmatched = shuffleArray(unmatchedCards)

  // Rebuild the cards array
  const newCards: Card[] = []
  let unmatchedIndex = 0

  cards.value.forEach(card => {
    if (card.isMatched) {
      newCards.push(card)
    } else {
      newCards.push(shuffledUnmatched[unmatchedIndex])
      unmatchedIndex++
    }
  })

  cards.value = newCards
  flippedCards.value = []
  isProcessing.value = false
}

const formatTime = (seconds: number): string => {
  const mins = Math.floor(seconds / 60)
  const secs = seconds % 60
  return `${mins}:${secs.toString().padStart(2, '0')}`
}

// Topic management functions
const fetchTopics = async () => {
  loadingTopics.value = true
  try {
    const response = await $fetch('/api/experiments/paired/topics') as any
    if (response.success) {
      topics.value = response.topics
    }
  } catch (error) {
    console.error('Error fetching topics:', error)
  } finally {
    loadingTopics.value = false
  }
}

const seedInitialData = async () => {
  try {
    await $fetch('/api/experiments/paired/seed', { method: 'POST' } as any)
    await fetchTopics()
  } catch (error) {
    console.error('Error seeding data:', error)
  }
}

const startGame = async () => {
  if (!selectedTopic.value) return

  loadingGame.value = true
  try {
    const response = await $fetch(`/api/experiments/paired/${selectedTopic.value.id}`) as any
    if (response.success) {
      currentCardPairs.value = response.topic.cardPairs
      gameStarted.value = true
      initializeGame()
    }
  } catch (error) {
    console.error('Error loading game data:', error)
  } finally {
    loadingGame.value = false
  }
}

const backToTopicSelection = () => {
  gameStarted.value = false
  selectedTopic.value = null
  // Reset game state
  cards.value = []
  flippedCards.value = []
  moves.value = 0
  matchedPairs.value = 0
  isProcessing.value = false
  gameWon.value = false
  currentFact.value = ''
  startTime.value = null
  elapsedTime.value = 0
  if (timerInterval.value) {
    clearInterval(timerInterval.value)
    timerInterval.value = null
  }
}

// Initialize game on mount
onMounted(() => {
  fetchTopics()
})

// Cleanup timer on unmount
onUnmounted(() => {
  if (timerInterval.value) {
    clearInterval(timerInterval.value)
  }
})
</script>

<style scoped>
.game-container {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(229, 231, 235, 0.5);
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.dark .game-container {
  background: rgba(17, 24, 39, 0.8);
  border: 1px solid rgba(75, 85, 99, 0.5);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3), 0 2px 4px -1px rgba(0, 0, 0, 0.2);
}

.card {
  position: relative;
  width: 100px;
  height: 120px;
  cursor: pointer;
  perspective: 1000px;

  &.disabled {
    cursor: not-allowed;
  }
}

.card-face {
  position: absolute;
  width: 100%;
  height: 100%;
  backface-visibility: hidden;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.6s ease-in-out;
  border: 2px solid rgba(229, 231, 235, 0.6);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.card-back {
  background: linear-gradient(135deg, #f8fafc, #e2e8f0);
  transform: rotateY(0deg);
}

.dark .card-back {
  background: linear-gradient(135deg, #374151, #1f2937);
  border-color: rgba(75, 85, 99, 0.6);
}

.card-front {
  background: linear-gradient(135deg, #ffffff, #f1f5f9);
  transform: rotateY(180deg);
  flex-direction: column;
  gap: 8px;
  padding: 12px;
}

.dark .card-front {
  background: linear-gradient(135deg, #1e293b, #0f172a);
  border-color: rgba(75, 85, 99, 0.6);
}

.card.flipped .card-back {
  transform: rotateY(-180deg);
}

.card.flipped .card-front {
  transform: rotateY(0deg);
}

.card.matched .card-face {
  border-color: #10b981;
  box-shadow: 0 0 12px rgba(16, 185, 129, 0.3);
}

.card-number {
  font-size: 1.5rem;
  font-weight: 600;
  color: #64748b;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.dark .card-number {
  color: #94a3b8;
}

.card-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  text-align: center;
}

.card-icon {
  font-size: 2rem;
  color: #3b82f6;
}

.dark .card-icon {
  color: #60a5fa;
}

.card-text {
  font-size: 0.75rem;
  font-weight: 500;
  color: #374151;
  line-height: 1.2;
}

.dark .card-text {
  color: #d1d5db;
}

.card:hover:not(.disabled) .card-face {
  transform: scale(1.02);
}

.card:hover:not(.disabled).flipped .card-back {
  transform: rotateY(180deg) scale(1.02);
}

.card:hover:not(.disabled).flipped .card-front {
  transform: rotateY(0deg) scale(1.02);
}

.stat-item {
  padding: 0.5rem;
}

.fact-display {
  animation: slideIn 0.5s ease-out;
}

.win-message {
  animation: bounceIn 0.8s ease-out;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes bounceIn {
  0% {
    opacity: 0;
    transform: scale(0.3);
  }
  50% {
    opacity: 1;
    transform: scale(1.05);
  }
  70% {
    transform: scale(0.9);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}

/* Topic card play button styling */
.topic-card {
  position: relative;
}

.play-button {
  width: 25px;
  border-top-left-radius: 0;
  border-bottom-left-radius: 0;
  border-left: 1px solid rgba(59, 130, 246, 0.3);
  transition: width 0.2s ease;
}

.play-button:hover {
  width: 30px;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .card {
    width: 80px;
    height: 100px;
  }

  .card-icon {
    font-size: 1.5rem;
  }

  .card-text {
    font-size: 0.7rem;
  }

  .card-number {
    font-size: 1.2rem;
  }
}

@media (max-width: 640px) {
  .card {
    width: 70px;
    height: 90px;
  }

  .card-icon {
    font-size: 1.25rem;
  }

  .card-text {
    font-size: 0.65rem;
  }

  .card-number {
    font-size: 1rem;
  }

  .game-container .grid {
    gap: 0.5rem;
  }
}
</style>
