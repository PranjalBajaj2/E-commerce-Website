import 'package:get/get.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/product_repository.dart';

class CategoriesController extends GetxController {
  final ProductRepository _productRepo = Get.find<ProductRepository>();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final list = await _productRepo.getCategories();
      categories.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }
}
