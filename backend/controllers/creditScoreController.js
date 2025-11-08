const CreditScore = require("../models/CreditScore");

// 🟢 Get credit score for logged-in user
exports.getCreditScoreForLoggedInUser = async (req, res) => {
  try {
    const score = await CreditScore.findOne({ customerId: req.user.id });

    if (!score) {
      return res.status(404).json({ message: "Credit score not found" });
    }

    res.json(score);
  } catch (err) {
    console.error("Error fetching credit score:", err);
    res.status(500).json({ message: "Server error" });
  }
};

// 🟠 Create or update credit score for logged-in user (for testing)
exports.createCreditScoreForLoggedInUser = async (req, res) => {
  try {
    const { score, grade, history, lastUpdated } = req.body;

    const newScore = await CreditScore.findOneAndUpdate(
      { customerId: req.user.id },
      { score, grade, history, lastUpdated },
      { new: true, upsert: true } // creates if not exists
    );

    res.status(201).json({
      message: "Credit score added/updated successfully",
      data: newScore,
    });
  } catch (err) {
    console.error("Error creating credit score:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
