import React, { useState } from 'react';
import Navbar from './components/Navbar';
import Products from './components/Products';
import Footer from './components/Footer';
import './App.css';

function App() {
  const [cartItems, setCartItems] = useState([]);
  const [showCart, setShowCart] = useState(false);

  const handleAddToCart = (product) => {
    setCartItems([...cartItems, product]);
  };

  return (
    <div className="app">
      <Navbar 
        cartItems={cartItems} 
        showCart={showCart} 
        setShowCart={setShowCart} 
      />
      <main className="main-content">
        <Products onAddToCart={handleAddToCart} />
      </main>
      <Footer />
    </div>
  );
}

export default App;
