import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../cart/cart_controller.dart';
import '../wishlist/wishlist_controller.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _productRepo = Get.find<ProductRepository>();
  final CartController _cartController = Get.find<CartController>();
  final WishlistController _wishlistController = Get.find<WishlistController>();

  late final ProductModel product;
  final RxInt selectedImageIndex = 0.obs;
  final RxString selectedColor = ''.obs;
  final RxString selectedSize = ''.obs;
  final RxInt quantity = 1.obs;
  final RxList<ProductModel> relatedProducts = <ProductModel>[].obs;
  final RxBool isLoadingRelated = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      product = args;
      _initSelections();
      loadRelatedProducts();
    }
  }

  void _initSelections() {
    if (product.colors.isNotEmpty) {
      selectedColor.value = product.colors.first.name;
    }
    if (product.sizes.isNotEmpty) {
      selectedSize.value = product.sizes.first;
    }
  }

  Future<void> loadRelatedProducts() async {
    isLoadingRelated.value = true;
    try {
      final list = await _productRepo.getRelatedProducts(product.id, product.categoryId);
      relatedProducts.assignAll(list);
    } finally {
      isLoadingRelated.value = false;
    }
  }

  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  void selectColor(String colorName) {
    selectedColor.value = colorName;
  }

  void selectSize(String sizeName) {
    selectedSize.value = sizeName;
  }

  void updateQuantity(int val) {
    if (val >= 1 && val <= 99) {
      quantity.value = val;
    }
  }

  bool get isFavorite => _wishlistController.isFavorite(product.id);

  void toggleWishlist() {
    _wishlistController.toggleWishlist(product);
  }

  void addToCart() {
    _cartController.addToCart(
      product,
      quantity: quantity.value,
      selectedColor: selectedColor.value.isNotEmpty ? selectedColor.value : null,
      selectedSize: selectedSize.value.isNotEmpty ? selectedSize.value : null,
    );
  }

  void buyNow() {
    _cartController.addToCart(
      product,
      quantity: quantity.value,
      selectedColor: selectedColor.value.isNotEmpty ? selectedColor.value : null,
      selectedSize: selectedSize.value.isNotEmpty ? selectedSize.value : null,
    );
    Get.toNamed('/checkout');
  }
}
