import mongoose from 'mongoose';

async function dbConnect() {
  try {
    await mongoose.connect(process.env.MONGODB_URL!);
    return console.log('Database connected');
  } catch (error) {
    console.log('Database connection error: ' + error);
    process.exit(1);
  }
}

export default dbConnect;
