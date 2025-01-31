export const useAuth = () => {
  const { $firebaseAuth } = useNuxtApp()

  onMounted(async () => {
    $firebaseAuth.onAuthStateChanged(async (user) => {
      if (user) {
        const token = await user.getIdToken()
        // Set default auth header for all future requests
        // setHeader('Authorization', `Bearer ${token}`)
        console.log('(useAuth) user: ', user)
      }
    })
  })
}
