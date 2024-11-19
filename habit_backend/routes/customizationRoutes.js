const express = require('express');
const router = express.Router();
const customizationController = require('../controllers/customizationController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/items', authMiddleware, customizationController.getAvailableItems);
router.post('/items/:id/purchase', authMiddleware, customizationController.purchaseItem);

module.exports = router;
