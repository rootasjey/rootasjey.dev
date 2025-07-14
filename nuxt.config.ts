// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2025-01-27",
  devtools: { enabled: true },
  app: {
    head: {
      htmlAttrs: {
        lang: "en",
      },
      title: "root",
      meta: [
        { name: "viewport", content: "width=device-width, initial-scale=1" },
        { name: "description", content: "Exploring the intersection of code & creativity" },
      ],
      link: [
        { rel: "icon", type: "image/png", href: "/favicon.ico" },
      ],
    },
  },

  hub: {
    blob: true,
    cache: true,
    database: true,
    kv: true,
  },

  image: {
    providers: {
      hubblob: {
        name: 'hubblob',
        provider: '~/providers/hubblob.ts',
      },
    },
  },

  modules: [
    "@nuxthub/core",
    "@nuxt/image",
    "@una-ui/nuxt",
    "nuxt-auth-utils",
    "@pinia/nuxt",
    "@nuxt/test-utils/module",
    "nuxt-shiki",
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
    theme: {
      colors: {
        primary: {
          DEFAULT: '#687FE5',
          50: '#F4F5FF',
          100: '#E9EDFF',
          200: '#DDE2FF',
          300: '#CDD4FF',
          400: '#BCC7FF',
          500: '#687FE5',
          600: '#576ED3',
          700: '#4659B7',
          800: '#2E3E93',
          900: '#161F70',
        },
      },
    },
  },
  una: {
    prefix: "U",
    themeable: true,
  },
})