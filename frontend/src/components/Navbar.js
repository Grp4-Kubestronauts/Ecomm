import React from 'react';
import './Navbar.css';

function Navbar({ cartItems, showCart, setShowCart }) {
  // Group items by their id and count quantities
  const groupedItems = cartItems.reduce((acc, item) => {
    const existingItem = acc.find(i => i.id === item.id);
    if (existingItem) {
      existingItem.quantity = (existingItem.quantity || 1) + 1;
    } else {
      acc.push({ ...item, quantity: 1 });
    }
    return acc;
  }, []);

  return (
    <nav className="navbar">
      <div className="navbar-brand">
        <h1>My Shop</h1>
      </div>
      <div className="navbar-cart" onClick={() => setShowCart(!showCart)}>
        <span>Cart ({cartItems.length})</span>
        {showCart && cartItems.length > 0 && (
          <div className="cart-dropdown">
            {groupedItems.map((item, index) => (
              <div key={index} className="cart-item">
                <div className="cart-item-image-container">
                  <img 
                    src={item.image_url} 
                    alt={item.title} 
                    className="cart-item-image" 
                  />
                  {item.quantity > 1 && (
                    <span className="item-quantity">×{item.quantity}</span>
                  )}
                </div>
                <div className="cart-item-details">
                  <h4>{item.title}</h4>
                  <p>${item.price}</p>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </nav>
  );
}

export default Navbar;