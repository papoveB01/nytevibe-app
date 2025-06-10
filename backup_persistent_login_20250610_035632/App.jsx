import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import { AppProvider } from './context/AppContext';
import ExistingApp from './ExistingApp';

function App() {
  return (
    <AppProvider>
      <BrowserRouter>
        <div className="App">
          <ExistingApp />
        </div>
      </BrowserRouter>
    </AppProvider>
  );
}

export default App;
