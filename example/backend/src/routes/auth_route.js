import { Router } from "express";
import { login, refresh, register, logout } from "../controllers/auth_controller.js";

const router = Router();

router.post("/register", register);
router.post("/login", login);
router.post("/refresh", refresh);
router.post("/logout", logout);

export default router;
