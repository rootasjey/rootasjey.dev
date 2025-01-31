import { initializeApp, getApps, cert } from 'firebase-admin/app'

export default defineNitroPlugin(() => {
  const apps = getApps()
  if (apps.length) return

  const firebaseConfig = {
    apiKey: process.env.VFIRE_API_KEY,
    authDomain: process.env.VFIRE_AUTH_DOMAIN,
    projectId: process.env.VFIRE_PROJECT_ID,
    storageBucket: process.env.VFIRE_STORAGE_BUCKET,
    messagingSenderId: process.env.VFIRE_MESSAGING_SENDER_ID,
    appId: process.env.VFIRE_APP_ID,
    measurementId: process.env.VFIRE_MEASUREMENT_ID
  }
  
  initializeApp(firebaseConfig)
})
