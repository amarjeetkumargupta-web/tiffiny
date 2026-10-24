import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';

class PartnerOrdersScreen extends StatelessWidget {
  const PartnerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders Queue', style: AppTypography.headline(isDark)),
          bottom: const TabBar(
            indicatorColor: AppColors.partnerPrimary,
            labelColor: AppColors.partnerPrimary,
            tabs: [
              Tab(text: 'Incoming (1)'),
              Tab(text: 'Preparing (2)'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Incoming Orders
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.partnerPrimary.withOpacity(0.4)),
                    boxShadow: AppColors.softShadow(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order #TIF-9042', style: AppTypography.headline(isDark)),
                          const Text('3m ago', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Delivery to: Flat 302, Green Glen Layout, Koramangala'),
                      const Divider(height: 20),
                      const Text('2x Special Deluxe Thali (Veg)'),
                      const Text('1x Extra Phulka Pack (4 pcs)'),
                      const SizedBox(height: 12),
                      Text(
                        'Total: ${CurrencyFormatter.formatPaise(29000)} (Paid online)',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                              child: const Text('Reject'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                              child: const Text('Accept Order'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Preparing
            const Center(child: Text('2 Orders Currently in Preparation')),
            // Past
            const Center(child: Text('No more past orders today')),
          ],
        ),
      ),
    );
  }
}
