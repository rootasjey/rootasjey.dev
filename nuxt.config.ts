// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2024-04-03',
  devtools: { enabled: true },
  app: {
    head: {
      htmlAttrs: {
        lang: "en",
      },
      title: "rootasjey.dev",
      meta: [
        { name: "viewport", content: "width=device-width, initial-scale=1" },
        { name: "description", content: "Exploring the intersection of code & creativity" },
      ],
      link: [
        { rel: "icon", type: "image/png", href: "/favicon.ico" },
      ],
    },
  },
  modules: [
    "@nuxthub/core",
    "@nuxtjs/color-mode",
    "@una-ui/nuxt",
    "@unocss/nuxt",
    "nuxt-vuefire",
  ],
  unocss: {
    preflight: true,
    icons: {
      scale: 1.0,
      extraProperties: {
        "display": "inline-block",
        "vertical-align": "middle",
      },
    },
  },
  una: {
    prefix: "u",
    themeable: true,
  },
  vuefire: {
    admin: {
      serviceAccount: process.env.GOOGLE_APPLICATION_CREDENTIALS,
      // serviceAccount: './rootasjey-firebase-adminsdk-8wlfd-515559bdf4.json',
    },
    auth: {
      enabled: true,
      sessionCookie: true,
    },
    config: {
      apiKey: process.env.VFIRE_API_KEY,
      authDomain: process.env.VFIRE_AUTH_DOMAIN,
      projectId: process.env.VFIRE_PROJECT_ID,
      storageBucket: process.env.VFIRE_STORAGE_BUCKET,
      messagingSenderId: process.env.VFIRE_MESSAGING_SENDER_ID,
      appId: process.env.VFIRE_APP_ID,
      measurementId: process.env.VFIRE_MEASUREMENT_ID,
    },
  },
})