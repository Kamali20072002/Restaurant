import 'package:get/get.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/food_model.dart';
import '../../routes/app_routes.dart';

class CartController extends GetxController {

  // Cart items list
  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  // Promo code
  final RxString promoCode = ''.obs;
  final RxBool promoApplied = false.obs;
  final RxString promoError = ''.obs;

  // Valid promo codes
  final Map<String, double> _promoCodes = {
    'NIGHT30': 0.30,
    'FIRST10': 0.10,
    'SAVE20':  0.20,
  };

  // ── Cart operations

  void addItem(FoodModel food, int quantity, String size, String spice) {
    // Check if same food + size + spice already in cart
    final existingIndex = items.indexWhere(
      (item) =>
          item.food.id == food.id &&
          item.selectedSize == size &&
          item.selectedSpice == spice,
    );

    if (existingIndex != -1) {
      // Update quantity
      final existing = items[existingIndex];
      items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      items.add(CartItemModel(
        food: food,
        quantity: quantity,
        selectedSize: size,
        selectedSpice: spice,
      ));
    }

    items.refresh();
  }

  void removeItem(int index) {
    items.removeAt(index);
  }

  void incrementItem(int index) {
    if (items[index].quantity < 10) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + 1,
      );
      items.refresh();
    }
  }

  void decrementItem(int index) {
    if (items[index].quantity > 1) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity - 1,
      );
      items.refresh();
    } else {
      removeItem(index);
    }
  }

  void clearCart() => items.clear();

  // ── Promo code

  void applyPromo(String code) {
    final upper = code.trim().toUpperCase();
    if (_promoCodes.containsKey(upper)) {
      promoCode.value   = upper;
      promoApplied.value = true;
      promoError.value  = '';
    } else {
      promoApplied.value = false;
      promoError.value  = 'Invalid promo code';
    }
  }

  void removePromo() {
    promoCode.value    = '';
    promoApplied.value = false;
    promoError.value   = '';
  }

  // ── Price calculations

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  double get discountAmount {
    if (!promoApplied.value) return 0;
    final rate = _promoCodes[promoCode.value] ?? 0;
    return subtotal * rate;
  }

  double get discountPercent {
    if (!promoApplied.value) return 0;
    return (_promoCodes[promoCode.value] ?? 0) * 100;
  }

  double get deliveryFee => subtotal > 200 ? 0 : 49;

  double get taxes => (subtotal - discountAmount) * 0.05;

  double get total => subtotal - discountAmount + deliveryFee + taxes;

  // ── Helpers

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  String fmt(double val) => '₹${val.toStringAsFixed(2)}';

  // ── Navigation

  void goToTracking() {
    Get.offAllNamed(AppRoutes.orderTracking);
  }
}