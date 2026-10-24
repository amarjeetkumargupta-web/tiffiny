import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class KitchenViewScreen extends StatefulWidget {
  const KitchenViewScreen({super.key});

  @override
  State<KitchenViewScreen> createState() => _KitchenViewScreenState();
}

class _KitchenViewScreenState extends State<KitchenViewScreen> {
  int _selectedDay = 0; // 0 = Today, 1 = Tomorrow

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kitchen Prep Sheet', style: AppTypography.headline(isDark)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Day Toggle (Today vs Tomorrow)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedDay = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedDay == 0
                                ? AppColors.partnerPrimary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Today's Meals",
                              style: TextStyle(
                                color: _selectedDay == 0 ? Colors.white : null,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedDay = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedDay == 1
                                ? AppColors.partnerPrimary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Tomorrow's Forecast",
                              style: TextStyle(
                                color: _selectedDay == 1 ? Colors.white : null,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Live subtraction notice
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.partnerPrimaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.sync_rounded, color: AppColors.partnerPrimary, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Live sync active: Customer skips are automatically subtracted from batch counts.',
                        style: TextStyle(
                          color: Color(0xFF0F766E),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Meal Batches Breakdown
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildMealCard(
                    title: 'Lunch Batch (12:00 PM - 1:30 PM)',
                    totalToCook: 48,
                    regularOrders: 10,
                    subscribedMeals: 42,
                    absentSkips: 4,
                    color: AppColors.primary,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildMealCard(
                    title: 'Dinner Batch (7:30 PM - 9:00 PM)',
                    totalToCook: 30,
                    regularOrders: 6,
                    subscribedMeals: 26,
                    absentSkips: 2,
                    color: AppColors.subscriptionBlue,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),

                  // Route / Zone Dispatch Summary (Section 4.1)
                  Text('Zone & Route Distribution', style: AppTypography.title2(isDark)),
                  const SizedBox(height: 10),
                  _buildZoneRow('Zone A (Koramangala 4th & 5th Block)', 28, isDark),
                  _buildZoneRow('Zone B (HSR Sector 1 & 2)', 14, isDark),
                  _buildZoneRow('Zone C (BTM 2nd Stage)', 6, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required int totalToCook,
    required int regularOrders,
    required int subscribedMeals,
    required int absentSkips,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: AppColors.softShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.headline(isDark)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$totalToCook Portions',
                  style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniMetric('Subscribers', '$subscribedMeals', isDark),
              _buildMiniMetric('Skips (Absent)', '-$absentSkips', isDark, isDeduction: true),
              _buildMiniMetric('Daily Orders', '+$regularOrders', isDark),
              _buildMiniMetric('Final Cook', '$totalToCook', isDark, isHighlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String label, String value, bool isDark,
      {bool isDeduction = false, bool isHighlight = false}) {
    return Column(
      children: [
        Text(label, style: AppTypography.footnote(isDark)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDeduction
                ? AppColors.error
                : (isHighlight ? AppColors.success : null),
          ),
        ),
      ],
    );
  }

  Widget _buildZoneRow(String zone, int count, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(zone, style: AppTypography.body(isDark)),
          Text('$count meals', style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
