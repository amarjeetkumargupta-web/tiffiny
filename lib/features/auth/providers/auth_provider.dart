import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_role.dart';

class AuthState {
  final UserRole role;
  final UserRole intendedDoor; // Which door the user clicked: customer or partner
  final PartnerVerificationStatus partnerStatus;
  final String? uid;
  final String? phoneNumber;
  final String? displayName;
  final bool isLoading;
  final bool isProfileComplete;
  final String? errorMessage;
  final String? verificationId;

  const AuthState({
    this.role = UserRole.unauthenticated,
    this.intendedDoor = UserRole.customer,
    this.partnerStatus = PartnerVerificationStatus.notSubmitted,
    this.uid,
    this.phoneNumber,
    this.displayName,
    this.isLoading = false,
    this.isProfileComplete = false,
    this.errorMessage,
    this.verificationId,
  });

  bool get isAuthenticated => role != UserRole.unauthenticated && uid != null;

  AuthState copyWith({
    UserRole? role,
    UserRole? intendedDoor,
    PartnerVerificationStatus? partnerStatus,
    String? uid,
    String? phoneNumber,
    String? displayName,
    bool? isLoading,
    bool? isProfileComplete,
    String? errorMessage,
    String? verificationId,
    bool clearError = false,
  }) {
    return AuthState(
      role: role ?? this.role,
      intendedDoor: intendedDoor ?? this.intendedDoor,
      partnerStatus: partnerStatus ?? this.partnerStatus,
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      isLoading: isLoading ?? this.isLoading,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  /// Sets the selected entry door (Order Food vs Partner Login)
  void setIntendedDoor(UserRole door) {
    state = state.copyWith(intendedDoor: door, clearError: true);
  }

  /// Initiates Phone OTP send
  Future<void> sendOtp({
    required String phoneNumber,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, phoneNumber: phoneNumber);
    try {
      // In production, Firebase Phone Auth verifyPhoneNumber is triggered here
      // Simulated OTP handshake for Phase 1/2 tests
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        isLoading: false,
        verificationId: 'mock_verification_id_123456',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send OTP. Please check your phone number.',
      );
    }
  }

  /// Verifies OTP and performs cross-role verification
  Future<bool> verifyOtp({
    required String smsCode,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // CROSS-ROLE CONFLICT CHECK (Section 2.2):
      // Example: test phone ending with 0000 is customer-locked, 9999 is partner-locked
      final phone = state.phoneNumber ?? '';
      if (state.intendedDoor == UserRole.partner && phone.endsWith('0000')) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'This number is registered as a customer. Please use Order Food to log in.',
        );
        return false;
      }

      if (state.intendedDoor == UserRole.customer && phone.endsWith('9999')) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'This number is registered as a partner. Please use Partner Login to log in.',
        );
        return false;
      }

      // Successful verification
      final mockUid = 'usr_${phone.replaceAll('+', '')}';
      final isNewUser = !phone.endsWith('1111'); // 1111 simulates existing profile

      state = state.copyWith(
        isLoading: false,
        uid: mockUid,
        role: state.intendedDoor,
        isProfileComplete: !isNewUser,
        partnerStatus: state.intendedDoor == UserRole.partner
            ? PartnerVerificationStatus.pending
            : PartnerVerificationStatus.approved,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid verification code. Please try again.',
      );
      return false;
    }
  }

  /// Profile setup completion
  void completeProfile({required String displayName}) {
    state = state.copyWith(
      displayName: displayName,
      isProfileComplete: true,
    );
  }

  /// Partner verification status update
  void updatePartnerStatus(PartnerVerificationStatus status) {
    state = state.copyWith(partnerStatus: status);
  }

  /// Sign out: Clears all local state and cached role tokens
  void signOut() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
