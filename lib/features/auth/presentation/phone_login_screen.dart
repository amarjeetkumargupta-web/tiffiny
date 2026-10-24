import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../domain/user_role.dart';
import '../providers/auth_provider.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final String _countryCode = '+91';
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    final text = _phoneController.text.trim();
    final isValid = text.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(text);
    if (isValid != _isPhoneValid) {
      setState(() {
        _isPhoneValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (!_isPhoneValid) return;
    final fullNumber = '$_countryCode${_phoneController.text.trim()}';
    final intendedDoor = ref.read(authProvider).intendedDoor;

    await ref.read(authProvider.notifier).sendOtp(
          phoneNumber: fullNumber,
          role: intendedDoor,
        );

    if (mounted) {
      context.push(RoutePaths.otpVerification);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final isPartnerDoor = authState.intendedDoor == UserRole.partner;
    final accentColor = isPartnerDoor ? AppColors.partnerPrimary : AppColors.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge indicator
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isPartnerDoor ? 'PARTNER LOGIN' : 'CUSTOMER LOGIN',
                    style: AppTypography.caption(isDark).copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                isPartnerDoor
                    ? 'Welcome back, Partner'
                    : 'Enter your phone number',
                style: AppTypography.title1(isDark),
              ),
              const SizedBox(height: 8),

              Text(
                isPartnerDoor
                    ? 'Log in to your mess / tiffin kitchen dashboard'
                    : 'We will send a 6-digit verification code via SMS',
                style: AppTypography.body(isDark).copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 32),

              // Phone Number Input with +91 Prefix
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isPhoneValid
                        ? accentColor
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: _isPhoneValid ? 1.5 : 1.0,
                  ),
                  boxShadow: AppColors.softShadow(context),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            _countryCode,
                            style: AppTypography.headline(isDark),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        autofocus: true,
                        style: AppTypography.headline(isDark).copyWith(
                          letterSpacing: 1.2,
                        ),
                        decoration: const InputDecoration(
                          hintText: '98765 43210',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Text(
                'Enter a valid 10-digit Indian mobile number',
                style: AppTypography.footnote(isDark),
              ),

              const Spacer(),

              // Submit Button
              PressableScale(
                onTap: _isPhoneValid && !authState.isLoading ? _handleSendOtp : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 54,
                  decoration: BoxDecoration(
                    color: _isPhoneValid ? accentColor : (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: authState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Send Verification Code',
                            style: AppTypography.headline(false).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'By continuing, you agree to our Terms of Service & Privacy Policy',
                textAlign: TextAlign.center,
                style: AppTypography.footnote(isDark),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
