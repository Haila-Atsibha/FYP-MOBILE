require('dotenv').config();
const pool = require('./src/db');

async function migrate() {
    try {
        console.log("Adding fcm_token column...");
        await pool.query(`
            ALTER TABLE users 
            ADD COLUMN IF NOT EXISTS fcm_token TEXT;
        `);
        console.log("Column added successfully!");
    } catch (err) {
        console.error("Migration failed:", err);
    } finally {
        pool.end();
    }
}

migrate();
