const express = require('express');
const router = express.Router();
const multer = require('multer');
const protect = require('../middlewares/authMiddleware');
const {
    sendMessage,
    getMessagesByBooking,
    getConversations,
    markMessagesAsRead
} = require('../controllers/messageController');

const storage = multer.memoryStorage();
const upload = multer({ storage });

// All message routes require authentication
router.use(protect);

// Get all conversations for the logged-in user (customer or provider)
router.get('/conversations', getConversations);

// Get messages for a specific booking
router.get('/booking/:booking_id', getMessagesByBooking);

// Mark messages as read for a booking
router.put('/booking/:booking_id/read', markMessagesAsRead);

// Send a message
router.post('/', upload.single('mediaFile'), sendMessage);

module.exports = router;
