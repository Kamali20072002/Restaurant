import '../../core/app_assets.dart';
import '../models/food_model.dart';
import '../models/restaurant_model.dart';

class DummyData {
  DummyData._();

  static const List<String> categories = [
    'All',
    'Pizza',
    'Sushi',
    'Burgers',
    'Biryani',
    'Desserts',
  ];

  static const List<FoodModel> foods = [
    FoodModel(
      id: 'f1',
      name: 'Spicy Ramen',
      category: 'All',
      imagePath: AppAssets.foodRamen,
      price: 12.99,
      rating: 4.8,
      deliveryMinutes: 20,
      isPopular: true,
    ),
    FoodModel(
      id: 'f2',
      name: 'Smash Burger',
      category: 'Burgers',
      imagePath: AppAssets.foodBurger,
      price: 10.99,
      rating: 4.7,
      deliveryMinutes: 18,
      isPopular: true,
    ),
    FoodModel(
      id: 'f3',
      name: 'Salmon Sushi',
      category: 'Sushi',
      imagePath: AppAssets.foodSushi,
      price: 16.99,
      rating: 4.9,
      deliveryMinutes: 25,
      isPopular: true,
    ),
    FoodModel(
      id: 'f4',
      name: 'Pepperoni Pizza',
      category: 'Pizza',
      imagePath: AppAssets.pizza,
      price: 13.99,
      rating: 4.6,
      deliveryMinutes: 22,
      isPopular: false,
    ),
    FoodModel(
      id: 'f5',
      name: 'Chicken Biryani',
      category: 'Biryani',
      imagePath: AppAssets.biryani,
      price: 11.99,
      rating: 4.8,
      deliveryMinutes: 30,
      isPopular: true,
    ),
    FoodModel(
      id: 'f6',
      name: 'Chocolate Lava',
      category: 'Desserts',
      imagePath: AppAssets.dessert,
      price: 7.99,
      rating: 4.9,
      deliveryMinutes: 15,
      isPopular: false,
    ),
  ];

  static const List<RestaurantModel> restaurants = [
    RestaurantModel(
      id: 'r1',
      name: 'Dark Kitchen Co.',
      cuisine: 'Asian Fusion',
      imagePath: AppAssets.foodRamen,
      rating: 4.9,
      deliveryMinutes: 20,
      deliveryFee: 'Free',
      isOpen: true,
    ),
    RestaurantModel(
      id: 'r2',
      name: 'Burger Noir',
      cuisine: 'American',
      imagePath: AppAssets.foodBurger,
      rating: 4.7,
      deliveryMinutes: 18,
      deliveryFee: '₹30',
      isOpen: true,
    ),
    RestaurantModel(
      id: 'r3',
      name: 'Sushi Midnight',
      cuisine: 'Japanese',
      imagePath: AppAssets.foodSushi,
      rating: 4.8,
      deliveryMinutes: 25,
      deliveryFee: 'Free',
      isOpen: false,
    ),
    RestaurantModel(
      id: 'r4',
      name: 'Pizza Underground',
      cuisine: 'Italian',
      imagePath: AppAssets.pizza,
      rating: 4.6,
      deliveryMinutes: 22,
      deliveryFee: '₹20',
      isOpen: true,
    ),
  ];
}