<template>
  <div class="frame">
    <header>
      <h1>Resume</h1>
    </header>

    <section class="w-full">
      <h1 class="font-600">Jérémie Corpinot</h1>
      <p class="color-gray-600 font-500 dark:color-gray-500">
        {{ new Date().getFullYear() - new Date(2015) }} years • software developer
      </p>
      <p class="color-gray-400 dark:color-gray-600">Yvelines, France</p>
    </section>

    <!-- Introduction -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-user-circle mr-2"></span>
        Professional Profile
      </h2>
      <p class="text-gray-700 dark:text-gray-300 mb-4">
        I'm a creative developer with 8 years of experience specializing in fullstack web applications with an emphasis 
        on frontend development. I combine technical expertise with an artistic sensibility to create intuitive, 
        engaging digital experiences. My approach is methodical yet innovative, focusing on clean code architecture 
        while embracing creative solutions to complex problems.
      </p>
    </section>

    <!-- Skills -->
    <section>
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-code mr-2"></span>
        Technical Skills
      </h2>
      <div class="grid grid-cols-2 gap-4 mb-4">
        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2">Frontend</h3>
          <ul class="list-disc list-inside text-gray-700 dark:text-gray-300">
            <li>JavaScript/TypeScript</li>
            <li>React & Next.js</li>
            <li>Vue & Nuxt</li>
            <li>HTML5/CSS3</li>
            <li>Design Systems</li>
          </ul>
        </div>
        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2">Backend & Tools</h3>
          <ul class="list-disc list-inside text-gray-700 dark:text-gray-300">
            <li>Node.js</li>
            <li>API Integration</li>
            <li>Git/GitLab</li>
            <li>Figma</li>
            <li>CI/CD Pipelines</li>
          </ul>
        </div>
      </div>
    </section>

    <!-- Work Experience -->
    <section class="workexperience mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-6">
        <span class="i-ph-briefcase mr-2"></span>
        Work Experience
      </h2>

      <div class="mb-8">
        <div class="flex justify-between items-start mb-2">
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Fullstack Developer</h3>
          <span class="text-sm text-gray-600 dark:text-gray-400">July 2024 - Jan 2025</span>
        </div>
        <div class="text-accent font-500 mb-2">Logora</div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Startup in the publishing and law industries
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Optimized legislative text extraction with LLM</li>
          <li>Developed new UI components for the frontend legislative platform</li>
          <li>Updated backend code to work with new dataset</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>React</span>
          <span>Typescript</span>
          <span>PostgreSQL</span>
          <span>Prisma</span>
          <span>API Integration</span>
        </div>
      </div>

      <div class="mb-8">
        <div class="flex justify-between items-start mb-2">
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Frontend Developer</h3>
          <span class="text-sm text-gray-600 dark:text-gray-400">Oct 2022 - Apr 2023</span>
        </div>
        <div class="text-accent font-500 mb-2">Comptoirs.co</div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Digital agency developing solutions for various industries (e.g. Dassault, Allianz, Renault)
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Created a back office to monitor connected devices</li>
          <li>Developed a design system in collaboration with component and design teams</li>
          <li>Built a middleware to integrate APIs from the backend team</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>React</span>
          <span>GitLab</span>
          <span>Figma</span>
          <span>API Integration</span>
        </div>
      </div>

      <div class="mb-8">
        <div class="flex justify-between items-start mb-2">
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Mentor</h3>
          <span class="text-sm text-gray-600 dark:text-gray-400">Jan 2021 - May 2022</span>
        </div>
        <div class="text-accent font-500 mb-2">OpenClassrooms</div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Online learning platform
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Taught programming concepts (web standards, python)</li>
          <li>Helped and motivated students on the path of reconversion in computer science</li>
          <li>Gave professional advices for their future career</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>HTML/CSS</span>
          <span>Javascript</span>
          <span>GitHub</span>
          <span>Python</span>
        </div>
      </div>

      <div class="mb-8">
        <div class="flex justify-between items-start mb-2">
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Fullstack Developer</h3>
          <span class="text-sm text-gray-600 dark:text-gray-400">Jul 2021 - Feb 2022</span>
        </div>
        <div class="text-accent font-500 mb-2">Servier</div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Pharmaceutical company governed by a non-profit foundation
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Developed a new platform for MyHealthPartner service</li>
          <li>Created a design system with component and maquette integration, working closely with design team</li>
          <li>Built and implemented Strapi backend</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>Next.js</span>
          <span>React</span>
          <span>Azure</span>
          <span>Vercel</span>
          <span>Platform.sh</span>
          <span>Figma</span>
          <span>Strapi</span>
        </div>
      </div>

      <div>
        <div class="flex justify-between items-start mb-2">
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Frontend Developer</h3>
          <span class="text-sm text-gray-600 dark:text-gray-400">Mar 2015 - Feb 2019</span>
        </div>
        <div class="text-accent font-500 mb-2">Dassault Systèmes</div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Software corporation developing 3D product design, simulation, and manufacturing solutions
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Added multiple features to a cloud storage application (web based)</li>
          <li>Implemented OneDrive, GoogleDrive, and Dropbox APIs integration</li>
          <li>Collaborated closely with UI/UX teams and wrote technical specifications</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>JavaScript</span>
          <span>Git</span>
          <span>V Cycle</span>
          <span>API Integration</span>
          <span>Selenium</span>
          <span>TestHarness</span>
          <span>KarmaJS</span>
        </div>
      </div>
    </section>

    <!-- Education -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-6">
        <span class="i-ph-graduation-cap mr-2"></span>
        Education
      </h2>

      <div>
        <div class="flex justify-between items-start mb-2">
          <h3 class="font-500 text-gray-800 dark:text-gray-200">Master's Degree in Computer Science</h3>
          <span class="text-sm text-gray-600 dark:text-gray-400">2013 - 2015</span>
        </div>
        <div class="text-accent font-500 mb-2">Université de Versailles</div>
        <p class="text-gray-600 dark:text-gray-400 text-sm italic mb-3">
          Advanced studies in computer science with focus on algorithms and software development
        </p>
        <p class="text-gray-700 dark:text-gray-300 mb-3">
          Key coursework and projects:
        </p>
        <ul class="list-disc list-outside ml-5 text-gray-700 dark:text-gray-300 mb-3">
          <li>Algorithms (traveling salesman problem, graph theory, robot movement)</li>
          <li>Cryptography and network security</li>
          <li>J2EE (Spring) and backend development</li>
          <li>Python (Flask) backend development</li>
          <li>Data mining & data integration (work on music pieces)</li>
          <li>Flask and Python (development of a course platform)</li>
          <li>Design patterns (Observer, Composition, Factory)</li>
          <li>Systems architecture</li>
          <li>Turing machines and transistors</li>
          <li>Database processing and management</li>
        </ul>
        <div class="tags flex flex-wrap gap-2 mt-2">
          <span>Java</span>
          <span>Spring</span>
          <span>Python</span>
          <span>Flask</span>
          <span>Algorithms</span>
          <span>Data Mining</span>
          <span>Design Patterns</span>
        </div>
      </div>
    </section>

    <!-- Personal Projects -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-6">
        <span class="i-ph-rocket-launch mr-2"></span>
        Personal Projects
      </h2>

      <div class="flex flex-row flex-wrap justify-between">
        <div class="w-full md:w-1/2.3 lg:w-1/3">
          <div class="flex justify-between items-start mb-2">
            <h3 class="font-500 text-gray-800 dark:text-gray-200">Kwotes</h3>
          </div>
          <div class="text-accent font-500 mb-2">Quotes app • web</div>
          <p class="text-gray-700 dark:text-gray-300 mb-3">
            Discover Kwotes, your go-to companion for inspiring, motivating, and sharing moments of
            wisdom anytime, anywhere.
          </p>
          <div class="tags flex flex-wrap gap-2 mt-2">
            <span>Web</span>
            <span>JavaScript</span>
            <span>Quotes</span>
          </div>
        </div>

        <div class="w-full md:w-1/2.3 lg:w-1/3">
          <div class="flex justify-between items-start mb-2">
            <h3 class="font-500 text-gray-800 dark:text-gray-200">Unsplasharp</h3>
          </div>
          <div class="text-accent font-500 mb-2">Unsplash library in C# • .NET</div>
          <p class="text-gray-700 dark:text-gray-300 mb-3">
            Unsplasharp enables seamless integration of Unsplash features into .NET applications.
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
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-6">
        <span class="i-ph-heart mr-2"></span>
        Interests
      </h2>

      <div class="grid grid-cols-2 gap-6">
        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2 flex items-center">
            <span class="i-ph-tree mr-2"></span>
            Physical Activity
          </h3>
          <p class="text-gray-700 dark:text-gray-300">
            Brisk walking in forest
          </p>
        </div>

        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2 flex items-center">
            <span class="i-ph-paint-brush mr-2"></span>
            Creative
          </h3>
          <p class="text-gray-700 dark:text-gray-300">
            Illustrations, portraits
          </p>
        </div>

        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2 flex items-center">
            <span class="i-ph-device-mobile-camera mr-2"></span>
            Technology
          </h3>
          <p class="text-gray-700 dark:text-gray-300">
            Microsoft Student Partner (3 years)
          </p>
        </div>

        <div>
          <h3 class="font-500 text-gray-800 dark:text-gray-200 mb-2 flex items-center">
            <span class="i-ph-film-slate mr-2"></span>
            Cinema
          </h3>
          <p class="text-gray-700 dark:text-gray-300">
            Engaged in critical film analysis
          </p>
        </div>
      </div>
    </section>

    <!-- Connect -->
    <section>
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-handshake mr-2"></span>
        Let's Connect
      </h2>
      <p class="text-gray-700 dark:text-gray-300 mb-6">
        Interested in working together or learning more about my experience? Feel free to reach out through 
        <ULink to="/contact" class="arrow"><span>my contact page</span></ULink> 
        or connect with me on the platforms below.
      </p>
      
      <SocialLinks />
    </section>

    <!-- Footer -->
     <footer class="w-2xl mt-16 text-size-3">
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
        <ULink to="/cv" class="footer-button">
          <span class="font-500">Voir ce cv en français</span>
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
  title: 'Resume',
  description: 'Professional experience and skills of a creative developer specializing in fullstack web applications.'
})

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}
</script>

<style scoped>
.frame {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  min-height: 100vh;
  padding-bottom: 12rem;

  > header {
    width: 42rem;
    margin-top: 3rem;
    margin-bottom: 3rem;
    text-align: center;
    padding: 0.5rem;
    
    border-bottom: 1px dashed rgba(var(--una-gray-200), 1);

    @media (min-width: 768px) {
      padding: 2rem;
      margin-top: 6rem;
    }

    > h1 {
      font-family: "Pilcrow Rounded";
      font-size: 3.75rem;
      line-height: 1;
      font-weight: 600;
      --un-text-opacity: 1;
      color: rgba(var(--una-gray-800), var(--un-text-opacity));
      margin-bottom: 1.5rem;
    }

    > h4 {
      font-size: 1.25rem;
      font-weight: 300;
      margin-bottom: 1.5rem;
      --un-text-opacity: 1;
      color: rgba(var(--una-gray-800), var(--un-text-opacity));
      max-width: 42rem; /* 672px */
      margin-left: auto;
      margin-right: auto;
    }
  }


  > section {
    width: 100%;
    max-width: 42rem;
    margin-bottom: 3rem;

    > p:not(:last-child) {
      --un-text-opacity: 1;
      color: rgba(var(--una-gray-700), var(--un-text-opacity));
      margin-bottom: 1rem;
    }

    > h2 {
      font-size: 1.125rem;
      line-height: 1.75rem;
      font-weight: 500;
      display: flex;
      align-items: center;
      gap: 0.75rem;
      --un-text-opacity: 1;
      color: rgba(var(--una-gray-800), var(--un-text-opacity));
      margin-bottom: 1rem;
    }
  }
}

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
    color: rgba(var(--una-gray-700), var(--un-text-opacity));
    --un-bg-opacity: 1;
    background-color: rgba(var(--una-gray-100), var(--un-bg-opacity));
  }
}
.dark .tags {
  span {
    --un-text-opacity: 1;
    color: rgba(var(--una-gray-300), var(--un-text-opacity));
    --un-bg-opacity: 1;
    background-color: rgba(var(--una-gray-800), var(--un-bg-opacity));
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
