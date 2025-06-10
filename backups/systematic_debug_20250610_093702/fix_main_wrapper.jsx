// Fix for main.jsx - Ensure AppProvider wrapper exists

import React from 'react'
import ReactDOM from 'react-dom/client'
import { AppProvider } from './src/context/AppContext'
import App from './src/App'
// or import ExistingApp from './src/ExistingApp'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <AppProvider>
      <App />
    </AppProvider>
  </React.StrictMode>,
)
