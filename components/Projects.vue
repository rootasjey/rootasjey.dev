<template>
  <div class="super-container">
    <h3 class="description opacity-60">My own little kingdom</h3>
    <WavyLine class="wavy-line" color="primary" />

    <div class="projects-section">
      <div v-if="loading" class="loading">
        <p>Loading...</p>
      </div>

      <UCard v-for="project in pageItems" class="project-card"
        :ui="{ header: { base: width > 600 ? 'hidden' : '' }, divide: width > 600 ? '' : 'divide-y divide-gray-200 dark:divide-gray-800' }">
        <template #header>
          <img class="img-header" :src="project.image.src" :alt="project.image.alt">
        </template>

        <div class="card-content flex flex-row">
          <div class="card-content-text">
            <h1 class="title">{{ project.name }}</h1>
            <p class="description mb-4">
              {{ project.description }}
            </p>

            <div v-if="project.links.length > 0 || project.technologies.length > 0"
              class="flex flex-row flex-wrap gap-4 items-center">
              <UTooltip v-for="link in project.links" :text="link.name" :popper="{ placement: 'top' }">
                <UButton :icon="link.icon" :to="link.url" target="_blank" variant="outline" label=""
                  :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <div v-if="project.links.length > 0 && project.technologies.length > 0"
                class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip v-for="tech in project.technologies" :text="tech.name" :popper="{ placement: 'top' }">
                <UButton :icon="tech.useExternalIcon ? undefined : tech.icon" :to="tech.href" target="_blank" variant="solid"
                  color="gray" label="">
                  <Icon v-if="tech.useExternalIcon" :name="tech.icon" size="1.1rem" />
                </UButton>
              </UTooltip>
            </div>
          </div>
          <img :src="project.image.src" :alt="project.image.alt">
        </div>
      </UCard>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { collection, getDocs, query, orderBy, limit } from 'firebase/firestore';
import { ref, type Ref, computed, onMounted, unref } from 'vue'
import { useCollection, useFirestore } from 'vuefire'
import { useWindowSize } from '@vueuse/core'

const { width } = useWindowSize()

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
    name: "Kwotes",
    description: "kwotes is a captivating mobile application that offers a vast collection of inspiring, thought- provoking, and insightful quotes from a diverse range of sources.Kwotes allows to explore, save, and share favorite quotes with ease.",
    image: {
      src: "https://github.com/rootasjey/kwotes/raw/master/screenshots/kwotes-banner.jpg",
      alt: "kwotes banner",
    },
    links: [
      {
        name: "GitHub",
        icon: "i-tabler-brand-github",
        url: "https://github.com/rootasjey/kwotes",
      },
      {
        name: "App Store",
        icon: "i-tabler-brand-appstore",
        url: "https://apps.apple.com/fr/app/kwotes/id6478239805?platform=iphone",
      },
    ],
    technologies: [
      {
        name: "Flutter",
        icon: "i-tabler-brand-flutter",
        href: "https://flutter.dev",
      },
      {
        name: "Firebase",
        icon: "i-tabler-brand-firebase",
        href: "https://firebase.com",
      },
      {
        name: "Algolia",
        icon: "i-tabler-brand-algolia",
        href: "https://algolia.com",
      },
    ],
  },
  {
    name: "Unsplasharp",
    description: "Unofficial C# wrapper around Unsplash API targeting .NET Standard 1.4. Unsplasharp provides a unified interface for accessing the Unsplash API.",
    image: {
      src: "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Funsplasharp-cover.jpg?alt=media&token=4a3e3bb9-eecc-4e89-94b2-bc31912e7f60",
      alt: "unsplasharp banner",
    },
    links: [
      {
        name: "GitHub",
        icon: "i-tabler-brand-github",
        url: "https://github.com/rootasjey/unsplasharp",
      },
    ],
    technologies: [
      {
        name: "C#",
        icon: "i-tabler-brand-c-sharp",
        href: "https://docs.microsoft.com/fr-fr/dotnet/csharp/",
      },
      {
        name: ".NET",
        icon: "mdi:dot-net",
        href: "https://dotnet.microsoft.com/",
        useExternalIcon: true,
      },
    ],
  },
  {
    name: "Backwards",
    description: "🚧 [WIP] A turn-based game system built with Phaser 3.",
    image: {
      src: "https://github.com/rootasjey/backwards/blob/master/cycles-preview.gif?raw=true",
      alt: "backwards banner",
    },
    links: [
      {
        name: "GitHub",
        icon: "i-tabler-brand-github",
        url: "https://github.com/rootasjey/backwards",
      },
    ],
    technologies: [
      {
        name: "TypeScript",
        icon: "i-tabler-brand-typescript",
        href: "https://www.typescriptlang.org/",
      },
      {
        name: "Phaser",
        icon: "covid:vaccine-protection-infrared-thermometer-gun",
        href: "https://phaser.io/",
        useExternalIcon: true,
      },
    ],
  },
  {
    name: "Kwotes Trivia",
    description: "Enjoy a 5 questions trivia game with your friends.",
    image: {
      src: "https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?q=80&w=2969&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      alt: "kwotes trivia banner",
    },
    links: [
      {
        name: "GitHub",
        icon: "i-tabler-brand-github",
        url: "https://github.com/rootasjey/kwotes-trivia",
      },
    ],
    technologies: [
      {
        name: "Flutter",
        icon: "i-tabler-brand-flutter",
        href: "https://flutter.dev",
      },
      {
        name: "Firebase",
        icon: "i-tabler-brand-firebase",
        href: "https://firebase.com",
      },
    ],
  },
  {
    name: "Kwotes CLI",
    description: "A tiny CLI app for Kwotes platform.",
    image: {
      src: "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fkwotes-cli-v0.png?alt=media&token=568cb6cc-4bfd-4be5-945d-4d77249f7cb8",
      alt: "kwotes cli banner",
    },
    links: [
      {
        name: "GitHub",
        icon: "i-tabler-brand-github",
        url: "https://github.com/rootasjey/kwotes-cli",
      },
    ],
    technologies: [
      {
        name: "Python",
        icon: "i-tabler-brand-python",
        href: "https://docs.python.org/3/",
      },
      {
        name: "Typer",
        icon: "i-tabler-arrow-autofit-right",
        href: "https://typer.tiangolo.com/",
      },
    ],
  },
  {
    name: "Metrix Fitbit",
    description: "A Fitbit clock face showing metrics activities.",
    image: {
      src: "https://github.com/rootasjey/metrix-fitbit/blob/master/screenshots/changelog.png?raw=true",
      alt: "metrix fitbit banner",
    },
    links: [
      {
        name: "GitHub",
        icon: "i-tabler-brand-github",
        url: "https://github.com/rootasjey/metrix-fitbit",
      },
    ],
    technologies: [
      {
        name: "JavaScript",
        icon: "i-tabler-brand-javascript",
        href: "https://www.javascript.com/",
      },
      {
        name: "CSS",
        icon: "i-tabler-brand-css3",
        href: "https://www.w3.org/Style/CSS/",
      },
    ],
  },
  {
    name: "Alarms Fitbit",
    description: "A Fitbit clock face looking like the Alarms app.",
    image: {
      src: "https://github.com/rootasjey/alarms-fitbit/blob/master/screenshots/screenshot1.png?raw=true",
      alt: "alarms fitbit banner",
    },
    links: [
      {
        name: "GitHub",
        icon: "i-tabler-brand-github",
        url: "https://github.com/rootasjey/alarms-fitbit",
      },
    ],
    technologies: [
      {
        name: "JavaScript",
        icon: "i-tabler-brand-javascript",
        href: "https://www.javascript.com/",
      },
      {
        name: "CSS",
        icon: "i-tabler-brand-css3",
        href: "https://www.w3.org/Style/CSS/",
      },
    ],
  },
  {
    name: "Feels UWP",
    description: "Minimalistic weather app for universal windows platform.",
    image: {
      src: "https://github.com/rootasjey/feels_uwp/blob/master/screenshots/presentation.png?raw=true",
      alt: "feels uwp banner",
    },
    links: [
      {
        name: "GitHub",
        icon: "i-tabler-brand-github",
        url: "https://github.com/rootasjey/feels_uwp",
      },
    ],
    technologies: [
      {
        name: "C#",
        icon: "i-tabler-brand-c-sharp",
        href: "https://docs.microsoft.com/fr-fr/dotnet/csharp/",
      },
    ],
  },
  {
    name: "Citations 365 (UWP)",
    description: "A quotes app written for Windows 10. Read meaningful quotes everyday. Source is based on https://evene.lefigaro.fr",
    image: {
      src: "https://github.com/rootasjey/citations365-8/blob/master/citations.windows.jpg?raw=true",
      alt: "feels uwp banner",
    },
    links: [
      {
        name: "GitHub",
        icon: "i-tabler-brand-github",
        url: "https://github.com/rootasjey/citations365-8",
      },
      {
        name: "Microsoft store",
        icon: "i-tabler-building-store",
        url: "https://apps.microsoft.com/detail/9nblggh68cv1?hl=en-us&gl=US",
      },
    ],
    technologies: [
      {
        name: "C#",
        icon: "i-tabler-brand-c-sharp",
        href: "https://docs.microsoft.com/fr-fr/dotnet/csharp/",
      },
    ],
  },
]

const loading = ref(false)
const error = ref("")
const heroQuote: Ref<any> = ref(null)
const quotes: Ref<any[]> = ref([])

async function fetchData() {
  loading.value = true

  try {
    const db = useFirestore()
    // const quotes = useCollection(collection(db, 'quotes'))
    const quotesRef = collection(db, "quotes");
    const q = query(quotesRef, orderBy("created_at", "desc"), limit(3))
    const querySnapshot = await getDocs(q)

    for (const doc of querySnapshot.docs) {
      quotes.value.push(doc.data())
    }

    heroQuote.value = quotes.value.at(0)
  } catch (err) {
    error.value = "error"
  } finally {
    loading.value = false
  }
}

// fetchData()
</script>

<style scoped>
.super-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  margin-bottom: 25%;

  .section-title {
    font-size: 3rem;
    font-weight: 400;
    font-family: "Poetsen One";
  }

  .description {
    margin-top: 2rem;
    font-size: 1.4rem;
  }

  .projects-section {
    display: flex;
    flex-direction: column;
    flex-wrap: wrap;
    justify-content: center;
    align-items: stretch;
    gap: 2rem;

    width: 75%;
    margin-top: 2rem;

    .project-card {
      margin: 1rem;
      max-width: 1200px;
      transition: transform 0.3s ease;

      .card-content-text {
        width: 50%;
        margin-right: 12px;
      }

      h1.title {
        font-size: 1.2rem;
        font-weight: 400;
        margin-bottom: 0.2rem;
      }
    
      .description {
        opacity: 0.5;
        font-size: 0.9rem;
        font-weight: 300;
      }

      img {
        width: 400px;
        height: 200px;
        object-fit: cover;
        border-radius: 0.5rem;
      }
    }

    .project-card:hover {
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
    .projects-section {
      width: 100%;

      .description {
        max-lines: 3;
        text-overflow: ellipsis;
        overflow: hidden;
        height: 8rem;
        max-height: 8rem;
      }

      .project-card {
        .card-content {
          img {
            display: none;
          }

          .card-content-text {
            width: 100%;
            margin-right: 0;
            
            .description {
                margin-top: 0rem;
                font-size: 0.8rem;
                text-overflow: ellipsis;
              }
          }
        }
      }
    }

    .wavy-line {
      display: none;
    }
  }
}

</style>