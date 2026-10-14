import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../view_models/ecommerce_view_model.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final EcommerceViewModel viewModel;

  const AppNavbar({super.key, required this.viewModel});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 800;
    final isTablet = screenWidth >= 500 && screenWidth < 800;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              // Brand Logo
              InkWell(
                onTap: () => viewModel.navigateTo(AppPage.home),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'LUMINA',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar on Desktop
              if (isDesktop) ...[
                const SizedBox(width: 24),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          onChanged: (val) {
                            viewModel.setSearchQuery(val);
                            if (viewModel.currentPage != AppPage.shop) {
                              viewModel.navigateTo(AppPage.shop);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Search products, brands, categories...',
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 20,
                              color: AppTheme.textMuted,
                            ),
                            suffixIcon: viewModel.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16),
                                    onPressed: () => viewModel.setSearchQuery(''),
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ] else
                const Spacer(),

              // Navigation Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Collection link on desktop
                  if (isDesktop)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton.icon(
                        onPressed: () => viewModel.navigateTo(AppPage.shop),
                        icon: const Icon(Icons.grid_view_rounded, size: 18),
                        label: const Text(
                          'Collection',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: viewModel.currentPage == AppPage.shop
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),

                  // Wishlist Icon (shown on tablet and desktop)
                  if (isTablet || isDesktop)
                    IconButton(
                      tooltip: 'Wishlist',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => viewModel.navigateTo(AppPage.wishlist),
                      icon: Badge(
                        isLabelVisible: viewModel.wishlist.isNotEmpty,
                        label: Text('${viewModel.wishlist.length}'),
                        backgroundColor: AppTheme.danger,
                        child: Icon(
                          viewModel.currentPage == AppPage.wishlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: viewModel.currentPage == AppPage.wishlist
                              ? AppTheme.danger
                              : AppTheme.textPrimary,
                          size: 22,
                        ),
                      ),
                    ),

                  // Cart Icon (always visible)
                  IconButton(
                    tooltip: 'Cart',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => viewModel.navigateTo(AppPage.cart),
                    icon: Badge(
                      isLabelVisible: viewModel.totalCartItemCount > 0,
                      label: Text('${viewModel.totalCartItemCount}'),
                      backgroundColor: AppTheme.primary,
                      child: Icon(
                        viewModel.currentPage == AppPage.cart
                            ? Icons.shopping_cart
                            : Icons.shopping_cart_outlined,
                        color: viewModel.currentPage == AppPage.cart
                            ? AppTheme.primary
                            : AppTheme.textPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
