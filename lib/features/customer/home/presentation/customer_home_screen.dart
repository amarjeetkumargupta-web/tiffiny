import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../../auth/providers/auth_provider.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'All',
    'Tiffin Service',
    'Daily Mess',
    'Pure Veg',
    'Non-Veg',
    'Thali',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Budget (<₹100)',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top Address & Action Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 26),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Tap to change address
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Home',
                                  style: AppTypography.headline(isDark).copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                              ],
                            ),
                            Text(
                              '5th Block, Koramangala, Bengaluru',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.footnote(isDark),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PressableScale(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: const Icon(Icons.notifications_none_rounded, size: 22),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        (authState.displayName?.isNotEmpty ?? false)
                            ? authState.displayName![0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: PressableScale(
                  onTap: () => context.go(RoutePaths.customerSearch),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                      boxShadow: AppColors.softShadow(context),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search "Punjabi Thali", "South Mess", dishes...',
                            style: AppTypography.callout(isDark).copyWith(
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.mic_rounded, color: AppColors.primary, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Category Chips Carousel
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PressableScale(
                        onTap: () => setState(() => _selectedCategoryIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.surfaceDark : Colors.white),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _categories[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Subscription Promo Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.3),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'TIFFINY MEAL PASS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Save up to 40% with Monthly Tiffin Plans',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Skip meals anytime with 1-click carry-forward',
                              style: TextStyle(
                                color: Color(0xFFDBEAFE),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lunch_dining_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Section Header: Top Rated Tiffin & Mess Services
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tiffin & Mess Services Near You', style: AppTypography.title2(isDark)),
                    Text(
                      'See all',
                      style: AppTypography.callout(isDark).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sample Partner Cards List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final partners = [
                    {
                      'id': 'pt_annapurna',
                      'name': 'Annapurna Homely Tiffins',
                      'cuisine': 'North Indian • Gujarati Thali',
                      'rating': '4.8',
                      'reviews': '520',
                      'time': '25-30 min',
                      'distance': '1.8 km',
                      'perMeal': '₹85 / meal',
                      'veg': true,
                      'hasSubscription': true,
                    },
                    {
                      'id': 'pt_dakshin',
                      'name': 'Dakshin Mess & Tiffin Box',
                      'cuisine': 'South Indian • Andhra Meals',
                      'rating': '4.6',
                      'reviews': '380',
                      'time': '20-25 min',
                      'distance': '1.2 km',
                      'perMeal': '₹70 / meal',
                      'veg': true,
                      'hasSubscription': true,
                    },
                    {
                      'id': 'pt_punjabi_dhaba',
                      'name': 'Punjab Express Tiffins',
                      'cuisine': 'Punjabi • Tandoori Roti • Dal Makhani',
                      'rating': '4.7',
                      'reviews': '840',
                      'time': '30-35 min',
                      'distance': '3.1 km',
                      'perMeal': '₹110 / meal',
                      'veg': false,
                      'hasSubscription': true,
                    },
                  ];

                  final p = partners[index % partners.length];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: PressableScale(
                      onTap: () {
                        context.push(
                          RoutePaths.customerPartnerDetail.replaceAll(':id', p['id'] as String),
                          extra: p,
                        );
                      },
                      child: Container(
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
                            // Banner Placeholder with Veg/Non-Veg & Subscription Badges
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                color: (p['veg'] as bool)
                                    ? const Color(0xFF15803D).withOpacity(0.08)
                                    : const Color(0xFFB91C1C).withOpacity(0.08),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Icon(
                                      Icons.restaurant_rounded,
                                      size: 54,
                                      color: (p['veg'] as bool)
                                          ? AppColors.vegGreen.withOpacity(0.5)
                                          : AppColors.nonVegRed.withOpacity(0.5),
                                    ),
                                  ),
                                  // Subscription Available Badge
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.subscriptionBlue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.calendar_month, color: Colors.white, size: 12),
                                          SizedBox(width: 4),
                                          Text(
                                            'Subscription Available',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Veg/Non-Veg Dot Icon
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: (p['veg'] as bool)
                                              ? AppColors.vegGreen
                                              : AppColors.nonVegRed,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: (p['veg'] as bool)
                                            ? AppColors.vegGreen
                                            : AppColors.nonVegRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Partner Metadata
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          p['name'] as String,
                                          style: AppTypography.headline(isDark),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.vegGreen,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              p['rating'] as String,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            const Icon(Icons.star, color: Colors.white, size: 11),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p['cuisine'] as String,
                                    style: AppTypography.footnote(isDark),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time_rounded,
                                          size: 14,
                                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                                      const SizedBox(width: 4),
                                      Text(p['time'] as String, style: AppTypography.footnote(isDark)),
                                      const SizedBox(width: 12),
                                      Icon(Icons.directions_bike_rounded,
                                          size: 14,
                                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight),
                                      const SizedBox(width: 4),
                                      Text(p['distance'] as String, style: AppTypography.footnote(isDark)),
                                      const Spacer(),
                                      Text(
                                        p['perMeal'] as String,
                                        style: AppTypography.headline(isDark).copyWith(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: 3,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }
}
