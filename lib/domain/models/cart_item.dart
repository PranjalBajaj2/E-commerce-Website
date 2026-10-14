import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final int selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    int? selectedColor,
  }) : selectedColor = selectedColor ?? (product.availableColorValues.isNotEmpty ? product.availableColorValues.first : 0xFF000000);

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    int? selectedColor,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
