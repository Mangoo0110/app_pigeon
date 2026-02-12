import crypto from "crypto";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../model/user.model.js";
import Auth from "../model/auth.model.js";
import AppError from "../error/app_error.js";
import catchAsync from "../utils/catch_async.js";
import {sendVerificationMail} from "../utils/send_mail.js";
import {verificationOtpHtml} from "../utils/html.js";

const ACCESS_TTL_MS = Number(process.env.ACCESS_TTL_MS || 15 * 60 * 1000);
const REFRESH_TTL_MS = Number(
  process.env.REFRESH_TTL_MS || 7 * 24 * 60 * 60 * 1000
);
const JWT_ACCESS_SECRET =
  process.env.JWT_ACCESS_SECRET || "dev_access_secret";

const signAccessToken = (user) =>
  jwt.sign(
    { id: user._id, email: user.email, role: user.role },
    JWT_ACCESS_SECRET,
    { expiresIn: Math.floor(ACCESS_TTL_MS / 1000) }
  );

const issueRefreshToken = () => crypto.randomBytes(32).toString("hex");

export const register = catchAsync(async (req, res) => {
  const { userName, email, password } = req.body;
  if (!email || !userName) {
    throw new AppError(400, "Email and username are required");
  }
  if (!password) {
    throw new AppError(400, "Password is required");
  }

  // Username must be lowercase letters and numbers only.
  if (!String(userName).trim().match(/^[a-z0-9]+$/)) {
    throw new AppError(
      400,
      "Username can only contain lowercase letters and numbers"
    );
  }

  const normalizedEmail = String(email).toLowerCase().trim();
  const normalizedUserName = String(userName).toLowerCase().trim();

  let user = await User.findOne({ email: normalizedEmail });
  if (user) {
    throw new AppError(400, "User with this email already exists");
  }

  user = await User.findOne({ userName: normalizedUserName });
  if (user) {
    throw new AppError(400, "User with this username already exists");
  }
  // generate otp to send
  const otp = String(Math.floor(100000 + Math.random() * 900000));
  const otpExpiry =
    String(process.env.OTP_EXPIRE || "").trim() || "10 minutes";
  // try sending email otp
  try {
    await sendVerificationMail(
      email,
      "Verify your email",
      verificationOtpHtml({ name: userName, otp, expiry: otpExpiry })
    );
  } catch (e) {
    const reason = e?.message ? ` Reason: ${e.message}` : "";
    throw new AppError(500, `Failed to send verification email!${reason}`);
  }

  const newUser = new User({
    userName: normalizedUserName,
    email: normalizedEmail,
    password,
  });
  await newUser.save();
  await Auth.create({ userId: newUser._id });

  res.status(201).json({ message: "User registered successfully" });
});

export const login = catchAsync(async (req, res) => {
  const { email, userName, password } = req.body;
  if (!password || (!email && !userName)) {
    throw new AppError(400, "Email or username and password are required");
  }

  const query = email
    ? { email: String(email).toLowerCase().trim() }
    : { userName: String(userName).toLowerCase().trim() };

  const user = await User.findOne(query);
  if (!user) {
    throw new AppError(401, "Invalid credentials");
  }

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    throw new AppError(401, "Invalid credentials");
  }

  const accessToken = signAccessToken(user);
  const refreshToken = issueRefreshToken();
  const refreshTokenExpiresAt = new Date(Date.now() + REFRESH_TTL_MS);

  await Auth.findOneAndUpdate(
    { userId: user._id },
    { refreshToken, refreshTokenExpiresAt },
    { upsert: true, new: true, setDefaultsOnInsert: true }
  );
  const auth = await Auth.findOne({ userId: user._id });
  const isVerified = auth?.emailVerified ?? user.emailVerified ?? false;

  res.json({
    data: {
      userId: user._id.toString(),
      user_id: user._id.toString(),
      accessToken,
      access_token: accessToken,
      refreshToken,
      refresh_token: refreshToken,
      isVerified,
      is_verified: isVerified,
    },
  });
});

export const refresh = catchAsync(async (req, res) => {
  const { refreshToken } = req.body;
  if (!refreshToken) {
    throw new AppError(400, "Refresh token is required");
  }

  const auth = await Auth.findOne({ refreshToken });
  if (!auth || !auth.refreshTokenExpiresAt) {
    throw new AppError(401, "Invalid refresh token");
  }

  if (auth.refreshTokenExpiresAt.getTime() <= Date.now()) {
    await Auth.updateOne(
      { _id: auth._id },
      { refreshToken: null, refreshTokenExpiresAt: null }
    );
    throw new AppError(401, "Refresh token expired");
  }

  const user = await User.findById(auth.userId);
  if (!user) {
    throw new AppError(404, "User not found");
  }

  const newRefreshToken = issueRefreshToken();
  const refreshTokenExpiresAt = new Date(Date.now() + REFRESH_TTL_MS);

  auth.refreshToken = newRefreshToken;
  auth.refreshTokenExpiresAt = refreshTokenExpiresAt;
  await auth.save();

  const accessToken = signAccessToken(user);
  const isVerified = auth.emailVerified ?? user.emailVerified ?? false;

  res.json({
    data: {
      userId: user._id.toString(),
      user_id: user._id.toString(),
      accessToken,
      access_token: accessToken,
      refreshToken: newRefreshToken,
      refresh_token: newRefreshToken,
      isVerified,
      is_verified: isVerified,
    },
  });
});

export const logout = catchAsync(async (req, res) => {
  const { refreshToken } = req.body;
  if (!refreshToken) {
    throw new AppError(400, "Refresh token is required");
  }

  await Auth.updateOne(
    { refreshToken },
    { refreshToken: null, refreshTokenExpiresAt: null }
  );

  res.json({ message: "Logged out successfully" });
});
