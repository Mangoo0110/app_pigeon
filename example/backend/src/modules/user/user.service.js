import { unlink } from "fs/promises";
import User from "./user.model.js";
import Auth from "../auth/auth.model.js";
import AppError from "../../shared/errors/app_error.js";
import cloudinary from "../../shared/utils/cloudinary.js";

export const getProfileByUserId = async ({ userId }) => {
  if (!userId) {
    throw new AppError(401, "Not authenticated");
  }

  const user = await User.findById(userId).select("-password");
  if (!user) {
    throw new AppError(404, "User not found");
  }

  const auth = await Auth.findOne({ userId: user._id });
  const isVerified = auth?.emailVerified ?? user.emailVerified ?? false;

  return {
    ...user.toObject(),
    isVerified,
  };
};

export const updateProfileByUserId = async ({ userId, fullName, filePath }) => {
  if (!userId) {
    throw new AppError(401, "Not authenticated");
  }

  const update = {};
  if (fullName !== undefined) {
    update.fullName = String(fullName).trim();
  }

  if (filePath) {
    const uploaded = await cloudinary.uploader.upload(filePath, {
      folder: "app_pigeon/avatars",
      resource_type: "image",
    });
    update.avatarUrl = uploaded.secure_url;
    await unlink(filePath);
  }

  if (Object.keys(update).length === 0) {
    throw new AppError(400, "Nothing to update");
  }

  const user = await User.findByIdAndUpdate(userId, update, {
    new: true,
    runValidators: true,
  }).select("-password");

  if (!user) {
    throw new AppError(404, "User not found");
  }

  return user;
};
