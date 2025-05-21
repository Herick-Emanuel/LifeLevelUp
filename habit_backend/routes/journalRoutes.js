const express = require("express");
const router = express.Router();
const journalController = require("../controllers/journalController");
const authMiddleware = require("../middlewares/authMiddleware");
const levelRestriction = require("../middlewares/levelRestriction");

router.post(
  "/",
  authMiddleware,
  levelRestriction(2),
  journalController.addEntry
);
router.get(
  "/",
  authMiddleware,
  levelRestriction(2),
  journalController.getEntries
);

module.exports = router;
