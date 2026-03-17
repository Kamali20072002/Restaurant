import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_food_delivery_ui/modules/cart/cart_controller.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_image.dart';
import '../../core/app_icons.dart';
import '../../core/app_icon_widget.dart';
import 'food_detail_controller.dart';
import '../../routes/app_routes.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dim = AppDimensions.of(context);
    final controller = Get.find<FoodDetailController>();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _HeroImage(dim: dim, controller: controller),
              ),
              SliverToBoxAdapter(
                child: _ContentCard(dim: dim, controller: controller),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: dim.h(110)),
              ),
            ],
          ),
          Positioned(
            top: dim.topPadding + dim.h(8),
            left: dim.w(16),
            right: dim.w(16),
            child: _TopOverlay(dim: dim, controller: controller),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _StickyCartBar(dim: dim, controller: controller),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hero image
// ─────────────────────────────────────────────
class _HeroImage extends StatelessWidget {
  final AppDimensionData dim;
  final FoodDetailController controller;
  const _HeroImage({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dim.h(380),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(
            path: controller.food.imagePath,
            width: dim.screenWidth,
            height: dim.h(380),
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: dim.h(180),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xBB0A0A0F),
                    Color(0xFF0A0A0F),
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: dim.h(100),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x880A0A0F), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: dim.h(20),
            left: dim.w(20),
            right: dim.w(20),
            child: _HeroChips(dim: dim, controller: controller),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hero chips
// ─────────────────────────────────────────────
class _HeroChips extends StatelessWidget {
  final AppDimensionData dim;
  final FoodDetailController controller;
  const _HeroChips({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    final food = controller.food;
    return Row(
      children: [
        _InfoChip(
          dim: dim,
          icon: AppIcons.star,
          iconColor: AppColors.gold,
          label: food.rating.toString(),
        ),
        SizedBox(width: dim.w(8)),
        _InfoChip(
          dim: dim,
          icon: AppIcons.clock,
          iconColor: Colors.white70,
          label: '${food.deliveryMinutes} min',
        ),
        SizedBox(width: dim.w(8)),
        _InfoChip(
          dim: dim,
          icon: AppIcons.filter,
          iconColor: Colors.white70,
          label: '${food.calories} cal',
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final AppDimensionData dim;
  final String icon;
  final Color iconColor;
  final String label;
  const _InfoChip({
    required this.dim,
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dim.w(10),
        vertical: dim.h(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(dim.w(20)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(path: icon, size: dim.w(12), color: iconColor),
          SizedBox(width: dim.w(4)),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: dim.f(11),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Top overlay
// ─────────────────────────────────────────────
class _TopOverlay extends StatelessWidget {
  final AppDimensionData dim;
  final FoodDetailController controller;
  const _TopOverlay({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: dim.w(40),
            height: dim.w(40),
            decoration: BoxDecoration(
              color: AppColors.glassFill,
              borderRadius: BorderRadius.circular(dim.w(12)),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: dim.w(16),
              ),
            ),
          ),
        ),
        Obx(() => GestureDetector(
          onTap: controller.toggleFavourite,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: dim.w(40),
            height: dim.w(40),
            decoration: BoxDecoration(
              color: controller.isFavourite.value
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : AppColors.glassFill,
              borderRadius: BorderRadius.circular(dim.w(12)),
              border: Border.all(
                color: controller.isFavourite.value
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.glassBorder,
              ),
            ),
            child: Center(
              child: Icon(
                controller.isFavourite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: controller.isFavourite.value
                    ? AppColors.primary
                    : Colors.white,
                size: dim.w(18),
              ),
            ),
          ),
        )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Content card
// ─────────────────────────────────────────────
class _ContentCard extends StatelessWidget {
  final AppDimensionData dim;
  final FoodDetailController controller;
  const _ContentCard({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    final food = controller.food;
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding, dim.h(4), dim.pagePadding, 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  food.name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: dim.f(26),
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(width: dim.w(12)),
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    controller.formattedUnit,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: dim.f(22),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'per item',
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: dim.f(10),
                    ),
                  ),
                ],
              )),
            ],
          ),

          SizedBox(height: dim.h(16)),

          // About
          Text(
            'About',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: dim.f(15),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: dim.h(8)),
          Text(
            food.description,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: dim.f(13),
              height: 1.7,
              fontWeight: FontWeight.w300,
            ),
          ),

          SizedBox(height: dim.h(24)),

          // Size
          _SectionLabel(dim: dim, label: 'Choose Size'),
          SizedBox(height: dim.h(10)),
          _SizeSelector(dim: dim, controller: controller),

          SizedBox(height: dim.h(24)),

          // Spice
          _SectionLabel(dim: dim, label: 'Spice Level'),
          SizedBox(height: dim.h(10)),
          _SpiceSelector(dim: dim, controller: controller),

          SizedBox(height: dim.h(24)),

          // Ingredients
          _SectionLabel(dim: dim, label: 'Ingredients'),
          SizedBox(height: dim.h(12)),
          _IngredientsGrid(dim: dim, controller: controller),

          SizedBox(height: dim.h(24)),

          // Quantity
          _SectionLabel(dim: dim, label: 'Quantity'),
          SizedBox(height: dim.h(12)),
          _QuantitySelector(dim: dim, controller: controller),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final AppDimensionData dim;
  final String label;
  const _SectionLabel({required this.dim, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: dim.f(15),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Size selector
// ─────────────────────────────────────────────
class _SizeSelector extends StatelessWidget {
  final AppDimensionData dim;
  final FoodDetailController controller;
  const _SizeSelector({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(
          controller.food.sizes.length,
          (i) {
            final isSelected = controller.selectedSize.value == i;
            return GestureDetector(
              onTap: () => controller.selectSize(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                margin: EdgeInsets.only(right: dim.w(10)),
                padding: EdgeInsets.symmetric(
                  horizontal: dim.w(18),
                  vertical: dim.h(10),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(dim.w(12)),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.glassBorder,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  controller.food.sizes[i],
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontSize: dim.f(12),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}

// ─────────────────────────────────────────────
// Spice selector
// ─────────────────────────────────────────────
class _SpiceSelector extends StatelessWidget {
  final AppDimensionData dim;
  final FoodDetailController controller;
  const _SpiceSelector({required this.dim, required this.controller});

  Color _spiceColor(int index, int total) {
    if (total <= 1) return AppColors.textHint;
    final t = index / (total - 1);
    if (t < 0.33) return const Color(0xFF4CAF50);
    if (t < 0.66) return const Color(0xFFFFB400);
    if (t < 0.85) return const Color(0xFFFF6B35);
    return const Color(0xFFFF3D00);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(
          controller.food.spiceLevels.length,
          (i) {
            final isSelected = controller.selectedSpice.value == i;
            final color = _spiceColor(
              i, controller.food.spiceLevels.length,
            );
            return GestureDetector(
              onTap: () => controller.selectSpice(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.only(right: dim.w(10)),
                padding: EdgeInsets.symmetric(
                  horizontal: dim.w(14),
                  vertical: dim.h(10),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(dim.w(12)),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.6)
                        : AppColors.glassBorder,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '🌶',
                      style: TextStyle(fontSize: dim.f(11)),
                    ),
                    SizedBox(width: dim.w(4)),
                    Text(
                      controller.food.spiceLevels[i],
                      style: TextStyle(
                        color: isSelected
                            ? color
                            : AppColors.textSecondary,
                        fontSize: dim.f(11),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}

// ─────────────────────────────────────────────
// Ingredients grid
// ─────────────────────────────────────────────
class _IngredientsGrid extends StatelessWidget {
  final AppDimensionData dim;
  final FoodDetailController controller;
  const _IngredientsGrid({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: dim.w(8),
      runSpacing: dim.h(8),
      children: controller.food.ingredients.map((ingredient) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: dim.w(12),
            vertical: dim.h(7),
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(dim.w(10)),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Text(
            ingredient,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: dim.f(12),
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// Quantity selector
// ─────────────────────────────────────────────
class _QuantitySelector extends StatelessWidget {
  final AppDimensionData dim;
  final FoodDetailController controller;
  const _QuantitySelector({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      children: [
        _QtyButton(
          dim: dim,
          icon: Icons.remove_rounded,
          onTap: controller.decrement,
          enabled: controller.quantity.value > 1,
        ),
        SizedBox(width: dim.w(20)),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Text(
            '${controller.quantity.value}',
            key: ValueKey(controller.quantity.value),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: dim.f(22),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: dim.w(20)),
        _QtyButton(
          dim: dim,
          icon: Icons.add_rounded,
          onTap: controller.increment,
          enabled: controller.quantity.value < 10,
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Total',
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: dim.f(11),
              ),
            ),
            Obx(() => Text(
              controller.formattedTotal,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: dim.f(22),
                fontWeight: FontWeight.w800,
              ),
            )),
          ],
        ),
      ],
    ));
  }
}

class _QtyButton extends StatelessWidget {
  final AppDimensionData dim;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  const _QtyButton({
    required this.dim,
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: dim.w(40),
        height: dim.w(40),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(dim.w(12)),
          border: Border.all(
            color: enabled
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.glassBorder,
          ),
        ),
        child: Icon(
          icon,
          color: enabled ? AppColors.primary : AppColors.textHint,
          size: dim.w(18),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sticky cart bar — FIXED
// ─────────────────────────────────────────────
class _StickyCartBar extends StatelessWidget {
  final AppDimensionData dim;
  final FoodDetailController controller;
  const _StickyCartBar({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding,
        dim.h(12),
        dim.pagePadding,
        dim.h(24) + dim.bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.glassBorder,
            width: 0.5,
          ),
        ),
      ),
      child: Obx(() => GestureDetector(
        onTap: () {
          final cartController = Get.find<CartController>();
          cartController.addItem(
            controller.food,
            controller.quantity.value,
            controller.food.sizes[controller.selectedSize.value],
            controller.food.spiceLevels[controller.selectedSpice.value],
          );
          Get.snackbar(
            '✅ Added to Cart!',
            '${controller.quantity.value}x ${controller.food.name}',
            backgroundColor: AppColors.surfaceLight,
            colorText: AppColors.textPrimary,
            borderRadius: 12,
            margin: EdgeInsets.all(dim.w(16)),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
            mainButton: TextButton(
              onPressed: () => Get.toNamed(AppRoutes.cart),
              child: const Text(
                'View Cart',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          );
        },
        child: Container(
          height: dim.h(56),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8C42), Color(0xFFFF3D00)],
            ),
            borderRadius: BorderRadius.circular(dim.w(18)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(
                path: AppIcons.cart,
                size: dim.w(20),
                color: Colors.white,
              ),
              SizedBox(width: dim.w(10)),
              Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: dim.f(16),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: dim.w(12)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: dim.w(12),
                  vertical: dim.h(4),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(dim.w(8)),
                ),
                child: Text(
                  controller.formattedTotal,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: dim.f(13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}