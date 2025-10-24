/**
 * Seed script to populate the database with existing CV and letter data
 * Run this after migrating your database schema
 */

export default defineEventHandler(async (event) => {
  // Only allow in development or with proper auth
  const { user } = await getUserSession(event)
  if (!user || user.role !== 'admin') {
    throw createError({
      statusCode: 403,
      statusMessage: 'Unauthorized',
    })
  }

  const db = hubDatabase()
  
  try {
    // ==================== SEED RESUMES ====================
    
    // Resume 1: General/Technical CV (cv.vue)
    const cvGeneral = {
      slug: 'cv',
      title: 'CV - Développeur Web & Mobile',
      subtitle: '10 ans d\'expérience • développeur web & mobile',
      type: 'general',
      language: 'fr',
      template_name: 'default',
      name: 'Jérémie Corpinot',
      tagline: `${new Date().getFullYear() - 2015} ans d'expérience • développeur web & mobile`,
      location: 'Yvelines, France',
      profile: JSON.stringify({
        text: `Je suis un développeur avec ${new Date().getFullYear() - 2015} ans d'expérience spécialisé dans les applications web et mobile, avec une emphase sur le développement d'interfaces utilisateur. Je combine une expertise technique avec une sensibilité artistique pour créer des expériences numériques intuitives et engageantes.`
      }),
      skills: JSON.stringify({
        categories: [
          {
            title: 'Frontend',
            skills: ['JavaScript, TypeScript', 'React, Next.js, Vue, Nuxt', 'Design Systems']
          },
          {
            title: 'Backend & Tools',
            skills: ['Node.js, Bun', 'Git/GitLab', 'PostgreSQL, Prisma, NoSQL']
          }
        ]
      }),
      experiences: JSON.stringify([
        {
          company: 'Logora',
          position: 'Developer',
          startDate: '2024-01-01',
          endDate: '2025-01-01',
          description: 'Startup dans les industries d\'organes de presse et de la loi',
          highlights: [
            'Optimiser les textes législatifs avec des LLM',
            'Développer de nouveaux composants visuels pour l\'app législative',
            'Mise à jour de code serveur avec de nouveaux jeux de données'
          ],
          tags: ['React', 'Typescript', 'PostgreSQL', 'Prisma', 'API Integration']
        },
        {
          company: 'Comptoirs',
          position: 'Developer',
          startDate: '2023-01-01',
          endDate: '2024-01-01',
          description: 'PME dans le développement logiciel',
          highlights: [
            'Créer un dashboard de suivi des appareils connectés',
            'Mise en place d\'un design system avec l\'équipe design',
            'Intégration d\'APIs pour la gestion des données'
          ],
          tags: ['React', 'Typescript', 'Design System', 'API Integration']
        },
        {
          company: 'Servier',
          position: 'Developer',
          startDate: '2022-01-01',
          endDate: '2023-01-01',
          description: 'Groupe pharmaceutique international',
          highlights: [
            'Refonte du site web vitrine français MyHealthPartner',
            'Étroite collaboration avec l\'équipe design',
            'Mise en place d\'une solution complète front, back, APIs, DevOps',
            'Intégration d\'APIs Strapi pour la gestion des données',
            'Déploiement de l\'application sur des environnements cloud Azure'
          ],
          tags: ['Next.js', 'Typescript', 'Azure', 'Strapi']
        },
        {
          company: 'Fabernovel',
          position: 'Developer',
          startDate: '2019-01-01',
          endDate: '2019-12-31',
          description: 'Cabinet de conseil en innovation et transformation digitale',
          highlights: [
            'Mission pour un client dans le secteur bancaire',
            'Amélioration d\'un portail interne de gestion de clients',
            'Ajout de fonctionnalités de reporting et d\'analyse',
            'Apprentissage de nouveaux frameworks et langages: Kaiju.js, Scala'
          ],
          tags: ['Typescript', 'Kaiju.js', 'Scala']
        },
        {
          company: 'Dassault Systèmes',
          position: 'Developer',
          startDate: '2015-01-01',
          endDate: '2019-01-01',
          description: 'Éditeur de logiciels de conception 3D, maquette numérique et gestion du cycle de vie des produits',
          highlights: [
            'Développement d\'une application de stockage de fichiers',
            'Intégration d\'API tierces (GoogleDrive, OneDrive, Box)',
            'Intégration de solutions de modélisation 3D',
            'Collaboration avec des équipes pluridisciplinaires (design, tests)',
            'Utilisation de C#, .NET, pour les tests end-to-end',
            'Rédaction de spécifications techniques',
            'Passation de connaissances aux équipes de développement',
            'Participation à des revues de code',
            'Gestion de releases de l\'application'
          ],
          tags: ['JavaScript', 'API', '3D Modeling']
        }
      ]),
      education: JSON.stringify([
        {
          institution: 'Université de Versailles',
          degree: 'Master en informatique',
          startDate: '2013-09-01',
          endDate: '2015-06-30',
          description: 'Études supérieures en informatique avec une spécialisation en algorithmes et développement logiciel',
          courses: [
            'Machines de Turing',
            'Algorithmique (théorie des graphes)',
            'Cryptographie et sécurité des réseaux',
            'Développement Java (J2EE)',
            'Développement Python (Flask)',
            'Data mining et intégration de données',
            'Architecture des systèmes d\'information'
          ]
        }
      ]),
      projects: JSON.stringify([
        {
          name: 'Verbatims',
          url: 'https://verbatims.cc',
          description: 'Découvrez des citations de cinéma, littérature, jeux-vidéos et de pop-culture.',
          tags: ['Web', 'JavaScript', 'Quotes']
        },
        {
          name: 'UnsplashSharp',
          url: 'https://github.com/rootasjey/unsplasharp',
          description: 'Utiliez les fonctionnalités Unsplash dans vos applications .NET.',
          tags: ['C#', '.NET', 'API', 'Unsplash']
        }
      ]),
      interests: JSON.stringify([
        {
          icon: 'i-ph-tree',
          title: 'Activité Physique',
          description: 'Marche en forêt'
        },
        {
          icon: 'i-ph-paint-brush',
          title: 'Créatif',
          description: 'Illustrations, portraits: <a href="https://zimablue.cc/" target="_blank" class="underline">zimablue.cc</a>'
        },
        {
          icon: 'i-ph-device-mobile-camera',
          title: 'Technologie',
          description: 'Microsoft Student Partner'
        },
        {
          icon: 'i-ph-film-slate',
          title: 'Cinéma',
          description: 'Engagé dans l\'analyse de films'
        }
      ]),
      contact: JSON.stringify({
        email: 'contact@rootasjey.dev',
        website: 'https://rootasjey.dev',
        github: 'https://github.com/rootasjey'
      }),
      published: true,
      user_id: user.id
    }

    // Resume 2: Communication-focused CV (cv-com.vue)
    const cvCommunication = {
      slug: 'cv-communication',
      title: 'CV - Chargé de Communication Digitale',
      subtitle: 'Webmaster, développeur web & mobile',
      type: 'communication',
      language: 'fr',
      template_name: 'default',
      name: 'Jérémie Corpinot',
      tagline: `Webmaster, développeur web & mobile – ${new Date().getFullYear() - 2015} ans d'expérience`,
      location: 'Yvelines, France',
      profile: JSON.stringify({
        text: `Webmaster, développeur web / mobile et chargé de communication digitale avec ${new Date().getFullYear() - 2015} ans d'expérience. J'ai piloté la gestion de réseaux sociaux (Facebook, Instagram, Twitter), la création de contenus visuels et rédactionnels, ainsi que l'administration de sites web sous CMS (WordPress, Drupal, Joomla). Réactif et à l'écoute, je sais gérer l'E-réputation et la modération sur les réseaux sociaux, en adaptant la communication selon l'actualité. Disponible et adaptable, j'ai l'habitude de travailler en équipe et de collaborer avec différents services pour mener à bien des projets de communication, y compris l'organisation et la couverture d'événements. Ma polyvalence technique s'accompagne d'une forte sensibilité artistique et d'une pratique quotidienne de la création graphique et multimédia.`
      }),
      skills: JSON.stringify({
        categories: [
          {
            title: 'Web & Communication',
            skills: [
              'Gestion et administration de sites web (CMS : WordPress, Drupal, Joomla)',
              'Gestion de réseaux sociaux (Facebook, Instagram, Twitter), modération et E-réputation',
              'Organisation et couverture d\'événements',
              'Création de contenus visuels et rédactionnels adaptés à l\'actualité',
              'Travail en équipe et collaboration interservices',
              'Création graphique (illustrations, vignettes, vidéos)'
            ]
          }
        ]
      }),
      experiences: JSON.stringify([
        {
          company: 'Logora',
          position: 'Communication & Development',
          startDate: '2024-01-01',
          endDate: '2025-01-01',
          description: 'Startup dans les industries d\'organes de presse et de la loi',
          highlights: [
            'Développement de contenus visuels pour une application législative'
          ],
          tags: ['Communication visuelle', 'Création de contenu']
        },
        {
          company: 'Servier',
          position: 'Webmaster',
          startDate: '2017-01-01',
          endDate: '2018-01-01',
          description: 'Développement et administration de sites web pour le groupe Servier',
          highlights: [
            'Gestion de sites sous CMS (WordPress, Drupal)',
            'Création et mise à jour de contenus visuels et rédactionnels'
          ]
        },
        {
          company: 'Mon Windows Phone',
          position: 'Rédacteur',
          startDate: '2015-01-01',
          endDate: '2015-12-31',
          description: 'Rédaction d\'articles spécialisés sur les applications mobiles et l\'écosystème Windows Phone',
          highlights: [
            'Rédaction web, veille technologique',
            'Gestion de contenus éditoriaux'
          ]
        },
        {
          company: 'Résidence étudiante Lamarck',
          position: 'Délégué',
          startDate: '2013-01-01',
          endDate: '2015-01-01',
          description: 'Animation et gestion de la communication digitale de la résidence',
          highlights: [
            'Gestion de la page Facebook de la résidence',
            'Organisation d\'événements et création de contenus'
          ]
        }
      ]),
      education: JSON.stringify([
        {
          institution: 'Université de Versailles',
          degree: 'Master en informatique',
          startDate: '2013-09-01',
          endDate: '2015-06-30',
          description: 'Études supérieures en informatique avec une spécialisation en algorithmes et développement logiciel',
          courses: [
            'Machines de Turing',
            'Algorithmique (théorie des graphes)',
            'Cryptographie et sécurité des réseaux',
            'Développement Java (J2EE)',
            'Développement Python (Flask)',
            'Data mining et intégration de données',
            'Architecture des systèmes d\'information'
          ]
        }
      ]),
      published: true,
      user_id: user.id
    }

    // Resume 3: Community Manager focus (cv-com-2.vue)
    const cvCommunityManager = {
      slug: 'cv-community-manager',
      title: 'CV - Community Manager / Webmaster',
      subtitle: `Webmaster, développeur web & mobile – ${new Date().getFullYear() - 2015} ans d'expérience`,
      type: 'communication',
      language: 'fr',
      template_name: 'default',
      name: 'Jérémie Corpinot',
      tagline: `Webmaster, développeur web & mobile – ${new Date().getFullYear() - 2015} ans d'expérience`,
      location: 'Yvelines, France',
      profile: JSON.stringify({
        text: 'Webmaster et chargé de communication digitale. Spécialiste réseaux sociaux, contenus (rédaction, visuels, vidéo) et sites WordPress. À l\'aise avec Facebook, Instagram, LinkedIn, YouTube, j\'assure aussi la couverture d\'événements (reels, stories, live). Réactif, orienté données (Analytics/insights) et à l\'aise en équipe comme en astreinte si besoin.'
      }),
      skills: JSON.stringify({
        categories: [
          {
            title: 'Compétences clés',
            skills: [
              'Réseaux sociaux & community management (animation, modération, éditorial)',
              'Contenus: rédaction, photo, vidéo, infographie',
              'Web: WordPress (plugins, thèmes), Next.js/Strapi',
              'Analytics & reporting (Google Analytics, Meta Insights)',
              'Outils: Adobe CC, Filmora, Canva, Buffer/Hootsuite',
              'Soft skills: gestion de crise, réactivité, coordination, veille/IA',
              'Disponibilité: astreintes réseaux sociaux (soirées/week-ends)'
            ]
          }
        ]
      }),
      experiences: JSON.stringify([
        {
          company: 'Logora',
          position: 'Développeur web & contenus',
          startDate: '2024-01-01',
          endDate: '2025-01-01',
          description: 'Développeur web & contenus (application législative)',
          highlights: [
            'UI/UX et optimisation de l\'expérience web, création de visuels',
            'Expérimentations IA sur les textes de loi (veille et prototypage)'
          ]
        },
        {
          company: 'Servier',
          position: 'Webmaster',
          startDate: '2017-01-01',
          endDate: '2018-01-01',
          description: 'Administration de sites WordPress/Strapi (2 sites)',
          highlights: [
            'Gestion plugins, thèmes personnalisés et mises à jour de contenus',
            'Coordination des contributeurs interservices'
          ]
        },
        {
          company: 'MonWindowsPhone',
          position: 'Rédacteur',
          startDate: '2015-01-01',
          endDate: '2015-12-31',
          description: 'Rédaction web (6 articles)',
          highlights: [
            'Veille technologique et analyse d\'audience (insights)'
          ]
        },
        {
          company: 'Résidence Lamarck',
          position: 'Délégué',
          startDate: '2013-01-01',
          endDate: '2015-01-01',
          description: 'Animation et communication (~100 résidents)',
          highlights: [
            'Animation du groupe Facebook (100+ membres, publications 2–3x/semaine)',
            'Organisation d\'événements (sorties, soirées, vidéo-club, participation régulière)',
            'Gestion proactive de l\'engagement et modération communautaire'
          ]
        }
      ]),
      education: JSON.stringify([
        {
          institution: 'Université de Versailles',
          degree: 'Master Informatique',
          startDate: '2013-09-01',
          endDate: '2015-06-30',
          description: 'Algorithmique, sécurité, développement Java/Python, data & architectures SI'
        }
      ]),
      interests: JSON.stringify([
        {
          title: 'Atouts clés',
          description: '<ul><li><strong>Réactivité & gestion de crise</strong> : expérience en modération/astreintes réseaux sociaux</li><li><strong>Approche data-driven</strong> : analytics, insights et optimisation avant décision</li><li><strong>Polyvalence</strong> : technique (WordPress, dev) + créativité (visuels, vidéo, événementiel)</li></ul>'
        }
      ]),
      published: true,
      user_id: user.id
    }

    // Helper function to insert resume
    const insertResume = async (resumeData: any) => {
      const fields = Object.keys(resumeData).join(', ')
      const placeholders = Object.keys(resumeData).map(() => '?').join(', ')
      const values = Object.values(resumeData)
      
      await db.prepare(`INSERT INTO resumes (${fields}) VALUES (${placeholders})`)
        .bind(...values)
        .run()
    }
    
    // Insert resumes
    await insertResume(cvGeneral)
    await insertResume(cvCommunication)
    await insertResume(cvCommunityManager)

    // ==================== SEED COVER LETTERS ====================
    
    // Letter 1: Maurepas (lettre-com.vue)
    const letterMaurepas = {
      slug: 'lettre-maurepas',
      title: 'Lettre de motivation - Ville de Maurepas',
      company_name: 'Ville de Maurepas',
      position: 'Chargé(e) de communication digitale / Webmaster',
      language: 'fr',
      template_name: 'default',
      greeting: 'Madame, Monsieur,',
      body: `
        <p>Résident de Maurepas et passionné par la communication digitale, je souhaite mettre mes compétences et mon engagement au service de ma ville et de mon pays. Issu du monde du développement logiciel, j'ai acquis une solide expérience technique qui me permet d'appréhender les outils numériques avec aisance et d'envisager des améliorations concrètes pour le site web de la ville et ses outils informatiques.</p>
        
        <p>J'accorde une grande importance à la collaboration et au travail en équipe. J'aime échanger, co-construire et faciliter les relations entre les différents acteurs d'un projet, tout en sachant faire preuve de fermeté lorsque la situation l'exige. Mon esprit facilitateur s'accompagne d'une capacité d'observation et d'analyse : je prends le temps d'écouter et d'observer avant de prendre des décisions, afin de garantir la pertinence et l'efficacité de mes actions.</p>
        
        <p>La création artistique occupe une place centrale dans ma vie : je pratique quotidiennement le dessin, l'illustration et la création de contenus visuels. J'ai un attrait particulier pour les événements artistiques, que j'aime organiser, valoriser et partager avec le plus grand nombre.</p>
        
        <p>Mon profil hybride de développeur et de créatif me permet d'apporter un regard neuf et des solutions innovantes pour la communication numérique de la ville. Je suis convaincu que mon expertise technique, alliée à ma passion pour la création et mon sens du service public, seront des atouts précieux pour contribuer au rayonnement de Maurepas.</p>
        
        <p>Flexible et disponible, je m'adapte facilement aux besoins du service, y compris lors d'événements en soirée, le week-end ou les jours fériés.</p>
        
        <p>Je serais honoré de pouvoir mettre mon énergie et mes compétences au service de la collectivité et de participer activement à la valorisation de notre ville.</p>
      `,
      closing: 'Je vous prie d\'agréer, Madame, Monsieur, l\'expression de mes salutations distinguées.',
      signature: 'Jérémie Corpinot',
      published: true,
      user_id: user.id
    }

    // Letter 2: Montigny-le-Bretonneux (lettre-com-2.vue)
    const letterMontigny = {
      slug: 'lettre-montigny',
      title: 'Lettre de motivation - Ville de Montigny-le-Bretonneux',
      company_name: 'Ville de Montigny-le-Bretonneux',
      position: 'Community Manager / Webmaster',
      language: 'fr',
      template_name: 'default',
      greeting: 'Madame, Monsieur,',
      body: `
        <p>Passionné par la communication digitale, la création de contenus et fort de ${new Date().getFullYear() - 2015} ans d'expérience de développeur et webmaster, je souhaite mettre mes compétences au service de la commune de Montigny-le-Bretonneux. Habitant à Maurepas, j'apprécie particulièrement la commune pour la qualité de son cadre de vie et son engagement en faveur de la nature. Après plusieurs années dans le secteur privé, je souhaite désormais contribuer au rayonnement d'une collectivité qui partage mes valeurs.</p>
        
        <p><strong>Expertises digitales et création de contenus</strong><br>
        Mon expérience combine community management (animation d'une communauté Facebook de 100 membres, organisation d'événements), administration WordPress (deux sites chez Servier) et création de contenus multimédias. À l'aise avec l'ensemble des plateformes sociales (Facebook, Instagram, LinkedIn, YouTube), je maîtrise la création de formats variés : reels, stories, carrousels et couverture live d'événements. Je pratique régulièrement le montage vidéo et l'infographie (<em>Adobe Creative Cloud, Filmora, Canva</em>).</p>

        <p><strong>Analyse et innovation</strong><br>
        Mon expérience rédactionnelle pour <em>MonWindowsPhone</em> (plusieurs milliers de visiteurs hebdomadaires) m'a formé à l'analyse de statistiques et au reporting. Curieux des innovations technologiques, j'explore régulièrement les potentialités de l'IA (de manière éthique) dans la création de contenus et l'optimisation de l'engagement (expérimentations chez Logora sur le traitement de textes de loi).</p>

        <p><strong>Disponibilité et réactivité</strong><br>
        Flexible et disponible, je m'adapte aux besoins du service : événements en soirée ou week-end, astreintes réseaux sociaux en cas d'urgence. Mon expérience en animation de communauté m'a appris l'importance d'une communication rapide et appropriée en situation de crise. J'ai également développé de solides compétences en coordination d'équipes à travers mes projets open source (60 contributeurs sur GitHub).</p>

        <p>Convaincu que mon expertise digitale et ma passion pour la création seront des atouts pour valoriser le territoire et ses initiatives, je serais honoré d'échanger avec vous sur la façon dont je peux contribuer au rayonnement de Montigny-le-Bretonneux.</p>
      `,
      closing: 'Je vous prie d\'agréer, Madame, Monsieur, l\'expression de mes salutations distinguées.',
      signature: 'Jérémie Corpinot',
      published: true,
      user_id: user.id
    }

    // Helper function to insert cover letter
    const insertLetter = async (letterData: any) => {
      const fields = Object.keys(letterData).join(', ')
      const placeholders = Object.keys(letterData).map(() => '?').join(', ')
      const values = Object.values(letterData)
      
      await db.prepare(`INSERT INTO cover_letters (${fields}) VALUES (${placeholders})`)
        .bind(...values)
        .run()
    }
    
    // Insert cover letters
    await insertLetter(letterMaurepas)
    await insertLetter(letterMontigny)

    return {
      success: true,
      message: 'Database seeded successfully',
      data: {
        resumes: 3,
        coverLetters: 2
      }
    }
  } catch (error: any) {
    console.error('Seed error:', error)
    throw createError({
      statusCode: 500,
      statusMessage: `Failed to seed database: ${error.message}`,
    })
  }
})
