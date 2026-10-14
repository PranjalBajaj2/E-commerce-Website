import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../view_models/ecommerce_view_model.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget {
  final EcommerceViewModel viewModel;

  const WishlistScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final wishlisted = viewModel.wishlistedProducts;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saved to Wishlist',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${wishlisted.length} ${wishlisted.length == 1 ? 'item' : 'items'} saved for later',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),

                const SizedBox(height: 20),

                if (wishlisted.isEmpty)
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
                        itemCount: wishlisted.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: wishlisted[index],
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

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.backgroundSubtle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 52,
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Save your favorite tech and accessories here by tapping the heart icon.',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => viewModel.navigateTo(AppPage.shop),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'Discover Products',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
