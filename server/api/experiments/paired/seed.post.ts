// POST /api/experiments/paired/seed
// Seed initial card pairs data into KV storage

export default defineEventHandler(async (event) => {
  try {
    // Computer Science topic (existing data)
    const computerScienceData = {
      name: "Computer Science",
      description: "Programming concepts and their real-world applications",
      difficulty: "medium",
      icon: "i-ph-code",
      cardPairs: [
        {
          pair1: { text: "Algorithm", icon: "i-ph-flow-arrow" },
          pair2: { text: "Recipe", icon: "i-ph-cooking-pot" },
          fact: "Algorithms are like recipes - they're step-by-step instructions to solve a problem or complete a task."
        },
        {
          pair1: { text: "Variable", icon: "i-ph-package" },
          pair2: { text: "Container", icon: "i-ph-archive-box" },
          fact: "Variables in programming are like labeled containers that store different types of data."
        },
        {
          pair1: { text: "Function", icon: "i-ph-function" },
          pair2: { text: "Machine", icon: "i-ph-gear" },
          fact: "Functions are like machines - you put something in (input), it processes it, and gives you something back (output)."
        },
        {
          pair1: { text: "Loop", icon: "i-ph-arrow-clockwise" },
          pair2: { text: "Repeat", icon: "i-ph-repeat" },
          fact: "Loops allow computers to repeat tasks efficiently, just like how you might repeat a daily routine."
        },
        {
          pair1: { text: "Database", icon: "i-ph-database" },
          pair2: { text: "Library", icon: "i-ph-books" },
          fact: "Databases organize and store information systematically, much like how libraries organize books."
        },
        {
          pair1: { text: "API", icon: "i-ph-plugs-connected" },
          pair2: { text: "Waiter", icon: "i-ph-user-circle" },
          fact: "APIs are like waiters - they take your request, communicate with the kitchen (server), and bring back what you ordered."
        },
        {
          pair1: { text: "Bug", icon: "i-ph-bug" },
          pair2: { text: "Error", icon: "i-ph-warning" },
          fact: "The term 'bug' in programming comes from an actual moth found in a computer relay in 1947 by Grace Hopper."
        },
        {
          pair1: { text: "Cloud", icon: "i-ph-cloud" },
          pair2: { text: "Internet", icon: "i-ph-globe" },
          fact: "Cloud computing means using someone else's computer over the internet instead of your own local machine."
        }
      ]
    }

    // Physics topic
    const physicsData = {
      name: "Physics",
      description: "Fundamental forces and phenomena in the universe",
      difficulty: "medium",
      icon: "i-ph-atom",
      cardPairs: [
        {
          pair1: { text: "Gravity", icon: "i-ph-arrow-down" },
          pair2: { text: "Apple", icon: "i-ph-apple-logo" },
          fact: "Newton's law of universal gravitation was inspired by observing an apple fall from a tree."
        },
        {
          pair1: { text: "Light", icon: "i-ph-lightbulb" },
          pair2: { text: "Wave", icon: "i-ph-wave-sine" },
          fact: "Light exhibits both wave and particle properties, a phenomenon called wave-particle duality."
        },
        {
          pair1: { text: "Energy", icon: "i-ph-lightning" },
          pair2: { text: "Motion", icon: "i-ph-arrow-right" },
          fact: "Energy cannot be created or destroyed, only transformed from one form to another (conservation of energy)."
        },
        {
          pair1: { text: "Magnet", icon: "i-ph-magnet" },
          pair2: { text: "Field", icon: "i-ph-circles-three" },
          fact: "Magnetic fields are invisible forces that can attract or repel magnetic materials without touching them."
        },
        {
          pair1: { text: "Sound", icon: "i-ph-speaker-high" },
          pair2: { text: "Vibration", icon: "i-ph-wave-triangle" },
          fact: "Sound is created by vibrations that travel through air, water, or solid materials as waves."
        },
        {
          pair1: { text: "Heat", icon: "i-ph-thermometer-hot" },
          pair2: { text: "Movement", icon: "i-ph-arrows-out" },
          fact: "Heat is actually the movement of tiny particles - the faster they move, the hotter something feels."
        },
        {
          pair1: { text: "Electricity", icon: "i-ph-plug" },
          pair2: { text: "Electrons", icon: "i-ph-circle" },
          fact: "Electricity is the flow of electrons through materials like copper wires."
        },
        {
          pair1: { text: "Rainbow", icon: "i-ph-rainbow" },
          pair2: { text: "Prism", icon: "i-ph-triangle" },
          fact: "Rainbows form when sunlight is separated into different colors by water droplets acting like tiny prisms."
        }
      ]
    }

    // Mathematics topic
    const mathematicsData = {
      name: "Mathematics",
      description: "Mathematical concepts and their practical applications",
      difficulty: "medium",
      icon: "i-ph-calculator",
      cardPairs: [
        {
          pair1: { text: "Pi", icon: "i-ph-circle" },
          pair2: { text: "Circle", icon: "i-ph-circle-dashed" },
          fact: "Pi (π) is the ratio of a circle's circumference to its diameter, approximately 3.14159."
        },
        {
          pair1: { text: "Fibonacci", icon: "i-ph-spiral" },
          pair2: { text: "Nature", icon: "i-ph-leaf" },
          fact: "The Fibonacci sequence appears everywhere in nature: flower petals, pinecones, and seashells."
        },
        {
          pair1: { text: "Zero", icon: "i-ph-number-circle-zero" },
          pair2: { text: "Nothing", icon: "i-ph-circle" },
          fact: "Zero was invented in ancient India and revolutionized mathematics by representing 'nothing' as a number."
        },
        {
          pair1: { text: "Infinity", icon: "i-ph-infinity" },
          pair2: { text: "Endless", icon: "i-ph-arrows-out" },
          fact: "Infinity is not a number but a concept representing something without bound or end."
        },
        {
          pair1: { text: "Triangle", icon: "i-ph-triangle" },
          pair2: { text: "180°", icon: "i-ph-angle" },
          fact: "The angles inside any triangle always add up to exactly 180 degrees, no matter the triangle's shape."
        },
        {
          pair1: { text: "Prime", icon: "i-ph-number-one" },
          pair2: { text: "Unique", icon: "i-ph-star" },
          fact: "Prime numbers can only be divided by 1 and themselves, making them the building blocks of all numbers."
        },
        {
          pair1: { text: "Equation", icon: "i-ph-equals" },
          pair2: { text: "Balance", icon: "i-ph-scales" },
          fact: "Equations are like balanced scales - what you do to one side, you must do to the other."
        },
        {
          pair1: { text: "Graph", icon: "i-ph-chart-line" },
          pair2: { text: "Story", icon: "i-ph-book-open" },
          fact: "Graphs tell visual stories about data, showing relationships and patterns that numbers alone can't reveal."
        }
      ]
    }

    // Biology topic
    const biologyData = {
      name: "Biology",
      description: "Life sciences and living organisms",
      difficulty: "medium",
      icon: "i-ph-dna",
      cardPairs: [
        {
          pair1: { text: "DNA", icon: "i-ph-dna" },
          pair2: { text: "Blueprint", icon: "i-ph-file-text" },
          fact: "DNA is like a blueprint that contains all the instructions needed to build and maintain a living organism."
        },
        {
          pair1: { text: "Cell", icon: "i-ph-cell-signal-full" },
          pair2: { text: "Building Block", icon: "i-ph-cube" },
          fact: "Cells are the basic building blocks of all living things, from tiny bacteria to massive whales."
        },
        {
          pair1: { text: "Heart", icon: "i-ph-heart" },
          pair2: { text: "Pump", icon: "i-ph-engine" },
          fact: "The heart is a powerful muscle that pumps about 2,000 gallons of blood through your body every day."
        },
        {
          pair1: { text: "Photosynthesis", icon: "i-ph-sun" },
          pair2: { text: "Food Factory", icon: "i-ph-factory" },
          fact: "Plants use photosynthesis to convert sunlight, water, and carbon dioxide into food and oxygen."
        },
        {
          pair1: { text: "Evolution", icon: "i-ph-tree-structure" },
          pair2: { text: "Change", icon: "i-ph-arrows-clockwise" },
          fact: "Evolution is the process by which species change and adapt over millions of years to survive in their environment."
        },
        {
          pair1: { text: "Ecosystem", icon: "i-ph-tree" },
          pair2: { text: "Community", icon: "i-ph-users-three" },
          fact: "An ecosystem is a community of living organisms interacting with each other and their environment."
        },
        {
          pair1: { text: "Antibody", icon: "i-ph-shield-check" },
          pair2: { text: "Defender", icon: "i-ph-sword" },
          fact: "Antibodies are proteins that act like tiny soldiers, defending your body against harmful invaders."
        },
        {
          pair1: { text: "Mitosis", icon: "i-ph-copy" },
          pair2: { text: "Division", icon: "i-ph-divide" },
          fact: "Mitosis is how cells divide to create two identical copies, allowing organisms to grow and heal."
        }
      ]
    }

    // Space Science topic
    const spaceScienceData = {
      name: "Space Science",
      description: "Astronomy, space exploration, and cosmic phenomena",
      difficulty: "medium",
      icon: "i-ph-planet",
      cardPairs: [
        {
          pair1: { text: "Black Hole", icon: "i-ph-circle-dashed" },
          pair2: { text: "Vacuum", icon: "i-ph-funnel" },
          fact: "Black holes have such strong gravity that not even light can escape once it crosses the event horizon."
        },
        {
          pair1: { text: "Galaxy", icon: "i-ph-spiral" },
          pair2: { text: "Island", icon: "i-ph-island" },
          fact: "Galaxies are like cosmic islands containing billions of stars, separated by vast empty spaces."
        },
        {
          pair1: { text: "Rocket", icon: "i-ph-rocket" },
          pair2: { text: "Balloon", icon: "i-ph-balloon" },
          fact: "Rockets work like balloons - they push gas out one end to propel themselves in the opposite direction."
        },
        {
          pair1: { text: "Moon", icon: "i-ph-moon" },
          pair2: { text: "Mirror", icon: "i-ph-mirror" },
          fact: "The Moon doesn't produce its own light - it reflects sunlight like a giant mirror in space."
        },
        {
          pair1: { text: "Comet", icon: "i-ph-shooting-star" },
          pair2: { text: "Snowball", icon: "i-ph-snowflake" },
          fact: "Comets are like dirty snowballs made of ice and rock that develop tails when they approach the Sun."
        },
        {
          pair1: { text: "Nebula", icon: "i-ph-cloud" },
          pair2: { text: "Nursery", icon: "i-ph-baby" },
          fact: "Nebulae are stellar nurseries where new stars are born from clouds of gas and dust."
        },
        {
          pair1: { text: "Satellite", icon: "i-ph-satellite" },
          pair2: { text: "Companion", icon: "i-ph-users" },
          fact: "Satellites are objects that orbit around larger objects, like the Moon orbiting Earth."
        },
        {
          pair1: { text: "Solar System", icon: "i-ph-sun" },
          pair2: { text: "Family", icon: "i-ph-house" },
          fact: "Our solar system is like a cosmic family with the Sun as the parent and planets as children orbiting around it."
        }
      ]
    }

    // Store the data in KV
    await hubKV().set('paired:topic:computer-science', computerScienceData)
    await hubKV().set('paired:topic:physics', physicsData)
    await hubKV().set('paired:topic:mathematics', mathematicsData)
    await hubKV().set('paired:topic:biology', biologyData)
    await hubKV().set('paired:topic:space-science', spaceScienceData)

    return {
      success: true,
      message: 'Initial data seeded successfully',
      topics: ['computer-science', 'physics', 'mathematics', 'biology', 'space-science']
    }
  } catch (error) {
    console.error('Error seeding data:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to seed data'
    })
  }
})
