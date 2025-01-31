import presetIcons from '@unocss/preset-icons'
import { defineConfig, presetAttributify, presetTagify, presetUno, presetWebFonts } from 'unocss'

export default defineConfig({
  presets: [
    presetAttributify(),
    // presetIcons({
    //   autoInstall: false,
    // }),
    presetUno(),
    presetTagify(),
    presetWebFonts({
      provider: 'fontshare',
      fonts: {
        title: 'Author',
        text: 'Satoshi',
        body: 'Chillax',
        mono: 'Cabinet',
        serif: 'Boska',
        cursive: 'Pencerio',
      },
    })
  ],
})