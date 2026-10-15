import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/network_image_with_fallback.dart';
import '../auth/auth_controller.dart';
import 'checkout_controller.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Shipping Address
            _buildSectionTitle('1. Shipping Address'),
            const SizedBox(height: 10),
            Obx(() {
              final addr = controller.selectedAddress.value;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppTheme.softShadow,
                ),
                child: addr != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                addr.recipientName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                  color: AppColors.charcoal,
                                ),
                              ),
                              TextButton(
                                onPressed: () => _showAddressSelectionModal(context, controller, authController),
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                    color: AppColors.rose,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            addr.formattedAddress,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            addr.phone,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'No address selected',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          TextButton(
                            onPressed: () => _showAddressSelectionModal(context, controller, authController),
                            child: const Text('Select Address'),
                          ),
                        ],
                      ),
              );
            }),

            const SizedBox(height: 24),

            // Section 2: Delivery Method
            _buildSectionTitle('2. Delivery Method'),
            const SizedBox(height: 10),
            Obx(
              () => Column(
                children: List.generate(
                  controller.deliveryOptions.length,
                  (index) {
                    final opt = controller.deliveryOptions[index];
                    final isSelected = controller.selectedDeliveryIndex.value == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => controller.selectDelivery(index),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            border: Border.all(
                              color: isSelected ? AppColors.charcoal : AppColors.border,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            boxShadow: AppTheme.softShadow,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppColors.charcoal : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.charcoal,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          opt.title,
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.charcoal,
                                          ),
                                        ),
                                        Text(
                                          opt.fee == 0.0
                                              ? 'FREE'
                                              : '${AppConstants.currency}${opt.fee.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: opt.fee == 0.0 ? AppColors.success : AppColors.charcoal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${opt.estimatedDays} • ${opt.description}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
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
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Section 3: Payment Method
            _buildSectionTitle('3. Payment Option (Mock Test)'),
            const SizedBox(height: 10),
            Obx(
              () => Column(
                children: [
                  _buildPaymentOptionTile(
                    controller,
                    id: 'Credit Card (Visa ending 4242)',
                    title: 'Visa •••• 4242',
                    subtitle: 'Expires 08/29 • Eleanor Vance',
                    icon: Icons.credit_card_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentOptionTile(
                    controller,
                    id: 'Apple Pay',
                    title: 'Apple Pay / Google Pay',
                    subtitle: 'Instant biometric authorization',
                    icon: Icons.contactless_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentOptionTile(
                    controller,
                    id: 'Cash on Delivery',
                    title: 'Pay Upon Inspection',
                    subtitle: 'Verify your order before payment',
                    icon: Icons.handshake_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 4: Items Preview
            _buildSectionTitle('4. Items Ordered'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.border),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                children: controller.cartController.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: NetworkImageWithFallback(
                              imageUrl: item.product.primaryImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.charcoal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Qty: ${item.quantity} ${item.selectedColor != null ? "• ${item.selectedColor}" : ""}',
                                style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${AppConstants.currency}${item.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Section 5: Order Breakdown
            _buildSectionTitle('5. Order Total Summary'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.border),
                boxShadow: AppTheme.softShadow,
              ),
              child: Obx(
                () => Column(
                  children: [
                    _buildSummaryLine('Subtotal', '${AppConstants.currency}${controller.cartController.subtotal.toStringAsFixed(2)}'),
                    if (controller.cartController.discount > 0)
                      _buildSummaryLine(
                        'Promo Discount',
                        '-${AppConstants.currency}${controller.cartController.discount.toStringAsFixed(2)}',
                        color: AppColors.success,
                      ),
                    _buildSummaryLine(
                      'Delivery (${controller.currentDelivery.title})',
                      controller.deliveryFee == 0
                          ? 'FREE'
                          : '${AppConstants.currency}${controller.deliveryFee.toStringAsFixed(2)}',
                      color: controller.deliveryFee == 0 ? AppColors.success : null,
                    ),
                    _buildSummaryLine('Estimated Tax (8%)', '${AppConstants.currency}${controller.cartController.tax.toStringAsFixed(2)}'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Final Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.charcoal,
                          ),
                        ),
                        Text(
                          '${AppConstants.currency}${controller.finalTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Place Order Button
            Obx(
              () => CustomButton(
                text: 'Place Order (${AppConstants.currency}${controller.finalTotal.toStringAsFixed(2)})',
                icon: Icons.check_circle_outline_rounded,
                isLoading: controller.isPlacingOrder.value,
                onPressed: controller.submitOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPaymentOptionTile(
    CheckoutController controller, {
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = controller.selectedPaymentMethod.value == id;
    return GestureDetector(
      onTap: () => controller.selectPaymentMethod(id),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.charcoal : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.charcoal : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.charcoal,
                        ),
                      ),
                    )
                  : null,
            ),
            Icon(icon, color: AppColors.charcoal, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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

  Widget _buildSummaryLine(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressSelectionModal(
    BuildContext context,
    CheckoutController controller,
    AuthController authController,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Shipping Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...authController.currentUser.value?.addresses.map((a) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.location_on_outlined, color: AppColors.charcoal),
                      title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(a.formattedAddress, style: const TextStyle(fontSize: 12)),
                      onTap: () {
                        controller.selectAddress(a);
                        Get.back();
                      },
                    );
                  }).toList() ??
                  [],
              const SizedBox(height: 12),
              CustomButton(
                text: 'Manage Addresses',
                variant: ButtonVariant.outline,
                onPressed: () {
                  Get.back();
                  Get.toNamed('/manage-addresses');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
