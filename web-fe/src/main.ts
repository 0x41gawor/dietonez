// main.ts
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

import Toast, { type PluginOptions, POSITION  } from 'vue-toastification'
import 'vue-toastification/dist/index.css'
import './style/style.css'

const app = createApp(App)

const toastOptions: PluginOptions = {
  position: POSITION.TOP_RIGHT,
  timeout: 3000,
  closeOnClick: true,
  pauseOnFocusLoss: true,
  pauseOnHover: true,
  draggable: true,
  draggablePercent: 0.6,
  showCloseButtonOnHover: false,
  hideProgressBar: false,
  closeButton: 'button',
  icon: true,
  rtl: false,
  transition: 'Vue-Toastification__bounce',
  maxToasts: 5,
  newestOnTop: true
}

// Używamy routera i toastów
app.use(router)
app.use(Toast, toastOptions)

// Montujemy aplikację
app.mount('#app')

