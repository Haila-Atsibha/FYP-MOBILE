const pool = require('../db');

exports.getCustomerStats = async (req, res) => {
    try {
        const userId = req.user.id;

        // Active bookings (pending, accepted)
        const activeRes = await pool.query(
            "SELECT COUNT(*) FROM bookings WHERE customer_id = $1 AND status IN ('pending', 'accepted')",
            [userId]
        );

        // Completed bookings
        const completedRes = await pool.query(
            "SELECT COUNT(*) FROM bookings WHERE customer_id = $1 AND status = 'completed'",
            [userId]
        );

        // Cancelled bookings
        const cancelledRes = await pool.query(
            "SELECT COUNT(*) FROM bookings WHERE customer_id = $1 AND status = 'cancelled'",
            [userId]
        );

        // Unread notifications
        const unreadNotificationsRes = await pool.query(
            "SELECT COUNT(*) FROM notifications WHERE user_id = $1 AND is_read = false",
            [userId]
        );

        res.json({
            active: parseInt(activeRes.rows[0].count),
            completed: parseInt(completedRes.rows[0].count),
            cancelled: parseInt(cancelledRes.rows[0].count),
            unread: parseInt(unreadNotificationsRes.rows[0].count),
            saved: 0
        });
    } catch (error) {
        res.status(500).json({ message: "Server error", error });
    }
};

exports.updateCustomerProfile = async (req, res) => {
    try {
        const userId = req.user.id;
        const { name, email } = req.body;

        if (!name || !email) {
            return res.status(400).json({ message: "Name and email are required" });
        }

        let profileImageUrl = null;
        if (req.file) {
            const upload = require('../utils/supabaseHelper').uploadFile;
            profileImageUrl = await upload(
                req.file.buffer,
                req.file.mimetype,
                'profile-images'
            );
        }

        let query, values;
        if (profileImageUrl) {
            query = "UPDATE users SET name = $1, email = $2, profile_image_url = $3 WHERE id = $4 AND role = 'customer' RETURNING id, name, email, role, status, profile_image_url";
            values = [name, email, profileImageUrl, userId];
        } else {
            query = "UPDATE users SET name = $1, email = $2 WHERE id = $3 AND role = 'customer' RETURNING id, name, email, role, status, profile_image_url";
            values = [name, email, userId];
        }

        const result = await pool.query(query, values);
        if (result.rows.length === 0) {
            return res.status(404).json({ message: "User not found or not a customer" });
        }

        res.json({
            message: "Profile updated successfully",
            user: result.rows[0]
        });
    } catch (error) {
        if (error.code === '23505') {
            return res.status(400).json({ message: "Email already in use" });
        }
        res.status(500).json({ message: "Server error", error: error.message });
    }
};
