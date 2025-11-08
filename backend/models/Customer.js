const mongoose = require("mongoose");

const customerSchema = new mongoose.Schema(
  {
    pan: { type: String, required: true, unique: true },
    aadhaar: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true },
    twoFAEnabled: { type: Boolean, default: false },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Customer", customerSchema);
