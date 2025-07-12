<template>
  <div class="w-full flex flex-col items-center min-h-screen">
    <!-- Hero Section -->
    <section class="w-full max-w-4xl mt-24 md:mt-32 mb-16 text-center px-4">
      <h1 class="font-body text-4xl md:text-5xl font-600 mb-4 text-gray-800 dark:text-gray-200">
        Conway's Game of Life
      </h1>
      <h4 class="text-size-5 font-300 mb-8 text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
        A cellular automaton that demonstrates how complex patterns can emerge from simple rules.
        Click cells to bring them to life, then watch evolution unfold.
      </h4>
    </section>

    <!-- Game Section -->
    <section class="w-full max-w-4xl px-4 mb-16">
      <div class="flex flex-col items-center justify-center">
        <div class="grid-container mb-6 rounded-lg shadow-lg">
          <div
            v-for="(row, rowIndex) in grid"
            :key="`row-${rowIndex}`"
            class="flex"
          >
            <div
              v-for="(cell, colIndex) in row"
              :key="`cell-${rowIndex}-${colIndex}`"
              class="cell"
              :class="{ 'alive': cell === 1 }"
              @mousedown="startPainting(rowIndex, colIndex)"
              @mouseover="paintCell(rowIndex, colIndex)"
              @mouseup="stopPainting"
            ></div>
          </div>
        </div>

        <div class="controls flex flex-wrap gap-4 justify-center mb-8">
          <UButton
           @click="toggleSimulation"
           :btn="isRunning ? '~' : '~'"
           :class="{
              'light:btn-glowing dark:bg-[#426AFE]': !isRunning,
              'bg-pink-6 dark:bg-[#15F5BA] dark:color-black': isRunning
            }"
           :label="isRunning ? 'Stop' : 'Start'"
           :trailing="isRunning ? 'i-ph-pause' : 'i-ph-play'"
          />

          <UButton
            @click="resetGrid"
            btn="outline-gray"
            leading="i-ph-arrow-clockwise"
          >
            Reset
          </UButton>

          <UButton
            @click="randomizeGrid"
            btn="outline-gray"
            leading="i-ph-shuffle"
          >
            Randomize
          </UButton>
        </div>
      </div>
    </section>

    <!-- Explanation Section -->
    <section class="w-full max-w-4xl px-4 mb-24">
      <div class="explanations max-w-2xl mx-auto text-gray-700 dark:text-gray-300">
        <div class="border-b border-dashed border-gray-300 dark:border-gray-600 w-full mb-12"></div>

        <h2 class="font-body text-2xl font-600 text-gray-800 dark:text-gray-200 mb-6">
          About the Game of Life
        </h2>

        <p class="text-gray-700 dark:text-gray-300 mb-6 text-lg leading-relaxed">
          The Game of Life is a cellular automaton devised by mathematician John Conway in 1970.
          It's a zero-player game, meaning its evolution is determined by its initial state, requiring no further input.
        </p>

        <p class="text-gray-700 dark:text-gray-300 mb-6 leading-relaxed">
          What makes this cellular automaton truly fascinating is its computational universality. Despite having only four simple rules,
          the Game of Life is Turing complete, meaning it can simulate any computation that can be performed by a computer.
          In fact, it's theoretically possible to build the entire Game of Life <em>within itself</em> – creating a recursive,
          self-contained universe where patterns can compute, store information, and even replicate themselves.
        </p>

        <p class="text-gray-700 dark:text-gray-300 mb-8 leading-relaxed">
          I first discovered this mesmerizing world through <ULink to="https://www.youtube.com/watch?v=S-W0NX97DB0" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline">ScienceEtonnante's excellent video</ULink>
          which beautifully explains the mathematical foundations. Later, I watched an <ULink to="https://www.youtube.com/watch?v=gKgAaZ7a5Bs" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline">Arte documentary</ULink>
          that delved into Conway's life and mathematical legacy, and finally discovered <ULink to="https://www.youtube.com/watch?v=eMn43As24Bo" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline">Ego's visual exploration</ULink>
          of the stunning patterns that emerge from these simple rules.
        </p>

        <div class="border-b border-dashed border-gray-200 dark:border-gray-700 my-8" />

        <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-4">The Rules</h3>
        <ol class="list-decimal pl-6 space-y-3 text-base mb-8">
          <li class="text-gray-600 dark:text-gray-400">
            Any live cell with fewer than two live neighbors <span class="font-semibold text-red-500 dark:text-red-400">dies</span> (underpopulation)
          </li>
          <li class="text-gray-600 dark:text-gray-400">
            Any live cell with more than three live neighbors <span class="font-semibold text-red-500 dark:text-red-400">dies</span> (overpopulation)
          </li>
          <li class="text-gray-600 dark:text-gray-400">
            Any live cell with two or three live neighbors <span class="font-semibold text-green-500 dark:text-green-400">lives on</span> to the next generation
          </li>
          <li class="text-gray-600 dark:text-gray-400">
            Any dead cell with exactly three live neighbors <span class="font-semibold text-blue-500 dark:text-blue-400">becomes a live cell</span> (reproduction)
          </li>
        </ol>

        <div class="border-b border-dashed border-gray-200 dark:border-gray-700 my-8" />

        <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-4">Common Patterns</h3>
        <p class="text-gray-700 dark:text-gray-300 mb-6 leading-relaxed">
          Over the decades, enthusiasts have discovered and catalogued thousands of patterns. Here are some of the most fundamental ones:
        </p>

        <div class="patterns-grid grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          <div class="pattern-card bg-gray-50 dark:bg-gray-800 p-4 rounded-lg">
            <h4 class="font-semibold text-gray-800 dark:text-gray-200 mb-2">Still Lifes</h4>
            <div class="pattern-visual mb-2">
              <div class="mini-grid">
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                </div>
              </div>
            </div>
            <p class="text-sm text-gray-600 dark:text-gray-400">Block - remains unchanged</p>
          </div>

          <div class="pattern-card bg-gray-50 dark:bg-gray-800 p-4 rounded-lg">
            <h4 class="font-semibold text-gray-800 dark:text-gray-200 mb-2">Blinker</h4>
            <div class="pattern-visual mb-2">
              <div class="mini-grid">
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                </div>
              </div>
            </div>
            <p class="text-sm text-gray-600 dark:text-gray-400">Oscillates every 2 generations</p>
          </div>

          <div class="pattern-card bg-gray-50 dark:bg-gray-800 p-4 rounded-lg">
            <h4 class="font-semibold text-gray-800 dark:text-gray-200 mb-2">Glider</h4>
            <div class="pattern-visual mb-2">
              <div class="mini-grid">
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                </div>
              </div>
            </div>
            <p class="text-sm text-gray-600 dark:text-gray-400">Moves diagonally across the grid</p>
          </div>

          <div class="pattern-card bg-gray-50 dark:bg-gray-800 p-4 rounded-lg">
            <h4 class="font-semibold text-gray-800 dark:text-gray-200 mb-2">Beacon</h4>
            <div class="pattern-visual mb-2">
              <div class="mini-grid">
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                </div>
              </div>
            </div>
            <p class="text-sm text-gray-600 dark:text-gray-400">Oscillates every 2 generations</p>
          </div>

          <div class="pattern-card bg-gray-50 dark:bg-gray-800 p-4 rounded-lg">
            <h4 class="font-semibold text-gray-800 dark:text-gray-200 mb-2">Toad</h4>
            <div class="pattern-visual mb-2">
              <div class="mini-grid">
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                </div>
              </div>
            </div>
            <p class="text-sm text-gray-600 dark:text-gray-400">Oscillates every 2 generations</p>
          </div>

          <div class="pattern-card bg-gray-50 dark:bg-gray-800 p-4 rounded-lg">
            <h4 class="font-semibold text-gray-800 dark:text-gray-200 mb-2">Pulsar</h4>
            <div class="pattern-visual mb-2">
              <div class="mini-grid">
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                </div>
                <div class="mini-row">
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell alive"></div>
                  <div class="mini-cell"></div>
                  <div class="mini-cell"></div>
                </div>
              </div>
            </div>
            <p class="text-sm text-gray-600 dark:text-gray-400">Complex oscillator (period 3)</p>
          </div>
        </div>

        <div class="mb-8">
          <p class="text-gray-700 dark:text-gray-300 mb-4 leading-relaxed">
            These are just a few examples of the thousands of patterns discovered over the decades. Each pattern tells a story of emergence, complexity, and mathematical beauty.
          </p>
          <div class="space-y-2">
            <p class="text-gray-700 dark:text-gray-300">
              <ULink to="https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Examples_of_patterns" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline font-medium">
                Wikipedia: Examples of Patterns
              </ULink>
              <span class="text-gray-500 dark:text-gray-400 ml-2">— Comprehensive catalog with detailed descriptions</span>
            </p>
            <p class="text-gray-700 dark:text-gray-300">
              <ULink to="https://conwaylife.appspot.com/library/" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline font-medium">
                Conway Life Pattern Library
              </ULink>
              <span class="text-gray-500 dark:text-gray-400 ml-2">— Interactive collection of patterns to explore</span>
            </p>
          </div>
        </div>

        <div class="border-b border-dashed border-gray-200 dark:border-gray-700 my-8" />

        <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-4">Further Reading</h3>
        <div class="space-y-3">
          <p class="text-gray-700 dark:text-gray-300">
            <ULink to="https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline font-medium">
              Wikipedia: Conway's Game of Life
            </ULink>
            <span class="text-gray-500 dark:text-gray-400 ml-2">— Comprehensive overview and mathematical details</span>
          </p>
          <p class="text-gray-700 dark:text-gray-300">
            <ULink to="https://conwaylife.com/" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline font-medium">
              LifeWiki
            </ULink>
            <span class="text-gray-500 dark:text-gray-400 ml-2">— Extensive catalog of patterns and discoveries</span>
          </p>
          <p class="text-gray-700 dark:text-gray-300">
            <ULink to="https://playgameoflife.com/" target="_blank" class="text-blue-600 dark:text-blue-400 hover:underline font-medium">
              Play Game of Life
            </ULink>
            <span class="text-gray-500 dark:text-gray-400 ml-2">— Interactive simulator with preset patterns</span>
          </p>
        </div>
      </div>
    </section>

    <Footer class="mt-24 mb-42" />
  </div>
</template>


<script lang="ts" setup>

useHead({
  title: "Conway's Game of Life • experiements • rootasjey",
  meta: [
    {
      name: 'description',
      content: "Conway's Game of Life cellular automaton",
    },
  ],
})

const grid = ref<number[][]>([])
const rows = ref(25)
const cols = ref(25)
const isRunning = ref(false)
const intervalId = ref<NodeJS.Timeout | null>(null)
const speed = ref(200) // milliseconds

// Painting state
const isPainting = ref(false)
const paintMode = ref<'add' | 'remove'>('add')

const initializeGrid = () => {
  grid.value = Array(rows.value).fill(0).map(() => Array(cols.value).fill(0))
}

const toggleSimulation = () => {
  if (isRunning.value) {
    stopSimulation()
    return
  }

  startSimulation()
}

const startSimulation = () => {
  if (!isRunning.value) {
    isRunning.value = true
    intervalId.value = setInterval(updateGrid, speed.value)
  }
}

const stopSimulation = () => {
  if (!isRunning.value) return

  isRunning.value = false
  if (intervalId.value) {
    clearInterval(intervalId.value)
    intervalId.value = null
  }
}

const resetGrid = () => {
  stopSimulation()
  initializeGrid()
}

const randomizeGrid = () => {
  grid.value = Array(rows.value).fill(0).map(() => 
    Array(cols.value).fill(0).map(() => Math.random() > 0.7 ? 1 : 0)
  )
}

// Painting functions
const startPainting = (row: number, col: number) => {
  if (isRunning.value) return // Don't allow painting while simulation is running

  isPainting.value = true
  // Determine paint mode based on current cell state
  paintMode.value = grid.value[row][col] === 1 ? 'remove' : 'add'
  // Apply the initial paint
  grid.value[row][col] = paintMode.value === 'add' ? 1 : 0
}

const paintCell = (row: number, col: number) => {
  if (!isPainting.value || isRunning.value) return

  // Apply paint based on current mode
  grid.value[row][col] = paintMode.value === 'add' ? 1 : 0
}

const stopPainting = () => {
  isPainting.value = false
}

const updateGrid = () => {
  const newGrid = JSON.parse(JSON.stringify(grid.value))

  for (let row = 0; row < rows.value; row++) {
    for (let col = 0; col < cols.value; col++) {
      const neighbors = countNeighbors(row, col)
      
      if (grid.value[row][col] === 1) {
        // Cell is alive
        if (neighbors < 2 || neighbors > 3) {
          newGrid[row][col] = 0 // Cell dies
        }
      } else {
        // Cell is dead
        if (neighbors === 3) {
          newGrid[row][col] = 1 // Cell becomes alive
        }
      }
    }
  }

  grid.value = newGrid
}

const countNeighbors = (row: number, col: number) => {
  let count = 0

  for (let i = -1; i <= 1; i++) {
    for (let j = -1; j <= 1; j++) {
      if (i === 0 && j === 0) continue
      
      const newRow = row + i
      const newCol = col + j
      
      if (newRow >= 0 && newRow < rows.value && newCol >= 0 && newCol < cols.value) {
        count += grid.value[newRow][newCol]
      }
    }
  }

  return count
}

onMounted(() => {
  initializeGrid()

  // Add global mouseup listener to handle painting outside the grid
  document.addEventListener('mouseup', stopPainting)
})

onBeforeUnmount(() => {
  stopSimulation()
  if (intervalId.value) {
    clearInterval(intervalId.value)
    intervalId.value = null
  }

  // Clean up global event listener
  document.removeEventListener('mouseup', stopPainting)
})

</script>

<style scoped>
.grid-container {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(229, 231, 235, 0.5);
  border-radius: 12px;
  padding: 16px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.dark .grid-container {
  background: rgba(17, 24, 39, 0.8);
  border: 1px solid rgba(75, 85, 99, 0.5);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3), 0 2px 4px -1px rgba(0, 0, 0, 0.2);
}

.cell {
  width: 18px;
  height: 18px;
  border: 1px solid rgba(229, 231, 235, 0.6);
  background-color: rgba(249, 250, 251, 0.9);
  border-radius: 3px;
  margin: 1px;
  cursor: pointer;
  transition: all 0.2s ease-in-out;

  &:hover {
    background-color: rgba(229, 231, 235, 0.8);
    transform: scale(1.05);
  }
}

.dark .cell {
  background-color: rgba(17, 24, 39, 0.9);
  border: 1px solid rgba(75, 85, 99, 0.6);

  &:hover {
    background-color: rgba(55, 65, 81, 0.8);
    transform: scale(1.05);
  }
}

.cell.alive {
  border: 1px solid transparent;
  box-shadow: 0 0 12px rgba(168, 162, 158, 0.4);
  transition: all 0.2s ease-in-out;
  transform: scale(1.02);

  /* Colorful alive cells with app's color palette */
  background: linear-gradient(135deg, #A684FF, #8567DB);

  &:nth-child(2n) {
    background: linear-gradient(135deg, #FF3EA5, #F564A9);
  }

  &:nth-child(3n) {
    background: linear-gradient(135deg, #00FFDE, #15F5BA);
  }

  &:nth-child(4n) {
    background: linear-gradient(135deg, #FFDB5C, #FFAF61);
  }

  &:nth-child(5n) {
    background: linear-gradient(135deg, #687EFF, #1B56FD);
  }

  &:hover {
    transform: scale(1.1);
    box-shadow: 0 0 20px rgba(168, 162, 158, 0.6);
  }
}

.dark .cell.alive {
  box-shadow: 0 0 12px rgba(168, 162, 158, 0.6);

  &:hover {
    box-shadow: 0 0 20px rgba(168, 162, 158, 0.8);
  }
}

.explanations {
  ul, ol {
    li {
      line-height: 1.7;
    }

    li::marker {
      font-weight: 600;
      color: rgba(var(--una-primary-500), 1);
    }
  }
}

/* Pattern visualization styles */
.patterns-grid {
  .pattern-card {
    transition: transform 0.2s ease, box-shadow 0.2s ease;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
  }
}

.dark .patterns-grid .pattern-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.mini-grid {
  display: flex;
  flex-direction: column;
  gap: 1px;
  background: rgba(0, 0, 0, 0.1);
  padding: 4px;
  border-radius: 4px;
  width: fit-content;
  margin: 0 auto;
}

.mini-row {
  display: flex;
  gap: 1px;
}

.mini-cell {
  width: 12px;
  height: 12px;
  background-color: rgba(229, 231, 235, 0.8);
  border-radius: 1px;

  &.alive {
    background: linear-gradient(135deg, #A684FF, #8567DB);
    box-shadow: 0 0 4px rgba(166, 132, 255, 0.4);
  }
}

.dark .mini-cell {
  background-color: rgba(55, 65, 81, 0.8);

  &.alive {
    background: linear-gradient(135deg, #A684FF, #8567DB);
    box-shadow: 0 0 4px rgba(166, 132, 255, 0.6);
  }
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .cell {
    width: 16px;
    height: 16px;
  }

  .grid-container {
    padding: 12px;
  }
}

@media (max-width: 640px) {
  .cell {
    width: 14px;
    height: 14px;
  }

  .grid-container {
    padding: 8px;
  }
}
</style>
