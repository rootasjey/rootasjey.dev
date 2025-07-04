<template>
  <div class="space-y-4">
    <!-- First Row: 1/3 + 2/3 -->
    <div class="grid grid-cols-3 gap-4">
      <!-- The Projects Section Card (1/3) -->
       <ProjectCard
       title="The Projects Section"
       description="You can present your projects in this section. Describe your work, the technologies you used, and the lessons you learned."
       :span="1"
       :show-mock-interface="true"
       mock-interface-type="email-list"
       :mock-email-list="[
         { address: 'Alicia Koch', dotColor: 'bg-yellow-400', rightIcon: 'i-ph-caret-down' },
         { address: 'alicia@example.com', dotColor: 'bg-green-400', rightIcon: 'i-ph-check' },
         { address: 'alicia@gmail.com', dotColor: 'bg-gray-400', rightIcon: 'i-ph-envelope' },
         { address: 'alicia@me.com', dotColor: 'bg-gray-400', rightIcon: 'i-ph-cloud' }
       ]"
     />

      <!-- Feature Showcase Card (2/3) -->
       <ProjectCard
       title="Features, specificities, and how to manage them."
       description="Projects are different to posts in that they have specific properties like a start and an end date. You can add links to your project, such as the source code, the live demo, or the documentation."
       :span="2"
       :show-mock-interface="true"
       mock-interface-type="message"
       mock-user="Alice Smith"
       mock-time="4 months ago"
       mock-title="Welcome"
       mock-message="Thank you for joining our us! I hope you're settling in well. This is an open source project, and I'm always happy to receive contributions. If you have any questions, don't hesitate to ask."
       :mock-tags="['hello', 'world']"
     />
    </div>

    <!-- Second Row: 2/3 + 1/3 -->
    <div class="grid grid-cols-3 gap-4">
      <!-- Visually Blown Away Card (2/3) -->
       <ProjectCard
        title="Visually Blown Away"
        description="Always start with a beautiful image. It will catch the reader's attention and make them want to learn more about your project."
        :span="2"
        :show-mock-interface="true"
        mock-interface-type="message"
        mock-user="I (myself)"
        mock-time="4 months ago"
        mock-title="Re: Welcome"
        mock-message="Thank you for the warm welcome! I'm really excited to be part of this project. I'm looking forward to contributing and learning from everyone."
        :mock-tags="['a better', 'world']"
      />

      <!-- Call to Action Card (1/3) -->
      <div class="col-span-1 border-2 border-dashed border-blue-300 dark:border-blue-600 rounded-xl p-6 bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-900 hover:border-blue-400 dark:hover:border-blue-500 transition-all duration-200">
        <h3 class="font-body text-xl font-600 text-gray-800 dark:text-gray-200 mb-3">
          Create Your First Project
        </h3>
        <p class="text-gray-600 dark:text-gray-400 text-sm mb-6 leading-relaxed">
          Head over to the projects page to create your first project.
        </p>
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