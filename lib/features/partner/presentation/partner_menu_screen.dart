import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';

class PartnerMenuScreen extends StatefulWidget {
  const PartnerMenuScreen({super.key});

  @override
  State<PartnerMenuScreen> createState() => _PartnerMenuScreenState();
}

class _PartnerMenuScreenState extends State<PartnerMenuScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      'name': 'Special Homely Thali',
      'price': 14000,
      'isVeg': true,
      'available': true,
    },
    {
      'name': 'Mini Executive Lunch Box',
      'price': 9500,
      'isVeg': true,
      'available': true,
    },
    {
      'name': 'Desi Ghee Phulka (4 pcs)',
      'price': 4000,
      'isVeg': true,
      'available': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu & Plans', style: AppTypography.headline(isDark)),
          bottom: const TabBar(
            indicatorColor: AppColors.partnerPrimary,
            labelColor: AppColors.partnerPrimary,
            tabs: [
              Tab(text: 'Menu Items'),
              Tab(text: 'Subscription Plans'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
              onPressed: () {
                // Add item sheet
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Menu Items List
            ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: (item['isVeg'] as bool)
                                ? AppColors.vegGreen
                                : AppColors.nonVegRed,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: (item['isVeg'] as bool)
                              ? AppColors.vegGreen
                              : AppColors.nonVegRed,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'] as String, style: AppTypography.headline(isDark)),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.formatPaise(item['price'] as int),
                              style: TextStyle(
                                color: AppColors.partnerPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: item['available'] as bool,
                          activeColor: AppColors.partnerPrimary,
                          onChanged: (val) {
                            setState(() => item['available'] = val);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Subscription Plans
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.partnerPrimary.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Monthly Lunch Plan', style: AppTypography.headline(isDark)),
                          Text(
                            CurrencyFormatter.formatPaise(240000),
                            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.partnerPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text('30 Days • Lunch Only • Up to 10 Skips Allowed'),
                      const SizedBox(height: 12),
                      const Text('Active Subscribers: 42 customers', style: TextStyle(fontWeight: FontWeight.w600)),
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
