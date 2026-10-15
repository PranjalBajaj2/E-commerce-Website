import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/widgets/network_image_with_fallback.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/section_header.dart';
import '../auth/auth_controller.dart';
import '../cart/cart_controller.dart';
import '../main/navigation_controller.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final authController = Get.find<AuthController>();
    final cartController = Get.find<CartController>();
    final navController = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.charcoal,
          backgroundColor: AppColors.white,
          onRefresh: () => homeController.loadHomeData(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Top Bar with Greeting and Cart Badge
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppConstants.appName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3.0,
                              color: AppColors.charcoal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Obx(() {
                            final user = authController.currentUser.value;
                            final name = user != null ? user.name.split(' ').first : 'Curator';
                            return Text(
                              'Welcome back, $name',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          // Search shortcut button
                          IconButton(
                            onPressed: () => Get.toNamed('/search'),
                            icon: const Icon(
                              Icons.search_rounded,
                              size: 24,
                              color: AppColors.charcoal,
                            ),
                          ),
                          // Cart shortcut button with badge
                          Obx(() {
                            final count = cartController.totalItemCount;
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => navController.goToCart(),
                                  icon: const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 24,
                                    color: AppColors.charcoal,
                                  ),
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
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
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
                    ],
                  ),
                ),
              ),

              // Search Bar Trigger
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: GestureDetector(
                    onTap: () => Get.toNamed('/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(color: AppColors.border, width: 1),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Search timeless furniture, audio, lighting...',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          Icon(Icons.tune_rounded, color: AppColors.textMuted, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Promotional Banner Carousel
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: _buildBannerCarousel(context, homeController),
                ),
              ),

              // Categories Shortcuts
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: 'Shop by Category',
                        subtitle: 'Intentional craftsmanship for every room',
                        actionText: 'View All',
                        onActionTap: () => navController.goToCategories(),
                      ),
                      _buildCategoriesList(homeController),
                    ],
                  ),
                ),
              ),

              // Featured / Editorial Collection
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: 'Curated Essentials',
                        subtitle: 'Hand-picked for distinctive character',
                        actionText: 'Explore',
                        onActionTap: () => navController.goToCategories(),
                      ),
                      _buildHorizontalProductsList(homeController.featuredProducts),
                    ],
                  ),
                ),
              ),

              // Best Sellers Grid Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SectionHeader(
                    title: 'Best Sellers',
                    subtitle: 'Our community’s most celebrated designs',
                    actionText: 'See All',
                    onActionTap: () => navController.goToCategories(),
                  ),
                ),
              ),

              // Best Sellers Grid
              Obx(() {
                if (homeController.isLoading.value) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.charcoal),
                        ),
                      ),
                    ),
                  );
                }

                final products = homeController.bestSellers;
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.64,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                      childCount: products.length,
                    ),
                  ),
                );
              }),

              // New Arrivals Header
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'New Arrivals',
                  subtitle: 'Recently inducted to the collection',
                  actionText: 'Browse',
                  onActionTap: () => navController.goToCategories(),
                ),
              ),

              // New Arrivals Grid
              Obx(() {
                final products = homeController.newArrivals;
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.64,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                      childCount: products.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(BuildContext context, HomeController controller) {
    final banners = controller.promoBanners;

    return Column(
      children: [
        SizedBox(
          height: 195,
          child: PageView.builder(
            itemCount: banners.length,
            onPageChanged: controller.updateBannerIndex,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        NetworkImageWithFallback(
                          imageUrl: banner.imageUrl,
                          fit: BoxFit.cover,
                        ),
                        // Gradient Overlay for readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.charcoal.withAlpha(220),
                                AppColors.charcoal.withAlpha(120),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.rose,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  banner.badge,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                banner.title,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                banner.subtitle,
                                style: const TextStyle(
                                  color: AppColors.linen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  final cartController = Get.find<CartController>();
                                  cartController.applyPromoCode(banner.promoCode);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Use code ${banner.promoCode}',
                                        style: const TextStyle(
                                          color: AppColors.charcoal,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 12,
                                        color: AppColors.charcoal,
                                      ),
                                    ],
                                  ),
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
        const SizedBox(height: 10),
        // Dots
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: controller.currentBannerIndex.value == i ? 18 : 5,
                decoration: BoxDecoration(
                  color: controller.currentBannerIndex.value == i
                      ? AppColors.charcoal
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesList(HomeController controller) {
    return Obx(() {
      final categories = controller.categories;
      return SizedBox(
        height: 48,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ActionChip(
                backgroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                label: Text(
                  cat.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
                onPressed: () {
                  Get.toNamed('/category-products', arguments: cat);
                },
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildHorizontalProductsList(RxList<dynamic> products) {
    return Obx(() {
      if (products.isEmpty) {
        return const SizedBox(height: 250);
      }
      return SizedBox(
        height: 275,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                width: 175,
                child: ProductCard(product: p),
              ),
            );
          },
        ),
      );
    });
  }
}
