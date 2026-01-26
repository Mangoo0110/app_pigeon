import "dotenv/config";
import { createServer } from "http";
import mongoose from "mongoose";
import { Server as SocketIOServer } from "socket.io";
import app from "./app.js";

const PORT = Number(process.env.PORT || 3000);
const MONGO_URI = process.env.MONGO_URI || "";

if (MONGO_URI) {
  console.log("MONGO_URI:", MONGO_URI);
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

io.on("connection", (socket) => {
  console.log(`Socket connected: ${socket.id}`);

  socket.on("message", (payload) => {
    io.emit("message", payload);
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
