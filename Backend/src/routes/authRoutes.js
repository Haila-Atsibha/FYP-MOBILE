const express = require('express');
const router = express.Router();
const multer = require('multer');
const storage = multer.memoryStorage();
const upload = multer({ storage });
const { registerUser, loginUser, verifyEmail, resendOtp, updateFcmToken } = require('../controllers/authController');
const protect = require('../middlewares/authMiddleware');

// registration expects multipart/form-data with three files and optional categories array
router.post(
    '/register',
    upload.fields([
        { name: 'profileImage', maxCount: 1 },
        { name: 'nationalId', maxCount: 1 },
        { name: 'verificationSelfie', maxCount: 1 },
        { name: 'educationalDocuments', maxCount: 10 },
        { name: 'educationalDocuments[]', maxCount: 10 }
    ]),
    registerUser
);
router.post('/login', loginUser);
router.post('/verify-email', verifyEmail);
router.post('/resend-otp', resendOtp);

// Requires auth
router.post('/fcm-token', protect, updateFcmToken);

module.exports = router;
