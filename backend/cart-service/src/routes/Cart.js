import express from 'express';
import { v4 as uuidv4 } from 'uuid';
import pkg from 'pg';
const { Pool } = pkg;

const router = express.Router();
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

// Debug middleware - log all requests
router.use((req, res, next) => {
  console.log(`Cart route hit: ${req.method} ${req.originalUrl}`);
  next();
});

// Middleware to ensure session ID
const ensureSession = (req, res, next) => {
  let sessionId = req.headers['x-session-id'];
  if (!sessionId) {
    sessionId = uuidv4();
    res.setHeader('X-Session-Id', sessionId);
  }
  req.sessionId = sessionId;
  next();
};

router.use(ensureSession);


// GET cart items
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT ci.*, p.title, p.price, p.image_key 
       FROM cart_items ci 
       JOIN products p ON ci.product_id = p.id 
       WHERE ci.session_id = $1`,
      [req.sessionId]
    );

    res.json({
      sessionId: req.sessionId,
      items: result.rows
    });
  } catch (error) {
    console.error('Get cart error:', error);
    res.status(500).send('An error occurred while getting the cart items.');
  }
});

// POST add item to cart
router.post('/', async (req, res) => {
  console.log('Add to cart request received:', req.body);
  try {
    const { productId, quantity } = req.body;

    // Add to cart_items table
    const result = await pool.query(
      `INSERT INTO cart_items (session_id, product_id, quantity) 
       VALUES ($1, $2, $3) 
       RETURNING *`,
      [req.sessionId, productId, quantity]
    );

    // Get product details
    const productResult = await pool.query(
      `SELECT title, price, image_key 
       FROM products 
       WHERE id = $1`,
      [productId]
    );

    if (productResult.rows.length === 0) {
      return res.status(404).json({ error: 'Product not found' });
    }

    const cartItem = {
      ...result.rows[0],
      ...productResult.rows[0]
    };

    res.json(cartItem);
  } catch (error) {
    console.error('Add to cart error:', error);
    res.status(500).json({
      error: 'Failed to add item to cart',
      details: error.message
    });
  }
});

export default router;