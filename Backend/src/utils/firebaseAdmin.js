const admin = require('firebase-admin');

// We will load the service account credentials from an env variable or json file
// The user needs to download their Firebase Service Account JSON and set it up.
// For now, we will wrap it in a try-catch so the app doesn't crash if the file is missing.

let isFirebaseInitialized = false;

try {
    // Attempt to load from a local file first
    // The user should place their downloaded service account JSON at the root of the backend directory.
    const serviceAccount = require('../../firebase-service-account.json');
    
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
    });
    isFirebaseInitialized = true;
    console.log("Firebase Admin initialized successfully.");
} catch (error) {
    console.warn("⚠️ Firebase Admin initialization failed. Push notifications will not be sent.");
    console.warn("Make sure you have downloaded the Firebase Service Account JSON and saved it as 'firebase-service-account.json' in the root of your Backend folder.");
}

const sendPushNotification = async (fcmToken, title, body, data = {}) => {
    if (!isFirebaseInitialized || !fcmToken) return false;

    try {
        const message = {
            notification: {
                title,
                body
            },
            data: {
                ...data,
                click_action: 'FLUTTER_NOTIFICATION_CLICK' // Standard for Flutter handling
            },
            token: fcmToken
        };

        const response = await admin.messaging().send(message);
        console.log("Successfully sent push notification:", response);
        return true;
    } catch (error) {
        console.error("Error sending push notification:", error);
        return false;
    }
};

module.exports = {
    sendPushNotification
};
