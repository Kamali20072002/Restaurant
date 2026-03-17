import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/dummy/dummy_data.dart';
import '../../data/models/food_model.dart';
import '../../data/models/restaurant_model.dart';

enum SearchFilter { all, food, restaurant }

class NightBiteSearchController extends GetxController {
  final TextEditingController textCtrl  = TextEditingController();
  final FocusNode             focusNode = FocusNode();

  final RxString         query          = ''.obs;
  final Rx<SearchFilter> activeFilter   = SearchFilter.all.obs;
  final RxBool           isSearching    = false.obs;
  final RxList<String>   recentSearches = <String>[
    'Biryani', 'Pizza', 'Burger', 'Sushi',
  ].obs;

  final List<String> trendingSearches = [
    '🔥  Butter Chicken',
    '⭐  Margherita Pizza',
    '🌮  Tacos',
    '🍜  Ramen',
    '🍰  Chocolate Cake',
    '🥗  Caesar Salad',
  ];

  final List<String> filterChips = ['All', 'Food', 'Restaurants'];

  final List<FoodModel>       _allFoods       = DummyData.foods;
  final List<RestaurantModel> _allRestaurants = DummyData.restaurants;

  RxList<FoodModel>       foodResults       = <FoodModel>[].obs;
  RxList<RestaurantModel> restaurantResults = <RestaurantModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
    debounce(
      query,
      (_) => _runSearch(),
      time: const Duration(milliseconds: 300),
    );
  }

  void onQueryChanged(String val) {
    query.value       = val;
    isSearching.value = val.isNotEmpty;
  }

  void _runSearch() {
    if (query.value.isEmpty) {
      foodResults.clear();
      restaurantResults.clear();
      return;
    }
    final q = query.value.toLowerCase();
    foodResults.assignAll(
      _allFoods.where((f) =>
        f.name.toLowerCase().contains(q) ||
        f.description.toLowerCase().contains(q),
      ).toList(),
    );
    restaurantResults.assignAll(
      _allRestaurants.where((r) =>
        r.name.toLowerCase().contains(q) ||
        r.cuisine.toLowerCase().contains(q),
      ).toList(),
    );
  }

  void setFilter(SearchFilter f) => activeFilter.value = f;

  void selectRecent(String term) {
    textCtrl.text     = term;
    query.value       = term;
    isSearching.value = true;
    _runSearch();
  }

  void selectTrending(String term) {
    final clean       = term.replaceAll(RegExp(r'^\S+\s+'), '');
    textCtrl.text     = clean;
    query.value       = clean;
    isSearching.value = true;
    _runSearch();
  }

  void clearSearch() {
    textCtrl.clear();
    query.value       = '';
    isSearching.value = false;
    foodResults.clear();
    restaurantResults.clear();
    focusNode.requestFocus();
  }

  void saveSearch(String term) {
    if (term.isEmpty) return;
    recentSearches.remove(term);
    recentSearches.insert(0, term);
    if (recentSearches.length > 6) recentSearches.removeLast();
  }

  void removeRecent(String term) => recentSearches.remove(term);
  void clearAllRecent()          => recentSearches.clear();

  int get totalResults =>
      foodResults.length + restaurantResults.length;

  @override
  void onClose() {
    textCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }
}