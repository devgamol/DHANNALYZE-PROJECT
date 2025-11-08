const mongoose = require('mongoose');
const dotenv = require('dotenv');
const User = require('./models/userModel');
const Loan = require('./models/loanModel');

dotenv.config();

async function seedData() {
  await mongoose.connect(process.env.MONGO_URI);

  // Clear old data
  await User.deleteMany();
  await Loan.deleteMany();

  // Create users
  const amol = await User.create({ name: 'Amol Sahu', email: 'amol@example.com', password: '123456' });
  const ravi = await User.create({ name: 'Ravi Sharma', email: 'ravi@example.com', password: 'ravi123' });

  // Create loans
  await Loan.create([
    { userId: amol._id, loanAmount: 60000, bankName: 'SBI Bank', city: 'Pune', status: 'pending' },
    { userId: ravi._id, loanAmount: 120000, bankName: 'Axis Bank', city: 'Mumbai', status: 'approved' }
  ]);

  console.log('Dummy data added.');
  mongoose.disconnect();
}

seedData();
    