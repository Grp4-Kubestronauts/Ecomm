import React, { createContext, useContext, useState } from 'react';

const CartContext = createContext();

export const useCart = () => {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error('useCart must be used within a CartProvider');
  }
  return context;
};

export const CartProvider = ({ children }) => {
  const [cart, setCart] = useState([]);

  const updateCart = (newCart) => {
    setCart(newCart);
  };

  return (
    <CartContext.Provider value={{ cart, updateCart }}>
      {children}
    </CartContext.Provider>
  );
}; 