import 'package:get/get.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_screen.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_screen.dart';
import '../modules/food_detail/food_detail_binding.dart';
import '../modules/food_detail/food_detail_screen.dart';
import '../modules/cart/cart_binding.dart';
import '../modules/cart/cart_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.foodDetail,
      page: () => const FoodDetailScreen(),
      binding: FoodDetailBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
  name: AppRoutes.cart,
  page: () => const CartScreen(),
  // No binding needed — controller already registered globally
  transition: Transition.rightToLeft,
  transitionDuration: const Duration(milliseconds: 350),
),
  ];
}