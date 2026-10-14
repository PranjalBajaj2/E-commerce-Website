import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../view_models/ecommerce_view_model.dart';
import '../widgets/app_image.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  final EcommerceViewModel viewModel;

  const HomeScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mobile Search Bar (only shown when screen is narrow)
                if (MediaQuery.sizeOf(context).width < 800)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      onChanged: (val) {
                        viewModel.setSearchQuery(val);
                        viewModel.navigateTo(AppPage.shop);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: Icon(Icons.search, size: 20),
                      ),
                    ),
                  ),

                // Hero Section
                _buildHero(context),

                const SizedBox(height: 48),

                // Shop by Category
                _buildCategories(context),

                const SizedBox(height: 48),

                // Featured Products Header
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Arrivals',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Carefully curated tech and essentials',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => viewModel.navigateTo(AppPage.shop),
                      icon: const Text(
                        'View All',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      label: const Icon(Icons.arrow_forward_rounded, size: 14),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Featured Products Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    int crossAxisCount;
                    double childAspectRatio;

                    if (width > 900) {
                      crossAxisCount = 3;
                      childAspectRatio = 0.75;
                    } else if (width > 550) {
                      crossAxisCount = 2;
                      childAspectRatio = 0.70;
                    } else if (width > 340) {
                      crossAxisCount = 2;
                      childAspectRatio = 0.62;
                    } else {
                      crossAxisCount = 1;
                      childAspectRatio = 1.05;
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.featuredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final product = viewModel.featuredProducts[index];
                        return ProductCard(
                          product: product,
                          viewModel: viewModel,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 50),

                // Newsletter / Promo Banner
                _buildPromoBanner(context),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 850;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundSubtle,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  flex: 11,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: _buildHeroContent(context, isDesktop),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: SizedBox(
                    height: 360,
                    child: AppImage(
                      src: 'assets/hero.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: AppImage(
                    src: 'assets/hero.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildHeroContent(context, isDesktop),
                ),
              ],
            ),
    );
  }

  Widget _buildHeroContent(BuildContext context, bool isDesktop) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt, color: AppTheme.primary, size: 14),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Limited Edition Release',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Experience Pure Sound with Lumina Pro',
          style: TextStyle(
            fontSize: isDesktop ? 30 : (screenWidth < 380 ? 20 : 24),
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'The next generation of noise-canceling technology, designed for comfort and acoustic precision.',
          style: TextStyle(
            fontSize: isDesktop ? 14 : 13,
            color: AppTheme.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => viewModel.navigateTo(AppPage.shop),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'Shop Collection',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      {
        'title': 'Wearables',
        'subtitle': 'Smart Tech',
        'category': 'Wearables',
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800',
      },
      {
        'title': 'Audio & Sound',
        'subtitle': 'High Fidelity',
        'category': 'Audio',
        'image':
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=800',
      },
      {
        'title': 'Smart Home',
        'subtitle': 'Aura Collection',
        'category': 'Home',
        'image':
            'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=800',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shop by Category',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: isWide ? 1.4 : 2.5,
              ),
              itemBuilder: (context, index) {
                final cat = categories[index];
                return InkWell(
                  onTap: () {
                    viewModel.setSelectedCategory(cat['category']!);
                    viewModel.navigateTo(AppPage.shop);
                  },
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(color: AppTheme.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppImage(
                          src: cat['image']!,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withAlpha(200),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 14,
                          left: 14,
                          right: 14,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                cat['subtitle']!,
                                style: TextStyle(
                                  color: Colors.white.withAlpha(200),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 650;

        return Container(
          padding: EdgeInsets.all(isWide ? 28 : 20),
          decoration: BoxDecoration(
            color: AppTheme.textPrimary,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: isWide
              ? Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join the Lumina Collective',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Get 15% off your first order plus exclusive access to future releases.',
                            style: TextStyle(
                              color: AppTheme.secondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.navigateTo(AppPage.shop),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.textPrimary,
                      ),
                      child: const Text('Explore Now'),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Join the Lumina Collective',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Get 15% off your first order plus exclusive access to future releases.',
                      style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => viewModel.navigateTo(AppPage.shop),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.textPrimary,
                        ),
                        child: const Text('Explore Now'),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
