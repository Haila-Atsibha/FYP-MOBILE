require('dotenv').config();
const pool = require('./src/db');

async function migrate() {
    try {
        console.log("Adding email verification columns...");
        await pool.query(`
            ALTER TABLE users 
            ADD COLUMN IF NOT EXISTS is_email_verified BOOLEAN DEFAULT false,
            ADD COLUMN IF NOT EXISTS verification_otp VARCHAR(6);
        `);
        console.log("Columns added successfully!");
    } catch (err) {
        console.error("Migration failed:", err);
    } finally {
        pool.end();
    }
}

migrate();
