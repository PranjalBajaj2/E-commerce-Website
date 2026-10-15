import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../cart/cart_controller.dart';
import '../cart/cart_view.dart';
import '../categories/categories_view.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';
import '../wishlist/wishlist_controller.dart';
import '../wishlist/wishlist_view.dart';
import 'navigation_controller.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final wishlistController = Get.find<WishlistController>();
    final cartController = Get.find<CartController>();

    final screens = const [
      HomeView(),
      CategoriesView(),
      WishlistView(),
      CartView(),
      ProfileView(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (navController.currentIndex.value != 0) {
          navController.goToHome();
        } else {
          // Allow system back to minimize / exit app
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Obx(
          () => IndexedStack(
            index: navController.currentIndex.value,
            children: screens,
          ),
        ),
        bottomNavigationBar: Obx(() {
          final currentIndex = navController.currentIndex.value;
          final wishlistCount = wishlistController.wishlistIds.length;
          final cartCount = cartController.totalItemCount;

          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: navController.changeTab,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.white,
              selectedItemColor: AppColors.charcoal,
              unselectedItemColor: AppColors.textMuted,
              selectedLabelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              elevation: 0,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_rounded),
                  activeIcon: Icon(Icons.grid_view_sharp),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    isLabelVisible: wishlistCount > 0,
                    label: Text('$wishlistCount'),
                    backgroundColor: AppColors.rose,
                    child: const Icon(Icons.favorite_outline_rounded),
                  ),
                  activeIcon: Badge(
                    isLabelVisible: wishlistCount > 0,
                    label: Text('$wishlistCount'),
                    backgroundColor: AppColors.rose,
                    child: const Icon(Icons.favorite_rounded, color: AppColors.rose),
                  ),
                  label: 'Wishlist',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    isLabelVisible: cartCount > 0,
                    label: Text('$cartCount'),
                    backgroundColor: AppColors.rose,
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                  activeIcon: Badge(
                    isLabelVisible: cartCount > 0,
                    label: Text('$cartCount'),
                    backgroundColor: AppColors.rose,
                    child: const Icon(Icons.shopping_bag_rounded),
                  ),
                  label: 'Bag',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
