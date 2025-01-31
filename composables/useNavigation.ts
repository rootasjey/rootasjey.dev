export const useNavigation = (countMap: { [key: string]: number } = {}) => {
  return [
    {
      title: "projects",
      count: countMap["projects"] ?? 0,
      subtitle: "A collection of finished coding projects I've worked sometimes on years.",
      icon: 'i-ph:laptop',
      to: '/projects',
      color: '#3D3BF3'
    },
    {
      title: "reflexions",
      count: countMap["posts"] ?? 0,
      subtitle: "Thoughts, insights, and contemplations of the past. A garden of ideas in constant move.",
      icon: 'i-ph-brain',
      to: '/reflexions',
      color: '#FAB12F'
    },
    {
      title: "experiments",
      count: countMap["experiments"] ?? 0,
      subtitle: "A playground for testing new ideas and breaking conventional boundaries.",
      icon: 'i-ph-flask',
      to: '/experiments',
      color: '#CB9DF0'
    }
  ]
}