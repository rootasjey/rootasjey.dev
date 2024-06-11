<template>
  <div :class="{'wavy-line': true, [`${color}`]: true}" data-text="xxxxxxxxxxxxxx"></div>
</template>

<script lang="ts" setup>
export interface WavyLineProps {
  color?: string
}

defineProps<WavyLineProps>()
</script>

<style>
.wavy-line {
  /* width: 150px; */
  overflow: hidden;
  margin: 0 auto 0 auto;
}

.wavy-line:before {
  content: attr(data-text);
  position: relative;
  top: -35px;
  color: rgba(0, 0, 0, 0);
  width: calc(100% + 27px);
  font-size: 4em;
  text-decoration-style: wavy;
  /* text-decoration-color: var(--primary-color); */
  /* text-decoration-color: #25173A; */
  text-decoration-line: underline;
  /* animation: animate .9s linear infinite; */
  /* -webkit-animation: animate .9s linear infinite; */
}

@keyframes animate {
  0% {
    left: -0px;
  }

  100% {
    left: -30px;
  }
}

@-webkit-keyframes animate {
  0% {
    left: -0px;
  }

  100% {
    left: -30px;
  }
}

.green:before {
  text-decoration-color: #56AE5F;
}

.primary:before {
  text-decoration-color: var(--primary-color);
}

.secondary:before {
  text-decoration-color: var(--secondary-color);
}

.yellow:before {
  text-decoration-color: #F9B930;
}

.love:before {
  text-decoration-color: #F075AA;
}
</style>