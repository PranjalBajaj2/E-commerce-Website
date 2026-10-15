import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/network_image_with_fallback.dart';
import '../../shared/widgets/quantity_counter.dart';
import '../main/navigation_controller.dart';
import 'cart_controller.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final navController = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Shopping Bag',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          Obx(() {
            if (cartController.items.isEmpty) return const SizedBox.shrink();
            return TextButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: AppColors.white,
                    title: const Text('Empty Bag?'),
                    content: const Text('Are you sure you want to remove all items from your bag?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                      TextButton(
                        onPressed: () {
                          cartController.clearCart();
                          Get.back();
                        },
                        child: const Text('Empty Bag', style: TextStyle(color: AppColors.danger)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (cartController.items.isEmpty) {
          return EmptyStateView(
            icon: Icons.shopping_bag_outlined,
            title: 'Your Bag is Empty',
            message:
                'Explore our intentional collections to discover furniture, acoustics, and accents crafted for daily ritual.',
            buttonText: 'Start Shopping',
            onButtonPressed: () => navController.goToHome(),
          );
        }

        return Column(
          children: [
            // Free Shipping Progress Notice
            _buildFreeShippingProgress(cartController),

            // Cart Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                itemCount: cartController.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = cartController.items[index];
                  return _buildCartItemCard(item, cartController);
                },
              ),
            ),

            // Order Summary & Checkout Bottom Sheet
            _buildCheckoutSection(context, cartController),
          ],
        );
      }),
    );
  }

  Widget _buildFreeShippingProgress(CartController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                controller.qualifiesForFreeShipping
                    ? Icons.check_circle_rounded
                    : Icons.local_shipping_outlined,
                size: 16,
                color: controller.qualifiesForFreeShipping ? AppColors.success : AppColors.rose,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.qualifiesForFreeShipping
                      ? 'Congratulations! You unlocked complimentary shipping.'
                      : 'Add ${AppConstants.currency}${controller.remainingForFreeShipping.toStringAsFixed(2)} more for complimentary shipping.',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: controller.qualifiesForFreeShipping
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (controller.subtotal / AppConstants.freeShippingThreshold).clamp(0.0, 1.0),
              backgroundColor: AppColors.borderSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(
                controller.qualifiesForFreeShipping ? AppColors.success : AppColors.rose,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(dynamic item, CartController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          GestureDetector(
            onTap: () => Get.toNamed('/product-detail', arguments: item.product),
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                child: NetworkImageWithFallback(
                  imageUrl: item.product.primaryImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Trash / Remove
                    InkWell(
                      onTap: () => controller.removeItem(item.id),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Variant Info
                if (item.selectedColor != null || item.selectedSize != null) ...[
                  Text(
                    [
                      if (item.selectedColor != null) item.selectedColor,
                      if (item.selectedSize != null) item.selectedSize,
                    ].join(' • '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],

                // Price and Quantity Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${AppConstants.currency}${item.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                    ),
                    QuantityCounter(
                      quantity: item.quantity,
                      size: 32,
                      onChanged: (newQty) {
                        controller.updateQuantity(item.id, newQty);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Promo Code Input
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.creamSubtle,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _promoController,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        color: AppColors.charcoal,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'PROMO CODE (e.g. LUMINA10)',
                        hintStyle: TextStyle(
                          fontSize: 11.5,
                          letterSpacing: 0.5,
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        prefixIcon: Icon(Icons.discount_outlined, size: 16, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.charcoal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                    ),
                    onPressed: () {
                      if (_promoController.text.trim().isNotEmpty) {
                        controller.applyPromoCode(_promoController.text.trim());
                      }
                    },
                    child: const Text('Apply', style: TextStyle(fontSize: 13, color: AppColors.white)),
                  ),
                ),
              ],
            ),

            if (controller.appliedPromoCode.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                      const SizedBox(width: 6),
                      Text(
                        'Code ${controller.appliedPromoCode.value} Applied',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.removePromoCode();
                      _promoController.clear();
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Cost Summary
            _buildSummaryRow('Subtotal', '${AppConstants.currency}${controller.subtotal.toStringAsFixed(2)}'),
            if (controller.discount > 0)
              _buildSummaryRow(
                'Promo Discount',
                '-${AppConstants.currency}${controller.discount.toStringAsFixed(2)}',
                textColor: AppColors.success,
              ),
            _buildSummaryRow(
              'Estimated Shipping',
              controller.shippingFee == 0
                  ? 'FREE'
                  : '${AppConstants.currency}${controller.shippingFee.toStringAsFixed(2)}',
              textColor: controller.shippingFee == 0 ? AppColors.success : null,
            ),
            _buildSummaryRow('Estimated Tax (8%)', '${AppConstants.currency}${controller.tax.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            // Grand Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                  ),
                ),
                Text(
                  '${AppConstants.currency}${controller.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Proceed to Checkout Button
            CustomButton(
              text: 'Proceed to Checkout',
              icon: Icons.lock_outline_rounded,
              onPressed: () => Get.toNamed('/checkout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: textColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
