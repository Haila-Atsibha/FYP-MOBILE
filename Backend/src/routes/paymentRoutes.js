const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const protect = require('../middlewares/authMiddleware');
const authorizeRoles = require('../middlewares/roleMiddleware');

// Initialize payment - Protected (only for providers)
router.post('/subscribe', protect, paymentController.initializePayment);

// Get payment history - Protected
router.get('/history', protect, authorizeRoles('provider'), paymentController.getPaymentHistory);

// Verify payment - Public (called by Chapa or redirected frontend)
router.get('/verify-payment/:tx_ref', paymentController.verifyPayment);

// Success page for mobile in-app browser
router.get('/payment-success', (req, res) => {
    res.send(`
        <html>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <body style="display:flex; justify-content:center; align-items:center; height:100vh; margin:0; font-family:sans-serif; text-align:center; background-color:#f0fdf4;">
                <div style="padding: 20px;">
                    <h1 style="color:#16a34a; font-size:24px; margin-bottom:10px;">Payment Successful!</h1>
                    <p style="color:#374151; font-size:16px;">Your transaction has been processed properly.</p>
                    <p style="color:#4b5563; font-size:14px; margin-top:30px; padding:10px; background:#e5e7eb; border-radius:8px;">
                        <b>Please close this window/browser to return to your dashboard.</b>
                    </p>
                </div>
            </body>
        </html>
    `);
});

module.exports = router;
