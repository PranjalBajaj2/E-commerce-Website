import 'package:get/get.dart';
import '../../data/models/address_model.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import '../cart/cart_controller.dart';

class OrdersController extends GetxController {
  final OrderRepository _orderRepo = Get.find<OrderRepository>();
  final CartController _cartController = Get.find<CartController>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final list = await _orderRepo.getOrders();
      orders.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  Future<OrderModel> placeOrder({
    required AddressModel shippingAddress,
    required String deliveryMethod,
    required double deliveryFee,
    required String paymentMethod,
  }) async {
    final cartItems = List.from(_cartController.items);
    final subtotal = _cartController.subtotal;
    final discount = _cartController.discount;
    final tax = _cartController.tax;
    final total = subtotal - discount + deliveryFee + tax;

    final orderItems = cartItems.map((ci) {
      return OrderItemModel(
        productId: ci.product.id,
        productName: ci.product.name,
        productImage: ci.product.primaryImage,
        price: ci.product.price,
        quantity: ci.quantity,
        selectedColor: ci.selectedColor,
        selectedSize: ci.selectedSize,
      );
    }).toList();

    final orderId = 'LUM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final newOrder = OrderModel(
      id: orderId,
      orderNumber: orderId,
      createdAt: DateTime.now(),
      items: orderItems,
      subtotal: subtotal,
      shippingFee: deliveryFee,
      tax: tax,
      discount: discount,
      total: total,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      deliveryMethod: deliveryMethod,
      status: OrderStatus.processing,
      trackingNumber: 'TRK-${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}US',
    );

    final saved = await _orderRepo.createOrder(newOrder);
    orders.insert(0, saved);

    // Clear cart after placing order
    _cartController.clearCart();

    return saved;
  }
}
