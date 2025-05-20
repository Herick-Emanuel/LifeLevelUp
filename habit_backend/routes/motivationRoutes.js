const express = require("express");
const router = express.Router();
const motivationController = require("../controllers/motivationController");
const authMiddleware = require("../middlewares/authMiddleware");

router.post("/", authMiddleware, motivationController.addMessage);
router.get("/", authMiddleware, motivationController.getMessages);
router.delete("/:id", authMiddleware, motivationController.deleteMessage);

module.exports = router;
