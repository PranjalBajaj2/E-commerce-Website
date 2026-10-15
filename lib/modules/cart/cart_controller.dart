import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../data/services/storage_service.dart';

class CartController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final RxList<CartItemModel> items = <CartItemModel>[].obs;
  final RxString appliedPromoCode = ''.obs;
  final RxDouble discountPercentage = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCart();
  }

  void _loadCart() {
    final raw = _storage.getJsonList(AppConstants.keyCart);
    if (raw.isNotEmpty) {
      items.assignAll(raw.map((e) => CartItemModel.fromJson(e)).toList());
    }
  }

  Future<void> _saveCart() async {
    await _storage.setJsonList(
      AppConstants.keyCart,
      items.map((i) => i.toJson()).toList(),
    );
  }

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shippingFee {
    if (items.isEmpty) return 0.0;
    if (subtotal >= AppConstants.freeShippingThreshold) return 0.0;
    return AppConstants.standardShippingFee;
  }

  double get discount => subtotal * discountPercentage.value;

  double get tax {
    if (items.isEmpty) return 0.0;
    final taxable = subtotal - discount;
    return taxable > 0 ? taxable * AppConstants.estimatedTaxRate : 0.0;
  }

  double get total {
    if (items.isEmpty) return 0.0;
    final val = subtotal - discount + shippingFee + tax;
    return val > 0 ? val : 0.0;
  }

  bool get qualifiesForFreeShipping =>
      subtotal >= AppConstants.freeShippingThreshold && items.isNotEmpty;

  double get remainingForFreeShipping {
    if (qualifiesForFreeShipping || items.isEmpty) return 0.0;
    return AppConstants.freeShippingThreshold - subtotal;
  }

  void addToCart(
    ProductModel product, {
    int quantity = 1,
    String? selectedColor,
    String? selectedSize,
  }) {
    final color = selectedColor ?? (product.colors.isNotEmpty ? product.colors.first.name : null);
    final size = selectedSize ?? (product.sizes.isNotEmpty ? product.sizes.first : null);
    final itemId = '${product.id}_${color ?? ""}_${size ?? ""}';

    final existingIndex = items.indexWhere((i) => i.id == itemId);

    if (existingIndex >= 0) {
      final current = items[existingIndex];
      items[existingIndex] = current.copyWith(quantity: current.quantity + quantity);
    } else {
      items.add(
        CartItemModel(
          id: itemId,
          product: product,
          quantity: quantity,
          selectedColor: color,
          selectedSize: size,
        ),
      );
    }

    _saveCart();

    Get.snackbar(
      'Added to Bag',
      '${product.name} (x$quantity) added to your shopping bag.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.charcoal,
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      mainButton: TextButton(
        onPressed: () {
          // Navigate to cart tab or screen
          Get.toNamed('/cart');
        },
        child: const Text(
          'VIEW BAG',
          style: TextStyle(
            color: AppColors.rose,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = items.indexWhere((i) => i.id == itemId);
    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: newQuantity);
      _saveCart();
    }
  }

  void removeItem(String itemId) {
    final removed = items.firstWhereOrNull((i) => i.id == itemId);
    items.removeWhere((i) => i.id == itemId);
    _saveCart();

    if (removed != null) {
      Get.snackbar(
        'Item Removed',
        '${removed.product.name} removed from your bag.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.charcoalLight,
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void clearCart() {
    items.clear();
    appliedPromoCode.value = '';
    discountPercentage.value = 0.0;
    _saveCart();
  }

  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (AppConstants.activePromoCodes.containsKey(cleanCode)) {
      appliedPromoCode.value = cleanCode;
      discountPercentage.value = AppConstants.activePromoCodes[cleanCode]!;
      Get.snackbar(
        'Promo Applied!',
        'Code $cleanCode applied (${(discountPercentage.value * 100).toInt()}% off)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return true;
    } else {
      Get.snackbar(
        'Invalid Code',
        'Coupon "$code" is not valid. Try LUMINA10 or LUMINA20.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }
  }

  void removePromoCode() {
    appliedPromoCode.value = '';
    discountPercentage.value = 0.0;
  }
}
