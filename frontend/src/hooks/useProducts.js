import { useState, useEffect } from 'react';

export const useProducts = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        console.log('Fetching products...');
        const apiUrl = process.env.REACT_APP_API_URL || 'http://localhost:3001';
        const response = await fetch(`${apiUrl}/api/products`);
        
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log('Products fetched:', data);
        setProducts(data);
      } catch (err) {
        console.error('Error fetching products:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  return { products, loading, error };
}; 