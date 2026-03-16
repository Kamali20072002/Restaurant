import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/routes/app_routes.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_image.dart';
import '../../core/app_icons.dart';
import '../../core/app_icon_widget.dart';
import '../../data/models/food_model.dart';
import '../../data/models/restaurant_model.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dim = AppDimensions.of(context);
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Main scrollable content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _TopBar(dim: dim)),
                SliverToBoxAdapter(
                  child: _SearchBar(dim: dim, controller: controller),
                ),
                SliverToBoxAdapter(
                  child: _CategoryRow(dim: dim, controller: controller),
                ),
                SliverToBoxAdapter(child: _PromoBanner(dim: dim)),
                SliverToBoxAdapter(
                  child: _SectionHeader(
                    dim: dim,
                    title: 'Popular Near You',
                    onSeeAll: () {},
                  ),
                ),
                SliverToBoxAdapter(
                  child: _PopularFoodsRow(dim: dim, controller: controller),
                ),
                SliverToBoxAdapter(
                  child: _SectionHeader(
                    dim: dim,
                    title: 'Top Restaurants',
                    onSeeAll: () {},
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    dim.pagePadding,
                    0,
                    dim.pagePadding,
                    dim.h(120),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _RestaurantCard(
                        dim: dim,
                        restaurant: controller.allRestaurants[index],
                      ),
                      childCount: controller.allRestaurants.length,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom fade so content fades into nav
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: dim.h(120),
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // ignore: deprecated_member_use
                      AppColors.background.withOpacity(0),
                      // ignore: deprecated_member_use
                      AppColors.background.withOpacity(0.95),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Floating liquid glass nav
          Positioned(
            bottom: dim.h(20) + dim.bottomPadding,
            left: dim.w(24),
            right: dim.w(24),
            height: dim.h(60),
            child: _LiquidGlassNav(dim: dim),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Top bar
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final AppDimensionData dim;
  const _TopBar({required this.dim});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding,
        dim.h(16),
        dim.pagePadding,
        dim.h(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppIcon(
                    path: AppIcons.location,
                    size: dim.w(14),
                    color: AppColors.primary,
                  ),
                  SizedBox(width: dim.w(4)),
                  Text(
                    'Bengaluru, India',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: dim.f(12),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: dim.w(2)),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: dim.w(16),
                  ),
                ],
              ),
              SizedBox(height: dim.h(4)),
              Text(
                'What are you craving?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: dim.f(20),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // Bell + Cart
          Row(
            children: [
              // Notification bell
              Container(
                width: dim.w(40),
                height: dim.w(40),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(dim.w(12)),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Center(
                  child: AppIcon(
                    path: AppIcons.bell,
                    size: dim.w(18),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: dim.w(10)),
              // Cart with badge
              GestureDetector(
onTap: () => Get.toNamed(AppRoutes.cart),
                child: Container(
                  width: dim.w(40),
                  height: dim.w(40),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(dim.w(12)),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AppIcon(
                        path: AppIcons.cart,
                        size: dim.w(20),
                        color: AppColors.textPrimary,
                      ),
                      Positioned(
                        top: dim.w(6),
                        right: dim.w(6),
                        child: Container(
                          width: dim.w(7),
                          height: dim.w(7),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Search bar
// ─────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final AppDimensionData dim;
  final HomeController controller;
  const _SearchBar({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding,
        dim.h(4),
        dim.pagePadding,
        dim.h(16),
      ),
      child: Container(
        height: dim.h(52),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(dim.w(16)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            SizedBox(width: dim.w(14)),
            AppIcon(
              path: AppIcons.search,
              size: dim.w(18),
              color: AppColors.textHint,
            ),
            SizedBox(width: dim.w(10)),
            Expanded(
              child: TextField(
                onChanged: controller.onSearchChanged,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: dim.f(14),
                ),
                decoration: InputDecoration(
                  hintText: 'Search food, restaurants...',
                  hintStyle: TextStyle(
                    color: AppColors.textHint,
                    fontSize: dim.f(14),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(dim.w(7)),
              width: dim.w(36),
              height: dim.w(36),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(dim.w(10)),
              ),
              child: Center(
                child: AppIcon(
                  path: AppIcons.filter,
                  size: dim.w(16),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Category chips
// ─────────────────────────────────────────────
class _CategoryRow extends StatelessWidget {
  final AppDimensionData dim;
  final HomeController controller;
  const _CategoryRow({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dim.h(40),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: dim.pagePadding),
        itemCount: controller.categories.length,
        separatorBuilder: (_, __) => SizedBox(width: dim.w(8)),
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedCategory.value == index;
            return GestureDetector(
              onTap: () => controller.selectCategory(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: dim.w(16),
                  vertical: dim.h(8),
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primary : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(dim.w(10)),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.glassBorder,
                  ),
                ),
                child: Text(
                  controller.categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: dim.f(12),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Promo banner
// ─────────────────────────────────────────────
class _PromoBanner extends StatelessWidget {
  final AppDimensionData dim;
  const _PromoBanner({required this.dim});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dim.h(140),
      margin: EdgeInsets.fromLTRB(
        dim.pagePadding,
        dim.h(20),
        dim.pagePadding,
        0,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(dim.w(20)),
        border: Border.all(color: AppColors.primaryGlow),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dim.w(20)),
        child: Stack(
          children: [
            // Right glow
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: dim.w(160),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0x33FF6B35)],
                  ),
                ),
              ),
            ),
            // Food image
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: AppImage(
                path: 'assets/images/onboarding/food_ramen.jpg',
                width: dim.w(130),
                height: dim.h(140),
                fit: BoxFit.cover,
              ),
            ),
            // Dark fade over image
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: dim.w(130),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1C1C26), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Text
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dim.w(18),
                vertical: dim.h(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: dim.w(8),
                      vertical: dim.h(3),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'LIMITED OFFER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dim.f(9),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: dim.h(8)),
                  Text(
                    'Get 30% OFF',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: dim.f(20),
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'your first order',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: dim.f(13),
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: dim.h(10)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: dim.w(10),
                      vertical: dim.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: AppColors.primary.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      'NIGHT30',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: dim.f(11),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final AppDimensionData dim;
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({
    required this.dim,
    required this.title,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding,
        dim.h(24),
        dim.pagePadding,
        dim.h(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: dim.f(17),
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'See all',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: dim.f(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Popular foods row
// ─────────────────────────────────────────────
class _PopularFoodsRow extends StatelessWidget {
  final AppDimensionData dim;
  final HomeController controller;
  const _PopularFoodsRow({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dim.h(210),
      child: Obx(() => ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: dim.pagePadding),
            itemCount: controller.filteredFoods.length,
            separatorBuilder: (_, __) => SizedBox(width: dim.w(14)),
            itemBuilder: (context, index) => _FoodCard(
              dim: dim,
              food: controller.filteredFoods[index],
            ),
          )),
    );
  }
}

// ─────────────────────────────────────────────
// Food card
// ─────────────────────────────────────────────
class _FoodCard extends StatelessWidget {
  final AppDimensionData dim;
  final FoodModel food;
  const _FoodCard({required this.dim, required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.foodDetail,
          arguments: food,
        );
      },
      child: Container(
        width: dim.w(150),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(dim.w(18)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dim.w(18)),
                topRight: Radius.circular(dim.w(18)),
              ),
              child: AppImage(
                path: food.imagePath,
                width: dim.w(150),
                height: dim.h(115),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(dim.w(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: dim.f(13),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: dim.h(5)),
                  Row(
                    children: [
                      AppIcon(
                        path: AppIcons.star,
                        size: dim.w(12),
                        color: AppColors.gold,
                      ),
                      SizedBox(width: dim.w(3)),
                      Text(
                        food.rating.toString(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: dim.f(11),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹${food.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: dim.f(13),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dim.h(5)),
                  Row(
                    children: [
                      AppIcon(
                        path: AppIcons.clock,
                        size: dim.w(11),
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: dim.w(3)),
                      Text(
                        '${food.deliveryMinutes} min',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: dim.f(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Restaurant card
// ─────────────────────────────────────────────
class _RestaurantCard extends StatelessWidget {
  final AppDimensionData dim;
  final RestaurantModel restaurant;
  const _RestaurantCard({required this.dim, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: dim.h(12)),
        padding: EdgeInsets.all(dim.w(12)),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(dim.w(18)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(dim.w(12)),
              child: AppImage(
                path: restaurant.imagePath,
                width: dim.w(72),
                height: dim.w(72),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: dim.w(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: dim.f(15),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: dim.w(8),
                          vertical: dim.h(3),
                        ),
                        decoration: BoxDecoration(
                          color: restaurant.isOpen
                              ? const Color(0x1A4CAF50)
                              : const Color(0x1AFF5252),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          restaurant.isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color: restaurant.isOpen
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF5252),
                            fontSize: dim.f(10),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dim.h(4)),
                  Text(
                    restaurant.cuisine,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: dim.f(12),
                    ),
                  ),
                  SizedBox(height: dim.h(8)),
                  Row(
                    children: [
                      AppIcon(
                        path: AppIcons.star,
                        size: dim.w(13),
                        color: AppColors.gold,
                      ),
                      SizedBox(width: dim.w(3)),
                      Text(
                        restaurant.rating.toString(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: dim.f(12),
                        ),
                      ),
                      SizedBox(width: dim.w(10)),
                      AppIcon(
                        path: AppIcons.clock,
                        size: dim.w(12),
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: dim.w(3)),
                      Text(
                        '${restaurant.deliveryMinutes} min',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: dim.f(12),
                        ),
                      ),
                      SizedBox(width: dim.w(10)),
                      AppIcon(
                        path: AppIcons.delivery,
                        size: dim.w(12),
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: dim.w(3)),
                      Text(
                        restaurant.deliveryFee,
                        style: TextStyle(
                          color: restaurant.deliveryFee == 'Free'
                              ? const Color(0xFF4CAF50)
                              : AppColors.textHint,
                          fontSize: dim.f(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Liquid glass nav bar — new style
// ─────────────────────────────────────────────
class _LiquidGlassNav extends StatefulWidget {
  final AppDimensionData dim;
  const _LiquidGlassNav({required this.dim});

  @override
  State<_LiquidGlassNav> createState() => _LiquidGlassNavState();
}

class _LiquidGlassNavState extends State<_LiquidGlassNav>
    with SingleTickerProviderStateMixin {
  int _active = 0;
  late AnimationController _bubbleCtrl;
  late Animation<double> _bubbleAnim;

  final List<_NavData> _items = const [
    _NavData(iconPath: AppIcons.home, label: 'Home'),
    _NavData(iconPath: AppIcons.search, label: 'Search'),
    _NavData(iconPath: AppIcons.cart, label: 'Cart'),
    _NavData(iconPath: AppIcons.profile, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _bubbleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bubbleAnim = CurvedAnimation(
      parent: _bubbleCtrl,
      curve: Curves.elasticOut,
    );
    _bubbleCtrl.forward();
  }

  @override
  void dispose() {
    _bubbleCtrl.dispose();
    super.dispose();
  }

  void _onTap(int index) {
  setState(() => _active = index);
  _bubbleCtrl..reset()..forward();
  if (index == 2) Get.toNamed(AppRoutes.cart);
}

  @override
  Widget build(BuildContext context) {
    final dim = widget.dim;

    return Container(
      height: dim.h(68),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dim.w(36)),
        // layered glass effect
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // ignore: deprecated_member_use
            const Color(0xFF1C1C28).withOpacity(0.95),
            // ignore: deprecated_member_use
            const Color(0xFF0F0F18).withOpacity(0.98),
          ],
        ),
        border: Border.all(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          // deep shadow
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.5),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
          // orange ambient glow
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.12),
            blurRadius: 24,
            spreadRadius: -2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dim.w(36)),
        child: Stack(
          children: [
            // Top shine streak — liquid glass feel
            Positioned(
              top: 0,
              left: dim.w(40),
              right: dim.w(40),
              height: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      // ignore: deprecated_member_use
                      Colors.white.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Nav items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _items.length,
                (i) => _LiquidNavItem(
                  dim: dim,
                  data: _items[i],
                  isActive: _active == i,
                  bubbleAnim: _active == i ? _bubbleAnim : null,
                  onTap: () => _onTap(i),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Single liquid nav item
// ─────────────────────────────────────────────
// ─────────────────────────────────────────────
// Single liquid nav item — no label
// ─────────────────────────────────────────────
class _LiquidNavItem extends StatelessWidget {
  final AppDimensionData dim;
  final _NavData data;
  final bool isActive;
  final Animation<double>? bubbleAnim;
  final VoidCallback onTap;

  const _LiquidNavItem({
    required this.dim,
    required this.data,
    required this.isActive,
    required this.onTap,
    this.bubbleAnim,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: dim.w(72),
        height: double.infinity,
        child: Center(
          child: isActive && bubbleAnim != null
              ? ScaleTransition(
                  scale: bubbleAnim!,
                  child: _ActiveBubble(dim: dim, data: data),
                )
              : _InactiveIcon(dim: dim, data: data),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Active bubble — glowing pill, icon only
// ─────────────────────────────────────────────
class _ActiveBubble extends StatelessWidget {
  final AppDimensionData dim;
  final _NavData data;
  const _ActiveBubble({required this.dim, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dim.w(52),
      height: dim.w(40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dim.w(16)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // ignore: deprecated_member_use
            AppColors.primary.withOpacity(0.4),
            // ignore: deprecated_member_use
            AppColors.primary.withOpacity(0.2),
          ],
        ),
        border: Border.all(
          // ignore: deprecated_member_use
          color: AppColors.primary.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 14,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: AppIcon(
          path: data.iconPath,
          size: dim.w(20),
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Inactive icon — plain muted, no container
// ─────────────────────────────────────────────
class _InactiveIcon extends StatelessWidget {
  final AppDimensionData dim;
  final _NavData data;
  const _InactiveIcon({required this.dim, required this.data});

  @override
  Widget build(BuildContext context) {
    return AppIcon(
      path: data.iconPath,
      size: dim.w(22),
      color: AppColors.textHint,
    );
  }
}

// ─────────────────────────────────────────────
// Nav data model — uses asset path
// ─────────────────────────────────────────────
class _NavData {
  final String iconPath;
  final String label;
  const _NavData({required this.iconPath, required this.label});
}
