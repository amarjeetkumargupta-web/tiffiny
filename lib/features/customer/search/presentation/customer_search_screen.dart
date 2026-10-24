import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _vegOnly = false;
  String _selectedSort = 'Rating: High to Low';

  final List<String> _recentSearches = [
    'Gujarati Thali',
    'Monthly Tiffin Koramangala',
    'South Indian Mess',
    'Diet Meals (High Protein)',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Search for mess, tiffin, cuisines...',
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filter Pills Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  FilterChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 10, color: AppColors.vegGreen),
                        SizedBox(width: 6),
                        Text('Veg Only'),
                      ],
                    ),
                    selected: _vegOnly,
                    onSelected: (val) => setState(() => _vegOnly = val),
                    selectedColor: AppColors.primaryLight,
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedSort,
                    underline: const SizedBox(),
                    items: [
                      'Rating: High to Low',
                      'Delivery Time',
                      'Price: Low to High',
                      'Distance',
                    ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) => setState(() => _selectedSort = val!),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Recent Searches or Results
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  Text('Recent Searches', style: AppTypography.title2(isDark)),
                  const SizedBox(height: 12),
                  ..._recentSearches.map(
                    (query) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history_rounded, size: 20),
                      title: Text(query, style: AppTypography.body(isDark)),
                      trailing: const Icon(Icons.north_west_rounded, size: 16),
                      onTap: () {
                        _searchController.text = query;
                        setState(() {});
                      },
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
}
