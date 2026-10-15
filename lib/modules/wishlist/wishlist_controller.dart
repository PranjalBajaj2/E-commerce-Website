import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/services/storage_service.dart';

class WishlistController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final ProductRepository _productRepo = Get.find<ProductRepository>();

  final RxSet<String> wishlistIds = <String>{}.obs;
  final RxList<ProductModel> wishlistProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final saved = _storage.getStringList(AppConstants.keyWishlist);
    wishlistIds.addAll(saved);
    loadWishlistProducts();
  }

  Future<void> _saveToStorage() async {
    await _storage.setStringList(AppConstants.keyWishlist, wishlistIds.toList());
  }

  Future<void> loadWishlistProducts() async {
    isLoading.value = true;
    try {
      final all = await _productRepo.getProducts();
      final filtered = all.where((p) => wishlistIds.contains(p.id)).toList();
      wishlistProducts.assignAll(filtered);
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(String productId) {
    return wishlistIds.contains(productId);
  }

  void toggleWishlist(ProductModel product) {
    if (wishlistIds.contains(product.id)) {
      wishlistIds.remove(product.id);
      wishlistProducts.removeWhere((p) => p.id == product.id);
      _saveToStorage();
      Get.snackbar(
        'Removed from Wishlist',
        '${product.name} removed from your saved items.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.charcoal,
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      wishlistIds.add(product.id);
      if (!wishlistProducts.any((p) => p.id == product.id)) {
        wishlistProducts.insert(0, product);
      }
      _saveToStorage();
      Get.snackbar(
        'Saved to Wishlist',
        '${product.name} added to your favorites.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.rose,
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void removeFromWishlist(String productId) {
    wishlistIds.remove(productId);
    wishlistProducts.removeWhere((p) => p.id == productId);
    _saveToStorage();
  }

  void clearWishlist() {
    wishlistIds.clear();
    wishlistProducts.clear();
    _saveToStorage();
  }
}
