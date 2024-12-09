import pkg from 'pg';
const { Pool } = pkg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  },
  connectionTimeoutMillis: 10000, // Increase timeout to 10 seconds
  query_timeout: 10000
});

export class ProductController {
  async getProducts(req, res) {
    try {
      const result = await pool.query(
        'SELECT id, title, price, description, image_key FROM products'
      );

      if (!process.env.S3_BUCKET || !process.env.AWS_REGION) {
        console.error('Missing S3 configuration:', { 
          bucket: process.env.S3_BUCKET, 
          region: process.env.AWS_REGION 
        });
      }

      const products = result.rows.map(product => ({
        ...product,
        image_url: `https://${process.env.S3_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com/${product.image_key}`
      }));

      res.json(products);
    } catch (error) {
      console.error('Error fetching products:', error);
      res.status(500).json({ 
        error: 'Failed to fetch products',
        details: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }

  async getProduct(req, res) {
    try {
      const { id } = req.params;
      const result = await pool.query(
        'SELECT id, title, price, description, image_key FROM products WHERE id = $1',
        [id]
      );

      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'Product not found' });
      }

      const product = {
        ...result.rows[0],
        image_url: `https://${process.env.S3_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com/${result.rows[0].image_key}`
      };

      res.json(product);
    } catch (error) {
      console.error('Error fetching product:', error);
      res.status(500).json({ error: 'Failed to fetch product' });
    }
  }
} 