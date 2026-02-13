import mongoose, { Schema } from "mongoose";

const ghostSchema = new Schema(
  {
    ghostId: { type: String, required: true, unique: true, index: true },
    displayName: { type: String, default: null },
    lastSeenAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

const Ghost = mongoose.model("Ghost", ghostSchema);
export default Ghost;
