import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/network_image_with_fallback.dart';
import '../main/navigation_controller.dart';
import 'orders_controller.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    final navController = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Order History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.charcoal),
            ),
          );
        }

        if (controller.orders.isEmpty) {
          return EmptyStateView(
            icon: Icons.inventory_2_outlined,
            title: 'No Orders Yet',
            message: 'You have not placed any orders yet. Discover our collections to begin curating.',
            buttonText: 'Start Shopping',
            onButtonPressed: () {
              navController.goToHome();
              Get.offAllNamed('/main');
            },
          );
        }

        return RefreshIndicator(
          color: AppColors.charcoal,
          backgroundColor: AppColors.white,
          onRefresh: controller.loadOrders,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            itemCount: controller.orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(order.createdAt);
    final statusColor = _getStatusColor(order.status);

    return GestureDetector(
      onTap: () => Get.toNamed('/order-detail', arguments: order),
      child: Container(
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
            // Order number & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: statusColor.withAlpha(80)),
                  ),
                  child: Text(
                    order.status.displayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const Divider(height: 20),

            // Item Thumbnails
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: order.items.length,
                      itemBuilder: (context, idx) {
                        final item = order.items[idx];
                        return Container(
                          width: 52,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                            child: NetworkImageWithFallback(
                              imageUrl: item.productImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${order.totalItemCount} ${order.totalItemCount == 1 ? "item" : "items"}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${AppConstants.currency}${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.charcoal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return AppColors.warning;
      case OrderStatus.shipped:
        return AppColors.rose;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.danger;
      default:
        return AppColors.charcoal;
    }
  }
}
