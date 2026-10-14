import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../view_models/ecommerce_view_model.dart';
import '../widgets/product_card.dart';

class ShopScreen extends StatelessWidget {
  final EcommerceViewModel viewModel;

  const ShopScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final filtered = viewModel.filteredProducts;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Title
                const Text(
                  'Explore All Products',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Engineered for premium performance and minimalist aesthetics.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),

                const SizedBox(height: 20),

                // Controls Bar: Category Filters & Sort
                _buildControls(context),

                const SizedBox(height: 16),

                // Count indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing ${filtered.length} ${filtered.length == 1 ? 'product' : 'products'}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    if (viewModel.searchQuery.isNotEmpty ||
                        viewModel.selectedCategory != 'All')
                      TextButton(
                        onPressed: () {
                          viewModel.setSearchQuery('');
                          viewModel.setSelectedCategory('All');
                        },
                        child: const Text('Reset filters'),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Products Grid or Empty State
                if (filtered.isEmpty)
                  _buildEmptyState(context)
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int crossAxisCount;
                      double childAspectRatio;

                      if (width > 1050) {
                        crossAxisCount = 4;
                        childAspectRatio = 0.75;
                      } else if (width > 750) {
                        crossAxisCount = 3;
                        childAspectRatio = 0.72;
                      } else if (width > 550) {
                        crossAxisCount = 2;
                        childAspectRatio = 0.70;
                      } else if (width > 340) {
                        crossAxisCount = 2;
                        childAspectRatio = 0.62;
                      } else {
                        crossAxisCount = 1;
                        childAspectRatio = 1.05;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: filtered[index],
                            viewModel: viewModel,
                          );
                        },
                      );
                    },
                  ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: viewModel.categories.map((cat) {
              final isSelected = viewModel.selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    viewModel.setSelectedCategory(cat);
                  },
                  backgroundColor: AppTheme.backgroundSubtle,
                  selectedColor: AppTheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Sort Options & Mobile Search
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            const Text(
              'Sort by:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textMuted,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppTheme.backgroundSubtle,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppTheme.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SortOption>(
                  value: viewModel.selectedSort,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (SortOption? newSort) {
                    if (newSort != null) {
                      viewModel.setSortOption(newSort);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: SortOption.newest,
                      child: Text('Newest First'),
                    ),
                    DropdownMenuItem(
                      value: SortOption.priceLowHigh,
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: SortOption.priceHighLow,
                      child: Text('Price: High to Low'),
                    ),
                    DropdownMenuItem(
                      value: SortOption.topRated,
                      child: Text('Top Rated'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 60,
            color: AppTheme.secondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No matching products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try checking for spelling errors or clearing filters.',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              viewModel.setSearchQuery('');
              viewModel.setSelectedCategory('All');
            },
            child: const Text('Clear All Filters'),
          ),
        ],
      ),
    );
  }
}
