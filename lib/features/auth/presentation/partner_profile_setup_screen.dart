import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pressable_scale.dart';
import '../domain/user_role.dart';
import '../providers/auth_provider.dart';

class PartnerProfileSetupScreen extends ConsumerStatefulWidget {
  const PartnerProfileSetupScreen({super.key});

  @override
  ConsumerState<PartnerProfileSetupScreen> createState() =>
      _PartnerProfileSetupScreenState();
}

class _PartnerProfileSetupScreenState
    extends ConsumerState<PartnerProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _fssaiController = TextEditingController();
  final _gstController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _beneficiaryController = TextEditingController();
  final _addressController = TextEditingController();

  String _serviceType = 'Both (Tiffin & Mess)';
  String _vegType = 'Veg & Non-Veg';
  bool _fssaiUploaded = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _fssaiController.dispose();
    _gstController.dispose();
    _bankAccountController.dispose();
    _ifscController.dispose();
    _beneficiaryController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_fssaiUploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload your FSSAI certificate document')),
        );
        return;
      }

      ref.read(authProvider.notifier).completeProfile(
            displayName: _businessNameController.text.trim(),
          );
      ref.read(authProvider.notifier).updatePartnerStatus(
            PartnerVerificationStatus.pending,
          );

      context.go(RoutePaths.partnerDashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Partner Registration & KYC',
          style: AppTypography.headline(isDark),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.partnerPrimary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.partnerPrimary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded,
                          color: AppColors.partnerPrimary, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'FSSAI registration is mandatory for food delivery under Indian food safety regulations.',
                          style: AppTypography.footnote(isDark).copyWith(
                            color: isDark ? Colors.white : const Color(0xFF0F766E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Kitchen / Business Info', style: AppTypography.title2(isDark)),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _businessNameController,
                  decoration: const InputDecoration(
                    labelText: 'Mess / Tiffin Business Name *',
                    hintText: 'e.g. Annapurna Tiffin Center',
                  ),
                  validator: (v) => v!.isEmpty ? 'Business name required' : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _ownerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Owner / Contact Person Name *',
                    hintText: 'e.g. Ramesh Patel',
                  ),
                  validator: (v) => v!.isEmpty ? 'Owner name required' : null,
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: _serviceType,
                  decoration: const InputDecoration(labelText: 'Service Type *'),
                  items: ['Tiffin Delivery Only', 'Mess Dining Only', 'Both (Tiffin & Mess)']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _serviceType = val!),
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: _vegType,
                  decoration: const InputDecoration(labelText: 'Dietary Type *'),
                  items: ['Pure Veg Only', 'Non-Veg Only', 'Veg & Non-Veg']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _vegType = val!),
                ),
                const SizedBox(height: 24),

                // FSSAI & Compliance
                Text('Legal & FSSAI Verification', style: AppTypography.title2(isDark)),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _fssaiController,
                  keyboardType: TextInputType.number,
                  maxLength: 14,
                  decoration: const InputDecoration(
                    labelText: '14-Digit FSSAI License Number *',
                    hintText: 'e.g. 11223344556677',
                    counterText: '',
                  ),
                  validator: (v) => (v?.length ?? 0) != 14
                      ? 'Valid 14-digit FSSAI number required'
                      : null,
                ),
                const SizedBox(height: 14),

                // Certificate Upload Container
                GestureDetector(
                  onTap: () {
                    setState(() => _fssaiUploaded = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('FSSAI certificate uploaded successfully!')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _fssaiUploaded
                            ? AppColors.success
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        width: _fssaiUploaded ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _fssaiUploaded
                              ? Icons.check_circle_rounded
                              : Icons.cloud_upload_rounded,
                          color: _fssaiUploaded ? AppColors.success : AppColors.partnerPrimary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _fssaiUploaded
                              ? 'Certificate Attached (fssai_doc.pdf)'
                              : 'Upload FSSAI License Certificate (PDF/Image) *',
                          style: AppTypography.callout(isDark).copyWith(
                            color: _fssaiUploaded ? AppColors.success : AppColors.partnerPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _gstController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'GST Number (Optional)',
                    hintText: 'e.g. 29ABCDE1234F1Z5',
                  ),
                ),
                const SizedBox(height: 24),

                // Payout Bank Details
                Text('Bank Account for Payouts', style: AppTypography.title2(isDark)),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _beneficiaryController,
                  decoration: const InputDecoration(
                    labelText: 'Beneficiary Account Name *',
                    hintText: 'e.g. Annapurna Caterers',
                  ),
                  validator: (v) => v!.isEmpty ? 'Beneficiary name required' : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _bankAccountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Bank Account Number *',
                    hintText: 'e.g. 01234567890123',
                  ),
                  validator: (v) => v!.isEmpty ? 'Account number required' : null,
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _ifscController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Bank IFSC Code *',
                    hintText: 'e.g. HDFC0001234',
                  ),
                  validator: (v) => (v?.length ?? 0) != 11
                      ? 'Valid 11-character IFSC required'
                      : null,
                ),
                const SizedBox(height: 32),

                // Submit KYC Button
                PressableScale(
                  onTap: _handleSubmit,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.partnerPrimary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.partnerPrimary.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Submit for Verification',
                        style: AppTypography.headline(false).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
