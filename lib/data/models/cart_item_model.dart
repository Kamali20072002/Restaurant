import 'food_model.dart';

class CartItemModel {
  final FoodModel food;
  final int quantity;
  final String selectedSize;
  final String selectedSpice;

  const CartItemModel({
    required this.food,
    required this.quantity,
    required this.selectedSize,
    required this.selectedSpice,
  });

  double get totalPrice => food.price * quantity;

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      food: food,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize,
      selectedSpice: selectedSpice,
    );
  }
}