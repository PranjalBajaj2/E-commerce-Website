import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../view_models/ecommerce_view_model.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/wishlist_screen.dart';
import 'widgets/app_navbar.dart';

class MainShell extends StatelessWidget {
  final EcommerceViewModel viewModel;

  const MainShell({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final isMobile = screenWidth < 600;

        return Scaffold(
          appBar: AppNavbar(viewModel: viewModel),
          body: Column(
            children: [
              Expanded(
                child: _buildCurrentScreen(),
              ),
              _buildFooter(context),
            ],
          ),
          bottomNavigationBar: isMobile ? _buildBottomBar() : null,
        );
      },
    );
  }

  Widget _buildCurrentScreen() {
    switch (viewModel.currentPage) {
      case AppPage.home:
        return HomeScreen(viewModel: viewModel);
      case AppPage.shop:
        return ShopScreen(viewModel: viewModel);
      case AppPage.detail:
        return ProductDetailScreen(viewModel: viewModel);
      case AppPage.cart:
        return CartScreen(viewModel: viewModel);
      case AppPage.confirmation:
        return OrderConfirmationScreen(viewModel: viewModel);
      case AppPage.wishlist:
        return WishlistScreen(viewModel: viewModel);
    }
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: NavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedIndex: _getSelectedIndex(),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              viewModel.navigateTo(AppPage.home);
              break;
            case 1:
              viewModel.navigateTo(AppPage.shop);
              break;
            case 2:
              viewModel.navigateTo(AppPage.wishlist);
              break;
            case 3:
              viewModel.navigateTo(AppPage.cart);
              break;
          }
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppTheme.primary),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded, color: AppTheme.primary),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: viewModel.wishlist.isNotEmpty,
              label: Text('${viewModel.wishlist.length}'),
              child: const Icon(Icons.favorite_outline),
            ),
            selectedIcon: Badge(
              isLabelVisible: viewModel.wishlist.isNotEmpty,
              label: Text('${viewModel.wishlist.length}'),
              child: const Icon(Icons.favorite, color: AppTheme.danger),
            ),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: viewModel.totalCartItemCount > 0,
              label: Text('${viewModel.totalCartItemCount}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: viewModel.totalCartItemCount > 0,
              label: Text('${viewModel.totalCartItemCount}'),
              child: const Icon(Icons.shopping_bag, color: AppTheme.primary),
            ),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex() {
    switch (viewModel.currentPage) {
      case AppPage.home:
        return 0;
      case AppPage.shop:
      case AppPage.detail:
        return 1;
      case AppPage.wishlist:
        return 2;
      case AppPage.cart:
      case AppPage.confirmation:
        return 3;
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundSubtle,
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: const Center(
        child: Text(
          '© 2026 LUMINA Technologies Inc. Clean design, seamless shopping.',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
