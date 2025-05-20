<template>
  <div class="w-[600px] rounded-xl p-8 pb-[38vh] flex flex-col transition-all duration-500 overflow-y-auto">
    <!-- Header -->
    <header class="mt-12 mb-8">
      <div class="flex gap-2">
        <ULink to="/" class="hover:scale-102 active:scale-99 transition">
          <span class="i-ph-house-simple-duotone"></span>
        </ULink>
        <span>•</span>
        <h1 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200">
          Resume
        </h1>
      </div>
      <div class="w-40 flex text-center justify-center my-2">
        <div class="w-full h-2">
          <svg viewBox="0 0 300 10" preserveAspectRatio="none">
            <path d="M 0 5 Q 15 0, 30 5 T 60 5 T 90 5 T 120 5 T 150 5 T 180 5 T 210 5 T 240 5 T 270 5 T 300 5"
              stroke="currentColor" fill="none" class="text-gray-300 dark:text-gray-700" stroke-width="1" />
          </svg>
        </div>
      </div>
    </header>

    <section class="mb-12">
      <h1 class="font-600">Jérémie Corpinot</h1>
      <h2 class="color-gray-600 font-500 dark:color-gray-500">8 years creative developer</h2>
      <h2 class="color-gray-400 dark:color-gray-600">Yvelines, France</h2>
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
    <section class="mb-12">
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
      
      <div class="flex flex-wrap gap-4">
        <ULink to="https://github.com/rootasjey" target="_blank" rel="noopener noreferrer" 
           class="flex items-center gap-2 px-4 py-2 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
          <div class="i-ph-github-logo"></div>
          <span class="font-600 text-size-3">GitHub</span>
        </ULink>
        <ULink to="https://www.instagram.com/rootasjey" target="_blank" rel="noopener noreferrer"
           class="flex items-center gap-2 px-4 py-2 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
          <div class="i-ph-instagram-logo"></div>
          <span class="font-600 text-size-3">Instagram</span>
        </ULink>
        <ULink to="https://www.linkedin.com/in/jeremiecorpinot/" target="_blank" rel="noopener noreferrer"
           class="flex items-center gap-2 px-4 py-2 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors">
          <div class="i-ph-linkedin-logo"></div>
          <span class="font-600 text-size-3">LinkedIn</span>
        </ULink>
      </div>
    </section>

    <!-- Footer -->
     <footer class="mt-16 text-size-3">
      <div class="flex gap-4">
        <ULink to="/" class="footer-button">
          <span class="i-ph-arrow-arc-left-duotone text-size-4 mr-2"></span>
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
