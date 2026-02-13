import "dotenv/config";
import { createServer } from "http";
import mongoose from "mongoose";
import { Server as SocketIOServer } from "socket.io";
import jwt from "jsonwebtoken";
import app from "./app.js";
import { createMessage } from "./modules/chat/chat.service.js";

const PORT = Number(process.env.PORT || 3000);
const MONGO_URI = process.env.MONGO_URI || "";

if (MONGO_URI) {
  console.log("MONGO_URI is set");
  mongoose
    .connect(MONGO_URI)
    .then(() => {
      console.log("MongoDB connected");
    })
    .catch((err) => {
      console.error("MongoDB connection failed:", err.message);
    });
} else {
  console.warn("MONGO_URI not set; running without database connection.");
}

const httpServer = createServer(app);

const io = new SocketIOServer(httpServer, {
  cors: { origin: "*", methods: ["GET", "POST"] },
});

app.set("io", io);

io.use((socket, next) => {
  const authorization =
    socket.handshake.headers?.authorization ||
    socket.handshake.auth?.authorization ||
    socket.handshake.auth?.token;
  const token =
    typeof authorization === "string" && authorization.startsWith("Bearer ")
      ? authorization.slice(7)
      : typeof authorization === "string"
      ? authorization
      : null;

  if (!token) {
    socket.user = null;
    return next();
  }

  try {
    socket.user = jwt.verify(token, process.env.JWT_ACCESS_SECRET);
    return next();
  } catch {
    return next();
  }
});

io.on("connection", (socket) => {
  console.log(`Socket connected: ${socket.id}`);

  socket.on("message", async (payload = {}) => {
    try {
      if (!socket.user?.id) {
        socket.emit("error_message", {
          message: "Not authenticated for message event",
        });
        return;
      }
      const saved = await createMessage({
        text: payload?.text ?? payload?.message,
        sender: payload?.sender,
        userId: socket.user.id,
        identityType: "user",
        source: "socket",
      });
      io.emit("message", saved);
    } catch (err) {
      socket.emit("error_message", {
        message: err?.message || "Failed to send message",
      });
    }
  });

  socket.on("ghost_message", async (payload = {}) => {
    try {
      const saved = await createMessage({
        text: payload?.text ?? payload?.message,
        sender: payload?.sender,
        ghostId: payload?.ghostId,
        identityType: "ghost",
        source: "socket",
      });
      io.emit("ghost_message", saved);
    } catch (err) {
      socket.emit("error_message", {
        message: err?.message || "Failed to send ghost message",
      });
    }
  });

  socket.on("typing", (payload) => {
    socket.broadcast.emit("typing", payload);
  });

  socket.on("disconnect", () => {
    console.log(`Socket disconnected: ${socket.id}`);
  });
});

httpServer.listen(PORT, () => {
  console.log(`Example backend listening on http://localhost:${PORT}`);
});
