import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import '../../shared/widgets/network_image_with_fallback.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel?;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final formattedDate = DateFormat('MMMM dd, yyyy • hh:mm a').format(order.createdAt);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(order.orderNumber),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Tracking Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.border),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status: ${order.status.displayName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.charcoal,
                        ),
                      ),
                      Text(
                        order.orderNumber,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),

                  // Tracking progress stepper
                  _buildTrackingStepper(order.status),

                  if (order.trackingNumber != null) ...[
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Waybill Tracking ID',
                              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              order.trackingNumber!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.rose),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: order.trackingNumber!));
                            Get.snackbar(
                              'Copied',
                              'Tracking code copied to clipboard.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.charcoal,
                              colorText: AppColors.white,
                              duration: const Duration(seconds: 1),
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Purchased Items
            _buildSectionHeader('Purchased Pieces (${order.totalItemCount})'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.border),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                children: order.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: NetworkImageWithFallback(
                              imageUrl: item.productImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.charcoal,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Qty: ${item.quantity} ${item.selectedColor != null ? "• ${item.selectedColor}" : ""}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${AppConstants.currency}${item.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
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

            const SizedBox(height: 20),

            // Shipping Address & Delivery Method
            _buildSectionHeader('Delivery Information'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.border),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: AppColors.charcoal),
                      const SizedBox(width: 8),
                      Text(
                        order.shippingAddress.recipientName,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.shippingAddress.formattedAddress,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.shippingAddress.phone,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 18, color: AppColors.charcoal),
                      const SizedBox(width: 8),
                      Text(
                        order.deliveryMethod,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Payment Summary
            _buildSectionHeader('Payment Summary'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.border),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                children: [
                  _buildSummaryLine('Subtotal', '${AppConstants.currency}${order.subtotal.toStringAsFixed(2)}'),
                  if (order.discount > 0)
                    _buildSummaryLine(
                      'Promo Discount',
                      '-${AppConstants.currency}${order.discount.toStringAsFixed(2)}',
                      color: AppColors.success,
                    ),
                  _buildSummaryLine(
                    'Shipping',
                    order.shippingFee == 0
                        ? 'FREE'
                        : '${AppConstants.currency}${order.shippingFee.toStringAsFixed(2)}',
                    color: order.shippingFee == 0 ? AppColors.success : null,
                  ),
                  _buildSummaryLine('Tax', '${AppConstants.currency}${order.tax.toStringAsFixed(2)}'),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Paid',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${AppConstants.currency}${order.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Charged to',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                      Text(
                        order.paymentMethod,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
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

  Widget _buildTrackingStepper(OrderStatus currentStatus) {
    final stages = [
      {'status': OrderStatus.pending, 'label': 'Placed'},
      {'status': OrderStatus.processing, 'label': 'Processing'},
      {'status': OrderStatus.shipped, 'label': 'Shipped'},
      {'status': OrderStatus.delivered, 'label': 'Delivered'},
    ];

    int currentIndex = stages.indexWhere((s) => s['status'] == currentStatus);
    if (currentIndex == -1) currentIndex = 1;

    return Row(
      children: List.generate(stages.length * 2 - 1, (index) {
        if (index.isEven) {
          final stageIdx = index ~/ 2;
          final isCompleted = stageIdx <= currentIndex;
          return Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.rose : AppColors.creamSubtle,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted ? AppColors.rose : AppColors.border,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 13, color: AppColors.white)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                stages[stageIdx]['label'] as String,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isCompleted ? FontWeight.w700 : FontWeight.w500,
                  color: isCompleted ? AppColors.charcoal : AppColors.textMuted,
                ),
              ),
            ],
          );
        } else {
          final segmentIdx = index ~/ 2;
          final isCompleted = segmentIdx < currentIndex;
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 16),
              color: isCompleted ? AppColors.rose : AppColors.border,
            ),
          );
        }
      }),
    );
  }
}
