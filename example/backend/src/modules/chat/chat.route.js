import { Router } from "express";
import { isAuthenticated } from "../../shared/middleware/auth.js";
import {
  checkGhostUserName,
  createGhostSession,
  getGhostMessages,
  getMessages,
  loginGhost,
  registerGhost,
  sendGhostMessage,
  sendMessage,
} from "./chat.controller.js";

const router = Router();

router.get("/messages", isAuthenticated, getMessages);
router.post("/messages", isAuthenticated, sendMessage);
router.post("/ghost/check-username", checkGhostUserName);
router.post("/ghost/register", registerGhost);
router.post("/ghost/login", loginGhost);
router.post("/ghost/session", createGhostSession);
router.get("/ghost/messages", getGhostMessages);
router.post("/ghost/messages", sendGhostMessage);

export default router;
