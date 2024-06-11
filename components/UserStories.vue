<template>
  <div class="my-container">
    <h1 class="section-title">User stories</h1>
    <div class="branding-section">
      <div class="branding-section-imgs">
        <img src="https://www.dassault.fr/img/upload/ct/716/3DS_Corp_Logotype_Blue_RGB.png" alt="" srcset="">
        <img
          src="https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Ffabernovel-logo.png?alt=media&token=c285b578-cb47-4768-9e6d-d42089d13171"
          alt="" srcset="">
        <img
          src="https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fcomptoirs-logo.png?alt=media&token=295b6302-3b27-4949-85b8-d0f020cd7a95"
          alt="" srcset="">
        <img
          src="https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fservier-logo.png?alt=media&token=ac414b7e-ae9a-42ec-a6c0-757feefd3813"
          alt="" srcset="">
      </div>
    </div>

    <UContainer class="projects-section">
      <div v-if="loading" class="loading">
        <p>Loading...</p>
      </div>

      <UCard class="project-card">
        <template #header>
          <img
            src="https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fmy-health-partner-3.jpg?alt=media&token=b3c6e171-d1f5-473e-856d-7de8c159470f"
            alt="">
        </template>

        <h2 class="title">Servier • Customer Information</h2>
        <p class="description">
          I worked as a freelance for Servier.
          We developed a new platform for "My Health Partner" service.
          Create a design system with component and maquette integration, working closely with the design team"
          Create and use Strapi backend.
        </p>

        <template #footer>
          <UButton icon="i-tabler-external-link" to="https://myhealth-partner.com" target="_blank" variant="outline"
            label="View project" />
        </template>
      </UCard>

      <UCard class="project-card">
        <template #header>
          <img
            src="https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fcomptoirs-backoffice-monitoring.jpg?alt=media&token=774d9abc-4766-475a-a871-c025d84a9c09"
            alt="">
        </template>

        <h2 class="title">Comptoirs • Dashboard Monitoring</h2>
        <p class="description">
          In a small team of 3 developers, we created a back office to monitor connected devices.
          We also created & used a design system, in collaboration with the design team.
          Finally, we used REST APIs to communicate with the devices and designed a middleware to handle them.,
        </p>

        <template #footer>
          <UButton icon="i-tabler-external-link" to="https://comptoirs.co" target="_blank" variant="outline"
            label="View project" />
        </template>
      </UCard>

      <UCard class="project-card">
        <template #header>
          <img
            src="https://images.unsplash.com/photo-1607863680198-23d4b2565df0?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
            alt="">
        </template>
        <h2 class="title">Fabernovel • Customer Enrollment</h2>
        <p class="description">
          It was only for a little time as I worked for Fabernovel.
          In a team with 4 developers and 2 products owners, we developed a solution to enroll customers for BNP, a
          banking
          service.
          I was a dynamic environment facing new challenges and with welcoming people.
          Sadly, I lived too far from the office and after some months, I decided to leave.
        </p>

        <template #footer>
          <UButton icon="i-tabler-external-link" to="https://fabernovel.com" target="_blank" variant="outline"
            label="View project" />
        </template>
      </UCard>

      <UCard class="project-card">
        <template #header>
          <img
            src="https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2F3ddrive-windowed.jpg?alt=media&token=5445f84e-b68d-473c-b201-79fae0a16d70"
            alt="">
        </template>
        <h2 class="title">Dassault Systèmes • File Storage</h2>
        <p class="description">
          At Dassault Systèmes, I developed a cloud storage web application in a team of 7 developers.
          We integrated Google Drive & Microsoft OneDrive APIs (among others) into a single web application.
          I also wrote technical and design specifications in collaboration with the design and QA team.
        </p>

        <template #footer>
          <UButton icon="i-tabler-external-link"
            to="https://www.solidsolutions.co.uk/blog/2019/07/3d-experience-3ddrive/" target="_blank" variant="outline"
            label="View project" />
        </template>
      </UCard>
    </UContainer>
  </div>
</template>

<script lang="ts" setup>
  import { collection, getDocs, query, orderBy, limit } from 'firebase/firestore';
  import { ref, type Ref, computed, onMounted, unref } from 'vue'
  import { useCollection, useFirestore } from 'vuefire'

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
.my-container {
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

  .dot-divider {
    background-color: var(--dot-color);
  }

  .branding-section {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;

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
  
    .project-card {
      margin: 1rem;
      width: 360px;
      transition: transform 0.3s ease;

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
      }
    }

    .project-card:hover {
      transform: scale(1.01);
      /* transform: scale(1.01) translateY(-5px); */
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

</style>