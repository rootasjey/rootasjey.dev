
<template>
  <div class="max-w-4xl mx-auto px-4 py-8 my-24">
    <article class="space-y-8">
      <!-- Header -->
       <header class="mb-16 text-center flex flex-col items-center">
        <div class="flex items-center gap-2 ml--3">
          <UTooltip
            content="Go back"
          :_tooltip-content="{
            side: 'right',
          }">
            <template #default>
              <button opacity-50 flex items-center gap-2 @click="$router.back()">
                <div class="i-ph:arrow-bend-down-left-bold"></div>
              </button>
            </template>
            <template #content>
              <button @click="$router.back()" bg="light dark:dark" text="dark dark:white" text-3 px-3 py-1 rounded-md border-1 border-dashed class="b-#3D3BF3">
                Go back
              </button>
            </template>
          </UTooltip>
          <h1 class="font-body text-2xl font-600 text-gray-800 dark:text-gray-200">
            3DDrive
          </h1>
        </div>
        <h5 class="text-gray-800 dark:text-gray-200 text-12px opacity-50">
          3D models cloud storage
        </h5>
        <div class="flex gap-4">
          <a href="#" class="text-[#3D3BF3] dark:text-amber text-3 hover:underline">Live Demo</a>
          <a href="#" class="text-[#3D3BF3] dark:text-amber text-3 hover:underline">GitHub Repo</a>
        </div>
      </header>

      <!-- Hero Image -->
      <img src="https://picsum.photos/600/300" alt="Project Screenshot" class="w-full rounded-4 shadow-lg">

      <!-- Project Meta -->
      <div class="grid grid-cols-2 gap-6">
        <div>
          <!-- <h3 class="font-semibold mb-2">Technologies Used</h3> -->
          <div class="flex flex-wrap gap-2">
            <span class="px-3 py-1 bg-gray-100 dark:bg-gray-800 rounded-full text-sm">Vue.js</span>
            <span class="px-3 py-1 bg-gray-100 dark:bg-gray-800 rounded-full text-sm">TypeScript</span>
            <span class="px-3 py-1 bg-gray-100 dark:bg-gray-800 rounded-full text-sm">Tailwind CSS</span>
          </div>
        </div>
        <div>
          <!-- <h3 class="font-semibold mb-2">Timeline</h3> -->
          <p class="text-gray-600">Jan 2023 - Mar 2023</p>
        </div>
      </div>

      <!-- Key Features -->
      <section class="pt-6">
        <h2 class="font-body text-4 font-500 opacity-20 mb-4">Features</h2>
        <ul class="list-disc font-300 opacity-60 list-inside space-y-2">
          <li>Responsive design that works seamlessly across all devices</li>
          <li>Real-time data synchronization with backend API</li>
          <li>Advanced search and filtering capabilities</li>
          <li>User authentication and authorization system</li>
          <li>Automated deployment pipeline</li>
        </ul>
      </section>

      <!-- Project Description -->
      <section class="space-y-4 pt-8">
        <h2 class="font-body text-4 font-500 opacity-20 mb-4">About the Project</h2>
        <!-- <h2 class="text-2xl font-bold">About the Project</h2> -->
        <p class="list-disc font-300 opacity-60 list-inside space-y-2">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        </p>
        <p class="list-disc font-300 opacity-60 list-inside space-y-2">
          Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>
      </section>

      <!-- Technical Details -->
      <section class="space-y-4">
        <h2 class="font-body text-4 font-500 opacity-20 mb-4">Technical Implementation</h2>
        <!-- <h2 class="text-2xl font-bold">Technical Implementation</h2> -->
        <p class="list-disc font-300 opacity-60 list-inside space-y-2">
          The project was built using a modern tech stack, focusing on performance and scalability. The frontend utilizes Vue.js with TypeScript for type safety, while Tailwind CSS provides utility-first styling. The backend is powered by a RESTful API built with Node.js and Express.
        </p>
      </section>

      <!-- Buttons navigation -->
       <div class="flex gap-2 mt-8">
        <button 
          @click="$router.back()"
          class="hover:border-1 border-dashed b-amber text-3 opacity-60 hover:opacity-100 font-600 py-1 px-4 pl-0 hover:pl-4 transition-all rounded flex gap-2 items-center hover:scale-105 active:scale-99 active:border-solid">
          <div class="i-ph:arrow-bend-down-left-bold"></div>
          <span>back</span>
        </button>
        <button class="hover:border-1 border-dashed b-amber text-3 opacity-60 hover:opacity-100 font-600 py-1 px-4 pl-0 hover:pl-4 transition-all rounded">Next Project</button>
       </div>
    </article>
  </div>
</template>
