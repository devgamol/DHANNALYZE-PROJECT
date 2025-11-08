const Loan = require("../models/Loan");

//  Create a new loan (for the logged-in customer)
exports.createLoan = async (req, res) => {
  try {
    const customerId = req.user.id; // Extracted from JWT by auth middleware
    const {
      bankName,
      amount,
      issuedOn,
      duration,
      interestRate,
      paymentHistory,
      penalty,
      status,
    } = req.body;

    // 🔹 Basic input validation
    if (!bankName || !amount || !issuedOn || !duration || !interestRate) {
      return res
        .status(400)
        .json({ message: "All required fields must be provided." });
    }

    // 🔹 Create new loan and link to the logged-in user
    const newLoan = await Loan.create({
      customerId, // Linked to JWT user
      bankName,
      amount,
      issuedOn,
      duration,
      interestRate,
      paymentHistory: paymentHistory || "On Time",
      penalty: penalty || "NO",
      status: status || "Active",
    });

    res
      .status(201)
      .json({ message: "Loan created successfully.", loan: newLoan });
  } catch (error) {
    console.error(" Loan creation error:", error);
    res.status(500).json({ message: "Server error while creating loan." });
  }
};

//  Get all loans for the logged-in customer
exports.getLoansForLoggedInUser = async (req, res) => {
  try {
    const customerId = req.user.id;

    // Fetch loans belonging to this customer, sorted by latest
    const loans = await Loan.find({ customerId }).sort({ createdAt: -1 });

    // If none found, still return an empty array (handled in frontend)
    res.status(200).json(loans);
  } catch (error) {
    console.error(" Error fetching loans:", error);
    res.status(500).json({ message: "Server error while fetching loans." });
  }
};
