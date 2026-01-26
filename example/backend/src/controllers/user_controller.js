import User from "../model/user.model.js";
import AppError from "../error/app_error.js";
import catchAsync from "../utils/catch_async.js";
import cloudinary from "../utils/cloudinary.js";
import { unlink } from "fs/promises";

export const profile = catchAsync(async (req, res) => {
  const userId = req.user?.id;
  if (!userId) {
    throw new AppError(401, "Not authenticated");
  }

  const user = await User.findById(userId).select("-password");
  if (!user) {
    throw new AppError(404, "User not found");
  }

  res.json({ data: user });
});

export const updateProfile = catchAsync(async (req, res) => {
  const userId = req.user?.id;
  if (!userId) {
    throw new AppError(401, "Not authenticated");
  }

  const { fullName } = req.body ?? {};
  const update = {};

  if (fullName !== undefined) {
    update.fullName = String(fullName).trim();
  }

  if (req.file?.path) {
    const uploaded = await cloudinary.uploader.upload(req.file.path, {
      folder: "app_pigeon/avatars",
      resource_type: "image",
    });
    update.avatarUrl = uploaded.secure_url;
    await unlink(req.file.path);
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

  res.json({ data: user });
});
