<template>
  <div class="super-container">
    <!-- <h1 class="section-title">Interests</h1> -->
    <h3 class="description opacity-60">To fall in love</h3>

    <WavyLine class="wavy-line" color="love" />

    <div class="interest-section">
      <UCard class="interest-card" :ui="{ body: '' }">
        <div class="flex flex-row">
          <img src="https://upload.wikimedia.org/wikipedia/en/c/cc/Hades_cover_art.jpg" alt="hades image">
          <div class="card-content-text">
            <h1 class="title">Hades</h1>
            <p class="description">
              Hades is a 2020 roguelike action role-playing game developed and published by Supergiant Games.
            </p>
          </div>
        </div>
        <div class="category">
          <UIcon name="i-tabler-device-gamepad-2" />
        </div>
      </UCard>
      <UCard class="interest-card" :ui="{ body: '' }">
        <div class="flex flex-row">
          <img src="https://i.ytimg.com/an/IA-v_LB3Qpc/7932776273451997754_mq.jpg?v=62ebfa55" alt="Arcane image">
          <div class="card-content-text">
            <h1 class="title">Arcane</h1>
            <p class="description">
              Arcane is an animated television series set in the League of Legends universe.
            </p>
          </div>
        </div>
        <div class="category">
          <UIcon name="i-tabler-device-tv-old" />
        </div>
      </UCard>
      <UCard class="interest-card" :ui="{ body: '' }">
        <div class="flex flex-row">
          <img src="https://upload.wikimedia.org/wikipedia/commons/1/1f/Everything_everywhere_all_at_once_logo.jpg"
            alt="Everything, everywhere, all at once image">
          <div class="card-content-text">
            <h1 class="title">Everything, everywhere, all at once</h1>
            <p class="description">
              2022 American absurdist comedy-drama film directed by Daniel Kwan
              and Daniel Scheinert.
            </p>
          </div>
        </div>
        <div class="category">
          <UIcon name="i-tabler-movie" />
        </div>
      </UCard>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { collection, getDocs, query, orderBy, limit } from 'firebase/firestore';
import { ref, type Ref, computed, onMounted, unref } from 'vue'
import { useCollection, useFirestore } from 'vuefire'

const colorMode = useColorMode()
const isDark = computed({
  get() {
    return colorMode.value === 'dark'
  },
  set() {
    colorMode.preference = colorMode.value === 'dark' ? 'light' : 'dark'
  }
})

</script>

<style scoped>
.super-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  margin-bottom: 25%;
  
  .description {
    margin-top: 2rem;
    font-size: 1.4rem;
    /* margin-bottom: 14px; */
    margin-top: 16px;
  }

  .section-title {
    font-size: 3rem;
    font-weight: 400;
    font-family: "Poetsen One";
    margin-bottom: 0.5rem;
  }

  .interest-section {
    display: flex;
    flex-direction: column;
    flex-wrap: wrap;
    justify-content: center;
    align-items: stretch;
    gap: 2rem;

    width: 75%;
    margin-top: 2rem;

    .interest-card {
      margin: 1rem;
      max-width: 1000px;
      position: relative;
      padding: 1rem;
      transition: transform 0.3s ease;


      .card-content-text {
        width: 50%;
        margin-left: 24px;
      }


      h1.title {
        font-size: 1.5rem;
        font-weight: 100;
        line-height: 1.5rem;
      }
    
      .description {
        opacity: 0.5;
        font-size: 0.9rem;
        font-weight: 400;
      }
    
      .category {
        opacity: 0.4;
        font-size: 1.2rem;
        border-radius: 0.5rem;

        position: absolute;
        right: 12px;
        bottom: 12px;
      }

      img {
        width: 120px;
        height: 120px;
        object-fit: cover;
        border-radius: 0.5rem;
      }
    }

    .interest-card:hover {
      transform: scale(1.01);
      transition: transform 0.3s ease;
    }

    .dot-divider {
      background-color: var(--dot-color);
    }
  }
}

@media screen and (max-width: 1274px) {
  .super-container {
    .interest-section {
      width: 100%;

      .interest-card {
        .card-content-text {
          width: 50%;
          margin-right: 12px;
          margin-left: 12px;

          .title {
            font-size: 1.0rem;  
            font-weight: 400;
          }
          
        .description {
          font-size: 0.8rem;
          margin-bottom: 0;
          margin-top: 0;

          max-lines: 3;
          text-overflow: ellipsis;
          overflow: hidden;
          height: 8rem;
          max-height: 8rem;
        }
        }
      }
    }
  }

  .wavy-line {
    display: none;
  }
}

.loading {
  display: flex;
  flex-direction: column;
  justify-content: center;

  p {
    margin-top: 1rem;
    font-size: 1rem;
    font-weight: 400;
    text-transform: uppercase;
    text-align: center;
  }
}
</style>