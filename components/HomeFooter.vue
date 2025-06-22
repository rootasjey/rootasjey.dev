<template>
  <div class="frame">
    <h1 class="text-size-42 p-6 text-center">root</h1>
    <div class="links">
      <NuxtLink to="/about">about</NuxtLink>
      <span>•</span>
      <NuxtLink to="/contact">contact</NuxtLink>
      <span>•</span>
      <NuxtLink to="/resume" target="_blank">resume</NuxtLink>
    </div>
    <div class="text-center">
      <p class="font-600 text-gray-500 dark:text-gray-400 mr-5">
        A personal space to share passions, projects, and knowledge.
      </p>
    </div>
    <div class="socials">
      <NuxtLink to="https://github.com/rootasjey" target="_blank" rel="noopener noreferrer" >
        <UIcon name="i-ph-github-logo-bold" />
      </NuxtLink>
      <NuxtLink  to="https://www.linkedin.com/in/jeremiecorpinot/" target="_blank" rel="noopener noreferrer">
        <UIcon name="i-ph-linkedin-logo-bold" />
      </NuxtLink>
      <NuxtLink to="https://www.instagram.com/rootasjey" target="_blank" rel="noopener noreferrer">
        <UIcon name="i-ph-instagram-logo-bold" />
      </NuxtLink>
    </div>
    <div class="copyright">
      © <span class="font-600">Jérémie Corpinot</span>
        <span class="mx-1">&middot;</span>
        <span class="font-600">{{ new Date().getFullYear() }}</span>
    </div>
  </div>
</template>

<style scoped>
.frame {
  width: 100%;
  font-family: "Pilcrow Rounded";
  font-weight: 600;
  border-top: dashed;
  border-color: rgb(229, 231, 235);
  margin-bottom: 4rem;
}

.links {
  margin-top: -4rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 0.5rem;

  > a {
    color: #A8A29D;
    transition: color 0.2s ease-in-out;

    &:hover {
      color: #374151;
    }
  }

  @media (min-width: 768px) {
    flex-direction: row;
  }
}

.socials {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  margin-top: 0.5rem;
  margin-bottom: 4rem;
  
  > a {
    color: #090040;
    transition: color 0.2s ease-in-out;

    &:hover {
      color: #4300FF;
    }
  }
}

.dark .socials {
  > a {
    color: #fff;
  }
}

.copyright {
  font-size: 0.75rem;
  font-family: "Satoshi";
  color: rgb(107, 114, 128);
  border-top: dashed;
  border-color: rgb(229, 231, 235);
  padding-top: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  justify-content: center;
  align-items: center;
}

@media (min-width: 768px) {
  .copyright {
    flex-direction: row;
  }
}

@media (prefers-color-scheme: dark) {
  .copyright {
    color: rgb(156, 163, 175);
    border-color: rgb(55, 65, 81);
  }
}
</style>