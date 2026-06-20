import mongoose from "mongoose";

const userSchema = mongoose.Schema(
  {
    userId: {
      type: String,
      required: true,
      unique: true,
    },

    favorites: [
      {
        pexelsId: String,
        url: String,
        photographer: String,
        title: String,
        savedAt: {
          type: Date,
          default: Date.now,
        },
      },
    ],
  },
  { timestamps: true },
);

const User = mongoose.model("User", userSchema);

export default User;
