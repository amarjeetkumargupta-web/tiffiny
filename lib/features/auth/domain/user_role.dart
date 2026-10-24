enum UserRole {
  unauthenticated,
  customer,
  partner;

  bool get isCustomer => this == UserRole.customer;
  bool get isPartner => this == UserRole.partner;
  bool get isAuthenticated => this != UserRole.unauthenticated;
}

enum PartnerVerificationStatus {
  notSubmitted,
  pending,
  approved,
  suspended;

  bool get isApproved => this == PartnerVerificationStatus.approved;
  bool get isPending => this == PartnerVerificationStatus.pending;
  bool get isSuspended => this == PartnerVerificationStatus.suspended;

  String get displayBannerText {
    switch (this) {
      case PartnerVerificationStatus.pending:
        return 'Under review. We usually respond within 48 hours.';
      case PartnerVerificationStatus.suspended:
        return 'Account suspended. Please contact partner support.';
      case PartnerVerificationStatus.notSubmitted:
        return 'Please complete your business profile and FSSAI verification.';
      case PartnerVerificationStatus.approved:
        return 'Account verified & active.';
    }
  }
}
