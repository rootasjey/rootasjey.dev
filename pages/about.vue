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
          About Me
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

    <!-- Introduction -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-user-circle mr-2"></span>
        The Essence
      </h2>
      <p class="text-gray-700 dark:text-gray-300 mb-4">
        I'm a calm human being who regularly falls in love with art. There's something about creative expression 
        that resonates deeply with me—whether it's a well-crafted piece of code, a moving musical composition, 
        or a striking visual artwork. This appreciation for beauty in its many forms shapes how I approach both 
        my work and life.
      </p>
      <ULink to="/resume" class="arrow">
        <span>Learn more about my work experiences.</span>
      </ULink>
    </section>

    <!-- Systems & Patterns -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-tree-structure mr-2"></span>
        Systems & Origins
      </h2>
      <p class="text-gray-700 dark:text-gray-300 mb-4">
        I'm fond of systems and patterns. There's a particular satisfaction I find in recognizing the underlying 
        structures that govern our world—from code architecture to natural phenomena. This fascination extends to 
        understanding the origin of things; I'm often not content with knowing just how something works, but why 
        it works that way and how it came to be.
      </p>
      <p class="text-gray-700 dark:text-gray-300">
        This curiosity about origins has led me down countless rabbit holes of learning, but each journey has 
        enriched my perspective and approach to problem-solving.
      </p>
    </section>

    <!-- Learning & Curiosity -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-lightbulb mr-2"></span>
        Perpetual Learning
      </h2>
      <p class="text-gray-700 dark:text-gray-300">
        I'm a curious person who has no difficulty learning new concepts. My mind thrives on the challenge of 
        unfamiliar territory, and I find joy in the process of mastering new skills. This natural inclination 
        toward learning has served me well in the ever-evolving landscape of technology, where staying current 
        requires constant adaptation and growth.
      </p>
    </section>

    <!-- Approach to Authority -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-path mr-2"></span>
        Finding My Path
      </h2>
      <p class="text-gray-700 dark:text-gray-300">
        I'm not a fan of hierarchical authority. I believe in respect earned through competence, kindness, and 
        wisdom rather than position or title. This perspective shapes how I collaborate with others—I value 
        environments where ideas are evaluated on their merit, not on who proposed them, and where leadership 
        is about guidance and support rather than control.
      </p>
    </section>

    <!-- Pace & Mindfulness -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-hourglass mr-2"></span>
        The Art of Slowness
      </h2>
      <p class="text-gray-700 dark:text-gray-300 mb-4">
        I prefer doing things slowly instead of rushing. My body has developed its own wisdom in this regard, 
        manifesting symptoms when I push too hard or fast—a built-in reminder to honor a more sustainable pace. 
        This isn't about procrastination or lack of productivity, but rather about bringing mindfulness and 
        intention to each task.
      </p>
      <p class="text-gray-700 dark:text-gray-300">
        I've found that this measured approach often leads to higher quality outcomes and greater satisfaction 
        in the process. There's a certain richness that emerges when we allow ourselves the space to fully 
        engage with what we're doing.
      </p>
    </section>

    <!-- Diversity -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-rainbow mr-2"></span>
        Embracing Diversity
      </h2>
      <p class="text-gray-700 dark:text-gray-300">
        I 🩵 diversity in all its forms. I prefer to hold a bag of rainbows instead of gray clouds—metaphorically 
        speaking. The richness of different perspectives, backgrounds, experiences, and approaches brings depth 
        and vibrancy to life and work. I believe that innovation thrives at the intersection of diverse ideas, 
        and some of the most beautiful creations emerge from unexpected combinations and collaborations.
      </p>
    </section>

    <!-- Music -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-music-notes mr-2"></span>
        Musical Companion
      </h2>
      <p class="text-gray-700 dark:text-gray-300">
        Music is my daily companion. It accompanies me through coding sessions, contemplative moments, and 
        creative endeavors. Beyond just background sound, music shapes my mood, enhances my focus, and often 
        inspires new ideas. From ambient soundscapes to intricate compositions, the right music creates a 
        space for thought and feeling that enriches whatever I'm doing.
      </p>
    </section>

    <!-- Time Value -->
    <section class="mb-12">
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-clock mr-2"></span>
        Valuing Time
      </h2>
      <p class="text-gray-700 dark:text-gray-300 mb-4">
        I don't like to waste my time. This isn't about filling every moment with productivity—it's about 
        being intentional with how I spend the limited hours we all have. Whether I'm working, learning, 
        creating, or simply being, I try to bring awareness to my choices and align them with what truly 
        matters to me.
      </p>
      <p class="text-gray-700 dark:text-gray-300">
        This mindset has led me to be selective about projects and commitments, to set boundaries when 
        necessary, and to regularly reflect on whether my actions align with my values and aspirations.
      </p>
    </section>

    <!-- Connect -->
    <section>
      <h2 class="text-lg font-500 text-gray-800 dark:text-gray-200 mb-4">
        <span class="i-ph-handshake mr-2"></span>
        Let's Connect
      </h2>

      <p class="text-gray-700 dark:text-gray-300 mb-6">
        If any of this resonates with you, or if you're curious to learn more about my work and perspectives, 
        I'd love to connect. You can reach out through my 
        <ULink to="/contact" class="arrow"><span>contact page</span></ULink> 
        or find me on the social platforms linked below.
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

    <Footer />
  </div>
</template>

<script setup>
definePageMeta({
  title: 'About Me',
  description: 'A deeper look into who I am, what I value, and how I approach life and work.'
})
</script>
