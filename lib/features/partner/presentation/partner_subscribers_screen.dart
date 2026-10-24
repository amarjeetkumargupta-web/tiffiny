import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/pressable_scale.dart';

class PartnerSubscribersScreen extends StatelessWidget {
  const PartnerSubscribersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Subscribers & Delivery', style: AppTypography.headline(isDark)),
          bottom: const TabBar(
            indicatorColor: AppColors.partnerPrimary,
            labelColor: AppColors.partnerPrimary,
            tabs: [
              Tab(text: 'Subscribers (42)'),
              Tab(text: 'Delivery Staff (3)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Subscribers Tab
            ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 3,
              itemBuilder: (context, index) {
                final subs = [
                  {
                    'name': 'Rahul Sharma',
                    'phone': '+91 98765 43210',
                    'plan': 'Monthly Lunch Plan',
                    'address': 'Flat 204, Alpine Eco, Koramangala',
                    'status': 'Delivering Today',
                    'remaining': '18 / 30 meals',
                  },
                  {
                    'name': 'Pooja Verma',
                    'phone': '+91 91234 56789',
                    'plan': 'Monthly Lunch + Dinner',
                    'address': 'B-12, Green Glen Layout',
                    'status': 'Absent Today (Skipped)',
                    'remaining': '34 / 60 meals',
                  },
                  {
                    'name': 'Amit Saxena',
                    'phone': '+91 99887 76655',
                    'plan': 'Monthly Lunch Plan',
                    'address': 'House 89, 5th Main, HSR Sector 1',
                    'status': 'Delivering Today',
                    'remaining': '25 / 30 meals',
                  },
                ];

                final s = subs[index];
                final isAbsent = s['status']!.contains('Absent');

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isAbsent
                          ? AppColors.warning.withOpacity(0.5)
                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(s['name']!, style: AppTypography.headline(isDark)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isAbsent
                                  ? AppColors.warningLight
                                  : AppColors.successLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              s['status']!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isAbsent ? AppColors.warning : AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(s['plan']!, style: TextStyle(color: AppColors.partnerPrimary, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(s['address']!, style: AppTypography.footnote(isDark)),
                      const SizedBox(height: 8),
                      Text('Progress: ${s['remaining']}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                );
              },
            ),

            // Delivery Staff Tab (Section 4.4)
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Info banner explaining Section 4.4
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.partnerPrimary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.link_rounded, color: AppColors.partnerPrimary),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Delivery staff require no platform app. Send them a WhatsApp link to open their mobile delivery run-sheet.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ramesh Kumar', style: AppTypography.headline(isDark)),
                          const Text('+91 98450 12345', style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text('Assigned: Zone A (Koramangala 4th & 5th Block) • 28 Meals'),
                      const SizedBox(height: 14),
                      PressableScale(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Delivery link copied: https://tiffiny.in/dispatch/staff_demo_1')),
                          );
                        },
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.partnerPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share_rounded, color: Colors.white, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Share WhatsApp Dispatch Link',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
