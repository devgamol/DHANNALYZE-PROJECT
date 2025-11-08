const Customer = require("../models/Customer");

// 🔹 Get all registered customers (for internal/admin use, or testing)
async function getAllCustomers(req, res) {
  try {
    // Fetch all customers, exclude sensitive fields if needed
    const customers = await Customer.find().select("-__v -createdAt -updatedAt");
    res.json(customers);
  } catch (err) {
    console.error("Error fetching customers:", err);
    res.status(500).json({ error: "Server error while fetching customers" });
  }
}

// 🔹 Get profile of logged-in customer (for app)
async function getCustomerProfile(req, res) {
  try {
    const customerId = req.user.id; // comes from JWT in authMiddleware
    const customer = await Customer.findById(customerId).select("-__v");

    if (!customer) {
      return res.status(404).json({ message: "Customer not found" });
    }

    res.json(customer);
  } catch (err) {
    console.error("Error fetching profile:", err);
    res.status(500).json({ error: "Server error while fetching profile" });
  }
}

module.exports = { getAllCustomers, getCustomerProfile };
