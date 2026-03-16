class FoodModel {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final double price;
  final double rating;
  final int deliveryMinutes;
  final bool isPopular;
  final String description;
  final List<String> ingredients;
  final int calories;
  final List<String> sizes;
  final List<String> spiceLevels;

  const FoodModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.deliveryMinutes,
    this.isPopular = false,
    this.description = '',
    this.ingredients = const [],
    this.calories = 0,
    this.sizes = const ['Small', 'Medium', 'Large'],
    this.spiceLevels = const ['Mild', 'Medium', 'Hot'],
  });
}