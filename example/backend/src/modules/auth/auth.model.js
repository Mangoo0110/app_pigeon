import mongoose, { Schema } from "mongoose";

const otpFields = {
  code: { type: String, default: null },
  expiresAt: { type: Date, default: null },
  usedAt: { type: Date, default: null },
};

const authSchema = new Schema(
  {
    userId: { type: Schema.Types.ObjectId, ref: "User", required: true, index: true },
    refreshToken: { type: String, default: null },
    refreshTokenExpiresAt: { type: Date, default: null },
    emailVerified: { type: Boolean, default: false },
    otp: {
      emailVerify: { type: otpFields, default: () => ({}) },
      login: { type: otpFields, default: () => ({}) },
      reset: { type: otpFields, default: () => ({}) },
    },
  },
  { timestamps: true }
);

const Auth = mongoose.model("Auth", authSchema);
export default Auth;
