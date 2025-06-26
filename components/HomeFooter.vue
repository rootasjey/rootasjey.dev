<template>
  <footer>
    <h1 class="text-size-42 p-6 text-center">root</h1>
    <div class="links">
      <NuxtLink to="/about">about</NuxtLink>
      <span>•</span>
      <NuxtLink to="/contact">contact</NuxtLink>
      <span>•</span>
      <NuxtLink to="/resume">resume</NuxtLink>
    </div>
    <div class="font-sense font-400 mt-2 text-center text-gray-500 dark:text-gray-400">
      <p>
        Thank you. If you have any questions or need help, feel free to 
        <ULink to="/contact" class="hover:color-blue hover:underline underline-blue decoration-offset-6">reach out!</ULink>
      </p>
      <p>
        This is a personal space to share passions, projects, and knowledge.
      </p>
      <p>
        I'd love to change the world
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
      <span>© Jérémie Corpinot</span>
      <span>&middot;</span>
      <span>{{ new Date().getFullYear() }}</span>
    </div>
  </footer>
</template>

<style scoped>
footer {
  width: 100%;
  font-family: "Pilcrow Rounded";
  font-weight: 600;
  border-top: dashed;
  border-color: rgb(229, 231, 235);
  margin-bottom: 4rem;
  
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
    margin-top: 1rem;
    margin-bottom: 4rem;
    
    > a {
      color: #090040;
      transition: color 0.2s ease-in-out;

      &:hover {
        color: #4300FF;
      }
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
    justify-content: center;
    align-items: center;
    gap: 0.25rem;

    @media (min-width: 768px) {
      flex-direction: row;
      padding-top: 0.5rem;
    }
  }
}

.dark footer {
  border-color: rgb(55, 65, 81);

  .copyright {
    color: rgb(156, 163, 175);
    border-color: rgb(55, 65, 81);
  }

  .links {
    > a {
      color: #eee;

      &:first-child:hover {
        color: #00FFDE;
      }

      &:nth-child(3):hover {
        color: #EBD6FB;
      }

      &:nth-child(5):hover {
        color: #F564A9;
      }
    }
  }

  .socials {
    > a {
      color: #fff;

      &:first-child:hover {
        color: #00FFDE;
      }

      &:nth-child(2):hover {
        color: #EBD6FB;
      }

      &:nth-child(3):hover {
        color: #F564A9;
      }
    }
  }
}
</style>