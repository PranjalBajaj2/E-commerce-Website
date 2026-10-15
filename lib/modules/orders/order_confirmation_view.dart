import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import '../../shared/widgets/custom_button.dart';
import '../main/navigation_controller.dart';

class OrderConfirmationView extends StatelessWidget {
  const OrderConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel?;
    final navController = Get.find<NavigationController>();

    final orderNumber = order?.orderNumber ?? 'LUM-84920';
    final formattedDate = order != null
        ? DateFormat('MMMM dd, yyyy').format(order.createdAt)
        : DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Success Checkmark Badge
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.rose,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.rose.withAlpha(90),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 48,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Order Confirmed',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thank you for curating with Lumina. Your pieces are being carefully inspected and prepared for dispatch.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                // Order Receipt Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Column(
                    children: [
                      // Order Number with Copy Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Order Number',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: orderNumber));
                              Get.snackbar(
                                'Copied',
                                'Order reference copied to clipboard.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.charcoal,
                                colorText: AppColors.white,
                                duration: const Duration(seconds: 1),
                                margin: const EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  orderNumber,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.charcoal,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.copy_rounded, size: 14, color: AppColors.rose),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      _buildReceiptRow('Date Placed', formattedDate),
                      _buildReceiptRow(
                        'Total Charged',
                        '${AppConstants.currency}${(order?.total ?? 389.06).toStringAsFixed(2)}',
                      ),
                      _buildReceiptRow(
                        'Payment Method',
                        order?.paymentMethod ?? 'Credit Card (Visa ending 4242)',
                      ),
                      _buildReceiptRow(
                        'Destination',
                        order?.shippingAddress.formattedAddress ??
                            '742 Evergreen Terrace, Portland, OR 97201',
                      ),
                      _buildReceiptRow(
                        'Delivery Tier',
                        order?.deliveryMethod ?? 'Standard Carbon-Neutral',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Action Buttons
                CustomButton(
                  text: 'View in Order History',
                  icon: Icons.inventory_2_outlined,
                  onPressed: () {
                    Get.offNamed('/order-history');
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Continue Curating',
                  variant: ButtonVariant.outline,
                  onPressed: () {
                    navController.goToHome();
                    Get.offAllNamed('/main');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
