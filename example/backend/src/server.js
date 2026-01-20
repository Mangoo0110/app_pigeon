const crypto = require("crypto");
const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

const PORT = Number(process.env.PORT || 3000);
const ACCESS_TTL_MS = Number(process.env.ACCESS_TTL_MS || 60_000);
const REFRESH_TTL_MS = Number(process.env.REFRESH_TTL_MS || 3_600_000);

const accessTokens = new Map();
const refreshTokens = new Map();

function randomToken() {
  return crypto.randomBytes(24).toString("hex");
}

function issueTokens(userId) {
  const accessToken = randomToken();
  const refreshToken = randomToken();
  accessTokens.set(accessToken, {
    userId,
    expiresAt: Date.now() + ACCESS_TTL_MS,
  });
  refreshTokens.set(refreshToken, {
    userId,
    expiresAt: Date.now() + REFRESH_TTL_MS,
  });
  return { accessToken, refreshToken };
}

function isExpired(record) {
  return !record || record.expiresAt <= Date.now();
}

app.get("/health", (req, res) => {
  res.json({ ok: true });
});

app.post("/auth/login", (req, res) => {
  const { username } = req.body ?? {};
  const userId = (username && String(username).trim()) || "user_1";
  const tokens = issueTokens(userId);
  res.json({
    data: {
      userId,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    },
  });
});

app.post("/auth/refresh", (req, res) => {
  const { refreshToken } = req.body ?? {};
  if (!refreshToken || !refreshTokens.has(refreshToken)) {
    return res.status(401).json({ error: "Invalid refresh token" });
  }

  const record = refreshTokens.get(refreshToken);
  if (isExpired(record)) {
    refreshTokens.delete(refreshToken);
    return res.status(401).json({ error: "Refresh token expired" });
  }

  refreshTokens.delete(refreshToken);
  const tokens = issueTokens(record.userId);
  res.json({
    data: {
      userId: record.userId,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    },
  });
});

app.get("/profile", (req, res) => {
  const header = req.headers.authorization || "";
  const token = header.startsWith("Bearer ") ? header.slice(7) : null;
  if (!token || !accessTokens.has(token)) {
    return res.status(401).json({ error: "Missing token" });
  }

  const record = accessTokens.get(token);
  if (isExpired(record)) {
    accessTokens.delete(token);
    return res.status(401).json({ error: "Access token expired" });
  }

  res.json({
    data: {
      userId: record.userId,
      name: "App Pigeon Demo User",
    },
  });
});

app.listen(PORT, () => {
  console.log(`Example backend listening on http://localhost:${PORT}`);
});
