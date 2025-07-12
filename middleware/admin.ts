export default defineNuxtRouteMiddleware(() => {
  const { loggedIn, user } = useUserSession()

  // redirect the user to the login screen if they're not authenticated
  if (!loggedIn.value) {
    return navigateTo('/login')
  }

  // redirect non-admin users to the home page
  if (user.value?.role !== 'admin') {
    throw createError({
      statusCode: 403,
      statusMessage: 'Admin access required'
    })
  }
})
