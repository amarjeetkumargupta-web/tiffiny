# Legal, Compliance & FSSAI Guidelines (LEGAL.md)

This document contains legal checklists and regulatory requirements for running a food aggregator and meal subscription platform in India.

---

## 1. FSSAI Compliance (Food Safety and Standards Authority of India)
Under the Food Safety and Standards (Licensing and Registration of Food Businesses) Regulations:
- **Platform License**: Tiffiny operates as an E-commerce Food Business Operator (FBO) and must hold an active central FSSAI license.
- **Partner Verification**: Every mess, tiffin service, or home chef must submit an active 14-digit FSSAI license number and valid certificate before onboarding.
- **Display Requirement**: The partner's FSSAI number is displayed on their restaurant storefront and on all customer order receipts.

---

## 2. Privacy Policy Checklist
The Privacy Policy must be hosted publicly at `https://tiffiny.in/privacy` and linked in Google Play Console:
1. **Types of Data Collected**: Mobile number, delivery GPS coordinates, device identifiers (FCM tokens), transaction IDs.
2. **Third-Party Processors**:
   - Google Firebase (Cloud database, authentication, push notifications).
   - Razorpay Software Private Limited (PCI-DSS Level 1 compliant payment processor).
   - Google Maps Platform (Geocoding & places autocomplete).
3. **Data Retention**: Delivery addresses and order histories are retained for tax/accounting requirements. KYC documents are stored with server-side encryption.

---

## 3. Account Deletion Compliance (Google Play & App Store)
Both stores strictly require users to be able to delete their account from within the app and via a public web URL without reinstalling the app:
- **In-App Action**: Located in `CustomerProfileScreen` -> `Delete Account`.
- **Public Web Action**: Hosted at `https://tiffiny.in/delete-account`.
- **Anonymization**: Upon confirmed deletion, the user's phone number, addresses, and auth credentials are purged or hashed, while non-PII financial transaction records are retained for statutory GST audits.
