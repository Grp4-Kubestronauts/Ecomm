-- Select the ecomm database
\c ecomm;

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    image_key VARCHAR(255)
);

-- Insert sample products into the products table
INSERT INTO products (title, price, description, image_key) VALUES 
    ('Classic Watch', 299.99, 'Elegant timepiece with leather strap', 'products/watch.jpg'),
    ('Running Shoes', 149.99, 'Comfortable athletic shoes for daily use', 'products/shoe.jpg'),
    ('Cotton T-Shirt', 34.99, 'Premium quality cotton casual wear', 'products/shirt.jpg');

-- Create cart_items table (optional, if you want persistent carts)
CREATE TABLE IF NOT EXISTS cart_items (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) NOT NULL,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
