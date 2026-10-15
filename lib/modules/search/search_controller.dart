import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/services/storage_service.dart';
import '../categories/category_products_view.dart';

class SearchViewController extends GetxController {
  final ProductRepository _productRepo = Get.find<ProductRepository>();
  final StorageService _storage = Get.find<StorageService>();

  final TextEditingController textController = TextEditingController();
  final RxString query = ''.obs;
  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<SortCriteria> currentSort = SortCriteria.featured.obs;

  final List<String> trendingKeywords = const [
    'Headphones',
    'Titanium',
    'Lamp',
    'Leather',
    'Ceramic',
    'Keyboard',
    'Speaker',
    'Oak',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void _loadRecentSearches() {
    final list = _storage.getStringList(AppConstants.keyRecentSearches);
    recentSearches.assignAll(list);
  }

  Future<void> _saveRecentSearches() async {
    await _storage.setStringList(AppConstants.keyRecentSearches, recentSearches);
  }

  void onQueryChanged(String val) {
    query.value = val;
    if (val.trim().isEmpty) {
      searchResults.clear();
    } else {
      executeSearch(val);
    }
  }

  Future<void> executeSearch(String keyword) async {
    final clean = keyword.trim();
    if (clean.isEmpty) return;

    query.value = clean;
    textController.text = clean;
    isLoading.value = true;

    // Add to recent searches
    recentSearches.remove(clean);
    recentSearches.insert(0, clean);
    if (recentSearches.length > 8) {
      recentSearches.removeLast();
    }
    _saveRecentSearches();

    try {
      final list = await _productRepo.getProducts(searchQuery: clean);
      searchResults.assignAll(list);
      _applySort();
    } finally {
      isLoading.value = false;
    }
  }

  void removeRecentSearch(String item) {
    recentSearches.remove(item);
    _saveRecentSearches();
  }

  void clearRecentSearches() {
    recentSearches.clear();
    _saveRecentSearches();
  }

  void setSort(SortCriteria sort) {
    currentSort.value = sort;
    _applySort();
  }

  void _applySort() {
    switch (currentSort.value) {
      case SortCriteria.featured:
        break;
      case SortCriteria.priceAsc:
        searchResults.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortCriteria.priceDesc:
        searchResults.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortCriteria.rating:
        searchResults.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
  }
}
