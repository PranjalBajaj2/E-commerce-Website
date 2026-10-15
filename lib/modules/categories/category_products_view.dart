import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/product_card.dart';

enum SortCriteria { featured, priceAsc, priceDesc, rating }

class CategoryProductsController extends GetxController {
  final ProductRepository _productRepo = Get.find<ProductRepository>();
  late final CategoryModel category;

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final Rx<SortCriteria> currentSort = SortCriteria.featured.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is CategoryModel) {
      category = args;
    } else {
      category = const CategoryModel(id: 'all', name: 'All Products', slug: 'all');
    }
    loadCategoryProducts();
  }

  Future<void> loadCategoryProducts() async {
    isLoading.value = true;
    try {
      final list = await _productRepo.getProducts(
        categoryId: category.id == 'all' ? null : category.id,
      );
      products.assignAll(list);
      _applySort();
    } finally {
      isLoading.value = false;
    }
  }

  void setSort(SortCriteria sort) {
    currentSort.value = sort;
    _applySort();
  }

  void _applySort() {
    switch (currentSort.value) {
      case SortCriteria.featured:
        // Default order
        break;
      case SortCriteria.priceAsc:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortCriteria.priceDesc:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortCriteria.rating:
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
  }
}

class CategoryProductsView extends StatelessWidget {
  const CategoryProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryProductsController());

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(controller.category.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Get.toNamed('/search'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Sort bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    '${controller.products.length} Products',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                // Sort Menu
                Obx(
                  () => PopupMenuButton<SortCriteria>(
                    initialValue: controller.currentSort.value,
                    onSelected: controller.setSort,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sort_rounded, size: 16, color: AppColors.charcoal),
                          const SizedBox(width: 6),
                          Text(
                            _getSortLabel(controller.currentSort.value),
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.charcoal,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                        ],
                      ),
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: SortCriteria.featured,
                        child: Text('Featured'),
                      ),
                      const PopupMenuItem(
                        value: SortCriteria.priceAsc,
                        child: Text('Price: Low to High'),
                      ),
                      const PopupMenuItem(
                        value: SortCriteria.priceDesc,
                        child: Text('Price: High to Low'),
                      ),
                      const PopupMenuItem(
                        value: SortCriteria.rating,
                        child: Text('Highest Rated'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Product Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.charcoal),
                  ),
                );
              }

              if (controller.products.isEmpty) {
                return const EmptyStateView(
                  icon: Icons.inventory_2_outlined,
                  title: 'No Products Found',
                  message: 'There are currently no products available in this category.',
                );
              }

              return RefreshIndicator(
                color: AppColors.charcoal,
                backgroundColor: AppColors.white,
                onRefresh: controller.loadCategoryProducts,
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.64,
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return ProductCard(product: product);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(SortCriteria sort) {
    switch (sort) {
      case SortCriteria.featured:
        return 'Featured';
      case SortCriteria.priceAsc:
        return 'Price: Low';
      case SortCriteria.priceDesc:
        return 'Price: High';
      case SortCriteria.rating:
        return 'Top Rated';
    }
  }
}
