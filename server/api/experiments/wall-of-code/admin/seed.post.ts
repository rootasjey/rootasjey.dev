// POST /api/experiments/wall-of-code/admin/seed
// Admin endpoint to seed the cache with initial code snippets

interface CodeSnippet {
  code: string
  projectName: string
  filePath: string
  repositoryUrl: string
  language: string
  starCount: number
  lastUpdated: string
  commitHash?: string
}

// Curated seed snippets for initial cache population
const SEED_SNIPPETS: CodeSnippet[] = [
  {
    code: `function fibonacci(n) {
  if (n <= 1) return n;
  
  let a = 0, b = 1;
  for (let i = 2; i <= n; i++) {
    [a, b] = [b, a + b];
  }
  
  return b;
}

// Example usage
console.log(fibonacci(10)); // 55
console.log(fibonacci(20)); // 6765`,
    projectName: "algorithms/javascript-algorithms",
    filePath: "src/algorithms/math/fibonacci/fibonacci.js",
    repositoryUrl: "https://github.com/trekhleb/javascript-algorithms",
    language: "JavaScript",
    starCount: 187000,
    lastUpdated: new Date().toISOString()
  },
  {
    code: `def quick_sort(arr):
    """
    Sorts an array using the quicksort algorithm.
    
    Args:
        arr: List of comparable elements
        
    Returns:
        Sorted list
    """
    if len(arr) <= 1:
        return arr
    
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    
    return quick_sort(left) + middle + quick_sort(right)

# Example usage
numbers = [3, 6, 8, 10, 1, 2, 1]
sorted_numbers = quick_sort(numbers)
print(sorted_numbers)  # [1, 1, 2, 3, 6, 8, 10]`,
    projectName: "TheAlgorithms/Python",
    filePath: "sorts/quick_sort.py",
    repositoryUrl: "https://github.com/TheAlgorithms/Python",
    language: "Python",
    starCount: 184000,
    lastUpdated: new Date().toISOString()
  },
  {
    code: `package main

import (
    "fmt"
    "math/rand"
    "time"
)

// BinarySearch performs binary search on a sorted slice
func BinarySearch(arr []int, target int) int {
    left, right := 0, len(arr)-1
    
    for left <= right {
        mid := left + (right-left)/2
        
        if arr[mid] == target {
            return mid
        } else if arr[mid] < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    
    return -1 // Not found
}

func main() {
    arr := []int{1, 3, 5, 7, 9, 11, 13, 15, 17, 19}
    target := 7
    
    result := BinarySearch(arr, target)
    if result != -1 {
        fmt.Printf("Element found at index %d\\n", result)
    } else {
        fmt.Println("Element not found")
    }
}`,
    projectName: "TheAlgorithms/Go",
    filePath: "search/binary_search.go",
    repositoryUrl: "https://github.com/TheAlgorithms/Go",
    language: "Go",
    starCount: 15000,
    lastUpdated: new Date().toISOString()
  },
  {
    code: `use std::collections::HashMap;

/// A simple LRU (Least Recently Used) cache implementation
pub struct LRUCache<K, V> {
    capacity: usize,
    map: HashMap<K, V>,
    order: Vec<K>,
}

impl<K: Clone + Eq + std::hash::Hash, V> LRUCache<K, V> {
    pub fn new(capacity: usize) -> Self {
        LRUCache {
            capacity,
            map: HashMap::new(),
            order: Vec::new(),
        }
    }
    
    pub fn get(&mut self, key: &K) -> Option<&V> {
        if self.map.contains_key(key) {
            // Move to end (most recently used)
            self.order.retain(|k| k != key);
            self.order.push(key.clone());
            self.map.get(key)
        } else {
            None
        }
    }
    
    pub fn put(&mut self, key: K, value: V) {
        if self.map.contains_key(&key) {
            // Update existing
            self.order.retain(|k| k != &key);
        } else if self.map.len() >= self.capacity {
            // Remove least recently used
            if let Some(lru_key) = self.order.first().cloned() {
                self.map.remove(&lru_key);
                self.order.remove(0);
            }
        }
        
        self.map.insert(key.clone(), value);
        self.order.push(key);
    }
}`,
    projectName: "rust-unofficial/awesome-rust",
    filePath: "examples/lru_cache.rs",
    repositoryUrl: "https://github.com/rust-unofficial/awesome-rust",
    language: "Rust",
    starCount: 46000,
    lastUpdated: new Date().toISOString()
  },
  {
    code: `class TreeNode {
    constructor(val, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class BinarySearchTree {
    constructor() {
        this.root = null;
    }
    
    insert(val) {
        const newNode = new TreeNode(val);
        
        if (!this.root) {
            this.root = newNode;
            return this;
        }
        
        let current = this.root;
        while (true) {
            if (val === current.val) return undefined; // Duplicate
            
            if (val < current.val) {
                if (!current.left) {
                    current.left = newNode;
                    return this;
                }
                current = current.left;
            } else {
                if (!current.right) {
                    current.right = newNode;
                    return this;
                }
                current = current.right;
            }
        }
    }
    
    find(val) {
        if (!this.root) return false;
        
        let current = this.root;
        while (current) {
            if (val === current.val) return true;
            current = val < current.val ? current.left : current.right;
        }
        
        return false;
    }
    
    // In-order traversal (returns sorted array)
    inOrder() {
        const result = [];
        
        function traverse(node) {
            if (node) {
                traverse(node.left);
                result.push(node.val);
                traverse(node.right);
            }
        }
        
        traverse(this.root);
        return result;
    }
}

// Example usage
const bst = new BinarySearchTree();
bst.insert(10).insert(5).insert(15).insert(2).insert(7);
console.log(bst.inOrder()); // [2, 5, 7, 10, 15]
console.log(bst.find(7));   // true
console.log(bst.find(12));  // false`,
    projectName: "trekhleb/javascript-algorithms",
    filePath: "src/data-structures/tree/binary-search-tree/BinarySearchTree.js",
    repositoryUrl: "https://github.com/trekhleb/javascript-algorithms",
    language: "JavaScript",
    starCount: 187000,
    lastUpdated: new Date().toISOString()
  }
]

export default defineEventHandler(async (event) => {
  try {
    // Clear existing cache first
    const existingKeys = await hubKV().keys('wall-of-code:snippet:')
    if (existingKeys.length > 0) {
      await Promise.all(existingKeys.map(key => hubKV().del(key)))
    }
    
    // Seed with curated snippets
    const seedPromises = SEED_SNIPPETS.map(async (snippet, index) => {
      const key = `wall-of-code:snippet:seed-${index}-${Date.now()}`
      await hubKV().set(key, snippet, { ttl: 86400 }) // Cache for 24 hours
      return key
    })
    
    const seededKeys = await Promise.all(seedPromises)
    
    return {
      success: true,
      message: 'Cache seeded successfully with curated code snippets',
      seededCount: seededKeys.length,
      snippets: SEED_SNIPPETS.map(s => ({
        projectName: s.projectName,
        language: s.language,
        filePath: s.filePath,
        starCount: s.starCount
      }))
    }
  } catch (error: any) {
    console.error('Error seeding cache:', error)
    
    return {
      success: false,
      error: error.message || 'Failed to seed cache'
    }
  }
})
