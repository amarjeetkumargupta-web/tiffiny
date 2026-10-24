import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/pressable_scale.dart';

class CustomerSubscriptionsScreen extends StatelessWidget {
  const CustomerSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Subscriptions', style: AppTypography.headline(isDark)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          physics: const BouncingScrollPhysics(),
          children: [
            // Active Subscription Card
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.subscriptionBlue.withOpacity(0.4),
                  width: 1.5,
                ),
                boxShadow: AppColors.softShadow(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.subscriptionBlue.withOpacity(0.08),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'ACTIVE PLAN',
                              style: TextStyle(
                                color: AppColors.subscriptionBlue,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Lunch Only (30 Days)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.subscriptionBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Plan Details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Annapurna Homely Tiffins', style: AppTypography.title2(isDark)),
                        const SizedBox(height: 4),
                        Text(
                          'Delivering to: Home (Koramangala 5th Block)',
                          style: AppTypography.footnote(isDark),
                        ),
                        const SizedBox(height: 16),

                        // Stats Row: Remaining | Skipped | Extended End Date
                        Row(
                          children: [
                            _buildStatItem('Meals Left', '18 / 30', AppColors.primary, isDark),
                            _buildDivider(isDark),
                            _buildStatItem('Skipped', '3', AppColors.warning, isDark),
                            _buildDivider(isDark),
                            _buildStatItem('Valid Until', '12 Nov', AppColors.subscriptionBlue, isDark),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Live summary note (Section 3.5)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline_rounded, size: 16, color: AppColors.subscriptionBlue),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '3 skipped meals added to end of plan. New end date: 12 Nov.',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Meal Calendar CTA Button
                        PressableScale(
                          onTap: () {
                            context.push(
                              RoutePaths.customerMealCalendar.replaceAll(':id', 'sub_demo_101'),
                            );
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.subscriptionBlue,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Meal Calendar & Mark Absent',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

  static Widget _buildStatItem(String title, String value, Color color, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: AppTypography.footnote(isDark)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 32,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}
