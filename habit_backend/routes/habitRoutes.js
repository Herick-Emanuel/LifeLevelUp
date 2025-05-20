const express = require("express");
const router = express.Router();
const habitController = require("../controllers/habitController");
const authMiddleware = require("../middlewares/authMiddleware");
const { validateHabit } = require("../controllers/habitController");

router.post("/", authMiddleware, validateHabit, habitController.createHabit);
router.get("/", authMiddleware, habitController.getHabits);
router.put("/:id", authMiddleware, validateHabit, habitController.updateHabit);
router.delete("/:id", authMiddleware, habitController.deleteHabit);
router.post("/:id/progress", authMiddleware, habitController.updateProgress);

module.exports = router;
