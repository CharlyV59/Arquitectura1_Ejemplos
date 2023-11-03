import React, { useEffect, useState } from 'react';
import './App.css';

const urlAPI = "http://localhost:3001";

function App() {
  const [informacion, setInformacion] = useState('');

  useEffect(() => {
    fetch(urlAPI+'/getInformacion')
      .then((res) => res.json())
      .then((data) => setInformacion(data.informacion));
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Información desde Arduino</h1>
        <p>{informacion}</p>
      </header>
    </div>
  );
}

export default App;