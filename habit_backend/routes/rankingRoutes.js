const express = require('express');
const router = express.Router();
const rankingController = require('../controllers/rankingController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/global', authMiddleware, rankingController.getGlobalRanking);

module.exports = router;
