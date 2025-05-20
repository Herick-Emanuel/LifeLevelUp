const express = require("express");
const router = express.Router();
const habitCompletionController = require("../controllers/habitCompletionController");
const authMiddleware = require("../middlewares/authMiddleware");

router.use(authMiddleware);

router.post("/", habitCompletionController.createCompletion);
router.get("/habit/:habit_id", habitCompletionController.getCompletions);
router.get("/stats/:habit_id", habitCompletionController.getCompletionStats);

module.exports = router;
