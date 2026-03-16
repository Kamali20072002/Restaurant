class RestaurantModel {
  final String id;
  final String name;
  final String cuisine;
  final String imagePath;
  final double rating;
  final int deliveryMinutes;
  final String deliveryFee;
  final bool isOpen;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.imagePath,
    required this.rating,
    required this.deliveryMinutes,
    required this.deliveryFee,
    this.isOpen = true,
  });
}