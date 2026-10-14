import 'package:flutter/material.dart';
import '../data/repositories/product_repository.dart';
import '../domain/models/cart_item.dart';
import '../domain/models/product.dart';

enum AppPage {
  home,
  shop,
  detail,
  cart,
  confirmation,
  wishlist,
}

enum SortOption {
  newest,
  priceLowHigh,
  priceHighLow,
  topRated,
}

class EcommerceViewModel extends ChangeNotifier {
  final ProductRepository _repository;

  EcommerceViewModel({ProductRepository? repository})
      : _repository = repository ?? ProductRepository() {
    _loadInitialData();
  }

  AppPage _currentPage = AppPage.home;
  AppPage get currentPage => _currentPage;

  List<Product> _allProducts = [];
  List<Product> get allProducts => _allProducts;

  List<String> _categories = [];
  List<String> get categories => _categories;

  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;

  int _selectedColorIndex = 0;
  int get selectedColorIndex => _selectedColorIndex;

  final List<CartItem> _cart = [];
  List<CartItem> get cart => List.unmodifiable(_cart);

  final Set<int> _wishlist = {};
  Set<int> get wishlist => Set.unmodifiable(_wishlist);

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  SortOption _selectedSort = SortOption.newest;
  SortOption get selectedSort => _selectedSort;

  bool _isCheckingOut = false;
  bool get isCheckingOut => _isCheckingOut;

  void _loadInitialData() {
    _allProducts = _repository.getProducts();
    _categories = _repository.getCategories();
    notifyListeners();
  }

  // Navigation
  void navigateTo(AppPage page, {Product? product}) {
    _currentPage = page;
    if (product != null) {
      _selectedProduct = product;
      _selectedColorIndex = 0;
    }
    notifyListeners();
  }

  void selectProduct(Product product) {
    _selectedProduct = product;
    _selectedColorIndex = 0;
    _currentPage = AppPage.detail;
    notifyListeners();
  }

  void setSelectedColorIndex(int index) {
    _selectedColorIndex = index;
    notifyListeners();
  }

  // Search, Filter, Sort
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortOption(SortOption sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    var list = _allProducts.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    switch (_selectedSort) {
      case SortOption.newest:
        // Default order
        break;
      case SortOption.priceLowHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.topRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return list;
  }

  List<Product> get featuredProducts => _allProducts.take(3).toList();

  List<Product> get wishlistedProducts =>
      _allProducts.where((p) => _wishlist.contains(p.id)).toList();

  // Wishlist
  bool isWishlisted(int productId) => _wishlist.contains(productId);

  void toggleWishlist(int productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }

  // Cart operations
  int get totalCartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _cart.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.08;

  double get total => subtotal + tax;

  void addToCart(Product product, {int quantity = 1, int? colorValue}) {
    final effectiveColor = colorValue ??
        (product.availableColorValues.isNotEmpty ? product.availableColorValues.first : 0xFF000000);

    final index = _cart.indexWhere((item) =>
        item.product.id == product.id && item.selectedColor == effectiveColor);

    if (index >= 0) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(CartItem(
        product: product,
        quantity: quantity,
        selectedColor: effectiveColor,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(int productId, int selectedColor, int delta) {
    final index = _cart.indexWhere((item) =>
        item.product.id == productId && item.selectedColor == selectedColor);
    if (index >= 0) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(int productId, int selectedColor) {
    _cart.removeWhere((item) =>
        item.product.id == productId && item.selectedColor == selectedColor);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<void> checkout() async {
    if (_cart.isEmpty) return;
    _isCheckingOut = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1400));

    _cart.clear();
    _isCheckingOut = false;
    _currentPage = AppPage.confirmation;
    notifyListeners();
  }
}
