const express = require("express");
const router = express.Router();
const motivationController = require("../controllers/motivationController");
const authMiddleware = require("../middlewares/authMiddleware");
const levelRestriction = require("../middlewares/levelRestriction");

router.post(
  "/",
  authMiddleware,
  levelRestriction(3),
  motivationController.addMessage
);
router.get(
  "/",
  authMiddleware,
  levelRestriction(3),
  motivationController.getMessages
);
router.delete(
  "/:id",
  authMiddleware,
  levelRestriction(3),
  motivationController.deleteMessage
);

module.exports = router;
