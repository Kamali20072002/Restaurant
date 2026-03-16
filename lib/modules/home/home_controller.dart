import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/food_model.dart';
import '../../data/models/restaurant_model.dart';

class HomeController extends GetxController {

  // Selected category index
  final RxInt selectedCategory = 0.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // All data from dummy
  final List<String> categories = DummyData.categories;
  final List<RestaurantModel> allRestaurants = DummyData.restaurants;

  // Filtered food list — reacts to category change
  List<FoodModel> get filteredFoods {
    final cat = categories[selectedCategory.value];
    if (cat == 'All') return DummyData.foods;
    return DummyData.foods
        .where((f) => f.category == cat)
        .toList();
  }

  // Popular foods always from all foods
  List<FoodModel> get popularFoods =>
      DummyData.foods.where((f) => f.isPopular).toList();

  void selectCategory(int index) {
    selectedCategory.value = index;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }
}