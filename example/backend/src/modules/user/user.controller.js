import catchAsync from "../../shared/utils/catch_async.js";
import {
  getProfileByUserId,
  updateProfileByUserId,
} from "./user.service.js";

export const profile = catchAsync(async (req, res) => {
  const data = await getProfileByUserId({ userId: req.user?.id });
  res.json({
    data,
  });
});

export const updateProfile = catchAsync(async (req, res) => {
  const user = await updateProfileByUserId({
    userId: req.user?.id,
    fullName: req.body?.fullName,
    filePath: req.file?.path,
  });
  res.json({ data: user });
});
