import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_image.dart';
import '../../core/app_assets.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dim = AppDimensions.of(context);
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── 1. Background image
          Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: AppImage(
              key: ValueKey(controller.currentPage.value),
              path: controller.pages[controller.currentPage.value]['image']!,
              width: dim.screenWidth,
              height: dim.screenHeight,
              fit: BoxFit.cover,
            ),
          )),

          // ── 2. Dark gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xCC0A0A0F),
                  Color(0x550A0A0F),
                  Color(0xFF0A0A0F),
                ],
                stops: [0.0, 0.38, 0.70],
              ),
            ),
          ),

          // ── 3. PageView full screen swipe handler
          Positioned.fill(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.pages.length,
              itemBuilder: (context, index) => const SizedBox.expand(),
            ),
          ),

          // ── 4. UI overlay
          SafeArea(
            child: Column(
              children: [
                _TopBar(dim: dim),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _FoodCircleOverlay(
                        dim: dim,
                        controller: controller,
                      ),
                      SizedBox(height: dim.h(32)),
                    ],
                  ),
                ),
                _BottomContent(dim: dim, controller: controller),
              ],
            ),
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
    final controller = Get.find<OnboardingController>();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dim.pagePadding,
        vertical: dim.h(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IgnorePointer(
            child: Row(
              children: [
                Image.asset(
                  AppAssets.logoIcon,
                  width: dim.w(32),
                  height: dim.w(32),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      Text('🍽️', style: TextStyle(fontSize: dim.w(24))),
                ),
                SizedBox(width: dim.w(8)),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Night',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: dim.f(20),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: 'Bite',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: dim.f(20),
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() => controller.isLastPage
            ? const SizedBox.shrink()
            : GestureDetector(
                onTap: controller.goToHome,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: dim.w(16),
                    vertical: dim.h(8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassFill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: dim.f(13),
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Spinning rings overlay
// ─────────────────────────────────────────────
class _FoodCircleOverlay extends StatefulWidget {
  final AppDimensionData dim;
  final OnboardingController controller;
  const _FoodCircleOverlay({
    required this.dim,
    required this.controller,
  });

  @override
  State<_FoodCircleOverlay> createState() => _FoodCircleOverlayState();
}

class _FoodCircleOverlayState extends State<_FoodCircleOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _ring1;
  late final AnimationController _ring2;

  @override
  void initState() {
    super.initState();
    _ring1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _ring2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _ring1.dispose();
    _ring2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.dim;
    final circleSize = d.w(160);

    return IgnorePointer(
      child: SizedBox(
        width: d.w(280),
        height: d.w(280),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _ring2,
              builder: (_, __) => Transform.rotate(
                angle: -_ring2.value * 2 * math.pi,
                child: Container(
                  width: d.w(260),
                  height: d.w(260),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _ring1,
              builder: (_, __) => Transform.rotate(
                angle: _ring1.value * 2 * math.pi,
                child: Container(
                  width: d.w(215),
                  height: d.w(215),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Container(
                key: ValueKey(widget.controller.currentPage.value),
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: AppImage(
                    path: widget.controller.currentContent['image']!,
                    width: circleSize,
                    height: circleSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
            Positioned(
              top: d.w(30),
              left: 0,
              child: _GlassChip(label: '⭐  4.9 Rating', dim: d),
            ),
            Positioned(
              top: d.w(72),
              right: 0,
              child: _GlassChip(label: '🚀  25 min', dim: d),
            ),
            Positioned(
              bottom: d.w(30),
              left: d.w(8),
              child: _GlassChip(label: '🔥  500+ Dishes', dim: d),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Glass chip
// ─────────────────────────────────────────────
class _GlassChip extends StatelessWidget {
  final String label;
  final AppDimensionData dim;
  const _GlassChip({required this.label, required this.dim});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dim.w(12),
        vertical: dim.h(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: dim.f(11),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom content
// ─────────────────────────────────────────────
class _BottomContent extends StatelessWidget {
  final AppDimensionData dim;
  final OnboardingController controller;
  const _BottomContent({
    required this.dim,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding, 0,
        dim.pagePadding,
        dim.h(40) + dim.bottomPadding,
      ),
      child: Obx(() {
        final content = controller.currentContent;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              content['tagline']!,
              style: AppTextStyles.label.copyWith(fontSize: dim.f(11)),
            ),
            SizedBox(height: dim.h(10)),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: anim,
                    curve: Curves.easeOut,
                  )),
                  child: child,
                ),
              ),
              child: SizedBox(
                key: ValueKey('title_${controller.currentPage.value}'),
                width: double.infinity,
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.display.copyWith(
                      fontSize: dim.f(36),
                    ),
                    children: [
                      TextSpan(text: '${content['title1']!}\n'),
                      TextSpan(
                        text: '${content['title2']!} ',
                        style: AppTextStyles.display.copyWith(
                          fontSize: dim.f(36),
                          color: AppColors.primary,
                        ),
                      ),
                      TextSpan(text: content['title3']!),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: dim.h(12)),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: Text(
                content['subtitle']!,
                key: ValueKey('sub_${controller.currentPage.value}'),
                style: AppTextStyles.body.copyWith(fontSize: dim.f(14)),
              ),
            ),

            SizedBox(height: dim.h(28)),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: controller.isFirstPage
                      ? SizedBox(
                          key: const ValueKey('no_back'),
                          width: dim.w(56),
                          height: dim.w(56),
                        )
                      : GestureDetector(
                          key: const ValueKey('back_btn'),
                          onTap: controller.previousPage,
                          child: Container(
                            width: dim.w(56),
                            height: dim.w(56),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              shape: BoxShape.circle,
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
                ),

                SizedBox(width: dim.w(14)),

                Expanded(
                  child: Container(
                    height: dim.w(56),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(dim.w(56)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(dim.w(56)),
                        onTap: controller.nextPage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.isLastPage ? 'Get Started' : 'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: dim.f(16),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(width: dim.w(10)),
                            Container(
                              width: dim.w(32),
                              height: dim.w(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  controller.isLastPage
                                      ? Icons.rocket_launch_rounded
                                      : Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: dim.w(15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: dim.h(20)),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.pages.length,
                (i) => GestureDetector(
                  onTap: () => controller.pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.symmetric(horizontal: dim.w(4)),
                    width: controller.currentPage.value == i
                        ? dim.w(22)
                        : dim.w(6),
                    height: dim.h(6),
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == i
                          ? AppColors.primary
                          : AppColors.textHint,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
