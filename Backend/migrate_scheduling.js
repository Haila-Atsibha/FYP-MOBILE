require('dotenv').config();
const pool = require('./src/db');

async function migrate() {
    try {
        console.log("Adding scheduled_date and scheduled_time to bookings...");
        await pool.query(`
            ALTER TABLE bookings 
            ADD COLUMN IF NOT EXISTS scheduled_date DATE,
            ADD COLUMN IF NOT EXISTS scheduled_time TIME;
        `);
        console.log("Columns added successfully!");
    } catch (err) {
        console.error("Migration failed:", err);
    } finally {
        pool.end();
    }
}

migrate();
