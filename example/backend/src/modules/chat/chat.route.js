import { Router } from "express";
import { isAuthenticated } from "../../shared/middleware/auth.js";
import {
  createGhostSession,
  getGhostMessages,
  getMessages,
  sendGhostMessage,
  sendMessage,
} from "./chat.controller.js";

const router = Router();

router.get("/messages", isAuthenticated, getMessages);
router.post("/messages", isAuthenticated, sendMessage);
router.post("/ghost/session", createGhostSession);
router.get("/ghost/messages", getGhostMessages);
router.post("/ghost/messages", sendGhostMessage);

export default router;
