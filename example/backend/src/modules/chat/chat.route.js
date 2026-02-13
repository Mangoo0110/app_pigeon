import { Router } from "express";
import { isAuthenticated } from "../../shared/middleware/auth.js";
import { getMessages, sendMessage } from "./chat.controller.js";

const router = Router();

router.get("/messages", isAuthenticated, getMessages);
router.post("/messages", isAuthenticated, sendMessage);

export default router;
