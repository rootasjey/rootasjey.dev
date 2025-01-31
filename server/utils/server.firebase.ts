import { initializeApp } from "firebase/app"

const firebaseConfig = {
  apiKey: process.env.VFIRE_API_KEY,
  authDomain: process.env.VFIRE_AUTH_DOMAIN,
  projectId: process.env.VFIRE_PROJECT_ID,
  storageBucket: process.env.VFIRE_STORAGE_BUCKET,
  messagingSenderId: process.env.VFIRE_MESSAGING_SENDER_ID,
  appId: process.env.VFIRE_APP_ID,
  measurementId: process.env.VFIRE_MEASUREMENT_ID
}

const app = initializeApp(firebaseConfig)
