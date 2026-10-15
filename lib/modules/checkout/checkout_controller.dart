import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/address_model.dart';
import '../auth/auth_controller.dart';
import '../cart/cart_controller.dart';
import '../orders/orders_controller.dart';

class DeliveryOption {
  final String title;
  final String estimatedDays;
  final double fee;
  final String description;

  const DeliveryOption({
    required this.title,
    required this.estimatedDays,
    required this.fee,
    required this.description,
  });
}

class CheckoutController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final CartController cartController = Get.find<CartController>();
  final OrdersController ordersController = Get.find<OrdersController>();

  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  final RxInt selectedDeliveryIndex = 0.obs;
  final RxString selectedPaymentMethod = 'Credit Card (Visa ending 4242)'.obs;
  final RxBool isPlacingOrder = false.obs;

  List<DeliveryOption> get deliveryOptions {
    final isFreeStandard = cartController.subtotal >= AppConstants.freeShippingThreshold;
    return [
      DeliveryOption(
        title: 'Standard Carbon-Neutral',
        estimatedDays: '3-5 business days',
        fee: isFreeStandard ? 0.0 : AppConstants.standardShippingFee,
        description: isFreeStandard ? 'Free with order over \$150' : '\$5.00 flat rate',
      ),
      const DeliveryOption(
        title: 'Express Priority Courier',
        estimatedDays: '1-2 business days',
        fee: 15.0,
        description: 'Direct air transport & real-time GPS tracking',
      ),
      const DeliveryOption(
        title: 'White-Glove In-Home Placement',
        estimatedDays: '3-5 business days',
        fee: 45.0,
        description: 'Room of choice delivery, unboxing & packaging recycling',
      ),
    ];
  }

  DeliveryOption get currentDelivery => deliveryOptions[selectedDeliveryIndex.value];

  double get deliveryFee => currentDelivery.fee;

  double get finalTotal =>
      cartController.subtotal - cartController.discount + deliveryFee + cartController.tax;

  @override
  void onInit() {
    super.onInit();
    _initAddress();
  }

  void _initAddress() {
    final user = _authController.currentUser.value;
    if (user != null && user.addresses.isNotEmpty) {
      selectedAddress.value = user.defaultAddress;
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  void selectDelivery(int index) {
    selectedDeliveryIndex.value = index;
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> submitOrder() async {
    if (cartController.items.isEmpty) {
      Get.snackbar(
        'Empty Bag',
        'Please add items to your shopping bag before proceeding.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (selectedAddress.value == null) {
      Get.snackbar(
        'Missing Shipping Address',
        'Please select or add a valid shipping address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isPlacingOrder.value = true;
    try {
      // Simulate realistic authorization delay
      await Future.delayed(const Duration(milliseconds: 900));

      final createdOrder = await ordersController.placeOrder(
        shippingAddress: selectedAddress.value!,
        deliveryMethod: '${currentDelivery.title} (${currentDelivery.estimatedDays})',
        deliveryFee: deliveryFee,
        paymentMethod: selectedPaymentMethod.value,
      );

      Get.offNamed('/order-confirmation', arguments: createdOrder);
    } finally {
      isPlacingOrder.value = false;
    }
  }
}
