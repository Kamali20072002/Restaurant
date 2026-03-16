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
      calories: 520,
      description:
          'A rich, deeply flavoured broth simmered for 12 hours with miso, '
          'topped with tender chashu pork, soft-boiled egg, bamboo shoots '
          'and a swirl of chilli oil. The ultimate midnight comfort bowl.',
      ingredients: [
        'Ramen noodles',
        'Pork broth',
        'Chashu pork',
        'Soft boiled egg',
        'Bamboo shoots',
        'Spring onion',
        'Chilli oil',
        'Nori',
      ],
      sizes: ['Regular', 'Large', 'Extra Large'],
      spiceLevels: ['Mild', 'Medium', 'Hot', 'Extra Hot'],
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
      calories: 680,
      description:
          'Double smashed patties with crispy lacy edges, American cheese, '
          'house special sauce, pickles and caramelised onions on a toasted '
          'brioche bun. Messy, juicy, unforgettable.',
      ingredients: [
        'Beef patty x2',
        'Brioche bun',
        'American cheese',
        'House sauce',
        'Pickles',
        'Caramelised onion',
        'Iceberg lettuce',
        'Tomato',
      ],
      sizes: ['Single', 'Double', 'Triple'],
      spiceLevels: ['No spice', 'Mild', 'Hot'],
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
      calories: 340,
      description:
          'Premium Norwegian salmon nigiri and maki rolls with sushi-grade '
          'rice seasoned with rice vinegar. Served with wasabi, pickled ginger '
          'and premium soy sauce. Fresh. Elegant. Perfect.',
      ingredients: [
        'Norwegian salmon',
        'Sushi rice',
        'Nori',
        'Wasabi',
        'Pickled ginger',
        'Soy sauce',
        'Sesame seeds',
        'Cucumber',
      ],
      sizes: ['6 pieces', '12 pieces', '18 pieces'],
      spiceLevels: ['No spice', 'Wasabi'],
    ),
    FoodModel(
      id: 'f4',
      name: 'Pepperoni Pizza',
      category: 'Pizza',
      imagePath: AppAssets.pizza,
      price: 13.99,
      rating: 4.6,
      deliveryMinutes: 22,
      calories: 780,
      description:
          'Stone-baked thin crust topped with San Marzano tomato sauce, '
          'hand-pulled mozzarella and premium pepperoni that curl and crisp '
          'at the edges. Classic Italian done right.',
      ingredients: [
        'Pizza dough',
        'San Marzano tomato',
        'Mozzarella',
        'Pepperoni',
        'Olive oil',
        'Basil',
        'Oregano',
        'Chilli flakes',
      ],
      sizes: ['Small 8"', 'Medium 10"', 'Large 12"'],
      spiceLevels: ['Mild', 'Medium', 'Hot'],
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
      calories: 620,
      description:
          'Slow-cooked dum biryani with tender chicken marinated in yoghurt '
          'and spices, layered with aged basmati rice, saffron, crispy onions '
          'and fresh mint. A royal feast in every bite.',
      ingredients: [
        'Basmati rice',
        'Chicken',
        'Yoghurt',
        'Saffron',
        'Caramelised onion',
        'Mint',
        'Ghee',
        'Whole spices',
      ],
      sizes: ['Half', 'Full', 'Family'],
      spiceLevels: ['Mild', 'Medium', 'Hot'],
    ),
    FoodModel(
      id: 'f6',
      name: 'Chocolate Lava',
      category: 'Desserts',
      imagePath: AppAssets.dessert,
      price: 7.99,
      rating: 4.9,
      deliveryMinutes: 15,
      calories: 420,
      description:
          'Warm dark chocolate fondant with a molten liquid centre, served '
          'with a scoop of Madagascar vanilla ice cream and a dusting of '
          'cocoa powder. Pure indulgence at midnight.',
      ingredients: [
        'Dark chocolate 70%',
        'Butter',
        'Eggs',
        'Flour',
        'Vanilla ice cream',
        'Cocoa powder',
        'Icing sugar',
      ],
      sizes: ['Single', 'Double'],
      spiceLevels: ['Original'],
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
    ),
    RestaurantModel(
      id: 'r2',
      name: 'Burger Noir',
      cuisine: 'American',
      imagePath: AppAssets.foodBurger,
      rating: 4.7,
      deliveryMinutes: 18,
      deliveryFee: '₹30',
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
    ),
  ];
}