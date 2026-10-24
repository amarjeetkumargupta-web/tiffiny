import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';

class PartnerEarningsScreen extends StatelessWidget {
  const PartnerEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings & Payouts', style: AppTypography.headline(isDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          physics: const BouncingScrollPhysics(),
          children: [
            // Total Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Balance for Payout', style: TextStyle(color: Color(0xFFCCFBF1), fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(
                    CurrencyFormatter.formatPaise(3840000), // ₹38,400
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Next payout scheduled: Tuesday (via Razorpay Route / Bank NEFT)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Performance Intervals
            Row(
              children: [
                _buildIntervalCard('Today', CurrencyFormatter.formatPaise(485000), isDark),
                const SizedBox(width: 10),
                _buildIntervalCard('This Week', CurrencyFormatter.formatPaise(2890000), isDark),
                const SizedBox(width: 10),
                _buildIntervalCard('This Month', CurrencyFormatter.formatPaise(11420000), isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Platform Commission Breakdown
            Text('Platform Fee Breakdown', style: AppTypography.title2(isDark)),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _buildFeeRow('Gross Food Sales', CurrencyFormatter.formatPaise(13000000), isDark),
                  const SizedBox(height: 8),
                  _buildFeeRow('Platform Commission (12%)', '-${CurrencyFormatter.formatPaise(1560000)}', isDark, isDeduction: true),
                  const SizedBox(height: 8),
                  _buildFeeRow('GST on Platform Fee (18%)', '-${CurrencyFormatter.formatPaise(28080)}', isDark, isDeduction: true),
                  const Divider(height: 24),
                  _buildFeeRow('Net Settlement', CurrencyFormatter.formatPaise(11411920), isDark, isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bank Account Linked
            Text('Payout Bank Account', style: AppTypography.title2(isDark)),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_balance_rounded, color: AppColors.partnerPrimary, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HDFC Bank •••• 9812', style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 2),
                        Text('IFSC: HDFC0001234 • Verified', style: TextStyle(fontSize: 12, color: AppColors.success)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildIntervalCard(String title, String amount, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.footnote(isDark)),
            const SizedBox(height: 6),
            Text(
              amount,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFeeRow(String label, String value, bool isDark,
      {bool isDeduction = false, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.w700 : FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isDeduction ? AppColors.error : (isBold ? AppColors.partnerPrimary : null),
          ),
        ),
      ],
    );
  }
}
