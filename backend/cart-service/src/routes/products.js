import express from 'express';
import { ProductController } from '../controllers/ProductController.js';

const router = express.Router();
const productController = new ProductController();

router.get('/', productController.getProducts);
router.get('/:id', productController.getProduct);

export default router; 