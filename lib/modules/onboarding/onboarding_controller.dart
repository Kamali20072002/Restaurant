import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_assets.dart';
import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {

  final RxInt currentPage = 0.obs;

  // PageController exposed so screen can attach it
  final PageController pageController = PageController();

  final List<Map<String, String>> pages = [
    {
      'image':    AppAssets.foodRamen,
      'emoji':    '🍜',
      'tagline':  'PREMIUM FOOD DELIVERY',
      'title1':   'Taste the',
      'title2':   'Night',
      'title3':   'Life',
      'subtitle': 'Curated restaurants, midnight cravings sorted. Food that hits different after dark.',
    },
    {
      'image':    AppAssets.foodBurger,
      'emoji':    '🍔',
      'tagline':  'ORDER IN SECONDS',
      'title1':   'Fast as',
      'title2':   'Lightning,',
      'title3':   'Hot.',
      'subtitle': 'From kitchen to your door in under 25 minutes. Every single time.',
    },
    {
      'image':    AppAssets.foodSushi,
      'emoji':    '🍣',
      'tagline':  'EXCLUSIVE RESTAURANTS',
      'title1':   'Only the',
      'title2':   'Finest',
      'title3':   'Picks.',
      'subtitle': 'Hand-picked restaurants with 4.5+ ratings. Nothing less.',
    },
  ];

  // Called by PageView when user swipes
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  // Called by Next button
  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      goToHome();
    }
  }

  // Called by Back button or swipe right on page 0
  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  bool get isLastPage  => currentPage.value == pages.length - 1;
  bool get isFirstPage => currentPage.value == 0;

  Map<String, String> get currentContent => pages[currentPage.value];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}