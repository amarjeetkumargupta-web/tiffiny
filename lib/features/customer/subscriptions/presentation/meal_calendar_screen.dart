import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/pressable_scale.dart';

class MealCalendarScreen extends StatefulWidget {
  final String subscriptionId;

  const MealCalendarScreen({super.key, required this.subscriptionId});

  @override
  State<MealCalendarScreen> createState() => _MealCalendarScreenState();
}

class _MealCalendarScreenState extends State<MealCalendarScreen> {
  // Simulated subscription slot status map: date_meal -> MealSlotStatus
  final Map<String, MealSlotStatus> _slotStatuses = {};
  int _skippedCount = 3;
  int _remainingMeals = 18;

  @override
  void initState() {
    super.initState();
    _initializeDemoSlots();
  }

  void _initializeDemoSlots() {
    final now = DateTime.now();
    for (int i = 0; i < 14; i++) {
      final date = now.add(Duration(days: i));
      final slotKey = TiffinyDateUtils.formatSlotKey(date, MealType.lunch);
      if (i == 0) {
        // Today's lunch is locked / cut-off passed
        _slotStatuses[slotKey] = MealSlotStatus.locked;
      } else if (i == 3 || i == 7 || i == 10) {
        _slotStatuses[slotKey] = MealSlotStatus.skipped;
      } else {
        _slotStatuses[slotKey] = MealSlotStatus.scheduled;
      }
    }
  }

  void _toggleSlotSkip(DateTime date, MealType mealType) {
    final slotKey = TiffinyDateUtils.formatSlotKey(date, MealType.lunch);
    final currentStatus = _slotStatuses[slotKey] ?? MealSlotStatus.scheduled;

    // Check cut-off boundary
    final isEligible = TiffinyDateUtils.isMealEligibleToSkip(
      targetDate: date,
      mealType: mealType,
    );

    if (!isEligible) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cut-off passed (9:00 PM previous evening). This meal is already in prep.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      if (currentStatus == MealSlotStatus.scheduled) {
        _slotStatuses[slotKey] = MealSlotStatus.skipped;
        _skippedCount++;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Meal marked absent! Subscription extended by 1 day automatically.',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (currentStatus == MealSlotStatus.skipped) {
        _slotStatuses[slotKey] = MealSlotStatus.scheduled;
        _skippedCount--;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meal delivery resumed for this day.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Delivery Calendar', style: AppTypography.headline(isDark)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Live Extension Summary Bar (Section 3.5)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: isDark ? AppColors.surfaceDark : const Color(0xFFEFF6FF),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.subscriptionBlue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Meals left: $_remainingMeals | Skipped: $_skippedCount | Extended to: 15 Nov',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.subscriptionBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Cut-off Policy Notice
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Rule: Mark absent before 9:00 PM the previous evening. Skipped meals carry forward to the end of the plan.',
                style: AppTypography.footnote(isDark),
              ),
            ),

            // Days List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                physics: const BouncingScrollPhysics(),
                itemCount: 14,
                itemBuilder: (context, index) {
                  final date = now.add(Duration(days: index));
                  final slotKey = TiffinyDateUtils.formatSlotKey(date, MealType.lunch);
                  final status = _slotStatuses[slotKey] ?? MealSlotStatus.scheduled;
                  final isSkipped = status == MealSlotStatus.skipped;
                  final isLocked = status == MealSlotStatus.locked;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSkipped
                          ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
                          : (isDark ? AppColors.surfaceDark : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSkipped
                            ? (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1))
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      boxShadow: isSkipped ? [] : AppColors.softShadow(context),
                    ),
                    child: Row(
                      children: [
                        // Date column
                        Container(
                          width: 54,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSkipped
                                ? (isDark ? Colors.black26 : const Color(0xFFE2E8F0))
                                : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: isSkipped
                                      ? AppColors.textSecondaryLight
                                      : AppColors.primary,
                                ),
                              ),
                              Text(
                                TiffinyDateUtils.formatDisplayDate(date).split(',').first,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSkipped
                                      ? AppColors.textTertiaryLight
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Meal Info Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Lunch Delivery',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      decoration: isSkipped ? TextDecoration.lineThrough : null,
                                      color: isSkipped
                                          ? AppColors.textTertiaryLight
                                          : (isDark ? Colors.white : AppColors.textPrimaryLight),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Status tag
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isSkipped
                                          ? AppColors.warning.withOpacity(0.15)
                                          : (isLocked
                                              ? const Color(0xFF64748B).withOpacity(0.15)
                                              : AppColors.success.withOpacity(0.15)),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      status.label,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isSkipped
                                            ? AppColors.warning
                                            : (isLocked ? const Color(0xFF64748B) : AppColors.success),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isLocked
                                    ? 'Cut-off passed (In prep)'
                                    : (isSkipped ? 'Meal carried forward to end' : '12:30 PM - 1:30 PM'),
                                style: AppTypography.footnote(isDark),
                              ),
                            ],
                          ),
                        ),

                        // Action Button
                        if (!isLocked) ...[
                          PressableScale(
                            onTap: () => _toggleSlotSkip(date, MealType.lunch),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSkipped
                                    ? AppColors.subscriptionBlue
                                    : (isDark ? AppColors.surfaceDark : Colors.white),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSkipped ? AppColors.subscriptionBlue : AppColors.error,
                                ),
                              ),
                              child: Text(
                                isSkipped ? 'Resume' : 'Mark Absent',
                                style: TextStyle(
                                  color: isSkipped ? Colors.white : AppColors.error,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
