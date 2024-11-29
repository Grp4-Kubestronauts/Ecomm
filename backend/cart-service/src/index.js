import express from 'express';
import cors from 'cors';
import router from './routes/Cart.js';
import productRoutes from './routes/products.js';

const app = express();
const port = process.env.PORT || 3001;

// Add error handling for uncaught exceptions
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
});

process.on('unhandledRejection', (error) => {
  console.error('Unhandled Rejection:', error);
});

// Log environment variables (excluding sensitive data)
console.log('Environment:', {
  NODE_ENV: process.env.NODE_ENV,
  PORT: process.env.PORT,
  DATABASE_URL: process.env.DATABASE_URL ? 'Set' : 'Not set'
});

try {
  // Add request logging middleware
  app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
    next();
  });

  app.use(cors({
    origin: true,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'X-Session-Id']
  }));

  app.use(express.json());

  // Basic health check
  app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok' });
  });

  // Mount routes with error handling
  console.log('Mounting routes...');
  app.use('/api/cart', router);
  app.use('/api/products', productRoutes);

  // Error handling middleware
  app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({ 
      error: 'Internal server error',
      message: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  });

  // Start server with error handling
  const server = app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });

  server.on('error', (error) => {
    console.error('Server error:', error);
    process.exit(1);
  });

} catch (error) {
  console.error('Startup error:', error);
  process.exit(1);
} 