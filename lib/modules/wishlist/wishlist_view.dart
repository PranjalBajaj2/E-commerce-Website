import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/product_card.dart';
import '../main/navigation_controller.dart';
import 'wishlist_controller.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishlistController>();
    final navController = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.wishlistProducts.isEmpty) {
              return const SizedBox.shrink();
            }
            return TextButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: AppColors.white,
                    title: const Text('Clear Wishlist?'),
                    content: const Text('Are you sure you want to remove all saved pieces?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.clearWishlist();
                          Get.back();
                        },
                        child: const Text('Clear All', style: TextStyle(color: AppColors.danger)),
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
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.charcoal),
            ),
          );
        }

        if (controller.wishlistProducts.isEmpty) {
          return EmptyStateView(
            icon: Icons.favorite_border_rounded,
            title: 'Your Sanctuary is Empty',
            message:
                'Explore our intentional collections and tap the heart icon to curate your personal wishlist.',
            buttonText: 'Discover Pieces',
            onButtonPressed: () => navController.goToHome(),
          );
        }

        return RefreshIndicator(
          color: AppColors.charcoal,
          backgroundColor: AppColors.white,
          onRefresh: controller.loadWishlistProducts,
          child: Column(
            children: [
              // Count Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: AppColors.white,
                child: Row(
                  children: [
                    Text(
                      '${controller.wishlistProducts.length} Saved Essentials',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Wishlist Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.64,
                  ),
                  itemCount: controller.wishlistProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.wishlistProducts[index];
                    return ProductCard(product: product);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
