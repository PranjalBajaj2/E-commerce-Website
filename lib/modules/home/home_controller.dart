import 'package:get/get.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class PromoBanner {
  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final String imageUrl;
  final String promoCode;

  const PromoBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.imageUrl,
    required this.promoCode,
  });
}

class HomeController extends GetxController {
  final ProductRepository _productRepo = Get.find<ProductRepository>();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxList<ProductModel> newArrivals = <ProductModel>[].obs;
  final RxList<ProductModel> bestSellers = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt currentBannerIndex = 0.obs;

  final List<PromoBanner> promoBanners = const [
    PromoBanner(
      id: 'banner-1',
      title: 'Spring Equinox\nCollection',
      subtitle: 'Minimalist warmth for your sanctuary.',
      badge: 'SEASON SPECIAL',
      imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=1200',
      promoCode: 'SPRING25',
    ),
    PromoBanner(
      id: 'banner-2',
      title: 'Acoustic Purity\nStudio Grade',
      subtitle: 'Explore planar magnetic & ANC sound.',
      badge: 'AUDIO LAB',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1200',
      promoCode: 'LUMINA20',
    ),
    PromoBanner(
      id: 'banner-3',
      title: 'Tactile Workspaces\nEngineered',
      subtitle: 'Ergonomic mechanical precision.',
      badge: 'LIMITED RUN',
      imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?q=80&w=1200',
      promoCode: 'LUMINA10',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _productRepo.getCategories(),
        _productRepo.getFeaturedProducts(),
        _productRepo.getNewArrivals(),
        _productRepo.getBestSellers(),
      ]);

      categories.assignAll(results[0] as List<CategoryModel>);
      featuredProducts.assignAll(results[1] as List<ProductModel>);
      newArrivals.assignAll(results[2] as List<ProductModel>);
      bestSellers.assignAll(results[3] as List<ProductModel>);
    } finally {
      isLoading.value = false;
    }
  }

  void updateBannerIndex(int index) {
    currentBannerIndex.value = index;
  }
}
