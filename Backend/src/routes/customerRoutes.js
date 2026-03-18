const express = require('express');
const router = express.Router();
const protect = require('../middlewares/authMiddleware');
const authorizeRoles = require('../middlewares/roleMiddleware');
const { getCustomerStats, updateCustomerProfile } = require('../controllers/customerController');
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });

router.get('/stats', protect, authorizeRoles('customer'), getCustomerStats);
router.put('/profile', protect, authorizeRoles('customer'), upload.single('profileImage'), updateCustomerProfile);

module.exports = router;
