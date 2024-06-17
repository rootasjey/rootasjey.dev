<template>
  <div class="super-container">
    <div class="branding-section">
      <div class="branding-section-imgs">
        <NuxtImg v-for="brandItem in brandingItems" :key="brandItem.id" :src="brandItem.image" :alt="brandItem.name" />
      </div>
    </div>

    <div class="projects-section">
      <div v-if="loading" class="loading">
        <p>Loading...</p>
      </div>

      <UCard v-for="userStory in pageItems" :key="userStory.id" class="user-story-card">
        <template #header>
          <img
            :src="userStory.image"
            :alt="userStory.name">
        </template>

        <h2 class="title">{{ userStory.name }}</h2>
        <p class="description">
          {{ userStory.summary }}
        </p>

        <template #footer>
          <div class="card-footer">
            <UButton icon="i-tabler-external-link" :to="userStory.cta.href" target="_blank" variant="outline"
              :label= "userStory.cta.label" />
          </div>
        </template>
      </UCard>
    </div>
  </div>
</template>

<script lang="ts" setup>
  import { collection, getDocs, query, orderBy, limit } from 'firebase/firestore';
  import { ref, type Ref, computed, onMounted, unref } from 'vue'
  import { useCollection, useFirestore } from 'vuefire'

  const pageItems = [
    {
      id: 1,
      name: "Servier • Customer Information",
      subtitle: "",
      types: [],
      summary: "I worked as a freelance for Servier. We developed a new platform for \"My Health Partner\" service. Create a design system with component and maquette integration, working closely with the design team Create and use Strapi backend.",
      image: "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fmy-health-partner-3.jpg?alt=media&token=b3c6e171-d1f5-473e-856d-7de8c159470f",
      cta: {
        label: "View project",
        href: "https://servier.com"
      },
    },
    {
      id: 2,
      name: "Comptoirs • Dashboard Monitoring",
      subtitle: "",
      types: [],
      summary: "In a small team of 3 developers, we created a back office to monitor connected devices. We also created & used a design system, in collaboration with the design team. Finally, we used REST APIs to communicate with the devices and designed a middleware to handle them.",
      image: "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fcomptoirs-backoffice-monitoring.jpg?alt=media&token=774d9abc-4766-475a-a871-c025d84a9c09",
      cta: {
        label: "View project",
        href: "https://comptoirs.com"
      },
    },
    {
      id: 3,
      name: "Fabernovel • Customer Enrollment",
      subtitle: "",
      types: [],
      summary: "It was only for a little time as I worked for Fabernovel. In a team with 4 developers and 2 products owners, we developed a solution to enroll customers for BNP, a banking service. I was a dynamic environment facing new challenges and with welcoming people. Sadly, I lived too far from the office and after some months, I decided to leave.",
      image: "https://unsplash.com/photos/hpjSkU2UYSU/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzE4NTg3Mzc2fA&force=true&w=1920",
      cta: {
        label: "View project",
        href: "https://fabernovel.com"
      },
    },
    {
      id: 4,
      name: "Dassault Systèmes • File Storage",
      subtitle: "",
      types: [],
      summary: "At Dassault Systèmes, I developed a cloud storage web application in a team of 7 developers. We integrated Google Drive & Microsoft OneDrive APIs(among others) into a single web application. I also wrote technical and design specifications in collaboration with the design and QA team.",
      image: "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2F3ddrive-windowed.jpg?alt=media&token=5445f84e-b68d-473c-b201-79fae0a16d70",
      cta: {
        label: "View project",
        href: "https://www.solidsolutions.co.uk/blog/2019/07/3d-experience-3ddrive/"
      },
    },
  ]

  const brandingItems = [
    {
      id: 1,
      name: "Dassault Systèmes",
      href: "https://www.dassault.fr/",
      image: "https://www.dassault.fr/img/upload/ct/716/3DS_Corp_Logotype_Blue_RGB.png",
    },
    {
      id: 2,
      name: "Fabernovel",
      href: "https://fabernovel.com",
      image: "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Ffabernovel-logo.png?alt=media&token=c285b578-cb47-4768-9e6d-d42089d13171",
    },
    {
      id: 3,
      name: "Comptoirs",
      href: "https://comptoirs.com",
      image: "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fcomptoirs-logo.png?alt=media&token=295b6302-3b27-4949-85b8-d0f020cd7a95",
    },
    {
      id: 4,
      name: "Servier",
      href: "https://servier.com",
      image: "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fservier-logo.png?alt=media&token=ac414b7e-ae9a-42ec-a6c0-757feefd3813",
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

  .dot-divider {
    background-color: var(--dot-color);
  }

  .branding-section {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
    margin-top: 0.5rem;

    width: 100%;

    h1 {
      font-size: 1.2rem;
      font-weight: 400;
      margin-bottom: 0.5rem;
      opacity: 0.8;
    }

    .branding-section-imgs {
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
      flex-wrap: no-wrap;
      overflow: auto;
      gap: 2rem;

      background-color: var(--branding-background);
      border-radius: 2rem;
      padding: 0 1rem;

      img {
        width: 120px;
        border-radius: 0.2rem;
      }
    }
  }
  
  .projects-section {
    display: flex;
    flex-direction: row;
    justify-content: space-around;
    flex-wrap: wrap;
    gap: 2rem;

    width: 75%;
    margin-top: 2rem;
  
    .user-story-card {
      margin: 1rem;
      width: 360px;
      transition: transform 0.3s ease;

      img {
        width: 312px;
        height: 233px;
        object-fit: cover;
        border-radius: 0.5rem;
      }

      .title {
        font-size: 1.2rem;
        font-weight: 400;
        margin-bottom: 0.2rem;
      }
      
      .description {
        opacity: 0.5;
        font-size: 0.9rem;
        font-weight: 300;
        font-family: "Rubik";

        height: 170px;
        overflow: auto;
        text-wrap: wrap;
        max-lines: 4;
        text-overflow: ellipsis;
      }
    }

    .user-story-card:hover {
      transform: scale(1.01);
      transition: transform 0.3s ease;
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

@media screen and (max-width: 600px) {
  .my-container {
    .projects-section {
      width: 100%;
    }
  }
}

</style>