<template>
  <div class="super-container">
    <h1 class="section-title">Projects</h1>
    <h3 class="opacity-60">My own little kingdom</h3>

    <!-- <div class="wavy-line wavy-line-yellow" data-text="xxxxxxxxxxxxxx"></div> -->
    <WavyLine color="primary" />

    <UContainer class="projects-section">
      <div v-if="loading" class="loading">
        <img alt="kwotes logo" class="logo center" src="~/assets/animations/animated-app.gif" width="90" height="90" />
        <p>Loading...</p>
      </div>

      <UCard class="project-card">
        <div class="flex flex-row">
          <div class="w-1/2 mr-12">
            <h1 class="title">Kwotes</h1>
            <p class="description mb-4">
              kwotes is a captivating mobile application that offers a vast collection of inspiring,
              thought-provoking, and insightful quotes from a diverse range of sources. Designed to be a constant
              companion for users, kwotes provides a seamless and engaging experience, allowing individuals to
              explore, save, and share their favorite quotes with ease.
            </p>

            <div class="flex flex-row gap-4 items-center">
              <UTooltip text="GitHub" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-github" to="https://github.com/rootasjey/kwotes" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <UTooltip text="Website" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-appstore"
                  to="https://apps.apple.com/fr/app/kwotes/id6478239805?platform=iphone" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <div class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip text="Flutter" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-flutter" to="https://flutter.dev" target="_blank" variant="solid"
                  color="gray" label="" />
              </UTooltip>
              <UTooltip text="Firebase" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-firebase" to="https://firebase.com" target="_blank" variant="solid"
                  color="gray" label="" />
              </UTooltip>
              <UTooltip text="Algolia" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-algolia" to="https://algolia.com" target="_blank" variant="solid"
                  color="gray" label="" />
              </UTooltip>
            </div>
          </div>
          <img src="https://github.com/rootasjey/kwotes/raw/master/screenshots/kwotes-banner.jpg" alt="kwotes banner">
        </div>
      </UCard>

      <UCard class="project-card">
        <div class="flex flex-row">
          <div class="w-1/2 mr-12">
            <h1 class="title">Unsplasharp</h1>
            <p class="description mb-4">
              Unofficial C# wrapper around Unsplash API targeting .NET Standard 1.4.
              Unsplasharp provides a unified interface for accessing the Unsplash API.
            </p>

            <div class="flex flex-row gap-4 items-center">
              <UTooltip text="GitHub" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-github" to="https://github.com/rootasjey/unsplasharp" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <!-- <UTooltip text="Website" :popper="{ placement: 'top' }">
                  <UButton icon="i-tabler-world-latitude" to="https://kwotes.fr" target="_blank" variant="outline"
                    label="" :color="isDark ? 'secondary' : 'primary'" />
                </UTooltip> -->

              <div class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip text="C#" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-c-sharp" to="https://docs.microsoft.com/fr-fr/dotnet/csharp/"
                  target="_blank" variant="solid" color="gray" label="" />
              </UTooltip>
              <UTooltip text=".NET" :popper="{ placement: 'top' }">
                <UButton to="https://dotnet.microsoft.com/" target="_blank" variant="solid" color="gray" label="">
                  <Icon name="mdi:dot-net" size="1.1rem" />
                </UButton>
              </UTooltip>
            </div>
          </div>
          <img
            src="https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Funsplasharp-cover.jpg?alt=media&token=4a3e3bb9-eecc-4e89-94b2-bc31912e7f60"
            alt="unsplasharp banner">
        </div>
      </UCard>

      <UCard class="project-card">
        <div class="flex flex-row">
          <div class="w-1/2 mr-12">
            <h1 class="title">Backwards</h1>
            <p class="description mb-4">
              🚧 [WIP] A turn-based game system built with Phaser 3.
            </p>

            <div class="flex flex-row gap-4 items-center">
              <UTooltip text="GitHub" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-github" to="https://github.com/rootasjey/backwards" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <!-- <UTooltip text="Website" :popper="{ placement: 'top' }">
                  <UButton icon="i-tabler-world-latitude" to="https://kwotes.fr" target="_blank" variant="outline"
                    label="" :color="isDark ? 'secondary' : 'primary'" />
                </UTooltip> -->

              <div class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip text="TypeScript" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-typescript" to="https://www.typescriptlang.org/" target="_blank"
                  variant="solid" color="gray" label="" />
              </UTooltip>
              <UTooltip text="Phaser" :popper="{ placement: 'top' }">
                <UButton to="https://phaser.io/" target="_blank" variant="solid" color="gray" label="">
                  <Icon name="covid:vaccine-protection-infrared-thermometer-gun" size="1.1rem" />
                </UButton>
              </UTooltip>
            </div>
          </div>
          <img src="https://github.com/rootasjey/backwards/blob/master/cycles-preview.gif?raw=true"
            alt="backwards banner">
        </div>
      </UCard>

      <UCard class="project-card">
        <div class="flex flex-row">
          <div class="w-1/2 mr-12">
            <h1 class="title">Kwotes Trivia</h1>
            <p class="description mb-4">
              Enjoy a 5 questions trivia game with your friends.
            </p>

            <div class="flex flex-row gap-4 items-center">
              <UTooltip text="GitHub" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-github" to="https://github.com/rootasjey/kwotes-trivia" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <!-- <UTooltip text="Website" :popper="{ placement: 'top' }">
                  <UButton icon="i-tabler-world-latitude" to="https://kwotes.fr" target="_blank" variant="outline"
                    label="" :color="isDark ? 'secondary' : 'primary'" />
                </UTooltip> -->

              <div class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip text="Flutter" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-flutter" to="https://flutter.dev" target="_blank" variant="solid"
                  color="gray" label="" />
              </UTooltip>
              <UTooltip text="Firebase" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-firebase" to="https://firebase.com" target="_blank" variant="solid"
                  color="gray" label="" />
              </UTooltip>
            </div>
          </div>
          <img
            src="https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?q=80&w=2969&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
            alt="kwotes trivia banner">
        </div>
      </UCard>

      <UCard class="project-card">
        <div class="flex flex-row">
          <div class="w-1/2 mr-12">
            <h1 class="title">Kwotes CLI</h1>
            <p class="description mb-4">
              A tiny CLI app for kwotes platform.
            </p>

            <div class="flex flex-row gap-4 items-center">
              <UTooltip text="GitHub" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-github" to="https://github.com/rootasjey/kwotes-cli" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <!-- <UTooltip text="Website" :popper="{ placement: 'top' }">
                  <UButton icon="i-tabler-world-latitude" to="https://kwotes.fr" target="_blank" variant="outline"
                    label="" :color="isDark ? 'secondary' : 'primary'" />
                </UTooltip> -->

              <div class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip text="Python" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-python" to="https://python.org" target="_blank" variant="solid"
                  color="gray" label="" />
              </UTooltip>
              <UTooltip text="Typer" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-arrow-autofit-right" to="https://typer.tiangolo.com/" target="_blank"
                  variant="solid" color="gray" label="" />
              </UTooltip>
            </div>
          </div>
          <img
            src="https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fkwotes-cli-v0.png?alt=media&token=568cb6cc-4bfd-4be5-945d-4d77249f7cb8"
            alt="kwotes cli banner">
        </div>
      </UCard>

      <UCard class="project-card">
        <div class="flex flex-row">
          <div class="w-1/2 mr-12">
            <h1 class="title">Metrix Fitbit</h1>
            <p class="description mb-4">
              A Fitbit clock face showing metrics activities.
            </p>

            <div class="flex flex-row gap-4 items-center">
              <UTooltip text="GitHub" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-github" to="https://github.com/rootasjey/metrix-fitbit" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <div class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip text="JavaScript" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-javascript" to="https://www.javascript.com/" target="_blank"
                  variant="solid" color="gray" label="" />
              </UTooltip>
              <UTooltip text="CSS" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-file-type-css" to="https://developer.mozilla.org/en-US/docs/Web/CSS/"
                  target="_blank" variant="solid" color="gray" label="" />
              </UTooltip>
            </div>
          </div>
          <img src="https://github.com/rootasjey/metrix-fitbit/blob/master/screenshots/changelog.png?raw=true"
            alt="metrix fitbit banner">
        </div>
      </UCard>

      <UCard class="project-card">
        <div class="flex flex-row">
          <div class="w-1/2 mr-12">
            <h1 class="title">Alarm Fitbit</h1>
            <p class="description mb-4">
              A Fitbit clock face looking like the Alarms app.
            </p>

            <div class="flex flex-row gap-4 items-center">
              <UTooltip text="GitHub" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-github" to="https://github.com/rootasjey/alarm-fitbit" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <div class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip text="JavaScript" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-javascript" to="https://www.javascript.com/" target="_blank"
                  variant="solid" color="gray" label="" />
              </UTooltip>
              <UTooltip text="CSS" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-file-type-css" to="https://developer.mozilla.org/en-US/docs/Web/CSS/"
                  target="_blank" variant="solid" color="gray" label="" />
              </UTooltip>
            </div>
          </div>
          <img src="https://github.com/rootasjey/alarms-fitbit/blob/master/screenshots/screenshot1.png?raw=true"
            alt="alarm fitbit banner">
        </div>
      </UCard>

      <UCard class="project-card">
        <div class="flex flex-row">
          <div class="w-1/2 mr-12">
            <h1 class="title">Feels (UWP)</h1>
            <p class="description mb-4">
              Minimalistic weather app for universal windows platform.
            </p>

            <div class="flex flex-row gap-4 items-center">
              <UTooltip text="GitHub" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-github" to="https://github.com/rootasjey/feels_uwp" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>
              <UTooltip text="Microsoft store" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-building-store"
                  to="https://apps.microsoft.com/detail/9nb305kw0mbp?activetab=pivot:overviewtab&hl=en-us&gl=US"
                  target="_blank" variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <div class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip text="C#" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-c-sharp" to="https://docs.microsoft.com/fr-fr/dotnet/csharp/"
                  target="_blank" variant="solid" color="gray" label="" />
              </UTooltip>
            </div>
          </div>
          <img src="https://github.com/rootasjey/feels_uwp/blob/master/screenshots/presentation.png?raw=true"
            alt="feels uwp banner">
        </div>
      </UCard>

      <UCard class="project-card">
        <div class="flex flex-row">
          <div class="w-1/2 mr-12">
            <h1 class="title">Citations 365 (UWP)</h1>
            <p class="description mb-4">
              A quotes app written for Windows 10.
              Read meaningful quotes everyday.
              Source is based on https://evene.lefigaro.fr
            </p>

            <div class="flex flex-row gap-4 items-center">
              <UTooltip text="GitHub" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-github" to="https://github.com/rootasjey/citations365-8" target="_blank"
                  variant="outline" label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>
              <UTooltip text="Microsoft store" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-building-store"
                  to="https://apps.microsoft.com/detail/9nblggh68cv1?hl=en-us&gl=US" target="_blank" variant="outline"
                  label="" :color="isDark ? 'secondary' : 'primary'" />
              </UTooltip>

              <div class="dot-divider w-2 h-2	rounded-full" />

              <UTooltip text="C#" :popper="{ placement: 'top' }">
                <UButton icon="i-tabler-brand-c-sharp" to="https://docs.microsoft.com/fr-fr/dotnet/csharp/"
                  target="_blank" variant="solid" color="gray" label="" />
              </UTooltip>
            </div>
          </div>
          <img src="https://github.com/rootasjey/citations365-8/blob/master/citations.windows.jpg?raw=true"
            alt="feels uwp banner">
        </div>
      </UCard>
    </UContainer>
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
    margin-bottom: 0.5rem;
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
          width: 360px;
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
    }
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