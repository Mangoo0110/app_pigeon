import { Router } from "express";
import { profile, updateProfile } from "./user.controller.js";
import { isAuthenticated } from "../../shared/middleware/auth.js";
import { upload } from "../../shared/middleware/upload.js";

const router = Router();

router.get("/profile", isAuthenticated, profile);
router.patch("/profile", isAuthenticated, upload.single("avatar"), updateProfile);

export default router;
