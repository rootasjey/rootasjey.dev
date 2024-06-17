<template>
  <div class="super-container">
    <!-- <h1 class="section-title">Interests</h1> -->
    <h3 class="description opacity-60">To fall in love</h3>

    <WavyLine class="wavy-line" color="love" />

    <div class="interest-section">
      <UCard v-for="interest in pageItems" class="interest-card" :ui="{ body: '' }">
        <div class="flex flex-row">
          <NuxtImg :src="interest.image.src" :alt="interest.image.alt" />
          <div class="card-content-text">
            <h1 class="title">{{ interest.name }}</h1>
            <p class="description">
              {{ interest.description }}
            </p>
          </div>
        </div>
        <div class="category">
          <UTooltip v-for="category in interest.categories" :text="category.name" :popper="{ placement: 'top' }">
            <UIcon :name="category.icon" />
          </UTooltip>
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

const pageItems = [
  {
    name: 'Hades',
    categories: [
      {
        name: "Game",
        icon: "i-tabler-device-gamepad-2"
      },
    ],
    description: 'Hades is a 2020 roguelike action role-playing game developed and published by Supergiant Games.',
    image: {
      src: 'https://upload.wikimedia.org/wikipedia/en/c/cc/Hades_cover_art.jpg',
      alt: 'Hades image'
    },
    links: [
      {
        name: 'Hades on Steam',
        icon: 'i-tabler-brand-steam',
        url: 'https://store.steampowered.com/app/1145360/Hades/'
      },
      {
        name: 'Hades on Epic Games',
        icon: 'i-tabler-brand-epic-games',
        url: 'https://www.epicgames.com/store/en-US/product/hades'
      },
    ],
  },
  {
    name: 'Arcane',
    categories: [
      {
        name: "Series",
        icon: "i-tabler-device-tv-old"
      },
    ],
    description: 'Arcane is an animated television series set in the League of Legends universe.',
    image: {
      src: 'https://i.ytimg.com/an/IA-v_LB3Qpc/7932776273451997754_mq.jpg?v=62ebfa55',
      alt: 'Arcane image'
    },
    links: [
      {
        name: 'Arcane on YouTube',
        icon: 'i-tabler-brand-youtube',
        url: 'https://www.youtube.com/watch?v=IA-v_LB3Qpc'
      },
    ],
  },
  {
    name: "Everything Everywhere All at Once",
    categories: [
      {
        name: "Movie",
        icon: "i-tabler-movie"
      }
    ],
    description: '2022 American absurdist comedy-drama film directed by Daniel Kwan and Daniel Scheinert.',
    image: {
      src: 'https://upload.wikimedia.org/wikipedia/commons/1/1f/Everything_everywhere_all_at_once_logo.jpg',
      alt: 'Everything, everywhere, all at once image',
        },
    links: [
      {
        name: 'Everything, everywhere, all at once on YouTube',
        icon: 'i-tabler-brand-youtube',
        url: 'https://www.youtube.com/watch?v=IA-v_LB3Qpc'
      },
    ],
  },
]

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