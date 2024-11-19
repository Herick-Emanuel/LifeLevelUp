const express = require('express');
const router = express.Router();
const journalController = require('../controllers/journalController');
const authMiddleware = require('../middlewares/authMiddleware');

router.post('/', authMiddleware, journalController.addEntry);
router.get('/', authMiddleware, journalController.getEntries);

module.exports = router;
