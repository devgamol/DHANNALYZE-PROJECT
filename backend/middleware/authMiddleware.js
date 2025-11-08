const jwt = require("jsonwebtoken");

/**
 * Middleware to verify JWT token for authenticated routes.
 * Extracts token from the Authorization header (Bearer <token>)
 * and attaches decoded user info (id) to req.user.
 */
module.exports = (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Authorization token missing or invalid" });
    }

    const token = authHeader.split(" ")[1];

    // Verify JWT
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Attach customer ID to req.user
    req.user = { id: decoded.id };

    next(); // Proceed to controller
  } catch (err) {
    console.error("Auth middleware error:", err.message);
    if (err.name === "TokenExpiredError") {
      return res.status(401).json({ message: "Session expired. Please login again." });
    }
    return res.status(401).json({ message: "Invalid or missing token" });
  }
};
