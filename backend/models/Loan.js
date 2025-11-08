const mongoose = require("mongoose");

const loanSchema = new mongoose.Schema(
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
    amount: {
      type: Number,
      required: true,
    },
    issuedOn: {
      type: Date,
      required: true,
    },
    duration: {
      type: String,
      required: true,
    },
    interestRate: {
      type: String,
      required: true,
    },
    paymentHistory: {
      type: String,
      default: "On Time",
    },
    penalty: {
      type: String,
      default: "NO",
    },
    status: {
      type: String,
      enum: ["Active", "Inactive"],
      default: "Active",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Loan", loanSchema);
