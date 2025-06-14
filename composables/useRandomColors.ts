export const useRandomColors = () => {
  // Define your color palettes without prefixes
  const lightModeColors = [
    '#EC7FA9',
    '#FF6B6B',
    '#48A9A6',
    '#9370DB',
    '#4A90E2',
    '#F7B801'
  ]

  const darkModeColors = [
    '#66D2CE',
    '#FF9E9E',
    '#7FDBDA',
    '#B19CD9',
    '#7FB3F1',
    '#FFD54F'
  ]

  // Use useState to ensure the same random index is used on server and client
  const colorIndex = useState('colorIndex', () => Math.floor(Math.random() * lightModeColors.length))
  const darkColorIndex = useState('darkColorIndex', () => Math.floor(Math.random() * darkModeColors.length))

  // Function to get a random color from an array
  const getRandomColor = (colors: string[]) => {
    const randomIndex = Math.floor(Math.random() * colors.length)
    return colors[randomIndex]
  }

  // Get the current consistent colors
  const getCurrentLightColor = () => lightModeColors[colorIndex.value]
  const getCurrentDarkColor = () => darkModeColors[darkColorIndex.value]

  // Methods to generate CSS classes for different properties
  const getTextColorClasses = () => {
    const lightColor = getCurrentLightColor()
    const darkColor = getCurrentDarkColor()
    return `text-[${lightColor}] dark:text-[${darkColor}]`
  }

  const getBgColorClasses = () => {
    const lightColor = getCurrentLightColor()
    const darkColor = getCurrentDarkColor()
    return `bg-[${lightColor}] dark:bg-[${darkColor}]`
  }

  const getBorderColorClasses = () => {
    const lightColor = getCurrentLightColor()
    const darkColor = getCurrentDarkColor()
    return `border-[${lightColor}] dark:border-[${darkColor}]`
  }

  const getRingColorClasses = () => {
    const lightColor = getCurrentLightColor()
    const darkColor = getCurrentDarkColor()
    return `ring-[${lightColor}] dark:ring-[${darkColor}]`
  }

  // Generic method for any CSS property
  const getColorClasses = (property: string) => {
    const lightColor = getCurrentLightColor()
    const darkColor = getCurrentDarkColor()
    return `${property}-[${lightColor}] dark:${property}-[${darkColor}]`
  }

  // Methods for fresh random colors (not consistent across renders)
  const getRandomTextColorClasses = () => {
    const lightColor = getRandomColor(lightModeColors)
    const darkColor = getRandomColor(darkModeColors)
    return `text-[${lightColor}] dark:text-[${darkColor}]`
  }

  const getRandomBgColorClasses = () => {
    const lightColor = getRandomColor(lightModeColors)
    const darkColor = getRandomColor(darkModeColors)
    return `bg-[${lightColor}] dark:bg-[${darkColor}]`
  }

  const getRandomColorClasses = (property: string) => {
    const lightColor = getRandomColor(lightModeColors)
    const darkColor = getRandomColor(darkModeColors)
    return `${property}-[${lightColor}] dark:${property}-[${darkColor}]`
  }

  // Computed property for consistent text colors (backward compatibility)
  const randomColorCombination = computed(() => getTextColorClasses())

  // Function to regenerate the consistent random colors
  const regenerateColors = () => {
    colorIndex.value = Math.floor(Math.random() * lightModeColors.length)
    darkColorIndex.value = Math.floor(Math.random() * darkModeColors.length)
  }

  return {
    // Raw color arrays
    lightModeColors,
    darkModeColors,
    
    // Current color getters
    getCurrentLightColor,
    getCurrentDarkColor,
    
    // Consistent color class methods
    getTextColorClasses,
    getBgColorClasses,
    getBorderColorClasses,
    getRingColorClasses,
    getColorClasses,
    
    // Random color class methods
    getRandomColor,
    getRandomTextColorClasses,
    getRandomBgColorClasses,
    getRandomColorClasses,
    
    // Utilities
    regenerateColors,
    
    // Backward compatibility
    randomColorCombination
  }
}