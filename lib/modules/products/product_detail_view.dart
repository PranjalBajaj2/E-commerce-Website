import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/network_image_with_fallback.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/quantity_counter.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/star_rating_bar.dart';
import '../cart/cart_controller.dart';
import '../wishlist/wishlist_controller.dart';
import 'product_detail_controller.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController());
    final wishlistController = Get.find<WishlistController>();
    final cartController = Get.find<CartController>();
    final product = controller.product;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Favorite button
          Obx(() {
            final isFav = wishlistController.isFavorite(product.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? AppColors.rose : AppColors.charcoal,
              ),
              onPressed: controller.toggleWishlist,
            );
          }),
          // Cart button with badge
          Obx(() {
            final count = cartController.totalItemCount;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () => Get.toNamed('/cart'),
                ),
                if (count > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.rose,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$count',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Gallery & Thumbnails
                  _buildImageGallery(context, controller),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge & Category
                        Row(
                          children: [
                            if (product.badge != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.charcoal,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                                ),
                                child: Text(
                                  product.badge!.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              product.categoryName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Title
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: AppColors.charcoal,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Ratings & Reviews
                        Row(
                          children: [
                            StarRatingBar(
                              rating: product.rating,
                              reviewCount: product.reviewCount,
                              starSize: 16,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: product.inStock ? AppColors.successLight : AppColors.dangerLight,
                                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                              ),
                              child: Text(
                                product.inStock ? 'In Stock & Ready to Ship' : 'Out of Stock',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: product.inStock ? AppColors.success : AppColors.danger,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Price and Quantity Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${AppConstants.currency}${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.charcoal,
                              ),
                            ),
                            if (product.hasDiscount) ...[
                              const SizedBox(width: 10),
                              Text(
                                '${AppConstants.currency}${product.originalPrice!.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.roseLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'SAVE ${product.discountPercentage}%',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.roseDeep,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            // Quantity
                            Obx(
                              () => QuantityCounter(
                                quantity: controller.quantity.value,
                                onChanged: controller.updateQuantity,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),

                        // Color Variant Selector
                        if (product.colors.isNotEmpty) ...[
                          _buildColorSelector(controller),
                          const SizedBox(height: 20),
                        ],

                        // Size Variant Selector
                        if (product.sizes.isNotEmpty) ...[
                          _buildSizeSelector(controller),
                          const SizedBox(height: 20),
                        ],

                        // Description
                        const Text(
                          'About this piece',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 14.5,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Key Features
                        if (product.features.isNotEmpty) ...[
                          const Text(
                            'Specifications & Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...product.features.map(
                            (feat) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 16,
                                      color: AppColors.rose,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      feat,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        color: AppColors.textPrimary,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Complimentary Shipping Banner
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.creamSubtle,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined, color: AppColors.charcoal, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Complimentary Carbon-Neutral Shipping',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.5,
                                        color: AppColors.charcoal,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Delivered securely within 2-4 business days. 30-day effortless returns.',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Related Products Section
                  Obx(() {
                    if (controller.relatedProducts.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        const SectionHeader(
                          title: 'Complementary Pieces',
                          subtitle: 'Items styled seamlessly with this design',
                        ),
                        SizedBox(
                          height: 275,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: controller.relatedProducts.length,
                            itemBuilder: (context, index) {
                              final related = controller.relatedProducts[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: SizedBox(
                                  width: 175,
                                  child: ProductCard(product: related),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.border, width: 1)),
              boxShadow: AppTheme.softShadow,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Add to Bag Button
                  Expanded(
                    child: CustomButton(
                      text: 'Add to Bag',
                      icon: Icons.shopping_bag_outlined,
                      variant: ButtonVariant.outline,
                      onPressed: controller.addToCart,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Buy Now Button
                  Expanded(
                    child: CustomButton(
                      text: 'Buy Now',
                      icon: Icons.flash_on_rounded,
                      variant: ButtonVariant.primary,
                      onPressed: controller.buyNow,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context, ProductDetailController controller) {
    final images = controller.product.images;

    return Column(
      children: [
        // Main Image
        Container(
          height: MediaQuery.of(context).size.height * 0.40,
          width: double.infinity,
          color: AppColors.white,
          child: Obx(
            () => Hero(
              tag: 'product_img_${controller.product.id}',
              child: NetworkImageWithFallback(
                imageUrl: images.isNotEmpty
                    ? images[controller.selectedImageIndex.value]
                    : controller.product.primaryImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Thumbnails (if multiple images)
        if (images.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final isSelected = controller.selectedImageIndex.value == index;
                  return GestureDetector(
                    onTap: () => controller.selectImage(index),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        border: Border.all(
                          color: isSelected ? AppColors.charcoal : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm - 1),
                        child: NetworkImageWithFallback(
                          imageUrl: images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildColorSelector(ProductDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Color Finish: ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Obx(
              () => Text(
                controller.selectedColor.value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.roseDeep,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            spacing: 12,
            children: controller.product.colors.map((colorVariant) {
              final isSelected = controller.selectedColor.value == colorVariant.name;
              return GestureDetector(
                onTap: () => controller.selectColor(colorVariant.name),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Color(colorVariant.colorHex),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.charcoal : AppColors.border,
                      width: isSelected ? 2.5 : 1,
                    ),
                    boxShadow: isSelected ? AppTheme.softShadow : null,
                  ),
                  child: isSelected
                      ? Center(
                          child: Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Color(colorVariant.colorHex).computeLuminance() > 0.5
                                ? AppColors.charcoal
                                : AppColors.white,
                          ),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelector(ProductDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Size / Variant:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.product.sizes.map((size) {
              final isSelected = controller.selectedSize.value == size;
              return ChoiceChip(
                label: Text(size),
                selected: isSelected,
                selectedColor: AppColors.charcoal,
                backgroundColor: AppColors.white,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.charcoal : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                onSelected: (val) {
                  if (val) controller.selectSize(size);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
