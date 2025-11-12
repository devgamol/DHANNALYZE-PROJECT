const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const Customer = require("../models/Customer");
const OTPVerification = require("../models/OTPVerification");
const fetch = global.fetch || ((...args) => import('node-fetch').then(({ default: fetch }) => fetch(...args)));


// EMAIL SENDER (Brevo in production, Gmail locally)
async function sendEmail(to, subject, text) {
  try {
    const response = await fetch("https://api.brevo.com/v3/smtp/email", {
      method: "POST",
      headers: {
        "api-key": process.env.BREVO_API_KEY,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        sender: { name: "Dhannalyze", email: "amolsahu31010@gmail.com" },
        to: [{ email: to }],
        subject,
        textContent: text,
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      throw new Error(err);
    }

    console.log(`Email sent to ${to} via Brevo`);
  } catch (err) {
    console.error("Error sending email:", err.message);
  }
}


// SIGNUP
exports.signup = async (req, res) => {
  try {
    const { pan, aadhaar, email } = req.body;
    if (!pan || !aadhaar || !email) {
      return res.status(400).json({ message: "PAN, Aadhaar, and Email are required" });
    }

    const existingCustomer = await Customer.findOne({ email });
    if (existingCustomer) {
      return res.status(409).json({ message: "Customer already registered with this email" });
    }

    const customer = await Customer.create({
      pan,
      aadhaar,
      email,
      twoFAEnabled: false,
    });

    res.status(201).json({
      message: "Signup successful",
      customerId: customer._id,
    });
  } catch (err) {
    console.error("Signup error:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// SEND LOGIN OTP
exports.sendLoginOtp = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ message: "Email is required" });

    const customer = await Customer.findOne({ email });
    if (!customer) return res.status(404).json({ message: "Customer not found" });

    const otp = String(Math.floor(100000 + Math.random() * 900000));
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

    await OTPVerification.create({
      email,
      otp,
      expiresAt,
      verified: false,
    });

    await sendEmail(
      email,
      "Your Dhannalyze Login OTP",
      `Dear Customer,\n\nYour OTP for login is: ${otp}\nThis OTP is valid for 5 minutes.\n\nRegards,\nDhannalyze Security Team`
    );

    res.json({ message: "OTP sent successfully" });
  } catch (err) {
    console.error("sendLoginOtp error:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// VERIFY LOGIN OTP & ISSUE JWT
exports.verifyLoginOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;
    if (!email || !otp) return res.status(400).json({ message: "Email and OTP are required" });

    const record = await OTPVerification.findOne({ email, verified: false }).sort({ createdAt: -1 });
    if (!record) return res.status(400).json({ message: "No OTP request found for this email" });

    if (record.expiresAt < new Date()) return res.status(400).json({ message: "OTP has expired" });
    if (record.otp !== otp) return res.status(400).json({ message: "Invalid OTP" });

    record.verified = true;
    await record.save();

    const customer = await Customer.findOne({ email });
    if (!customer) return res.status(404).json({ message: "Customer not found" });

    const token = jwt.sign({ id: customer._id }, process.env.JWT_SECRET, { expiresIn: "15d" });

    res.json({
      message: "Login successful",
      token,
    });
  } catch (err) {
    console.error("verifyLoginOtp error:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// SEND CHANGE EMAIL OTP
exports.sendChangeEmailOtp = async (req, res) => {
  try {
    const { newEmail } = req.body;
    if (!newEmail) return res.status(400).json({ message: "New email is required" });

    const otp = String(Math.floor(100000 + Math.random() * 900000));
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

    await OTPVerification.create({
      email: newEmail,
      otp,
      expiresAt,
      verified: false,
    });

    await sendEmail(
      newEmail,
      "Verify your new Dhannalyze Email",
      `Dear Customer,\n\nYour OTP for verifying your new email is: ${otp}\nThis OTP is valid for 5 minutes.\n\nRegards,\nDhannalyze Security Team`
    );

    res.json({ message: "OTP sent to new email" });
  } catch (err) {
    console.error("sendChangeEmailOtp error:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

// VERIFY CHANGE EMAIL OTP
exports.verifyChangeEmailOtp = async (req, res) => {
  try {
    const userId = req.user?.id;
    const { newEmail, otp } = req.body;

    if (!userId) return res.status(401).json({ message: "Unauthorized" });
    if (!newEmail || !otp)
      return res.status(400).json({ message: "New email and OTP are required" });

    const record = await OTPVerification.findOne({ email: newEmail, verified: false }).sort({ createdAt: -1 });
    if (!record) return res.status(400).json({ message: "No OTP request found" });
    if (record.expiresAt < new Date()) return res.status(400).json({ message: "OTP expired" });
    if (record.otp !== otp) return res.status(400).json({ message: "Invalid OTP" });

    record.verified = true;
    await record.save();

    const existingEmail = await Customer.findOne({ email: newEmail });
    if (existingEmail) return res.status(409).json({ message: "This email is already in use" });

    await Customer.findByIdAndUpdate(userId, { email: newEmail });

    res.json({ message: "Email updated successfully" });
  } catch (err) {
    console.error("verifyChangeEmailOtp error:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

exports.updateFingerprint = async (req, res) => {
  try {
    const userId = req.user.id;
    const { enable } = req.body;

    const updatedUser = await Customer.findByIdAndUpdate(
      userId,
      { twoFAEnabled: enable },
      { new: true }
    );

    if (!updatedUser)
      return res.status(404).json({ message: "Customer not found" });

    res.json({ twoFAEnabled: updatedUser.twoFAEnabled });
  } catch (err) {
    console.error("updateFingerprint error:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
};
