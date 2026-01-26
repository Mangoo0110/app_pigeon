import jwt from "jsonwebtoken";
import httpStatus from "http-status";
import AppError from "../error/app_error.js";

export const isAuthenticated = (req, _res, next) => {
  const hdr = req.headers.authorization || "";
  const token = hdr.startsWith("Bearer ") ? hdr.slice(7) : null;
  if (!token) {
    throw new AppError(httpStatus.UNAUTHORIZED, "Not authenticated");
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_ACCESS_SECRET);
    req.user = decoded; // {id,email,role}
    next();
  } catch {
    throw new AppError(httpStatus.UNAUTHORIZED, "Invalid or expired token");
  }
};

export const authorize =
  (...roles) =>
  (req, _res, next) => {
    if (!roles.includes(req.user?.role)) {
      throw new AppError(httpStatus.FORBIDDEN, "Forbidden");
    }
    next();
  };
