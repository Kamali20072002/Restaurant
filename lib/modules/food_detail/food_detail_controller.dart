import 'package:get/get.dart';
import '../../data/models/food_model.dart';

class FoodDetailController extends GetxController {

  // Food passed from home screen
  late final FoodModel food;

  // Quantity
  final RxInt quantity = 1.obs;

  // Selected size index
  final RxInt selectedSize = 1.obs;

  // Selected spice index
  final RxInt selectedSpice = 0.obs;

  // Favourite toggle
  final RxBool isFavourite = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get food passed as argument from navigation
    food = Get.arguments as FoodModel;
  }

  void increment() {
    if (quantity.value < 10) quantity.value++;
  }

  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectSize(int index) {
    selectedSize.value = index;
  }

  void selectSpice(int index) {
    selectedSpice.value = index;
  }

  void toggleFavourite() {
    isFavourite.value = !isFavourite.value;
  }

  // Price multiplier based on size
  double get sizeMultiplier {
    switch (selectedSize.value) {
      case 0: return 0.85;
      case 1: return 1.0;
      case 2: return 1.3;
      default: return 1.0;
    }
  }

  double get unitPrice => food.price * sizeMultiplier;

  double get totalPrice => unitPrice * quantity.value;

  String get formattedTotal =>
      '₹${totalPrice.toStringAsFixed(2)}';

  String get formattedUnit =>
      '₹${unitPrice.toStringAsFixed(2)}';
}