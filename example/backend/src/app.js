import express from "express";
import cors from "cors";
import authRoutes from "./routes/auth_route.js";
import userRoutes from "./routes/user_route.js";
import globalErrorHandler from "./middleware/global_error_handler.js";

const app = express();
const api = express.Router();

app.use(cors());
app.use(express.json());


app.get("/health", (_req, res) => {
  res.json({ ok: true });
});


api.use("/auth", authRoutes);
api.use("/user", userRoutes);

app.use("/api/v1", api); 

app.use(globalErrorHandler);


export default app;
