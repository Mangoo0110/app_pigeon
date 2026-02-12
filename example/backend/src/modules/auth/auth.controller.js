import catchAsync from "../../shared/utils/catch_async.js";
import {
  forgotPasswordForUser,
  loginUser,
  logoutUser,
  refreshUserToken,
  registerUser,
  resetPasswordWithOtp,
  verifyEmailOtp,
} from "./auth.service.js";

export const register = catchAsync(async (req, res) => {
  await registerUser(req.body ?? {});

  res.status(201).json({ message: "User registered successfully" });
});

export const login = catchAsync(async (req, res) => {
  const data = await loginUser(req.body ?? {});
  res.json({
    data,
  });
});

export const refresh = catchAsync(async (req, res) => {
  const data = await refreshUserToken(req.body ?? {});
  res.json({
    data,
  });
});

export const logout = catchAsync(async (req, res) => {
  await logoutUser(req.body ?? {});

  res.json({ message: "Logged out successfully" });
});

export const forgotPassword = catchAsync(async (req, res) => {
  await forgotPasswordForUser(req.body ?? {});

  res.json({ message: "Password reset code sent to your email" });
});

export const verifyEmail = catchAsync(async (req, res) => {
  await verifyEmailOtp(req.body ?? {});

  res.json({ message: "Email verified successfully" });
});

export const resetPassword = catchAsync(async (req, res) => {
  await resetPasswordWithOtp(req.body ?? {});

  res.json({ message: "Password reset successfully" });
});
