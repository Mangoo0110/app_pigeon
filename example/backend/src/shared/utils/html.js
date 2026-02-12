export const verificationOtpHtml = ({
  name = "there",
  otp = "",
  appName = "App Pigeon",
  expiry = "10 minutes",
} = {}) => {
  const safeName = String(name).trim() || "there";
  const safeOtp = String(otp).trim();
  const safeAppName = String(appName).trim() || "App Pigeon";
  const safeExpiry = String(expiry).trim() || "10 minutes";

  return `<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${safeAppName} - Verify your email</title>
  </head>
  <body style="margin:0;padding:0;background:#f6f7fb;font-family:Arial,Helvetica,sans-serif;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f6f7fb;padding:24px 0;">
      <tr>
        <td align="center">
          <table role="presentation" width="600" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 8px 24px rgba(0,0,0,0.08);">
            <tr>
              <td style="padding:32px 40px 12px 40px;">
                <h1 style="margin:0;color:#1f2a37;font-size:22px;line-height:1.3;">Verify your email</h1>
              </td>
            </tr>
            <tr>
              <td style="padding:8px 40px 0 40px;color:#374151;font-size:15px;line-height:1.6;">
                Hi ${safeName},
              </td>
            </tr>
            <tr>
              <td style="padding:8px 40px 0 40px;color:#374151;font-size:15px;line-height:1.6;">
                Use the one-time password (OTP) below to verify your ${safeAppName} account.
              </td>
            </tr>
            <tr>
              <td align="center" style="padding:24px 40px 8px 40px;">
                <div style="display:inline-block;background:#111827;color:#ffffff;font-size:28px;letter-spacing:6px;padding:14px 24px;border-radius:10px;font-weight:700;">
                  ${safeOtp || "••••••"}
                </div>
              </td>
            </tr>
            <tr>
              <td style="padding:8px 40px 0 40px;color:#6b7280;font-size:13px;line-height:1.6;">
                This OTP expires in ${safeExpiry}. If you did not request this, you can safely ignore this email.
              </td>
            </tr>
            <tr>
              <td style="padding:24px 40px 32px 40px;color:#9ca3af;font-size:12px;line-height:1.5;">
                Thanks,<br />
                The ${safeAppName} Team
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </body>
</html>`;
};
