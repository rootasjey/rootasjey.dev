<template>
    <div class="w-[600px] mt-24 rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <section class="mb-12">
      <h1 class="font-600 mb-4">Lettre de motivation</h1>
      <h2 class="color-gray-600 font-500 dark:color-gray-500 mb-8">Candidature au poste de Community Manager / Webmaster – Ville de Montigny-le-Bretonneux</h2>
      <p class="mb-6">
        Madame, Monsieur,
      </p>
      
      <p class="mb-4">
        Passionné par la communication digitale, la création de contenus et fort de {{ new Date().getFullYear() - 2015 }} ans d'expérience de développeur et webmaster, 
        je souhaite mettre mes compétences au service de la commune de Montigny-le-Bretonneux. 
        Habitant à Maurepas, j'apprécie particulièrement la commune pour la qualité de son cadre de vie 
        et son engagement en faveur de la nature. Après plusieurs années dans le secteur privé, 
        je souhaite désormais contribuer au rayonnement d'une collectivité qui partage mes valeurs.
      </p>
      
      <p class="mb-4">
        <strong>Expertises digitales et création de contenus</strong><br>
        Mon expérience combine community management (animation d'une communauté Facebook de 100 membres, 
        organisation d'événements), administration WordPress (deux sites chez Servier) 
        et création de contenus multimédias. À l'aise avec l'ensemble des plateformes sociales 
        (Facebook, Instagram, LinkedIn, YouTube), je maîtrise la création de formats variés : 
        reels, stories, carrousels et couverture live d'événements. 
        Je pratique régulièrement le montage vidéo et l'infographie 
        (<i>Adobe Creative Cloud, Filmora, Canva</i>).
      </p>

      <p class="mb-4">
        <strong>Analyse et innovation</strong><br>
        Mon expérience rédactionnelle pour <i>MonWindowsPhone</i> (plusieurs milliers de visiteurs hebdomadaires) 
        m'a formé à l'analyse de statistiques et au reporting. 
        Curieux des innovations technologiques, j'explore régulièrement les potentialités de l'IA 
        (de manière éthique) dans la création de contenus et l'optimisation de l'engagement 
        (expérimentations chez Logora sur le traitement de textes de loi).
      </p>

      <p class="mb-4">
        <strong>Disponibilité et réactivité</strong><br>
        Flexible et disponible, je m'adapte aux besoins du service : 
        événements en soirée ou week-end, astreintes réseaux sociaux en cas d'urgence. 
        Mon expérience en animation de communauté m'a appris l'importance d'une communication rapide 
        et appropriée en situation de crise. J'ai également développé de solides compétences 
        en coordination d'équipes à travers mes projets open source (60 contributeurs sur GitHub).
      </p>

      <p class="mb-6">
        Convaincu que mon expertise digitale et ma passion pour la création seront des atouts 
        pour valoriser le territoire et ses initiatives, je serais honoré d'échanger avec vous 
        sur la façon dont je peux contribuer au rayonnement de Montigny-le-Bretonneux.
      </p>
      
      <p>
        Je vous prie d'agréer, Madame, Monsieur, l'expression de mes salutations distinguées.
      </p>
      <p class="mt-8 font-500">Jérémie Corpinot</p>
    </section>
  </div>
</template>

<script setup>
definePageMeta({
  title: "Lettre de motivation",
  description: "Lettre de motivation pour le poste de Community Manager / Webmaster à Montigny-le-Bretonneux",
})
</script>
