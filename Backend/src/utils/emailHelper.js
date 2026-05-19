const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    service: 'gmail', // Standard Gmail account
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
    }
});

exports.sendVerificationEmail = async (to, otp) => {
    const mailOptions = {
        from: `"Ethio-ServiceProvider" <${process.env.EMAIL_USER}>`,
        to: to,
        subject: 'Verify your email address',
        html: `
            <h2>Welcome to Ethio-ServiceProvider!</h2>
            <p>Your verification code is: <strong>${otp}</strong></p>
            <p>Please enter this code in the app to verify your email address.</p>
            <p>This code will expire in 10 minutes.</p>
        `
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`Verification email sent to ${to}`);
    } catch (error) {
        console.error('Error sending email:', error);
        throw error;
    }
};
