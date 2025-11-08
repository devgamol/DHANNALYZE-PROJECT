const express = require("express");
const router = express.Router();
const auth = require("../middleware/authMiddleware");
const { getAccountsForLoggedInUser, createAccountForLoggedInUser } = require("../controllers/accountController");

router.get("/", auth, getAccountsForLoggedInUser);

router.post("/", auth, createAccountForLoggedInUser);

module.exports = router;
