<template>
  <main>
    <h1 class="title">About</h1>
    <header>
      <div class="greetings">
        <h1 class="app-title">kwotes</h1>
        <p>
          Dive into an ocean of wisdom.
        </p>
      </div>
    </header>

    <div class="separator">
      <div class="dot"></div>
      <div class="dot"></div>
      <div class="dot"></div>
      <div class="dot"></div>
    </div>

    <body>
      <div class="item">
        <p>• A galaxy platform for quotes lovers</p>
        <p>• Come back regularly to see new quotes</p>
        <p>• You can explore, save, and share your quotes with others with the <a href="https://kwotes.fr"
            target="_blank">app</a></p>
        <p>• A project made by <a href="https://codingbox.fr">CODING BOX</a> (Lucille Vigné | Jérémie Corpinot)</p>
      </div>
    </body>
  </main>
</template>

<style scoped>
.title {
  font-size: 6rem;
  font-weight: 600;
  line-height: 1rem;
}

main {
  max-width: 600px;
  display: flex;
  margin: 0 auto;

  flex-direction: column;
  justify-content: center;
  align-content: center;
  /* align-items: center; */

  height: 100vh;

  /* background-color: #7469B6; */

  body {
    min-height: 0;
    /* margin-top: 2rem; */
  }


  header {
    display: flex;
    align-items: center;

    .logo {
      border: 1px solid #eee;
      border-radius: 12%;
    }

    .greetings {
      display: flex;
      flex-direction: column;
      margin-left: 0rem;

      h1 {
        font-size: 1.2rem;
        font-weight: 600;
        line-height: 1rem;
      }

      p {
        opacity: 0.6;
      }
    }
  }

  .separator {
    display: flex;
    margin: 1rem 0;

    .dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      margin: 0 0.5rem;

      &:first-of-type {
        background-color: #7469B6;
      }

      &:nth-of-type(2) {
        background-color: #AD88C6;
      }

      &:nth-of-type(3) {
        background-color: #E1AFD1;
      }

      &:last-of-type {
        background-color: #FFE6E6;
      }
    }
  }
}
</style>