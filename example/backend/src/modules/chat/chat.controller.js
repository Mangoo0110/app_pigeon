import catchAsync from "../../shared/utils/catch_async.js";
import {
  checkGhostUserNameAvailability,
  createMessage,
  loginGhostIdentity,
  listMessages,
  registerGhostIdentity,
  resolveGhostSession,
} from "./chat.service.js";

export const getMessages = catchAsync(async (req, res) => {
  const { limit, before } = req.query ?? {};
  const data = await listMessages({ limit, before });
  res.json({
    data: data.messages,
    meta: { nextCursor: data.nextCursor },
  });
});

export const sendMessage = catchAsync(async (req, res) => {
  const data = await createMessage({
    text: req.body?.text ?? req.body?.message,
    sender: req.body?.sender,
    userId: req.user?.id || null,
    identityType: "user",
    source: "api",
  });

  const io = req.app.get("io");
  io?.emit("message", data);

  res.status(201).json({ data });
});

export const createGhostSession = catchAsync(async (req, res) => {
  const data = await resolveGhostSession({ ghostId: req.body?.ghostId });
  res.json({ data });
});

export const checkGhostUserName = catchAsync(async (req, res) => {
  const data = await checkGhostUserNameAvailability({
    userName: req.body?.userName,
  });
  res.json({ data });
});

export const registerGhost = catchAsync(async (req, res) => {
  const data = await registerGhostIdentity({
    userName: req.body?.userName ?? req.body?.username,
  });
  res.status(201).json({ data });
});

export const loginGhost = catchAsync(async (req, res) => {
  const data = await loginGhostIdentity({
    userName: req.body?.userName ?? req.body?.username,
    passkey: req.body?.passkey,
  });
  res.json({ data });
});

export const getGhostMessages = catchAsync(async (req, res) => {
  const { limit, before } = req.query ?? {};
  const data = await listMessages({ limit, before, identityType: "ghost" });
  res.json({
    data: data.messages,
    meta: { nextCursor: data.nextCursor },
  });
});

export const sendGhostMessage = catchAsync(async (req, res) => {
  const data = await createMessage({
    text: req.body?.text ?? req.body?.message,
    sender: req.body?.sender,
    ghostId: req.body?.ghostId,
    identityType: "ghost",
    source: "api",
  });

  const io = req.app.get("io");
  io?.emit("ghost_message", data);

  res.status(201).json({ data });
});
