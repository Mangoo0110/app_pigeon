import crypto from "crypto";
import User from "../user/user.model.js";
import ChatMessage from "./chat.model.js";
import Ghost from "./ghost.model.js";
import AppError from "../../shared/errors/app_error.js";

const GHOST_ID_REGEX = /^ghost_[a-z0-9_-]{4,64}$/;

const toChatPayload = (doc) => {
  const createdAt = doc.createdAt ? new Date(doc.createdAt) : new Date();
  const sender = doc.sender || {};
  return {
    id: doc._id?.toString?.() ?? String(doc._id),
    text: doc.text,
    message: doc.text,
    sender: {
      id: sender.id || "unknown",
      name: sender.name || "Unknown",
      profileImage: sender.profileImage || null,
    },
    userId: doc.userId?.toString?.() ?? null,
    ghostId: doc.ghostId ?? null,
    identityType: doc.identityType ?? "user",
    source: doc.source,
    sentAt: createdAt.toISOString(),
    createdAt: createdAt.toISOString(),
  };
};

const normalizeGhostId = (value) => String(value || "").trim().toLowerCase();

const buildGhostName = (ghostId, fallbackName) => {
  const name = String(fallbackName || "").trim();
  if (name) return name;
  const tail = ghostId.slice(-4);
  return `Ghost ${tail}`;
};

const generateGhostId = () => `ghost_${crypto.randomBytes(8).toString("hex")}`;

const findOrCreateGhostById = async (ghostId) => {
  const normalized = normalizeGhostId(ghostId);
  if (!normalized || !GHOST_ID_REGEX.test(normalized)) {
    throw new AppError(
      400,
      "Invalid ghostId format. Expected something like ghost_ab12cd34"
    );
  }

  const existing = await Ghost.findOneAndUpdate(
    { ghostId: normalized },
    { $set: { lastSeenAt: new Date() } },
    { new: true }
  );
  if (existing) {
    return { ghost: existing, exists: true };
  }

  const created = await Ghost.create({ ghostId: normalized, lastSeenAt: new Date() });
  return { ghost: created, exists: false };
};

export const resolveGhostSession = async ({ ghostId }) => {
  const normalized = normalizeGhostId(ghostId);
  if (normalized) {
    const { ghost, exists } = await findOrCreateGhostById(normalized);
    return { ghostId: ghost.ghostId, exists };
  }

  let generated = generateGhostId();
  while (await Ghost.exists({ ghostId: generated })) {
    generated = generateGhostId();
  }
  await Ghost.create({ ghostId: generated, lastSeenAt: new Date() });
  return { ghostId: generated, exists: false };
};

const resolveSender = async ({ userId, sender, identityType, ghostId }) => {
  const fallbackSender = sender && typeof sender === "object" ? sender : {};
  if (identityType === "ghost") {
    return {
      id: ghostId || fallbackSender.id || "unknown",
      name: buildGhostName(ghostId || "ghost_anon", fallbackSender.name),
      profileImage: fallbackSender.profileImage || null,
    };
  }

  const user = await User.findById(userId).select("fullName userName avatarUrl");
  if (!user) {
    return {
      id: String(userId),
      name: fallbackSender.name || "Unknown",
      profileImage: fallbackSender.profileImage || null,
    };
  }

  const name =
    String(user.fullName || "").trim() ||
    String(user.userName || "").trim() ||
    fallbackSender.name ||
    "Unknown";

  return {
    id: String(user._id),
    name,
    profileImage: user.avatarUrl || fallbackSender.profileImage || null,
  };
};

export const createMessage = async ({
  text,
  sender,
  userId = null,
  ghostId = null,
  identityType = "user",
  source = "api",
}) => {
  const normalizedText = String(text || "").trim();
  if (!normalizedText) {
    throw new AppError(400, "Message text is required");
  }

  let resolvedGhostId = null;
  if (identityType === "ghost") {
    const ghostSession = await resolveGhostSession({ ghostId });
    resolvedGhostId = ghostSession.ghostId;
  } else if (!userId) {
    throw new AppError(401, "Not authenticated");
  }

  const resolvedSender = await resolveSender({
    userId,
    sender,
    identityType,
    ghostId: resolvedGhostId,
  });
  const created = await ChatMessage.create({
    text: normalizedText,
    sender: resolvedSender,
    userId: userId || null,
    ghostId: resolvedGhostId,
    identityType,
    source,
  });
  return toChatPayload(created.toObject());
};

export const listMessages = async ({ limit = 50, before, identityType = null }) => {
  const safeLimit = Math.max(1, Math.min(Number(limit) || 50, 200));
  const query = {};
  if (identityType) {
    query.identityType = identityType;
  }

  if (before) {
    const beforeDate = new Date(before);
    if (!Number.isNaN(beforeDate.getTime())) {
      query.createdAt = { $lt: beforeDate };
    }
  }

  const docs = await ChatMessage.find(query)
    .sort({ createdAt: -1 })
    .limit(safeLimit)
    .lean();

  const messages = docs.reverse().map(toChatPayload);
  const nextCursor =
    docs.length === safeLimit && docs[docs.length - 1]?.createdAt
      ? new Date(docs[docs.length - 1].createdAt).toISOString()
      : null;

  return { messages, nextCursor };
};
