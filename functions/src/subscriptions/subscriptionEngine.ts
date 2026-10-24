export type MealType = 'breakfast' | 'lunch' | 'dinner';

export interface SubscriptionSlot {
  date: string; // YYYY-MM-DD
  mealType: MealType;
  status: 'scheduled' | 'skipped' | 'delivered' | 'locked' | 'cancelled';
  skippedAt?: string;
}

export interface SubscriptionData {
  id: string;
  userId: string;
  partnerId: string;
  startDate: string; // YYYY-MM-DD
  endDate: string; // YYYY-MM-DD
  totalMeals: number;
  consumedMeals: number;
  skippedMeals: number;
  maxSkipsAllowed: number;
  activeWeekDays: number[]; // 0=Sun, 1=Mon, ..., 6=Sat
  mealTypes: MealType[];
  status: 'active' | 'paused' | 'cancelled' | 'expired';
}

export class SubscriptionEngine {
  private static IST_OFFSET_MS = 5.5 * 60 * 60 * 1000;

  /**
   * Converts any UTC date to Indian Standard Time (Asia/Kolkata)
   */
  public static toIST(date: Date): Date {
    const utc = date.getTime() + date.getTimezoneOffset() * 60000;
    return new Date(utc + this.IST_OFFSET_MS);
  }

  /**
   * Computes the exact cut-off deadline for a given target meal in IST.
   * Standard rule: 9:00 PM (21:00 IST) of the PREVIOUS calendar day.
   */
  public static getCutoffDeadline(targetDateStr: string, cutoffHour = 21, cutoffMinute = 0): Date {
    const [year, month, day] = targetDateStr.split('-').map(Number);
    // Previous day in IST
    const prevDate = new Date(Date.UTC(year, month - 1, day - 1, cutoffHour, cutoffMinute, 0));
    // Offset from UTC to match IST representation
    return new Date(prevDate.getTime() - this.IST_OFFSET_MS);
  }

  /**
   * Evaluates if a meal can be skipped based on cut-off rule.
   */
  public static canSkipMeal(targetDateStr: string, currentTimeUtc: Date, cutoffHour = 21): boolean {
    const deadlineUtc = this.getCutoffDeadline(targetDateStr, cutoffHour);
    return currentTimeUtc.getTime() < deadlineUtc.getTime();
  }

  /**
   * Calculates the extended end-date when 1 or more meals are carried forward.
   * Traverses forward from current endDate until finding the next valid delivery days.
   */
  public static calculateCarryForwardEndDate(
    currentEndDateStr: string,
    additionalSlotsCount: number,
    activeWeekDays: number[]
  ): string {
    const [y, m, d] = currentEndDateStr.split('-').map(Number);
    let curr = new Date(Date.UTC(y, m - 1, d));
    let added = 0;

    while (added < additionalSlotsCount) {
      curr.setUTCDate(curr.getUTCDate() + 1);
      const dayOfWeek = curr.getUTCDay();
      if (activeWeekDays.includes(dayOfWeek)) {
        added++;
      }
    }

    const year = curr.getUTCFullYear();
    const month = String(curr.getUTCMonth() + 1).padStart(2, '0');
    const day = String(curr.getUTCDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  /**
   * Calculates shifted start and end dates when a subscription is paused and resumed.
   */
  public static calculateResumeDates(
    pausedDateStr: string,
    resumeDateStr: string,
    currentEndDateStr: string,
    activeWeekDays: number[]
  ): string {
    const pauseStart = new Date(pausedDateStr);
    const resumeDate = new Date(resumeDateStr);
    const pauseDiffMs = Math.max(0, resumeDate.getTime() - pauseStart.getTime());
    const daysPaused = Math.ceil(pauseDiffMs / (1000 * 60 * 60 * 24));

    return this.calculateCarryForwardEndDate(currentEndDateStr, daysPaused, activeWeekDays);
  }
}
