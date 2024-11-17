// routes/missionRoutes.js

const express = require('express');
const router = express.Router();
const missionController = require('../controllers/missionController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/', authMiddleware, missionController.getMissions);
router.post('/:id/complete', authMiddleware, missionController.completeMission);

module.exports = router;
