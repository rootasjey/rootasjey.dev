<template>
  <div class="w-[600px] mt-24 rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <section class="mb-9">
      <h1 class="font-600">Jérémie Corpinot</h1>
      <h2 class="color-gray-600 font-500 dark:color-gray-500">
        {{ new Date().getFullYear() - new Date(2015) }} ans • développeur web & mobile
      </h2>
      <h2 class="color-gray-400 dark:color-gray-600">Yvelines, France</h2>
    </section>

    <!-- Introduction -->
    <section class="mb-6">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-2">
        <span class="i-ph-user-circle mr-2"></span>
        Profil
      </h2>
      <p class="text-size-4 text-gray-700 dark:text-gray-300 mb-4">
        Je suis un développeur avec {{ new Date().getFullYear() - new Date(2015) }} ans d'expérience spécialisé dans les applications web et mobile, avec une
        emphase sur le développement d'interfaces utilisateur. Je combine une expertise technique avec une sensibilité artistique pour
        créer des expériences numériques intuitives et engageantes.
      </p>
    </section>

    <!-- Skills -->
    <section class="mb-8">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-code mr-2"></span>
        Compétences Techniques
      </h2>
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2">Frontend</h3>
          <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
            <li>JavaScript, TypeScript</li>
            <li>React, Next.js, Vue, Nuxt</li>
            <li>Design Systems</li>
          </ul>
        </div>
        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2">Backend & Tools</h3>
          <ul class="list-disc list-inside text-size-3 font-500 text-gray-500 dark:text-gray-300">
            <li>Node.js, Bun</li>
            <li>Git/GitLab</li>
            <li>PostgreSQL, Prisma, NoSQL</li>
          </ul>
        </div>
      </div>
    </section>

    <!-- Work Experience -->
    <section class="workexperience mb-6">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-briefcase mr-2"></span>
        Expérience Professionnelle
      </h2>

      <div class="mt-6">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">Logora</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2024 - 2025</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Startup dans les industries d'organes de presse et de la loi
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Optimiser les textes législatifs avec des LLM</li>
          <li>Développer de nouveaux composants visuels pour l'app législative</li>
          <li>Mise à jour de code serveur avec de nouveaux jeux de données</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>React</span>
          <span>Typescript</span>
          <span>PostgreSQL</span>
          <span>Prisma</span>
          <span>API Integration</span>
        </div>
      </div>

      <div class="mt-6">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">Comptoirs</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2023 - 2024</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          PME dans le développement logiciel
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Créer un dashboard de suivi des appareils connectés</li>
          <li>Mise en place d'un design system avec l'équipe design</li>
          <li>Intégration d'APIs pour la gestion des données</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>React</span>
          <span>Typescript</span>
          <span>Design System</span>
          <span>API Integration</span>
        </div>
      </div>

      <div class="mt-6">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">Servier</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2022 - 2023</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Groupe pharmaceutique international
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Refonte du site web vitrine français MyHealthPartner</li>
          <li>Étroite collaboration avec l'équipe design</li>
          <li>Mise en place d'une solution complète front, back, APIs, DevOps</li>
          <li>Intégration d'APIs Strapi pour la gestion des données</li>
          <li>Déploiement de l'application sur des environnements cloud Azure</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>Next.js</span>
          <span>Typescript</span>
          <span>Azure</span>
          <span>Strapi</span>
        </div>
      </div>

      <div class="mt-6">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">Fabernovel</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2019</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Cabinet de conseil en innovation et transformation digitale
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Mission pour un client dans le secteur bancaire</li>
          <li>Amélioration d'un portail interne de gestion de clients</li>
          <li>Ajout de fonctionnalités de reporting et d'analyse</li>
          <li>Apprentissage de nouveaux frameworks et langages: Kaiju.js, Scala</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>Typescript</span>
          <span>Kaiju.js</span>
          <span>Scala</span>
        </div>
      </div>

      <div class="mt-6">
        <div class="flex justify-between items-start">
          <div class="text-accent font-500 mb-2">Dassault Systèmes</div>
          <span class="text-sm text-gray-600 dark:text-gray-400">2015 - 2019</span>
        </div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Éditeur de logiciels de conception 3D, maquette numérique et gestion du cycle de vie des produits
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Développement d'une application de stockage de fichiers</li>
          <li>Intégration d'API tierces (GoogleDrive, OneDrive, Box)</li>
          <li>Intégration de solutions de modélisation 3D</li>
          <li>Collaboration avec des équipes pluridisciplinaires (design, tests)</li>
          <li>Utilisation de C#, .NET, pour les tests end-to-end</li>
          <li>Rédaction de spécifications techniques</li>
          <li>Passation de connaissances aux équipes de développement</li>
          <li>Participation à des revues de code</li>
          <li>Gestion de releases de l'application</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>JavaScript</span>
          <span>API</span>
          <span>3D Modeling</span>
        </div>
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

    <!-- Personal Projects -->
    <section class="mb-12">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-3">
        <span class="i-ph-rocket-launch mr-2"></span>
        Projets Personnels
      </h2>

      <div class="flex flex-row flex-wrap justify-between">
        <div class="w-full md:w-1/2.3 lg:w-1/3">
          <div class="flex justify-between items-start">
            <h3 class="font-500 text-gray-800 dark:text-gray-200">
              <a href="https://verbatims.cc" target="_blank">
                Verbatims
              </a>
            </h3>
          </div>
          <div class="text-size-3 text-gray-500 font-500 mb-2">App de citations • web</div>
          <p class="text-size-3 font-500 text-gray-600 dark:text-gray-300 mb-3">
            Découvrez des citations de cinéma, littérature, jeux-vidéos et de pop-culture.
          </p>
          <div class="tags flex flex-wrap gap-2 mt-2">
            <span>Web</span>
            <span>JavaScript</span>
            <span>Quotes</span>
          </div>
        </div>

        <div class="w-full md:w-1/2.3 lg:w-1/3">
          <div class="flex justify-between items-start">
            <h3 class="font-500 text-gray-800 dark:text-gray-200">
              <a href="https://github.com/rootasjey/unsplasharp" target="_blank">
                UnsplashSharp
              </a>
            </h3>
          </div>
          <div class="text-size-3 text-gray-500 font-500 mb-2">Bibliothèque en C# • .NET</div>
          <p class="text-size-3 font-500 text-gray-600 dark:text-gray-300 mb-3">
            Utiliez les fonctionnalités Unsplash dans vos applications .NET.
          </p>
          <div class="tags flex flex-wrap gap-2 mt-2">
            <span>C#</span>
            <span>.NET</span>
            <span>API</span>
            <span>Unsplash</span>
          </div>
        </div>
      </div>
    </section>
    
    <!-- Interests -->
    <section class="mb-12">
      <h2 class="flex items-center text-4 font-500 text-gray-800 dark:text-gray-200 mb-3">
        Intérêts
      </h2>

      <div class="grid grid-cols-2 gap-6">
        <div>
          <h3 class="text-size-4 font-500 text-gray-800 dark:text-gray-200 mb-1 flex items-center">
            <span class="i-ph-tree mr-2"></span>
            Activité Physique
          </h3>
          <p class="text-size-4 text-gray-500 dark:text-gray-300">
            Marche en forêt
          </p>
        </div>

        <div>
          <h3 class="text-size-4 font-500 text-gray-800 dark:text-gray-200 mb-1 flex items-center">
            <span class="i-ph-paint-brush mr-2"></span>
            Créatif
          </h3>
          <p class="text-size-4 text-gray-500 dark:text-gray-300">
            Illustrations, portraits: <a href="https://zimablue.cc/" target="_blank" class="underline">zimablue.cc</a>
          </p>
        </div>

        <div>
          <h3 class="text-size-4 font-500 text-gray-800 dark:text-gray-200 mb-1 flex items-center">
            <span class="i-ph-device-mobile-camera mr-2"></span>
            Technologie
          </h3>
          <p class="text-size-4 text-gray-500 dark:text-gray-300">
            Microsoft Student Partner
          </p>
        </div>

        <div>
          <h3 class="text-size-4 font-500 text-gray-800 dark:text-gray-200 mb-1 flex items-center">
            <span class="i-ph-film-slate mr-2"></span>
            Cinéma
          </h3>
          <p class="text-size-4 text-gray-500 dark:text-gray-300">
            Engagé dans l'analyse de films
          </p>
        </div>
      </div>
    </section>

    <!-- Connect -->
    <section>
      <h2 class="flex items-center text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-handshake mr-2"></span>
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
