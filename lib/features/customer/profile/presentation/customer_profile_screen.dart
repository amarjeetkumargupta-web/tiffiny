import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../../auth/providers/auth_provider.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen> {
  String _dietaryPref = 'Regular';

  void _showDeleteAccountDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'In accordance with Google Play & Apple policies, deleting your account permanently removes your profile, active subscriptions, and saved addresses. This action cannot be undone.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(authProvider.notifier).signOut();
              context.go(RoutePaths.welcome);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion request submitted.')),
              );
            },
            child: const Text('Permanently Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account & Preferences', style: AppTypography.headline(isDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          physics: const BouncingScrollPhysics(),
          children: [
            // Profile Card
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    (authState.displayName?.isNotEmpty ?? false)
                        ? authState.displayName![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.displayName ?? 'Customer User',
                        style: AppTypography.title2(isDark),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        authState.phoneNumber ?? '+91 98765 43210',
                        style: AppTypography.footnote(isDark),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tiffiny Credits / Wallet Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tiffiny Credits (Refunds & Skip Credits)',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.formatPaise(15000), // ₹150
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Dietary Preferences
            Text('Dietary Preferences', style: AppTypography.title2(isDark)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['Regular', 'Pure Veg', 'Jain (No Root Veg)', 'No Onion / Garlic']
                  .map((pref) {
                final isSelected = _dietaryPref == pref;
                return ChoiceChip(
                  label: Text(pref),
                  selected: isSelected,
                  selectedColor: AppColors.primaryLight,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : null,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (_) => setState(() => _dietaryPref = pref),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Menu Links
            _buildSettingTile(
              icon: Icons.location_on_outlined,
              title: 'Saved Addresses',
              subtitle: 'Home, Work, Other addresses',
              isDark: isDark,
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.notifications_outlined,
              title: 'Notification Preferences',
              subtitle: 'Order updates, meal reminders, offers',
              isDark: isDark,
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.headset_mic_outlined,
              title: 'Help & Customer Support',
              subtitle: 'FAQs, ticket status, contact team',
              isDark: isDark,
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.policy_outlined,
              title: 'Privacy Policy & Terms',
              subtitle: 'Legal and data policies',
              isDark: isDark,
              onTap: () {},
            ),

            const Divider(height: 32),

            // Google Play Required: Delete Account
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 20),
              ),
              title: const Text(
                'Delete Account',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: const Text(
                'Permanently remove personal data & orders',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () => _showDeleteAccountDialog(context),
            ),
            const SizedBox(height: 12),

            // Sign Out
            PressableScale(
              onTap: () {
                ref.read(authProvider.notifier).signOut();
                context.go(RoutePaths.welcome);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(title, style: AppTypography.headline(isDark).copyWith(fontSize: 15)),
      subtitle: Text(subtitle, style: AppTypography.footnote(isDark)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}
