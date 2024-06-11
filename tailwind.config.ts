import type { Config } from 'tailwindcss'
import defaultTheme from 'tailwindcss/defaultTheme'

export default <Partial<Config>>{
  theme: {
    extend: {
      colors: {
        'ronchi': {
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
      }
    }
  }
}
