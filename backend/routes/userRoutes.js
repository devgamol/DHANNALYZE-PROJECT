const express = require("express");
const router = express.Router();
const auth = require("../middleware/authMiddleware");
const { getAllCustomers, getCustomerProfile } = require("../controllers/userController");
const { updateFingerprint } = require("../controllers/authController");

// 🧩 For testing or admin (list all customers)
router.get("/all", getAllCustomers);

// 🧍‍♂️ For logged-in customer’s own profile
router.get("/profile", auth, getCustomerProfile);

// fingerprint route
router.patch("/fingerprint", auth, updateFingerprint);

module.exports = router;
