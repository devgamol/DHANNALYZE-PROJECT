const Account = require("../models/Account");

exports.getAccountsForLoggedInUser = async (req, res) => {
  try {
    const accounts = await Account.find({ customerId: req.user.id });
    res.json(accounts);
  } catch (err) {
    console.error("Error fetching accounts:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.createAccountForLoggedInUser = async (req, res) => {
  try {
    const { bankName, accountType, branch, openingDate, status, linkedServices } = req.body;

    const newAccount = await Account.create({
      customerId: req.user.id,
      bankName,
      accountType,
      branch,
      openingDate,
      status,
      linkedServices
    });

    res.status(201).json({
      message: "Account created successfully",
      data: newAccount
    });
  } catch (err) {
    console.error("Error creating account:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
