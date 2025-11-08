const express = require("express");
const router = express.Router();
const auth = require("../middleware/authMiddleware");
const { createLoan, getLoansForLoggedInUser } = require("../controllers/loanController");

// All routes secured with JWT
router.post("/", auth, createLoan);
router.get("/", auth, getLoansForLoggedInUser);

module.exports = router;
