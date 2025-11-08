const mongoose = require("mongoose");

const creditScoreSchema = new mongoose.Schema(
  {
    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Customer",
      required: true,
    },
    score: {
      type: Number,
      required: true,
      min: 300,
      max: 900,
    },
    grade: {
      type: String,
      enum: ["Excellent", "Good", "Fair", "Poor"],
      required: true,
    },
    history: [
      {
        date: { type: Date },
        score: { type: Number },
      },
    ],
    lastUpdated: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("CreditScore", creditScoreSchema);
