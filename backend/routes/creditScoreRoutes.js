const express = require("express");
const router = express.Router();
const auth = require("../middleware/authMiddleware");
const { getCreditScoreForLoggedInUser, createCreditScoreForLoggedInUser } = require("../controllers/creditScoreController");

// GET - Fetch user's credit score
router.get("/", auth, getCreditScoreForLoggedInUser);

// POST - Add/Update credit score (for testing or admin use)
router.post("/", auth, createCreditScoreForLoggedInUser);

module.exports = router;
