import { SubscriptionEngine } from '../subscriptions/subscriptionEngine';

describe('SubscriptionEngine Unit Tests', () => {
  describe('1. Cut-off boundaries for meal skipping', () => {
    test('Allows skipping when requested well before 9:00 PM IST of previous day', () => {
      const targetDate = '2026-11-15'; // Target delivery date
      // Request at 2:00 PM IST on previous day (2026-11-14 14:00 IST = 08:30 UTC)
      const requestTimeUtc = new Date(Date.UTC(2026, 10, 14, 8, 30, 0));

      const canSkip = SubscriptionEngine.canSkipMeal(targetDate, requestTimeUtc);
      expect(canSkip).toBe(true);
    });

    test('Allows skipping at 8:59 PM IST (1 minute before cut-off)', () => {
      const targetDate = '2026-11-15';
      // 2026-11-14 20:59 IST = 15:29 UTC
      const requestTimeUtc = new Date(Date.UTC(2026, 10, 14, 15, 29, 0));

      const canSkip = SubscriptionEngine.canSkipMeal(targetDate, requestTimeUtc);
      expect(canSkip).toBe(true);
    });

    test('Denies skipping at exactly 9:00 PM IST of previous day (cut-off passed)', () => {
      const targetDate = '2026-11-15';
      // 2026-11-14 21:00 IST = 15:30 UTC
      const requestTimeUtc = new Date(Date.UTC(2026, 10, 14, 15, 30, 0));

      const canSkip = SubscriptionEngine.canSkipMeal(targetDate, requestTimeUtc);
      expect(canSkip).toBe(false);
    });

    test('Denies skipping on same day of delivery morning (too late, kitchen in prep)', () => {
      const targetDate = '2026-11-15';
      // 2026-11-15 07:00 IST = 01:30 UTC
      const requestTimeUtc = new Date(Date.UTC(2026, 10, 15, 1, 30, 0));

      const canSkip = SubscriptionEngine.canSkipMeal(targetDate, requestTimeUtc);
      expect(canSkip).toBe(false);
    });
  });

  describe('2. Carry-forward extension date calculations', () => {
    test('Extends end date by 1 day when all 7 days are active', () => {
      const currentEndDate = '2026-11-30';
      const allDays = [0, 1, 2, 3, 4, 5, 6];

      const newEndDate = SubscriptionEngine.calculateCarryForwardEndDate(
        currentEndDate,
        1,
        allDays
      );
      expect(newEndDate).toBe('2026-12-01');
    });

    test('Extends end date by 3 days for 3 skipped meals across month boundary (Nov to Dec)', () => {
      const currentEndDate = '2026-11-29';
      const allDays = [0, 1, 2, 3, 4, 5, 6];

      const newEndDate = SubscriptionEngine.calculateCarryForwardEndDate(
        currentEndDate,
        3,
        allDays
      );
      // Nov 29 + 3 days -> Nov 30 (1), Dec 1 (2), Dec 2 (3)
      expect(newEndDate).toBe('2026-12-02');
    });

    test('Correctly skips weekends for Monday-Friday only subscription plan', () => {
      // 2026-11-20 is a Friday
      const currentEndDate = '2026-11-20';
      const weekdaysOnly = [1, 2, 3, 4, 5]; // Mon to Fri

      const newEndDate = SubscriptionEngine.calculateCarryForwardEndDate(
        currentEndDate,
        1, // 1 extra slot needed
        weekdaysOnly
      );
      // Next weekday after Friday Nov 20 is Monday Nov 23
      expect(newEndDate).toBe('2026-11-23');
    });
  });

  describe('3. Month-end & Leap-year boundary tests', () => {
    test('Handles extension across February in leap year (2028)', () => {
      const currentEndDate = '2028-02-28';
      const allDays = [0, 1, 2, 3, 4, 5, 6];

      const newEndDate = SubscriptionEngine.calculateCarryForwardEndDate(
        currentEndDate,
        2,
        allDays
      );
      // 2028 is a leap year (Feb has 29 days). Slot 1: Feb 29. Slot 2: Mar 1.
      expect(newEndDate).toBe('2028-03-01');
    });

    test('Handles extension across December into next year (Dec 31 to Jan)', () => {
      const currentEndDate = '2026-12-30';
      const allDays = [0, 1, 2, 3, 4, 5, 6];

      const newEndDate = SubscriptionEngine.calculateCarryForwardEndDate(
        currentEndDate,
        3,
        allDays
      );
      // Dec 31 (1), Jan 01 2027 (2), Jan 02 2027 (3)
      expect(newEndDate).toBe('2027-01-02');
    });
  });

  describe('4. Pausing a subscription and resuming', () => {
    test('Correctly calculates new end date after a 5-day pause', () => {
      const currentEndDate = '2026-11-20';
      const allDays = [0, 1, 2, 3, 4, 5, 6];

      const newEndDate = SubscriptionEngine.calculateResumeDates(
        '2026-11-10',
        '2026-11-15', // 5 days paused
        currentEndDate,
        allDays
      );
      // 2026-11-20 + 5 days -> 2026-11-25
      expect(newEndDate).toBe('2026-11-25');
    });
  });
});
