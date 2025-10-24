import extratorUna from '@una-ui/extractor-vue-script'
import presetUna from '@una-ui/preset'
import prefixes from '@una-ui/preset/prefixes'
import presetAnimations from 'unocss-preset-animations'

import {
  presetAttributify,
  presetIcons,
  presetTagify,
  presetWind3,
  presetWebFonts,
  transformerDirectives,
  transformerVariantGroup,
} from 'unocss'

export default {
  presets: [
    presetWind3(),
    presetAttributify(),
    presetIcons({
      scale: 1.2,
      extraProperties: {
        'display': 'inline-block',
        'vertical-align': 'middle',
      },
    }),
    presetTagify(),
    presetWebFonts({
      provider: 'fontshare',
      fonts: {
        title: 'Khand',
        text: 'Satoshi',
        body: 'Pilcrow Rounded',
        serif: 'Pencerio',
        sense: 'General Sans',
      },
    }),
    presetAnimations(),
    presetUna(),
  ],
  safelist: [
    // Ensure these rules are always generated
    // because they are generated dynamically
    'i-ph-tree', 'i-ph-device-mobile-camera', 'i-ph-film-slate', 'i-ph-paint-brush',
  ],
  shortcuts: [
    {
      "btn-glowing": "from-primary-500 via-primary-600 to-primary-700 bg-gradient-to-r text-white shadow-lg shadow-primary-500/50 hover:bg-gradient-to-br dark:shadow-lg dark:shadow-primary-800/80 dark:focus:ring-primary-800",
      "btn-glowing-outline": "border border-primary-600 text-primary-600 hover:bg-primary-600 hover:text-white dark:border-primary-500 dark:text-primary-500 dark:hover:bg-primary-500 dark:hover:text-white",
      "social-btn": "flex items-center gap-2 px-4 py-2 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors",
    },
  ],
  extractors: [
    extratorUna({
      prefixes,
    }),
  ],
  transformers: [
    transformerDirectives(),
    transformerVariantGroup(),
  ],
}
