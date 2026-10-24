# Google Play Release & Deployment Guide (RELEASE.md)

Follow these instructions to generate a production-ready, signed Android App Bundle (`.aab`) for the Google Play Store.

---

## 1. Create an Upload Keystore
Generate a cryptographically secure 2048-bit RSA upload key:

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Keep your keystore file private and secure. Never commit `.jks` files to git.

---

## 2. Configure `key.properties`
Create a file named `android/key.properties` (this is ignored in `.gitignore`):

```properties
storePassword=YOUR_SECURE_STORE_PASSWORD
keyPassword=YOUR_SECURE_KEY_PASSWORD
keyAlias=upload
storeFile=upload-keystore.jks
```

---

## 3. Build Signed Android App Bundle (.aab)
Run the release build command with code shrinking, R8 tree shaking, and debug symbol obfuscation:

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

The resulting bundle will be located at:
`build/app/outputs/bundle/release/app-release.aab`

---

## 4. Google Play Console Checklist
Before promoting to Production:
1. Complete **App Content > Data Safety Form**:
   - Disclose Phone number (Account management).
   - Disclose Approximate & Precise Location (Food delivery & discovery).
   - Financial Info (Processed via Razorpay; card numbers not collected directly).
2. Complete **Account Deletion Requirements**:
   - Provide in-app deletion button (verified in Profile screen).
   - Provide public URL: `https://tiffiny.in/delete-account`.
3. Provide **Reviewer Test Credentials**:
   - Customer Test Phone: `+91 98765 00000` (OTP: `123456`)
   - Partner Test Phone: `+91 98765 99999` (OTP: `123456`)
