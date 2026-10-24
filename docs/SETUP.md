# Firebase & Environment Setup Guide (SETUP.md)

This document provides step-by-step instructions to configure Firebase, Cloud Functions, and API keys for **Tiffiny**.

---

## 1. Firebase Project Creation
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new Firebase project named `tiffiny-app` (or your company name).
3. Enable **Google Analytics** for the project.

---

## 2. Firebase Authentication Setup
1. In the Firebase console sidebar, navigate to **Build > Authentication**.
2. Click **Get Started**, choose **Phone** under Sign-in providers, and enable it.
3. For local development and Play Store review, configure test phone numbers:
   - `+91 98765 00000` with OTP `123456` (Simulates registered Customer)
   - `+91 98765 99999` with OTP `123456` (Simulates registered Partner)
   - `+91 98765 11111` with OTP `123456` (Simulates new onboarding user)

---

## 3. Cloud Firestore Database
1. Navigate to **Build > Firestore Database** and click **Create Database**.
2. Select database location `asia-south1` (Mumbai) for minimum latency in India.
3. Start in Production mode.
4. Deploy the security rules provided in `firestore.rules`:
   ```bash
   firebase deploy --only firestore:rules
   ```

---

## 4. Cloud Storage
1. Navigate to **Build > Storage** and click **Get Started**.
2. Create buckets for:
   - `/partners/{uid}/fssai/` (Partner FSSAI certificates - restricted to admin/partner)
   - `/partners/{uid}/menu/` (Publicly cached dish photos)
   - `/users/{uid}/avatar/` (Customer profile pictures)

---

## 5. Cloud Functions Deployment
1. Install dependencies in the `functions/` directory:
   ```bash
   cd functions
   npm install
   ```
2. Build and run unit tests:
   ```bash
   npm test
   ```
3. Set Razorpay webhook secret:
   ```bash
   firebase functions:secrets:set RAZORPAY_WEBHOOK_SECRET
   ```
4. Deploy functions to `asia-south1`:
   ```bash
   firebase deploy --only functions
   ```

---

## 6. Google Maps SDK Setup
1. In the [Google Cloud Console](https://console.cloud.google.com/), enable:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Geocoding API
2. Create two restricted API keys (one for Android SHA-1 fingerprint, one for iOS bundle ID).
3. Insert keys into `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`.

---

## 7. Razorpay Payment Gateway
1. Create a merchant account at [Razorpay Dashboard](https://dashboard.razorpay.com/).
2. Generate **Key ID** and **Key Secret**.
3. Place Key ID in `lib/core/config/env.dart` or `.env`.
4. Configure Webhook URL in Razorpay Dashboard:
   `https://asia-south1-tiffiny-app.cloudfunctions.net/razorpayWebhook`
   Enable events:
   - `payment.captured`
   - `payment.failed`
   - `subscription.charged`
