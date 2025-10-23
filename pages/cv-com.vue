<template>
  <div class="w-[600px] mt-24 rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <section class="mb-9">
      <h1 class="font-700">Jérémie Corpinot</h1>
      <!-- <p class="text-size-3.5 font-500 color-gray-600 mb-3 mt-3">
        Professionnel polyvalent de la communication digitale et du web, spécialisé dans la valorisation de l’image et la gestion de l’e-réputation.
      </p> -->
      <h2 class="text-size-3.5 color-gray-600 font-500 dark:color-gray-500">
        Webmaster, développeur web & mobile – {{ new Date().getFullYear() - new Date(2015) }} ans d'expérience
      </h2>
      <h2 class="color-gray-400 dark:color-gray-600">Yvelines, France</h2>
    </section>

    <!-- Introduction -->
    <section class="mb-6">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-2">
        <span class="i-ph-user-circle mr-2"></span>
        Profil
      </h2>
      <p class="text-size-3.5 text-gray-700 dark:text-gray-300 mb-4">
        Webmaster, développeur web / mobile et chargé de communication digitale 
        avec {{ new Date().getFullYear() - new Date(2015) }} ans d'expérience. 
        J'ai piloté la gestion de réseaux sociaux (Facebook, Instagram, Twitter), 
        la création de contenus visuels et rédactionnels, ainsi que l'administration 
        de sites web sous CMS (WordPress, Drupal, Joomla). 
        Réactif et à l'écoute, je sais gérer l'E-réputation et la modération sur les réseaux sociaux, 
        en adaptant la communication selon l'actualité. 
        Disponible et adaptable, j'ai l'habitude de travailler en équipe 
        et de collaborer avec différents services pour mener à bien des projets de communication, 
        y compris l'organisation et la couverture d'événements. 
        Ma polyvalence technique s'accompagne d'une forte sensibilité artistique 
        et d'une pratique quotidienne de la création graphique et multimédia.
      </p>
    </section>

    <!-- Skills -->
    <section class="mb-8">
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div class="col-span-2">
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2">Compétences: Web & Communication</h3>
          <div class="grid grid-cols-2 gap-4">
            <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
              <li>Gestion et administration de sites web (CMS : WordPress, Drupal, Joomla)</li>
              <li>Gestion de réseaux sociaux (Facebook, Instagram, Twitter), modération et E-réputation</li>
              <li>Organisation et couverture d'événements</li>
            </ul>
            <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
              <li>Création de contenus visuels et rédactionnels adaptés à l'actualité</li>
              <li>Travail en équipe et collaboration interservices</li>
              <li>Création graphique (illustrations, vignettes, vidéos)</li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <!-- Work Experience -->
    <section class="workexperience mb-6">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-briefcase mr-2"></span>
        Expériences Professionnelles
      </h2>

      <div>
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">Logora</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2024 - 2025</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Startup dans les industries d'organes de presse et de la loi
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Développement de contenus visuels pour une application législative</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>Communication visuelle</span>
          <span>Création de contenu</span>
        </div>
      </div>

      <div class="mt-6">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">Servier (groupe pharmaceutique)</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2017 - 2018</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Développement et administration de sites web pour le groupe Servier
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Gestion de sites sous CMS (WordPress, Drupal)</li>
          <li>Création et mise à jour de contenus visuels et rédactionnels</li>
        </ul>
      </div>


      <div class="mt-6">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">Mon Windows Phone (rédaction tech)</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2015</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Rédaction d'articles spécialisés sur les applications mobiles et l'écosystème Windows Phone
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Rédaction web, veille technologique</li>
          <li>Gestion de contenus éditoriaux</li>
        </ul>
      </div>

      <div class="mt-6">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">Délégué de résidence étudiante Lamarck</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2013 - 2015</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Animation et gestion de la communication digitale de la résidence
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Gestion de la page Facebook de la résidence</li>
          <li>Organisation d'événements et création de contenus</li>
        </ul>
      </div>
    </section>

    <!-- Education -->
    <section class="mb-12">
      <h2 class="flex items-center text-lg font-500 text-gray-800 dark:text-gray-200 mb-2">
        <span class="i-ph-graduation-cap mr-2"></span>
        Education
      </h2>

      <div>
        <div class="flex justify-between items-start mt-4">
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Master en informatique</h3>
          <span class="text-sm text-gray-600 dark:text-gray-400">2013 - 2015</span>
        </div>
        <div class="text-gray-500 font-500 mb-2">Université de Versailles</div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Études supérieures en informatique avec une spécialisation en algorithmes et développement logiciel
        </p>
        <p class="text-size-3 font-500 text-gray-600 dark:text-gray-300 mb-3">
          Machines de Turing • Algorithmique (théorie des graphes) • Cryptographie et sécurité des réseaux • Développement Java (J2EE) • 
          Développement Python (Flask) • Data mining et intégration de données • Architecture des systèmes d'information
        </p>
      </div>
    </section>

    <!-- Communication & Création de contenu -->
    <section class="mb-12">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-6">
        <span class="i-ph-image mr-2"></span>
        Communication & Création de contenu
      </h2>
      <div class="grid grid-cols-2 gap-6">
        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Gestion de réseaux sociaux</h3>
          <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
            <li>Animation de communauté et modération (Facebook, résidence étudiante)</li>
            <li>Création de vignettes</li>
            <li>Gestion de mon compte d'artiste Instagram</li>
          </ul>
        </div>
        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Rédaction & veille éditoriale</h3>
          <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
            <li>Rédaction d'articles pour Mon Windows Phone</li>
            <li>Veille sur les tendances numériques et réseaux sociaux</li>
          </ul>
        </div>
        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Création graphique & multimédia</h3>
          <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
            <li>Illustrations</li>
            <li>Création de vidéos (projets personnels)</li>
            <li>Pratique artistique quotidienne</li>
          </ul>
        </div>
      </div>
    </section>
    <!-- ...existing code... -->
    
    <!-- Interests -->
    <section class="mb-12">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-6">
        <span class="i-ph-heart mr-2"></span>
        Intérêts
      <!-- ...existing code... -->
        Prenons contact
      </h2>
      <p class="text-gray-700 dark:text-gray-300 mb-6">
        Intéressé•e pour travailler ensemble ou en apprendre davantage sur mon parcours ? N'hésitez pas à me contacter via
        <ULink to="/contact" class="arrow"><span>ma page de contact</span></ULink> 
        ou via les liens ci-dessous.
      </p>
      
      <SocialLinks />
    </section>

    <!-- Footer -->
     <footer class="mt-16 text-size-3">
      <div class="flex gap-4">
        <ULink to="/" class="footer-button">
          <span class="i-ph-house-simple text-size-3 mr-2"></span>
          <span class="font-500">Back to home</span>
        </ULink>
        <UButton btn="~"
          @click="scrollToTop"
          class="footer-button p-0 w-auto h-auto">
          <span class="i-ph-arrow-up-duotone text-size-3 mr-2 -mt-1"></span>
          <span class="font-500 text-size-3  relative -top-0.5">Back to top</span>
        </UButton>
        <ULink to="/resume" class="footer-button">
          <span class="font-500">See this resume in english</span>
        </ULink>
      </div>

      <p class="text-gray-500 dark:text-gray-400">
        © <span class="font-600">Jérémie Corpinot</span>
        <span class="mx-1">&middot;</span>
        <span class="font-600">{{ new Date().getFullYear()  }}</span>
      </p>
     </footer>
  </div>
</template>

<script setup>
definePageMeta({
  title: "CV",
  description: "Expérience professionnelle et compétences d'un développeur web full-stack",
})

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}
</script>

<style scoped>
.workexperience > div {
  padding-bottom: 1.5rem;
  border-bottom: 1px dashed rgba(var(--una-gray-200), 1);

  &:last-child {
    border-bottom: none;
  }
}

.dark .workexperience > div {
  padding-bottom: 1.5rem;
  border-bottom: 1px dashed rgba(var(--una-gray-600), 1);

  &:last-child {
    border-bottom: none;
  }
}

.tags {
  span {
    padding: 0.25rem 0.5rem;
    border-radius: var(--una-radius);
    font-size: 0.75rem; /* 12px */
    line-height: 1rem; /* 16px */
    --un-text-opacity: 1;
    color: rgba(var(--una-gray-700), var(--un-text-opacity))
      /* rgba(var(--una-gray-700) / <alpha-value>) */;
    --un-bg-opacity: 1;
    background-color: rgba(var(--una-gray-100), var(--un-bg-opacity))
    /* rgba(var(--una-gray-100) / <alpha-value>) */;
  }
}
.dark .tags {
  span {
    --un-text-opacity: 1;
    color: rgba(var(--una-gray-300), var(--un-text-opacity))
      /* rgba(var(--una-gray-300) / <alpha-value>) */;
    --un-bg-opacity: 1;
    background-color: rgba(var(--una-gray-800), var(--un-bg-opacity))
    /* rgba(var(--una-gray-800) / <alpha-value>) */;
  }
}

.footer-button {
  display: block;
  color: rgba(var(--una-gray-500), 1);
  transition: all;
  
  &:hover {
    color: rgba(var(--una-gray-600), 1);
    text-decoration: underline;
    text-underline-offset: 4px;
    transform: scale(1.01);
  }
  
  &:active {
    transform: scale(0.99);
  }
}

.dark .footer-button {
  color: rgba(var(--una-gray-400), 1);

  &:hover {
    color: rgba(var(--una-gray-300), 1);
  }
}
</style>
