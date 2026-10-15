import 'package:get/get.dart';
import '../../app/theme/theme_controller.dart';
import '../../data/models/user_model.dart';
import '../auth/auth_controller.dart';
import '../orders/orders_controller.dart';
import '../wishlist/wishlist_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final WishlistController wishlistController = Get.find<WishlistController>();
  final ThemeController themeController = Get.find<ThemeController>();

  UserModel? get currentUser => _authController.currentUser.value;
  bool get isLoggedIn => _authController.isLoggedIn.value;

  int get orderCount {
    if (Get.isRegistered<OrdersController>()) {
      return Get.find<OrdersController>().orders.length;
    }
    return 2; // initial mock count
  }

  void logout() {
    _authController.logout();
  }
}
