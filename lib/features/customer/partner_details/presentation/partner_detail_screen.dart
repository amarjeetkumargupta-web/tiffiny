import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/pressable_scale.dart';

class PartnerDetailScreen extends StatefulWidget {
  final String partnerId;
  final Map<String, dynamic>? initialData;

  const PartnerDetailScreen({
    super.key,
    required this.partnerId,
    this.initialData,
  });

  @override
  State<PartnerDetailScreen> createState() => _PartnerDetailScreenState();
}

class _PartnerDetailScreenState extends State<PartnerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, int> _cartQuantities = {};

  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 'item_1',
      'name': 'Special Homely Thali',
      'description': '4 Butter Phulkas, Dal Tadka, Paneer Sabzi, Seasonal Veg, Steamed Rice, Salad & Sweet',
      'price': 14000, // ₹140
      'isVeg': true,
      'category': 'Thali',
    },
    {
      'id': 'item_2',
      'name': 'Mini Executive Lunch Box',
      'description': '3 Phulkas, Daily Sabzi, Dal Fry, Jeera Rice, Pickle',
      'price': 9500, // ₹95
      'isVeg': true,
      'category': 'Thali',
    },
    {
      'id': 'item_3',
      'name': 'Fresh Ghee Phulka (Pack of 4)',
      'description': 'Soft 100% whole wheat rotis smeared with pure desi ghee',
      'price': 4000, // ₹40
      'isVeg': true,
      'category': 'Roti',
    },
    {
      'id': 'item_4',
      'name': 'Dal Makhani Bowl',
      'description': 'Slow-cooked overnight black lentils with fresh cream & butter',
      'price': 8000, // ₹80
      'isVeg': true,
      'category': 'Dal',
    },
  ];

  final List<Map<String, dynamic>> _subscriptionPlans = [
    {
      'id': 'plan_monthly_lunch',
      'name': 'Monthly Lunch Plan (30 Days)',
      'duration': '30 Days',
      'mealType': 'Lunch Only (Delivered 12:30 PM)',
      'totalMeals': 30,
      'price': 240000, // ₹2,400
      'dailyEquivalent': 360000, // ₹3,600
      'savings': 120000, // Save ₹1,200
      'skipAllowed': true,
      'maxSkips': 10,
    },
    {
      'id': 'plan_monthly_both',
      'name': 'Monthly Lunch + Dinner Pass',
      'duration': '30 Days',
      'mealType': 'Lunch (12:30 PM) & Dinner (8:00 PM)',
      'totalMeals': 60,
      'price': 460000, // ₹4,600
      'dailyEquivalent': 680000, // ₹6,800
      'savings': 220000, // Save ₹2,200
      'skipAllowed': true,
      'maxSkips': 15,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _cartTotalItems =>
      _cartQuantities.values.fold(0, (sum, count) => sum + count);

  int get _cartTotalPrice {
    int total = 0;
    for (final item in _menuItems) {
      final qty = _cartQuantities[item['id']] ?? 0;
      total += qty * (item['price'] as int);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final partnerName = widget.initialData?['name'] ?? 'Annapurna Homely Tiffins';

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              leading: IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black),
                ),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: AppColors.primaryLight,
                  child: Center(
                    child: Icon(
                      Icons.storefront_rounded,
                      size: 72,
                      color: AppColors.primary.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(partnerName, style: AppTypography.title1(isDark)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.vegGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                '4.8',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.star, color: Colors.white, size: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'North Indian • Gujarati Thali • 20-25 mins • 1.8 km away',
                      style: AppTypography.footnote(isDark),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'FSSAI License: 11223344556677 (Verified)',
                      style: AppTypography.caption(isDark).copyWith(color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  tabs: const [
                    Tab(text: 'Menu'),
                    Tab(text: 'Subscriptions'),
                    Tab(text: 'Reviews'),
                    Tab(text: 'Info'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Menu Items
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final itemId = item['id'] as String;
                final qty = _cartQuantities[itemId] ?? 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    boxShadow: AppColors.softShadow(context),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Veg indicator
                      Container(
                        padding: const EdgeInsets.all(3),
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.vegGreen, width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.circle, size: 8, color: AppColors.vegGreen),
                      ),
                      const SizedBox(width: 12),

                      // Item Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              style: AppTypography.headline(isDark),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.formatPaise(item['price'] as int),
                              style: AppTypography.priceTag(isDark).copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['description'] as String,
                              style: AppTypography.footnote(isDark),
                            ),
                          ],
                        ),
                      ),

                      // Stepper / Add button
                      const SizedBox(width: 12),
                      qty == 0
                          ? PressableScale(
                              onTap: () => setState(() => _cartQuantities[itemId] = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: const Text(
                                  'ADD',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                                    onPressed: () => setState(() {
                                      if (qty > 1) {
                                        _cartQuantities[itemId] = qty - 1;
                                      } else {
                                        _cartQuantities.remove(itemId);
                                      }
                                    }),
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    padding: EdgeInsets.zero,
                                  ),
                                  Text(
                                    '$qty',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.white, size: 16),
                                    onPressed: () => setState(() {
                                      _cartQuantities[itemId] = qty + 1;
                                    }),
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),

            // Tab 2: Subscription Plans
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
              itemCount: _subscriptionPlans.length,
              itemBuilder: (context, index) {
                final plan = _subscriptionPlans[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.subscriptionBlue.withOpacity(0.5),
                    ),
                    boxShadow: AppColors.softShadow(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(plan['name'] as String, style: AppTypography.headline(isDark)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              CurrencyFormatter.formatSavings(plan['savings'] as int),
                              style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(plan['mealType'] as String, style: AppTypography.footnote(isDark)),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Text(
                            CurrencyFormatter.formatPaise(plan['price'] as int),
                            style: AppTypography.priceBig(isDark).copyWith(
                              color: AppColors.subscriptionBlue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            CurrencyFormatter.formatPaise(plan['dailyEquivalent'] as int),
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textTertiaryLight,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                          const SizedBox(width: 6),
                          Text('Up to ${plan['maxSkips']} meal skips carry-forward', style: AppTypography.footnote(isDark)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      PressableScale(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Proceeding to Subscription Setup...')),
                          );
                        },
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.subscriptionBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Choose This Plan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Tab 3: Reviews
            Center(child: Text('Customer Reviews (4.8 ★ from 520 subscribers)', style: AppTypography.body(isDark))),

            // Tab 4: Info
            Center(child: Text('FSSAI Reg: 11223344556677 • Operating 7 AM - 10 PM', style: AppTypography.body(isDark))),
          ],
        ),
      ),

      // Sticky Bottom Cart Bar (Section 3.3 & Section 6.2)
      bottomSheet: _cartTotalItems > 0
          ? Container(
              margin: const EdgeInsets.all(16),
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_cartTotalItems ${_cartTotalItems == 1 ? "ITEM" : "ITEMS"} ADDED',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.formatPaise(_cartTotalPrice),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    PressableScale(
                      onTap: () {
                        // View cart
                      },
                      child: const Row(
                        children: [
                          Text(
                            'View Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.surfaceDark : Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
