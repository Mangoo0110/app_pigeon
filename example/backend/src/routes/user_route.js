import { Router } from "express";
import { profile, updateProfile } from "../controllers/user_controller.js";
import { isAuthenticated } from "../middleware/auth.js";
import { upload } from "../middleware/upload.js";

const router = Router();

router.get("/profile", isAuthenticated, profile);
router.patch("/profile", isAuthenticated, upload.single("avatar"), updateProfile);

export default router;
