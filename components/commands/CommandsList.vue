<template>
  <div class="dropdown-menu">
    <template v-if="items.length">
      <button v-for="(item, index) in items" :key="index" :class="{ 'is-selected': index === selectedIndex }"
        @click="selectItem(index)">
        <div class="flex items-center gap-4">
          <span icon-base :class="item.icon" class="text-size-3" />
          <span>{{ item.title }}</span>
        </div>
      </button>
    </template>
    <div class="item" v-else>
      No result
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  items: {
    type: Array,
    required: true,
  },
  command: {
    type: Function,
    required: true,
  },
})

const selectedIndex = ref(0)

watch(() => props.items, () => {
  selectedIndex.value = 0
})

const selectItem = (index) => {
  const item = props.items[index]
  if (item) {
    props.command(item)
  }
}

const upHandler = () => {
  selectedIndex.value = ((selectedIndex.value + props.items.length) - 1) % props.items.length
}

const downHandler = () => {
  selectedIndex.value = (selectedIndex.value + 1) % props.items.length
}

const enterHandler = () => {
  selectItem(selectedIndex.value)
}

const onKeyDown = ({ event }) => {
  if (event.key === 'ArrowUp') {
    upHandler()
    return true
  }

  if (event.key === 'ArrowDown') {
    downHandler()
    return true
  }

  if (event.key === 'Enter') {
    enterHandler()
    return true
  }

  return false
}

defineExpose({
  onKeyDown
})
</script>

<style scoped>
.dropdown-menu {
  background: #fff;
  border-radius: 0.7rem;
  box-shadow: 0rem 0.5rem 1rem rgba(0, 0, 0, 0.2);
  display: flex;
  flex-direction: column;
  gap: 0.1rem;
  overflow: auto;
  padding: 0.4rem;
  position: relative;

  button {
    align-items: center;
    background-color: transparent;
    display: flex;
    gap: 0.25rem;
    text-align: left;
    width: 100%;
    padding: 0.25rem 0.5rem;
    border-radius: 0.5rem;

    &:hover,
    &:hover.is-selected {
      background-color: #eee;
    }

    &.is-selected {
      background-color: #eee;
    }
  }
}

.dark {
  .dropdown-menu {
    background: #000;
    border: 1px solid #6466f19a;
    box-shadow: 0rem 0.5rem 1rem rgba(100, 102, 241, 0.2);

    button {
      &.is-selected {
        background-color: #212121;
      }
    }
  }
}
</style>
