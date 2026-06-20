import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config();

const connnectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("MongoDB connected!");
  } catch (error) {
    console.log("Connection Failed: " + error.message);
    process.exit(1);
  }
};

export default connnectDB;
