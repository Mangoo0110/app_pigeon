import { Router } from "express";
import {
  forgotPassword,
  login,
  refresh,
  register,
  resetPassword,
  logout,
  verifyEmail,
} from "./auth.controller.js";

const router = Router();

router.post("/register", register);
router.post("/login", login);
router.post("/refresh", refresh);
router.post("/logout", logout);
router.post("/forgot-password", forgotPassword);
router.post("/verify-email", verifyEmail);
router.post("/reset-password", resetPassword);

export default router;
