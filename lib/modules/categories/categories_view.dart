import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/widgets/network_image_with_fallback.dart';
import 'categories_controller.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController());

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Get.toNamed('/search'),
          ),
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

        final categories = controller.categories;

        return RefreshIndicator(
          color: AppColors.charcoal,
          backgroundColor: AppColors.white,
          onRefresh: controller.loadCategories,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/category-products', arguments: cat);
                  },
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (cat.imageUrl != null)
                            NetworkImageWithFallback(
                              imageUrl: cat.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          // Dark gradient overlay
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  AppColors.charcoal.withAlpha(210),
                                  AppColors.charcoal.withAlpha(120),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cat.name,
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${cat.itemCount} Curated Pieces',
                                        style: const TextStyle(
                                          color: AppColors.linen,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 18,
                                    color: AppColors.charcoal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
