class FoodModel {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final double price;
  final double rating;
  final int deliveryMinutes;
  final bool isPopular;

  const FoodModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.deliveryMinutes,
    this.isPopular = false,
  });
}