<template>
  <b class="hr anim"></b>
</template>

<style scoped>
.hr {
  width: 100%;
  height: 1px;
  display: block;
  position: relative;
  margin-bottom: 0em;
  padding: 0.5rem 0;
}

.hr:after,
.hr:before {
  content: "";
  position: absolute;
  width: 100%;
  height: 1px;
  bottom: 50%;
  left: 0;
}

.hr:before {
  background: linear-gradient(90deg, var(--color-background) 0%, var(--color-background) 50%, transparent 50%, transparent 100%);
  background-size: 15px;
  background-position: center;
  z-index: 1;
}

.hr:after {
  transition: opacity 0.3s ease, animation 0.3s ease;
  background: linear-gradient(to right, #62efab 5%, #f2ea7d 15%, #f2ea7d 25%, #ff8797 35%, #ff8797 45%, #e1a4f4 55%, #e1a4f4 65%, #82fff4 75%, #82fff4 85%, #62efab 95%);
  background-size: 200%;
  background-position: 0%;
  animation: bar 15s linear infinite;
}

@keyframes bar {
  0% {
    background-position: 0%;
  }

  100% {
    background-position: 200%;
  }
}

.hr.anim:before {
  background: linear-gradient(90deg, var(--color-background) 0%, var(--color-background) 5%, transparent 5%, transparent 10%, var(--color-background) 10%, var(--color-background) 15%, transparent 15%, transparent 20%, var(--color-background) 20%, var(--color-background) 25%, transparent 25%, transparent 30%, var(--color-background) 30%, var(--color-background) 35%, transparent 35%, transparent 40%, var(--color-background) 40%, var(--color-background) 45%, transparent 45%, transparent 50%, var(--color-background) 50%, var(--color-background) 55%, transparent 55%, transparent 60%, var(--color-background) 60%, var(--color-background) 65%, transparent 65%, transparent 70%, var(--color-background) 70%, var(--color-background) 75%, transparent 75%, transparent 80%, var(--color-background) 80%, var(--color-background) 85%, transparent 85%, transparent 90%, var(--color-background) 90%, var(--color-background) 95%, transparent 95%, transparent 100%);
  background-size: 150px;
  background-position: center;
  z-index: 1;
  animation: bar 120s linear infinite;
}

.hr.anim:hover:before {
  animation-duration: 20s;
}

.hr.anim:hover:after {
  animation-duration: 2s;
}

body {
  background: var(--color-background);
  padding: 4em;
  /* font-family: Lato; */
  font-weight: 100;
  color: #696b89;
  text-indent: 1em;
  line-height: 1;
}

h1,
h2 {
  line-height: 1;
  margin-bottom: -0.5em;
}

h2 {
  margin-top: 5em;
}
</style>