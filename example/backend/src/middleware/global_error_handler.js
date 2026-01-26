import httpStatus from "http-status";

export default function globalErrorHandler(err, _req, res, _next) {
  const status = err.statusCode || httpStatus.INTERNAL_SERVER_ERROR;
  const message = err.message || "Something went wrong";
  const payload = {
    success: false,
    message,
    ...(process.env.NODE_ENV !== "production" && { stack: err.stack }),
    ...(err.details && { details: err.details }),
  };
  res.status(status).json(payload);
}