import React from 'react';
import { useProducts } from '../../hooks/useProducts';
import '../../css/card.css';

const Card = () => {
  const { products, loading, error } = useProducts();

  if (loading) return <div className="loading">Loading products...</div>;
  if (error) return <div className="error">Error: {error}</div>;

  return (
    <div className="products-container">
      <div className="products-grid">
        {products.map(product => (
          <div key={product.id} className="product-card">
            <img 
              src={product.image_url} 
              alt={product.title}
              className="product-image"
            />
            <div className="product-details">
              <h3>{product.title}</h3>
              <p className="product-price">${product.price}</p>
              <button className="add-to-cart-btn">Add to Cart</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Card; 