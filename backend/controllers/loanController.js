const Loan = require("../models/Loan");

// ➤ Create a new loan (if your app allows adding one)
exports.createLoan = async (req, res) => {
  try {
    const customerId = req.user.id; // from JWT
    const { bankName, amount, issuedOn, duration, interestRate } = req.body;

    if (!bankName || !amount || !issuedOn || !duration || !interestRate) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const newLoan = await Loan.create({
      customerId,
      bankName,
      amount,
      issuedOn,
      duration,
      interestRate,
    });

    res.status(201).json({ message: "Loan created successfully", data: newLoan });
  } catch (error) {
    console.error("Loan creation error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// ➤ Get all loans for the logged-in user
exports.getLoansForLoggedInUser = async (req, res) => {
  try {
    const customerId = req.user.id;
    const loans = await Loan.find({ customerId }).sort({ createdAt: -1 });
    res.status(200).json(loans);
  } catch (error) {
    console.error("Get loans error:", error);
    res.status(500).json({ message: "Server error" });
  }
};
