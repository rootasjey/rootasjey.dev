<template>
  <div class="container mx-auto px-4 py-8 pb-24">
    <ULink class="flex flex-col items-center justify-center mt-6" 
      to="/experiments">
      <span class="i-ph-flask mx-auto text-center text-md text-gray-600 dark:text-gray-400" />
    </ULink>

    <PageHeader 
      title="Game of Life" 
      subtitle="Conway's Game of Life cellular automaton"
    />

    <div class="flex flex-col items-center justify-center">
      <div class="grid-container mb-4 rounded">
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
            @click="toggleCell(rowIndex, colIndex)"
          ></div>
        </div>
      </div>

      <div class="controls flex gap-4 mb-8">
        <UButton 
         @click="toggleSimulation"
         :btn="isRunning ? '~' : '~'"
         :class="{ 
            'light:btn-glowing dark:bg-[#FF3EA5]': !isRunning, 
            'bg-pink-6 dark:bg-[#15F5BA] dark:color-black': isRunning 
          }"
         :label="isRunning ? 'Stop' : 'Start'"
         :trailing="isRunning ? 'i-ph-pause' : 'i-ph-play'"
        />

        <UButton 
          @click="resetGrid" 
          btn="outline"
          leading="i-ph-arrow-clockwise"
        >
          Reset
        </UButton>

        <UButton 
          @click="randomizeGrid" 
          btn="outline"
          leading="i-ph-shuffle"
        >
          Randomize
        </UButton>
      </div>

      <div class="explanations max-w-2xl text-gray-700 dark:text-gray-300">
        <div class="border-b b-dashed w-full h-1 b-blue dark:b-[#FFAF61] mt-8 mb-12"></div>
        <h3 class="font-text text-16 font-200 mb-2">A little bit of explanation</h3>
        <p class="font-text font-400 text-gray-500 dark:text-gray-400">
          The Game of Life is a cellular automaton devised by mathematician John Conway in 1970.
          It's a zero-player game, meaning its evolution is determined by its initial state.
        </p>
        <h4 class="text-size-8 font-200 mt-8 mb-1">RULES:</h4>
        <ol class="list-decimal pl-8">
          <li class="color-[#FF3EA5] dark:color-[#FFDB5C]">Any live cell with fewer than two live neighbors dies (underpopulation)</li>
          <li class="color-[#FF3EA5] dark:color-[#FFDB5C]">Any live cell with more than three live neighbors dies (overpopulation)</li>
          <li class="color-[#8F87F1] dark:color-[#00FF9C]">Any live cell with two or three live neighbors lives on</li>
          <li class="color-[#8F87F1] dark:color-[#00FF9C]">Any dead cell with exactly three live neighbors becomes a live cell (reproduction)</li>
        </ol>
      </div>
    </div>
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

const toggleCell = (row: number, col: number) => {
  grid.value[row][col] = grid.value[row][col] === 1 ? 0 : 1
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
})

onBeforeUnmount(() => {
  stopSimulation()
  if (intervalId.value) {
    clearInterval(intervalId.value)
    intervalId.value = null
  }
})

</script>

<style scoped>
.grid-container {
  border: 0px solid #ccc;
}

.cell {
  width: 20px;
  height: 20px;
  border: 1px solid #eee;
  background-color: #f9f9f9;
  border-radius: 4px;
  margin: 1px;
  cursor: pointer;
  transition: 0.2s ease-in-out;

  &:hover {
    background-color: #e0e0e0;
  }
}

.dark .cell {
  background-color: #000;
  border: 1px solid #444;

  &:hover {
    background-color: #333;
  }
}

.cell.alive {
  background-color: #BFECFF;
  border: 1px solid transparent;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.6);
  transition: 0.2s ease-in-out;

  &:nth-child(2n) {
    background-color: #CDC1FF;
  }

  &:nth-child(3n) {
    background-color: #FFF6E3;
  }
  &:nth-child(4n) {
    background-color: #FFCCEA;
  }

  &:nth-child(5n) {
    background-color: #F5EFFF;
  }
}

.explanations {
  ul, ol {
    li {
      margin-top: 0.5rem;
    }

    li::marker {
      font-weight: 600;
    }
  }
}
</style>
