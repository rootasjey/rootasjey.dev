// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  app: {
    head: {
      title: 'rootasjey',
      meta: [
        { name: 'apple-mobile-web-app-capable', content: 'yes' },
        { name: 'apple-mobile-web-app-status-bar-style', content: 'black' },
      ]
    }
  },
  css: ['~/assets/styles/main.css'],
  devtools: { enabled: true },
  modules: ["@nuxt/ui", "nuxt-vuefire", "nuxt-icon", "@nuxt/image"],
  routeRules: {
    '/': { ssr: true },
  },
  ui: {
    icons: {
      dynamic: true,
    }
  },
  tailwindcss: {
    config: {
      theme: {
        extend: {
          colors: {
            secondary: {
              '50': '#f4fbf2',
              '100': '#e6f8e0',
              '200': '#ceefc3',
              '300': '#9dde8a',
              '400': '#77ca5e',
              '500': '#52af38',
              '600': '#409029',
              '700': '#337223',
              '800': '#2d5a21',
              '900': '#254b1c',
              '950': '#10280b',
            },
            tertiary: {
              '50': '#fdfaed',
              '100': '#faf1cb',
              '200': '#f4e293',
              '300': '#ecc94b',
              '400': '#e9ba36',
              '500': '#e29c1e',
              '600': '#c87917',
              '700': '#a65717',
              '800': '#874519',
              '900': '#6f3818',
              '950': '#401d08',
            },
          },
        },
      },
    },
  },
  vuefire: {
    config: {
      apiKey: process.env.VFIRE_API_KEY,
      authDomain: process.env.VFIRE_AUTH_DOMAIN,
      databaseURL: process.env.VFIRE_DATABASE_URL,
      projectId: process.env.VFIRE_PROJECT_ID,
      storageBucket: process.env.VFIRE_STORAGE_BUCKET,
      messagingSenderId: process.env.VFIRE_MESSAGING_SENDER_ID,
      appId: process.env.VFIRE_APP_ID,
      measurementId: process.env.VFIRE_MEASUREMENT_ID,
    },
    // Enables and initializes the auth module
    auth: {
      enabled: true,
      sessionCookie: true,
    },
    // appCheck: {
    //   // Allows you to use a debug token in development
    //   debug: process.env.NODE_ENV !== 'production',
    //   isTokenAutoRefreshEnabled: true,
    //   provider: 'ReCaptchaV3',
    //   // Find the instructions in the Firebase documentation, link above
    //   key: '...',
    // },
  },
})