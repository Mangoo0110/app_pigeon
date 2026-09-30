import multer from "multer";
import fs from "fs";

fs.mkdirSync("uploads", { recursive: true });

export const upload = multer({
  dest: "uploads/",
  limits: { fileSize: 10 * 1024 * 1024 },
});
