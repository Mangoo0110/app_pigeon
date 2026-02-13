import User from "../user/user.model.js";
import ChatMessage from "./chat.model.js";
import AppError from "../../shared/errors/app_error.js";

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
    source: doc.source,
    sentAt: createdAt.toISOString(),
    createdAt: createdAt.toISOString(),
  };
};

const resolveSender = async ({ userId, sender }) => {
  const fallbackSender = sender && typeof sender === "object" ? sender : {};
  if (!userId) {
    return {
      id: fallbackSender.id || "unknown",
      name: fallbackSender.name || "Unknown",
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

export const createMessage = async ({ text, sender, userId = null, source = "api" }) => {
  const normalizedText = String(text || "").trim();
  if (!normalizedText) {
    throw new AppError(400, "Message text is required");
  }

  const resolvedSender = await resolveSender({ userId, sender });
  const created = await ChatMessage.create({
    text: normalizedText,
    sender: resolvedSender,
    userId: userId || null,
    source,
  });
  return toChatPayload(created.toObject());
};

export const listMessages = async ({ limit = 50, before }) => {
  const safeLimit = Math.max(1, Math.min(Number(limit) || 50, 200));
  const query = {};

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
