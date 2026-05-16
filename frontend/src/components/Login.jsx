import { useState } from 'react';
import './Login.css';

function Login({ onLogin }) {
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!password.trim()) {
      setError('Por favor ingresa la contraseña');
      return;
    }
    
    // Save to local storage and trigger parent update
    localStorage.setItem('app_password', password);
    onLogin();
  };

  return (
    <div className="login-container">
      <div className="login-box">
        <h2>Council LLM</h2>
        <p>Por favor inicia sesión para continuar</p>
        <form onSubmit={handleSubmit}>
          <div className="input-group">
            <input
              type="password"
              placeholder="Contraseña"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoFocus
            />
          </div>
          {error && <div className="error-message">{error}</div>}
          <button type="submit" className="login-button">
            Entrar
          </button>
        </form>
      </div>
    </div>
  );
}

export default Login;
