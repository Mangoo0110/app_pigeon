import crypto from "crypto";
import bcrypt from "bcrypt";
import User from "../user/user.model.js";
import ChatMessage from "./chat.model.js";
import Ghost from "./ghost.model.js";
import AppError from "../../shared/errors/app_error.js";

const GHOST_USERNAME_REGEX = /^[a-z0-9_]{3,24}$/;

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
const normalizeGhostUserName = (value) =>
  String(value || "").trim().toLowerCase();

const buildGhostName = (ghostId, fallbackName) => {
  const name = String(fallbackName || "").trim();
  if (name) return name;
  const tail = ghostId.slice(-4);
  return `Ghost ${tail}`;
};

const generatePasskey = () =>
  crypto
    .randomBytes(4)
    .toString("base64")
    .replace(/[^a-zA-Z0-9]/g, "")
    .slice(0, 6)
    .toUpperCase();

const ghostIdFromUserName = (userName) => `ghost_${userName}`;

const ghostPublicPayload = (ghost) => ({
  ghostId: ghost.ghostId,
  userName: ghost.userName,
  displayName: ghost.displayName || ghost.userName,
});

export const checkGhostUserNameAvailability = async ({ userName }) => {
  const normalizedUserName = normalizeGhostUserName(userName);
  if (!normalizedUserName || !GHOST_USERNAME_REGEX.test(normalizedUserName)) {
    throw new AppError(
      400,
      "Invalid username format. Use 3-24 chars with lowercase letters, numbers, and underscore."
    );
  }

  const ghostId = ghostIdFromUserName(normalizedUserName);
  const exists = await Ghost.exists({ ghostId });
  return {
    userName: normalizedUserName,
    ghostId,
    available: !exists,
  };
};

export const registerGhostIdentity = async ({ userName }) => {
  const normalizedUserName = normalizeGhostUserName(userName);
  if (!normalizedUserName || !GHOST_USERNAME_REGEX.test(normalizedUserName)) {
    throw new AppError(
      400,
      "Invalid username format. Use 3-24 chars with lowercase letters, numbers, and underscore."
    );
  }

  const existing = await Ghost.findOne({ userName: normalizedUserName });
  if (existing) {
    throw new AppError(409, "Ghost username already exists");
  }

  const ghostId = ghostIdFromUserName(normalizedUserName);
  const passkey = generatePasskey();
  const saltRounds = Number(process.env.BCRYPT_SALT_ROUNDS) || 10;
  const passkeyHash = await bcrypt.hash(passkey, saltRounds);

  const created = await Ghost.create({
    ghostId,
    userName: normalizedUserName,
    passkeyHash,
    displayName: normalizedUserName,
    lastSeenAt: new Date(),
  });

  return {
    ...ghostPublicPayload(created),
    passkey,
    isNew: true,
  };
};

export const loginGhostIdentity = async ({ userName, passkey }) => {
  const normalizedUserName = normalizeGhostUserName(userName);
  const normalizedPasskey = String(passkey || "").trim().toUpperCase();
  if (!normalizedUserName || !normalizedPasskey) {
    throw new AppError(400, "username and passkey are required");
  }

  const ghost = await Ghost.findOne({ userName: normalizedUserName }).select(
    "+passkeyHash"
  );
  if (!ghost) {
    throw new AppError(404, "Ghost identity not found");
  }

  const isValidPasskey = await bcrypt.compare(normalizedPasskey, ghost.passkeyHash);
  if (!isValidPasskey) {
    throw new AppError(401, "Invalid ghost passkey");
  }

  ghost.lastSeenAt = new Date();
  await ghost.save();

  return {
    ...ghostPublicPayload(ghost),
    isNew: false,
  };
};

export const resolveGhostSession = async ({ ghostId }) => {
  const normalized = normalizeGhostId(ghostId);
  if (normalized) {
    const ghost = await Ghost.findOneAndUpdate(
      { ghostId: normalized },
      { $set: { lastSeenAt: new Date() } },
      { new: true }
    );
    return { ghostId: normalized, exists: Boolean(ghost) };
  }

  return { ghostId: null, exists: false };
};

const resolveSender = async ({ userId, sender, identityType, ghostId }) => {
  const fallbackSender = sender && typeof sender === "object" ? sender : {};
  if (identityType === "ghost") {
    const ghost = ghostId ? await Ghost.findOne({ ghostId }) : null;
    const ghostName =
      String(ghost?.displayName || "").trim() ||
      String(ghost?.userName || "").trim() ||
      buildGhostName(ghostId || "ghost_anon", fallbackSender.name);
    return {
      id: ghostId || fallbackSender.id || "unknown",
      name: ghostName,
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
    if (!ghostSession.exists || !ghostSession.ghostId) {
      throw new AppError(401, "Ghost identity not logged in or does not exist");
    }
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
