const express = require("express");
const router = express.Router();
const auth = require("../middleware/authMiddleware");
const {
  signup,
  sendLoginOtp,
  verifyLoginOtp,
  sendChangeEmailOtp,
  verifyChangeEmailOtp,
} = require("../controllers/authController");

// 🧾 SIGNUP (Customer registers with PAN, Aadhaar, Email)
router.post("/signup", signup);

// ✉️ LOGIN FLOW
// Step 1: Send OTP to email
router.post("/login/send-otp", sendLoginOtp);

// Step 2: Verify OTP and return JWT
router.post("/login/verify-otp", verifyLoginOtp);

// 🔄 CHANGE EMAIL FLOW (requires auth)
// Step 1: Send OTP to new email
router.post("/email/change/send-otp", auth, sendChangeEmailOtp);

// Step 2: Verify OTP and update email in DB
router.post("/email/change/verify-otp", auth, verifyChangeEmailOtp);

module.exports = router;
