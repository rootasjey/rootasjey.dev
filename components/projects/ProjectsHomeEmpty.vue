<template>
  <div class="space-y-4">
    <!-- First Row: 1/3 + 2/3 -->
    <div class="grid grid-cols-3 gap-4">
      <!-- The Projects Section Card (1/3) -->
      <div class="col-span-1 border border-gray-200 dark:border-gray-700 hover:b-blue rounded-xl p-2 bg-gray-50 dark:bg-[#1B1F29] opacity-100">
        <div class=" p-4 flex flex-col justify-between bg-white dark:bg-[#141418] rounded-xl h-100%">
          <div>
            <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-3">
              The Projects Section
            </h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm mb-6 leading-relaxed">
              You can present your projects in this section. 
              Describe your work, the technologies you used, and the lessons you learned.
            </p>
          </div>
          <!-- Mock Image/Interface at bottom -->
          <div class="bg-[#F1F1F1] dark:bg-gray-900 rounded-lg p-4 space-y-2">
            <div class="flex items-center gap-2 text-xs">
              <div class="w-2 h-2 bg-yellow-400 rounded-full"></div>
              <span>Alicia Koch</span>
              <UIcon name="i-ph-caret-down" size="3" class="ml-auto" />
            </div>
            <div class="flex items-center gap-2 text-xs">
              <div class="w-2 h-2 bg-green-400 rounded-full"></div>
              <span>alicia@example.com</span>
              <UIcon name="i-ph-check" size="3" class="ml-auto" />
            </div>
            <div class="flex items-center gap-2 text-gray-600 dark:text-gray-300 text-xs">
              <UIcon name="i-ph-envelope" size="3" />
              <span>alicia@gmail.com</span>
            </div>
            <div class="flex items-center gap-2 text-gray-600 dark:text-gray-300 text-xs">
              <UIcon name="i-ph-cloud" size="3" />
              <span>alicia@me.com</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Feature Showcase Card (2/3) -->
      <div class="col-span-2 border border-gray-200 dark:border-gray-700 hover:b-pink rounded-xl p-2 bg-gray-50 dark:bg-[#1B1F29] opacity-100">
        <div class="p-4 flex flex-col justify-between bg-white dark:bg-[#141418] rounded-xl h-100%">
          <div>
            <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-3">
              Features, specificities, and how to manage them.
            </h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm mb-6 leading-relaxed">
              Projects are different to posts in that they have specific properties like a start and an end date. 
              You can add links to your project, such as the source code, the live demo, or the documentation.
            </p>
          </div>
          <!-- Mock Message Interface -->
          <div class="bg-[#F1F1F1] dark:bg-gray-900 rounded-lg p-4 border border-gray-200 dark:border-gray-700">
            <div class="flex items-start gap-3 mb-4">
              <div class="flex-1">
                <div class="flex items-center justify-between gap-2 mb-1">
                  <span class="text-sm font-medium">Alice Smith</span>
                  <span class="text-gray-600 dark:text-gray-400 text-xs">4 months ago</span>
                </div>
                <div class="text-sm font-medium mb-2">Welcome <UIcon name="i-ph-heart-bold" size="3" /> </div>
                <p class="text-gray-600 dark:text-gray-300 text-xs leading-relaxed mb-3">
                  Thank you for joining our us! I hope you're settling in well. 
                  This is an open source project, and I'm always happy to receive contributions.
                  If you have any questions, don't hesitate to ask.
                </p>
                <div class="flex gap-2">
                  <span class="px-2 py-1 bg-gray-700 text-gray-300 text-xs font-600 rounded-xl">hello</span>
                  <span class="px-2 py-1 bg-gray-700 text-gray-300 text-xs font-600 rounded-xl">world</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Second Row: 2/3 + 1/3 -->
    <div class="grid grid-cols-3 gap-4">
      <!-- Visually Blown Away Card (2/3) -->
      <div class="col-span-2 border border-gray-200 dark:border-gray-700 hover:b-amber rounded-xl p-2 bg-gray-50 dark:bg-[#1B1F29] opacity-100">
        <div class="p-4 flex flex-col justify-between bg-white dark:bg-[#141418] rounded-xl h-100%">
          <div>
            <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-3">
              Visually Blown Away
            </h3>
            <p class="text-gray-600 dark:text-gray-400 text-sm mb-6 leading-relaxed">
              Always start with a beautiful image. 
              It will catch the reader's attention and make them want to learn more about your project.
            </p>
          </div>
          <!-- Mock Message Interface -->
          <div class="bg-[#F1F1F1] dark:bg-gray-900 rounded-lg p-4 border border-gray-200 dark:border-gray-700">
            <div class="flex items-start gap-3">
              <div class="flex-1">
                <div class="flex items-center justify-between gap-2 mb-1">
                  <span class="text-sm font-medium">I (myself)</span>
                  <span class="text-gray-600 dark:text-gray-400 text-xs">4 months ago</span>
                </div>
                <div class="text-sm font-medium mb-2">Re: Welcome <UIcon name="i-ph-heart-bold" size="3" /> </div>
                <p class="text-gray-600 dark:text-gray-300 text-xs leading-relaxed mb-3">
                  Thank you for the warm welcome! I'm really excited to be part of this project. 
                  I'm looking forward to contributing and learning from everyone.
                </p>
                <div class="flex gap-2">
                  <span class="px-2 py-1 bg-gray-700 text-gray-300 text-xs font-600 rounded-xl">a better</span>
                  <span class="px-2 py-1 bg-gray-700 text-gray-300 text-xs font-600 rounded-xl">world</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Call to Action Card (1/3) -->
      <div class="col-span-1 border-2 border-dashed border-blue-300 dark:border-blue-600 rounded-xl p-6 bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-900 hover:border-blue-400 dark:hover:border-blue-500 transition-all duration-200">
        <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-3">
          Create Your First Project
        </h3>
        <p class="text-gray-600 dark:text-gray-400 text-sm mb-6 leading-relaxed">
          Head over to the projects page to create your first project.
        </p>
        <!-- Mock Interface -->
        <div class="bg-white dark:bg-gray-900 rounded-lg p-4 space-y-2">
          <div class="flex items-center gap-2 text-xs">
            <div class="w-2 h-2 bg-yellow-400 rounded-full"></div>
            <span>Alicia Koch</span>
            <UIcon name="i-ph-caret-down" size="3" class="ml-auto" />
          </div>
          <div class="flex items-center gap-2 text-xs">
            <div class="w-2 h-2 bg-green-400 rounded-full"></div>
            <span>alicia@example.com</span>
            <UIcon name="i-ph-check" size="3" class="ml-auto" />
          </div>
          <div class="flex items-center gap-2 dark:text-gray-300 text-xs">
            <UIcon name="i-ph-envelope" size="3" />
            <span>alicia@gmail.com</span>
          </div>
          <div class="flex items-center gap-2 dark:text-gray-300 text-xs">
            <UIcon name="i-ph-cloud" size="3" />
            <span>alicia@me.com</span>
          </div>
        </div>

        <!-- Call to Action Button -->
        <div class="mt-6 text-center">
          <UButton
            to="/projects"
            btn="soft-blue"
            class="font-medium"
          >
            <UIcon name="i-ph-rocket-launch-duotone" size="4" class="mr-2" />
            Start Here
          </UButton>
        </div>
      </div>
    </div>
  </div>
</template>