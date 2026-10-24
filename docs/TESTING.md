# Testing & Verification Guide (TESTING.md)

This document provides commands and instructions to execute unit, widget, security rules, and integration tests for **Tiffiny**.

---

## 1. Cloud Functions & Subscription Engine Unit Tests
The core subscription and meal skip engine is located in `functions/src/subscriptions/subscriptionEngine.ts`. It includes tests for:
- 9:00 PM IST previous day cut-off boundary conditions.
- Automatic carry-forward extension calculations.
- Weekend skipping for Mon-Fri plans.
- Leap-year (Feb 29) and month-end extensions.
- Subscription pause and resume calculations.

### Execution:
```bash
cd functions
npm install
npm test
```

Expected output:
```
PASS src/tests/subscriptionEngine.test.ts
  SubscriptionEngine Unit Tests
    1. Cut-off boundaries for meal skipping
      ✓ Allows skipping when requested well before 9:00 PM IST of previous day
      ✓ Allows skipping at 8:59 PM IST (1 minute before cut-off)
      ✓ Denies skipping at exactly 9:00 PM IST of previous day (cut-off passed)
      ✓ Denies skipping on same day of delivery morning (too late, kitchen in prep)
    2. Carry-forward extension date calculations
      ✓ Extends end date by 1 day when all 7 days are active
      ✓ Extends end date by 3 days for 3 skipped meals across month boundary
      ✓ Correctly skips weekends for Monday-Friday only subscription plan
    3. Month-end & Leap-year boundary tests
      ✓ Handles extension across February in leap year (2028)
      ✓ Handles extension across December into next year (Dec 31 to Jan)
    4. Pausing a subscription and resuming
      ✓ Correctly calculates new end date after a 5-day pause
```

---

## 2. Flutter App Testing
Execute Flutter unit and widget tests:
```bash
flutter test
```

### Coverage targets:
1. `CurrencyFormatter`: Verifies integer paise to INR conversions (e.g. `240000 -> ₹2,400`).
2. `AuthNotifier`: Verifies cross-role blocking logic.
3. `PressableScale`: Verifies spring animation and haptic triggers.

---

## 3. Firestore Security Rules Testing (Firebase Emulator)
Test custom claim security boundaries using the Firebase Emulator Suite:
```bash
firebase emulators:start --only firestore
npm run test:rules
```

Tested assertions:
1. Customer attempting to read `/partners/{uid}` private banking details -> **DENIED**.
2. Partner attempting to read another partner's orders -> **DENIED**.
3. Client attempting to write `total` or `paymentStatus` directly to `/orders` -> **DENIED**.
4. Client attempting to mutate `/subscriptions` outside Cloud Functions -> **DENIED**.
