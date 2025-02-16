import { useSurrealDB } from '~/composables/useSurrealDB'

export const useAuth = () => {
  const { checkTokenExpiration } = useSurrealDB()
  
  const getToken = () => {
    if (import.meta.server) {
      const cookie = useCookie('token')
      return cookie.value
    }
    
    return localStorage.getItem('token')
  }

  const getValidToken = async () => {
    let token = getToken()
    if (token && checkTokenExpiration(token)) {
      return token
    }

    token = await refreshToken()
    return token ?? ""
  }

  const refreshToken = async () => {
    const email = import.meta.server ? null : localStorage.getItem('email')
    const password = import.meta.server ? null : localStorage.getItem('password')
    
    if (email && password) {
      const { token } = await $fetch('/api/user/signin', {
        method: 'POST',
        body: { email, password }
      })
      
      if (import.meta.client) {
        document.cookie = `token=${token}; path=/`
        localStorage.setItem('token', token)
      }
      
      return token
    }
    
    return null
  }

  const fetchWithAuth = async (url: string, options: any = {}) => {
    let token = getToken()
    
    if (token && !checkTokenExpiration(token)) {
      token = await refreshToken()
    }
    
    if (!token && import.meta.client) {
      navigateTo('/login')
      return
    }

    return $fetch(url, {
      ...options,
      headers: {
        ...options.headers,
        Authorization: `Bearer ${token}`
      }
    })
  }

  const useFetchWithAuth = async (url: string, options: any = {}) => {
    let token = getToken()

    if (token && !checkTokenExpiration(token)) {
      token = await refreshToken()
    }

    if (!token && import.meta.client) {
      navigateTo('/login')
      return
    }

    return useFetch(url, {
      ...options,
      headers: {
        ...options.headers,
        Authorization: `Bearer ${token}`
      }
    })
  }

  return {
    getToken,
    getValidToken,
    fetchWithAuth,
    refreshToken,
    useFetchWithAuth,
  }
}