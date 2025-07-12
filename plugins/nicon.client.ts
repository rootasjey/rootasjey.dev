import NIcon from '~/components/NIcon.vue'

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.component('NIcon', NIcon)
})
