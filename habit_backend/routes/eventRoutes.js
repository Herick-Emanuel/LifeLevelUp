const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/active', authMiddleware, eventController.getActiveEvents);

module.exports = router;
