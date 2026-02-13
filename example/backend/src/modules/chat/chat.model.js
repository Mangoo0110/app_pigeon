import mongoose, { Schema } from "mongoose";

const senderSchema = new Schema(
  {
    id: { type: String, default: "unknown" },
    name: { type: String, default: "Unknown" },
    profileImage: { type: String, default: null },
  },
  { _id: false }
);

const chatMessageSchema = new Schema(
  {
    text: { type: String, required: true, trim: true, maxlength: 2000 },
    sender: { type: senderSchema, required: true },
    userId: { type: Schema.Types.ObjectId, ref: "User", default: null, index: true },
    source: { type: String, enum: ["api", "socket"], default: "api" },
  },
  { timestamps: true }
);

chatMessageSchema.index({ createdAt: -1 });

const ChatMessage = mongoose.model("ChatMessage", chatMessageSchema);
export default ChatMessage;
