import 'package:intl/intl.dart';

enum MealType {
  breakfast,
  lunch,
  dinner;

  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
    }
  }

  String get defaultDeliveryTime {
    switch (this) {
      case MealType.breakfast:
        return '7:30 AM - 9:00 AM';
      case MealType.lunch:
        return '12:00 PM - 1:30 PM';
      case MealType.dinner:
        return '7:30 PM - 9:00 PM';
    }
  }
}

enum MealSlotStatus {
  scheduled,
  skipped,
  delivered,
  locked,
  cancelled;

  String get label {
    switch (this) {
      case MealSlotStatus.scheduled:
        return 'Delivering';
      case MealSlotStatus.skipped:
        return 'Skipped';
      case MealSlotStatus.delivered:
        return 'Delivered';
      case MealSlotStatus.locked:
        return 'Cut-off passed';
      case MealSlotStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class TiffinyDateUtils {
  static const Duration istOffset = Duration(hours: 5, minutes: 30);

  /// Converts any DateTime to Indian Standard Time (Asia/Kolkata)
  static DateTime toIST(DateTime dateTime) {
    return dateTime.toUtc().add(istOffset);
  }

  /// Current time in IST
  static DateTime nowIST() {
    return DateTime.now().toUtc().add(istOffset);
  }

  /// Computes the exact cut-off deadline for a given target meal slot.
  /// Standard rule: 9:00 PM (21:00 IST) of the PREVIOUS day.
  static DateTime getCutoffDeadline({
    required DateTime targetDate,
    required MealType mealType,
    int cutoffHour = 21,
    int cutoffMinute = 0,
  }) {
    // Normalizing target date to year, month, day in IST
    final normalizedDate = DateTime.utc(targetDate.year, targetDate.month, targetDate.day);
    // Previous day at cutoffHour:cutoffMinute IST
    final previousDay = normalizedDate.subtract(const Duration(days: 1));
    return DateTime.utc(
      previousDay.year,
      previousDay.month,
      previousDay.day,
      cutoffHour,
      cutoffMinute,
    );
  }

  /// Evaluates whether a customer can still mark themselves absent for a meal
  static bool isMealEligibleToSkip({
    required DateTime targetDate,
    required MealType mealType,
    DateTime? currentIST,
    int cutoffHour = 21,
  }) {
    final now = currentIST ?? nowIST();
    final deadline = getCutoffDeadline(
      targetDate: targetDate,
      mealType: mealType,
      cutoffHour: cutoffHour,
    );
    return now.isBefore(deadline);
  }

  /// Formats date for display (e.g., "Wed, 24 Oct")
  static String formatDisplayDate(DateTime dateTime) {
    return DateFormat('EEE, d MMM').format(dateTime);
  }

  /// Formats date with year (e.g., "12 Nov 2026")
  static String formatFullDate(DateTime dateTime) {
    return DateFormat('d MMM yyyy').format(dateTime);
  }

  /// Slot ID key format: "YYYY-MM-DD_lunch"
  static String formatSlotKey(DateTime date, MealType mealType) {
    final ymd = DateFormat('yyyy-MM-dd').format(date);
    return '${ymd}_${mealType.name}';
  }
}
