import React, { useState, useEffect } from 'react';
import { useProducts } from '../hooks/useProducts';
import '../css/card.css';

function Products({ onAddToCart }) {
  const { products, loading, error } = useProducts();
  const [cartItems, setCartItems] = useState([]);
  const [sessionId, setSessionId] = useState(localStorage.getItem('cartSessionId'));
  const [showCart, setShowCart] = useState(false);

  // Calculate total items in cart
  const cartItemCount = cartItems.reduce((total, item) => total + (item.quantity || 1), 0);

  // Fetch initial cart state
  useEffect(() => {
    const fetchCart = async () => {
      try {
        const apiUrl = process.env.REACT_APP_API_URL || 'http://localhost:3001';
        const response = await fetch(`${apiUrl}/api/cart`, {
          headers: {
            'X-Session-Id': sessionId || ''
          }
        });
        if (response.ok) {
          const data = await response.json();
          setCartItems(data.items || []);
        }
      } catch (err) {
        console.error('Error fetching cart:', err);
      }
    };

    if (sessionId) {
      fetchCart();
    }
  }, [sessionId]);

  const handleAddToCart = async (productId) => {
    try {
      const apiUrl = process.env.REACT_APP_API_URL || 'http://localhost:3001';
      console.log('Sending request to:', `${apiUrl}/api/cart`);
      
      const response = await fetch(`${apiUrl}/api/cart`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Session-Id': sessionId || ''
        },
        body: JSON.stringify({ 
          productId, 
          quantity: 1
        })
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      // Get the product that was added
      const addedProduct = products.find(p => p.id === productId);
      onAddToCart(addedProduct);

      const newSessionId = response.headers.get('x-session-id');
      if (newSessionId) {
        localStorage.setItem('cartSessionId', newSessionId);
        setSessionId(newSessionId);
      }

      // Fetch updated cart after adding item
      const cartResponse = await fetch(`${apiUrl}/api/cart`, {
        headers: {
          'X-Session-Id': newSessionId || sessionId || ''
        }
      });
      
      if (cartResponse.ok) {
        const cartData = await cartResponse.json();
        setCartItems(cartData.items || []);
      }

      alert('Product added to cart!');
    } catch (err) {
      console.error('Error adding to cart:', err);
      alert('Failed to add product to cart');
    }
  };

  if (loading) return <div className="loading">Loading products...</div>;
  if (error) return <div className="error">{error}</div>;

  return (
    <div className="products-container">
      <div className="header">
        <h2>Available Products LMAO XD LOLW</h2>
        <div className="cart-icon" onClick={() => setShowCart(!showCart)}>
          Cart ({cartItemCount})
          {showCart && cartItems.length > 0 && (
            <div className="cart-dropdown">
              {cartItems.map((item) => (
                <div key={item.id} className="cart-item">
                  <img 
                    src={item.image_url || `https://${process.env.REACT_APP_S3_BUCKET}.s3.${process.env.REACT_APP_AWS_REGION}.amazonaws.com/${item.image_key}`} 
                    alt={item.title} 
                    className="cart-item-image" 
                  />
                  <div className="cart-item-details">
                    <h4>{item.title}</h4>
                    <p>Quantity: {item.quantity}</p>
                    <p>${item.price}</p>
                  </div>
                </div>
              ))}
              <div className="cart-total">
                Total: ${cartItems.reduce((sum, item) => sum + (item.price * (item.quantity || 1)), 0).toFixed(2)}
              </div>
            </div>
          )}
        </div>
      </div>

      <div className="products-grid">
        {products.map(product => (
          <div key={product.id} className="product-card">
            <img src={product.image_url} alt={product.title} className="product-image" />
            <h3>{product.title}</h3>
            <p className="price">${product.price}</p>
            <p className="description">{product.description}</p>
            <button 
              className="add-to-cart-btn"
              onClick={() => handleAddToCart(product.id)}
            >
              Add to Cart
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Products;

