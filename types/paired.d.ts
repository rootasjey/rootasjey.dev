export type Card = {
  id: number
  text: string
  icon: string
  pairId: number
  isFlipped: boolean
  isMatched: boolean
  fact: string
}

export type Topic = {
  id: string
  name: string
  description: string
  cardCount: number
  difficulty: string
  icon: string
}

export type CardPair = {
  pair1: { text: string; icon: string }
  pair2: { text: string; icon: string }
  fact: string
}

export type CardPair = {
  pair1: { text: string; icon: string }
  pair2: { text: string; icon: string }
  fact: string
}

export type TopicData = {
  name: string
  description: string
  difficulty: 'easy' | 'medium' | 'hard'
  icon: string
  cardPairs: CardPair[]
  createdAt?: string
  updatedAt?: string
}
