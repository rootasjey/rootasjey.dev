<template>
  <div class="frame">
    <header>
      <h1>About</h1>
      <h4>
        This is where I talk about purpose and motive—why I build, create, and share. 
        My work is driven by a desire to make meaningful contributions, to solve real problems, and to inspire others through thoughtful design and engineering. 
        I believe that technology, when crafted with intention, can empower people and foster positive change.
      </h4>
    </header>

    <!-- Introduction -->
    <section>
      <h2>
        <UIcon name="i-ph-user-circle" />
        Personal identity
      </h2>
      <p>
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
    <section>
      <h2>
        <UIcon name="i-ph-tree-structure" />
        Systems & Origins
      </h2>
      <p>
        I'm fond of systems and patterns. There's a particular satisfaction I find in recognizing the underlying 
        structures that govern our world—from code architecture to natural phenomena. This fascination extends to 
        understanding the origin of things; I'm often not content with knowing just how something works, but why 
        it works that way and how it came to be.
      </p>
      <p>
        This curiosity about origins has led me down countless rabbit holes of learning, but each journey has 
        enriched my perspective and approach to problem-solving.
      </p>
    </section>

    <!-- Learning & Curiosity -->
    <section>
      <h2>
        <UIcon name="i-ph-lightbulb" />
        Perpetual Learning
      </h2>
      <p>
        I'm a curious person who has no difficulty learning new concepts. My mind thrives on the challenge of 
        unfamiliar territory, and I find joy in the process of mastering new skills. This natural inclination 
        toward learning has served me well in the ever-evolving landscape of technology, where staying current 
        requires constant adaptation and growth.
      </p>
    </section>

    <!-- Approach to Authority -->
    <section>
      <h2>
        <UIcon name="i-ph-path" />
        Finding My Path
      </h2>
      <p>
        I'm not a fan of hierarchical authority. I believe in respect earned through competence, kindness, and 
        wisdom rather than position or title. This perspective shapes how I collaborate with others—I value 
        environments where ideas are evaluated on their merit, not on who proposed them, and where leadership 
        is about guidance and support rather than control.
      </p>
    </section>

    <!-- Pace & Mindfulness -->
    <section>
      <h2>
        <UIcon name="i-ph-hourglass" />
        The Art of Slowness
      </h2>
      <p>
        I prefer doing things slowly instead of rushing. My body has developed its own wisdom in this regard, 
        manifesting symptoms when I push too hard or fast—a built-in reminder to honor a more sustainable pace. 
        This isn't about procrastination or lack of productivity, but rather about bringing mindfulness and 
        intention to each task.
      </p>
      <p>
        I've found that this measured approach often leads to higher quality outcomes and greater satisfaction 
        in the process. There's a certain richness that emerges when we allow ourselves the space to fully 
        engage with what we're doing.
      </p>
    </section>

    <!-- Diversity -->
    <section>
      <h2>
        <UIcon name="i-ph-rainbow" />
        Embracing Diversity
      </h2>
      <p>
        I 🩵 diversity in all its forms. I prefer to hold a bag of rainbows instead of gray clouds—metaphorically 
        speaking. The richness of different perspectives, backgrounds, experiences, and approaches brings depth 
        and vibrancy to life and work. I believe that innovation thrives at the intersection of diverse ideas, 
        and some of the most beautiful creations emerge from unexpected combinations and collaborations.
      </p>
    </section>

    <!-- Music -->
    <section>
      <h2>
        <UIcon name="i-ph-music-notes" />
        Musical Companion
      </h2>
      <p>
        Music is my daily companion. It accompanies me through coding sessions, contemplative moments, and 
        creative endeavors. Beyond just background sound, music shapes my mood, enhances my focus, and often 
        inspires new ideas. From ambient soundscapes to intricate compositions, the right music creates a 
        space for thought and feeling that enriches whatever I'm doing.
      </p>
    </section>

    <!-- Time Value -->
    <section>
      <h2>
        <UIcon name="i-ph-clock-afternoon" />
        Valuing Time
      </h2>
      <p>
        Time is precious. This isn't about filling every moment with productivity—it's about 
        being intentional with how I spend the limited hours we all have. Whether I'm working, learning, 
        creating, or simply being, I try to bring awareness to my choices and align them with what truly 
        matters to me.
      </p>
      <p>
        This has led me to be selective about projects and commitments, to set boundaries when 
        necessary, and to regularly reflect on whether my actions align with my values and aspirations.
      </p>
    </section>

    <!-- Project inspirations -->
    <section>
      <h2>
        <UIcon name="i-ph-heart-half" />
        Project inspirations
      </h2>
      <p>
        Human can be surprisingly creative, so I draw inspiration from a wide range of sources—art, 
        nature, technology, and everyday experiences. 
        Sometimes a fleeting idea, a conversation, or a problem I encounter sparks a new project.
      </p>
      <p>
        I enjoy exploring intersections between disciplines, 
        blending logic with imagination to create solutions that are both functional and expressive.
      </p>
      <p>
        For this website, I blended my own minimal tastes with 
        the beautiful 
        <ULink to="https://sense.ektothemes.com/" class="arrow" target="_blank" rel="noopener noreferrer">
          <span>Sense</span>
        </ULink> 
        and 
        <ULink to="https://onflow.priority.vision/" class="arrow" target="_blank" rel="noopener noreferrer">
          <span>OnFlow</span>
        </ULink> 
        Ghost theme.
      </p>
    </section>

    <!-- Connect -->
    <section>
      <h2>
        <span class="i-ph-handshake mr-2"></span>
        Let's Connect
      </h2>

      <p>
        If any of this resonates with you, or if you're curious to learn more about my work and perspectives, 
        I'd love to connect. You can reach out through my 
        <ULink to="/contact" class="arrow"><span>contact page</span></ULink> 
        or find me on the social platforms linked below.
      </p>

      <SocialLinks />
    </section>

    <Footer class="mt-24 w-2xl" />
  </div>
</template>

<script setup>
useHead({
  title: "root • about",
  meta: [
    {
      name: 'description',
      content: 'A deeper look into who I am, what I value, and how I approach life and work.',
    },
  ],
})
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

.dark .frame {
  > header {
    > h1, > h4 {
      color: rgba(var(--una-gray-200), 1);
    }
  }

  > section {
    > h2 {
      color: rgba(var(--una-gray-200), 1);
    }

    > p {
      color: rgba(var(--una-gray-300), 1);
    }
  }
}
</style>
