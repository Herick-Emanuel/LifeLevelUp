const express = require("express");
const router = express.Router();
const communityChallengeController = require("../controllers/communityChallengeController");
const authMiddleware = require("../middlewares/authMiddleware");
const adminOnly = require("../middlewares/adminOnly");

// Admin
router.post(
  "/",
  authMiddleware,
  adminOnly,
  communityChallengeController.createChallenge
);
router.put(
  "/:id",
  authMiddleware,
  adminOnly,
  communityChallengeController.updateChallenge
);
router.delete(
  "/:id",
  authMiddleware,
  adminOnly,
  communityChallengeController.deleteChallenge
);

// Público/autenticado
router.get("/", authMiddleware, communityChallengeController.listChallenges);
router.post(
  "/:id/join",
  authMiddleware,
  communityChallengeController.joinChallenge
);
router.post(
  "/:id/complete",
  authMiddleware,
  communityChallengeController.completeChallenge
);
router.get(
  "/user/me",
  authMiddleware,
  communityChallengeController.userChallenges
);

module.exports = router;
