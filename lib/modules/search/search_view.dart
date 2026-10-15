import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/product_card.dart';
import '../categories/category_products_view.dart';
import 'search_controller.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchViewController());

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: controller.textController,
              autofocus: true,
              style: const TextStyle(fontSize: 14, color: AppColors.charcoal),
              decoration: InputDecoration(
                hintText: 'Search pieces, materials, categories...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13.5),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                suffixIcon: Obx(() {
                  if (controller.query.value.isNotEmpty) {
                    return IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                      onPressed: () {
                        controller.textController.clear();
                        controller.onQueryChanged('');
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onChanged: controller.onQueryChanged,
              onSubmitted: controller.executeSearch,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.query.value.trim().isEmpty) {
          return _buildRecentAndTrending(controller);
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.charcoal),
            ),
          );
        }

        if (controller.searchResults.isEmpty) {
          return EmptyStateView(
            icon: Icons.search_off_rounded,
            title: 'No Matches Found',
            message: 'We couldn’t find any pieces matching "${controller.query.value}". Try searching with different keywords.',
            buttonText: 'Clear Search',
            onButtonPressed: () {
              controller.textController.clear();
              controller.onQueryChanged('');
            },
          );
        }

        return Column(
          children: [
            // Results Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.searchResults.length} results for "${controller.query.value}"',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  PopupMenuButton<SortCriteria>(
                    initialValue: controller.currentSort.value,
                    onSelected: controller.setSort,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.sort_rounded, size: 15, color: AppColors.charcoal),
                          SizedBox(width: 4),
                          Text('Sort', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: SortCriteria.featured, child: Text('Featured')),
                      PopupMenuItem(value: SortCriteria.priceAsc, child: Text('Price: Low to High')),
                      PopupMenuItem(value: SortCriteria.priceDesc, child: Text('Price: High to Low')),
                      PopupMenuItem(value: SortCriteria.rating, child: Text('Highest Rated')),
                    ],
                  ),
                ],
              ),
            ),

            // Results Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.64,
                ),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final product = controller.searchResults[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRecentAndTrending(SearchViewController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (controller.recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
                TextButton(
                  onPressed: controller.clearRecentSearches,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.recentSearches.map((item) {
                return Chip(
                  backgroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  label: Text(
                    item,
                    style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
                  ),
                  deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.textMuted),
                  onDeleted: () => controller.removeRecentSearch(item),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Trending Discoveries
          const Text(
            'Trending Discoveries',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.trendingKeywords.map((tag) {
              return ActionChip(
                backgroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                avatar: const Icon(Icons.trending_up_rounded, size: 16, color: AppColors.rose),
                label: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.charcoal,
                  ),
                ),
                onPressed: () => controller.executeSearch(tag),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
