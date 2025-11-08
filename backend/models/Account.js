const mongoose = require("mongoose");

const accountSchema = new mongoose.Schema(
  {
    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Customer",
      required: true,
    },
    bankName: {
      type: String,
      required: true,
    },
    accountType: {
      type: String,
      enum: ["Savings", "Current"],
      required: true,
    },
    branch: {
      type: String,
      required: true,
    },
    openingDate: {
      type: Date,
      required: true,
    },
    status: {
      type: String,
      enum: ["Active", "Inactive"],
      default: "Active",
    },
    linkedServices: {
      type: Boolean,
      default: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Account", accountSchema);
