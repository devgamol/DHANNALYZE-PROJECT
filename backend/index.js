const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const connectDB = require('./config/db');

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());
app.use(cookieParser());

connectDB();

// Existing routes
app.use('/api/auth', require('./routes/authRoutes'));
app.use('/api/users', require('./routes/userRoutes'));

// New secured routes
app.use('/api/accounts', require('./routes/accountRoutes'));
app.use('/api/creditscore', require('./routes/creditScoreRoutes'));
app.use('/api/loans', require('./routes/loanRoutes'));

app.get('/', (req, res) => {
  res.send('Dhannalyze backend running...');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
