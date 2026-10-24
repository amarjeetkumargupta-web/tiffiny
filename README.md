# Tiffiny: Mobile Food-Ordering & Meal-Subscription Platform

**Tiffiny** is a production-ready mobile food-ordering and meal-subscription app connecting customers with local tiffin and mess service providers ("Partners"). Built with Flutter, Firebase, TypeScript Cloud Functions, and an iOS-inspired fluid motion design system.

---

## Architecture Overview

```
Tiffiny/
├── lib/
│   ├── app.dart                   # MaterialApp.router with Cupertino/Material3 theming
│   ├── main.dart                  # Orientation locks, system chrome, ProviderScope
│   ├── core/
│   │   ├── config/env.dart        # Environment configuration (dev/prod, Razorpay keys)
│   │   ├── router/app_router.dart # GoRouter with reactive role separation guards
│   │   ├── theme/                 # iOS-styled Material 3 theme, spring physics, OLED dark mode
│   │   ├── utils/                 # Indian Rupee integer paise formatter, Asia/Kolkata date utils
│   │   └── widgets/               # PressableScale (0.97 spring compression), haptics
│   └── features/
│       ├── auth/                  # Phone OTP login, strictly separated entry doors, KYC onboarding
│       ├── customer/              # Home discovery, Search, Partner details, Sticky cart, Orders
│       └── partner/               # Partner dashboard, Kitchen view with skip deduction, Subscribers
├── functions/                     # TypeScript Cloud Functions (Carry-forward logic, Jest test suite)
├── firestore.rules                # Production security rules validating role custom claims
├── web_delivery/                  # Zero-login mobile web run-sheet for partner delivery staff
├── web_admin/                     # Operations admin dashboard for partner approvals & KYC
└── docs/                          # Architecture decisions, release guide, setup, and legal checklists
```

---

## Key Features

1. **Strictly Separated Two-Role System (Section 2)**:
   - Separate entry points: **Order Food** (Customer) vs **Partner Login** (Mess & Tiffin owners).
   - Server-enforced role custom claims (`role: 'customer'` vs `role: 'partner'`).
   - Phone numbers registered under one role are barred from logging in through the other.

2. **Smart Meal Subscription & Carry-Forward Engine (Section 3.5)**:
   - 30-day, quarterly, and yearly meal passes.
   - Interactive calendar with 9:00 PM IST previous day cut-off validation.
   - 1-click **Mark Absent**: missed meals are never lost—the subscription end date is automatically extended to append extra meal slots at the end.

3. **Partner Kitchen View (Section 4.1)**:
   - Tomorrow's and today's exact cook portion forecast.
   - Customer skips are subtracted automatically in real time.

4. **Zero-Login WhatsApp Delivery Dispatch (Section 4.4)**:
   - Partners add delivery boys by phone number.
   - Delivery staff receive a WhatsApp link opening a lightweight mobile run-sheet (`web_delivery/index.html`) to mark "Delivered" or "Undelivered".

5. **iOS Native Motion & Interaction Spec (Section 6)**:
   - Every tappable card/button compresses to `0.97` scale with spring-back physics (`PressableScale`) and light selection haptic feedback.
   - Sticky spring slide-up cart pill with live paise summation.
   - Full OLED-optimized Dark Mode conforming to system preferences.

---

## Quickstart & Local Execution

### 1. Run Cloud Functions Unit Tests (Subscription Engine)
```bash
cd functions
npm install
npm test
```

### 2. Run Flutter App
```bash
flutter pub get
flutter run
```

### 3. Review Admin Operations & Delivery Run-Sheets
- **Admin Dashboard**: Open `web_admin/index.html` in any browser.
- **Delivery Staff Portal**: Open `web_delivery/index.html` in any mobile browser emulator.

---

## Documentation Links
- [Architectural Decisions Log (DECISIONS.md)](file:///docs/DECISIONS.md)
- [Firebase & Environment Setup (SETUP.md)](file:///docs/SETUP.md)
- [Testing & Verification Guide (TESTING.md)](file:///docs/TESTING.md)
- [Google Play Release & Signing (RELEASE.md)](file:///docs/RELEASE.md)
- [Legal, Privacy Policy & FSSAI Guidelines (LEGAL.md)](file:///docs/LEGAL.md)
- [Play Store Listing Copy (PLAY_STORE_LISTING.md)](file:///docs/PLAY_STORE_LISTING.md)
