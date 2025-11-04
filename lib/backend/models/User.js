import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    uid: { type: String, unique:true, index:true, required: true },
    email:    { type: String, index:true },
    password: { type: String, required: true, minlength: 6 },
  },
  { timestamps: true }
);

export default mongoose.model("User", userSchema);
