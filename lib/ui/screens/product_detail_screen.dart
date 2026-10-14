import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../domain/models/product.dart';
import '../../view_models/ecommerce_view_model.dart';
import '../widgets/app_image.dart';
import '../widgets/star_rating.dart';

class ProductDetailScreen extends StatefulWidget {
  final EcommerceViewModel viewModel;

  const ProductDetailScreen({super.key, required this.viewModel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.viewModel.selectedProduct;

    if (product == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Product not found'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => widget.viewModel.navigateTo(AppPage.shop),
              child: const Text('Back to Shop'),
            ),
          ],
        ),
      );
    }

    final isWishlisted = widget.viewModel.isWishlisted(product.id);
    final isDesktop = MediaQuery.sizeOf(context).width > 800;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                TextButton.icon(
                  onPressed: () => widget.viewModel.navigateTo(AppPage.shop),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Back to Collection'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.textMuted,
                  ),
                ),

                const SizedBox(height: 16),

                // Responsive Layout: 2-column on desktop, 1-column on mobile
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _buildImageGallery(product),
                          ),
                          const SizedBox(width: 48),
                          Expanded(
                            flex: 6,
                            child: _buildDetails(product, isWishlisted),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageGallery(product),
                          const SizedBox(height: 24),
                          _buildDetails(product, isWishlisted),
                        ],
                      ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageGallery(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundSubtle,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: AppImage(
          src: product.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDetails(Product product, bool isWishlisted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.backgroundSubtle,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(color: AppTheme.border),
          ),
          child: Text(
            product.category.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Product Name
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            height: 1.25,
          ),
        ),

        const SizedBox(height: 10),

        // Ratings (Safe Row with Flexible)
        Row(
          children: [
            StarRating(rating: product.rating, size: 15),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '${product.rating} (${product.reviews} Verified Reviews)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Price
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),

        const SizedBox(height: 14),

        // Description
        Text(
          product.description,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textMuted,
            height: 1.6,
          ),
        ),

        const SizedBox(height: 20),

        // Color Selection
        const Text(
          'Select Finish / Color',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(product.availableColorValues.length, (index) {
            final colorVal = product.availableColorValues[index];
            final isSelected = widget.viewModel.selectedColorIndex == index;
            return GestureDetector(
              onTap: () => widget.viewModel.setSelectedColorIndex(index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(colorVal),
                    border: Border.all(color: AppTheme.border),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 20),

        // Quantity Selector
        Row(
          children: [
            const Text(
              'Quantity:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 14),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 14),
                    visualDensity: VisualDensity.compact,
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 14),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Actions: Add to Cart and Wishlist
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final selectedColor = product.availableColorValues[
                        widget.viewModel.selectedColorIndex];
                    widget.viewModel.addToCart(
                      product,
                      quantity: _quantity,
                      colorValue: selectedColor,
                    );
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppTheme.success,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('Added $_quantity × ${product.name} to cart!'),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? AppTheme.danger : AppTheme.textPrimary,
                  size: 20,
                ),
                onPressed: () {
                  widget.viewModel.toggleWishlist(product.id);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isWishlisted
                            ? 'Removed from wishlist'
                            : 'Added to wishlist',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // Value Proposition Badges
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundSubtle,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.local_shipping_outlined,
                        color: AppTheme.primary, size: 22),
                    SizedBox(height: 6),
                    Text(
                      'Free Fast Delivery',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundSubtle,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.assignment_return_outlined,
                        color: AppTheme.primary, size: 22),
                    SizedBox(height: 6),
                    Text(
                      '30-Day Returns',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
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
}
