<template>
  <div class="w-[600px] mt-24 rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <section class="mb-9">
      <h1 class="font-700">Jérémie Corpinot</h1>
      <h2 class="text-size-3.5 color-gray-600 font-500 dark:color-gray-500">
        Webmaster, développeur web & mobile – {{ new Date().getFullYear() - 2015 }} ans d'expérience
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
        Webmaster et chargé de communication digitale. 
        Spécialiste réseaux sociaux, contenus (rédaction, visuels, vidéo) et sites WordPress. 
        À l'aise avec Facebook, Instagram, LinkedIn, YouTube, j'assure aussi la couverture d'événements (reels, stories, live). 
        Réactif, orienté données (Analytics/insights) et à l'aise en équipe comme en astreinte si besoin.
      </p>
    </section>

    <!-- Skills -->
    <section class="mb-8">
      <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2">Compétences clés</h3>
      <div class="grid grid-cols-2 gap-4">
        <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
          <li>Réseaux sociaux & community management (animation, modération, éditorial)</li>
          <li>Contenus: rédaction, photo, vidéo, infographie</li>
          <li>Web: WordPress (plugins, thèmes), Next.js/Strapi</li>
        </ul>
        <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
          <li>Analytics & reporting (Google Analytics, Meta Insights)</li>
          <li>Outils: Adobe CC, Filmora, Canva, Buffer/Hootsuite</li>
          <li>Soft skills: gestion de crise, réactivité, coordination, veille/IA</li>
          <li>Disponibilité: astreintes réseaux sociaux (soirées/week-ends)</li>
        </ul>
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
          <div class="text-accent font-500 mb-1">Logora</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2024 – 2025</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-2">Développeur web & contenus (application législative)</p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-2">
          <li>UI/UX et optimisation de l'expérience web, création de visuels</li>
          <li>Expérimentations IA sur les textes de loi (veille et prototypage)</li>
        </ul>
      </div>

      <div class="mt-5">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-1">Servier (groupe pharmaceutique)</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2017 – 2018</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-2">Administration de sites WordPress/Strapi (2 sites)</p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-2">
          <li>Gestion plugins, thèmes personnalisés et mises à jour de contenus</li>
          <li>Coordination des contributeurs interservices</li>
        </ul>
      </div>

      <div class="mt-5">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-1">MonWindowsPhone (rédaction tech)</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2015</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-2">Rédaction web (6 articles)</p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-2">
          <li>Veille technologique et analyse d'audience (insights)</li>
        </ul>
      </div>

      <div class="mt-5">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-1">Délégué de résidence Lamarck</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2013 – 2015</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-2">Animation et communication (~100 résidents)</p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-2">
          <li>Animation du groupe Facebook (100+ membres, publications 2–3x/semaine)</li>
          <li>Organisation d'événements (sorties, soirées, vidéo-club, participation régulière)</li>
          <li>Gestion proactive de l'engagement et modération communautaire</li>
        </ul>
      </div>
    </section>

    <!-- Education -->
    <section class="mb-12">
      <h2 class="flex items-center text-lg font-500 text-gray-800 dark:text-gray-200 mb-2">
        <span class="i-ph-graduation-cap mr-2"></span>
        Education
      </h2>

      <div class="mt-3">
        <div class="flex justify-between items-start">
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Master Informatique — Université de Versailles</h3>
          <span class="text-sm text-gray-600 dark:text-gray-400">2013 – 2015</span>
        </div>
        <p class="text-size-3 font-500 text-gray-600 dark:text-gray-300">
          Algorithmique, sécurité, développement Java/Python, data & architectures SI
        </p>
      </div>
    </section>

    <!-- Removed detailed communication section to keep the CV concise -->
    
    <!-- Atouts -->
    <section class="mb-12">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-3">
        <span class="i-ph-star mr-2"></span>
        Atouts clés
      </h2>
      <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
        <li><strong>Réactivité & gestion de crise</strong> : expérience en modération/astreintes réseaux sociaux</li>
        <li><strong>Approche data-driven</strong> : analytics, insights et optimisation avant décision</li>
        <li><strong>Polyvalence</strong> : technique (WordPress, dev) + créativité (visuels, vidéo, événementiel)</li>
      </ul>
    </section>
    
    <!-- Interests -->
    <section class="mb-12">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-6">
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
