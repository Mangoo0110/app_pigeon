import catchAsync from "./catch_async";
import nodemailer from 'nodemailer';
import "dotenv/config";

export const sendVerificationMail = async (to,subject, html) => {
  const transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 587,
    secure: false,
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });
  await transporter.sendMail({
    from: process.env.EMAIL_USER, // sender address
    to,
    subject: subject? subject:  'Verify your email',
    html,
  });
};
