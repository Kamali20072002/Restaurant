import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_image.dart';
import '../../data/models/food_model.dart';
import '../../data/models/restaurant_model.dart';
import '../../routes/app_routes.dart';
import 'search_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
Widget build(BuildContext context) {
  final dim  = AppDimensions.of(context);
  final ctrl = Get.find<NightBiteSearchController>();

  return Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Column(
        children: [
          _SearchHeader(dim: dim, ctrl: ctrl),

          // Filter chips — only shown when searching
          Obx(() {
            if (!ctrl.isSearching.value) return const SizedBox.shrink();
            return _FilterChips(dim: dim, ctrl: ctrl);
          }),

          // Body — results or idle
          Expanded(
            child: Obx(() {
              if (ctrl.isSearching.value) {
                return _SearchResults(dim: dim, ctrl: ctrl);
              }
              return _IdleState(dim: dim, ctrl: ctrl);
            }),
          ),
        ],
      ),
    ),
  );
}
}

// ─────────────────────────────────────────────
// Search header
// ─────────────────────────────────────────────
class _SearchHeader extends StatelessWidget {
  final AppDimensionData        dim;
  final NightBiteSearchController ctrl;
  const _SearchHeader({required this.dim, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding, dim.h(16),
        dim.pagePadding, dim.h(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: dim.w(42),
              height: dim.w(42),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(dim.w(14)),
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

          SizedBox(width: dim.w(12)),

          Expanded(
            child: Container(
              height: dim.w(42),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(dim.w(14)),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                children: [
                  SizedBox(width: dim.w(14)),
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.textHint,
                    size: dim.w(18),
                  ),
                  SizedBox(width: dim.w(8)),
                  Expanded(
                    child: TextField(
                      controller: ctrl.textCtrl,
                      focusNode: ctrl.focusNode,
                      onChanged: ctrl.onQueryChanged,
                      onSubmitted: ctrl.saveSearch,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: dim.f(14),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Food, restaurants, cuisines...',
                        hintStyle: TextStyle(
                          color: AppColors.textHint,
                          fontSize: dim.f(14),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  Obx(() => ctrl.query.value.isNotEmpty
                      ? GestureDetector(
                          onTap: ctrl.clearSearch,
                          child: Padding(
                            padding: EdgeInsets.only(right: dim.w(12)),
                            child: Container(
                              width: dim.w(20),
                              height: dim.w(20),
                              decoration: BoxDecoration(
                                color: AppColors.textHint
                                    .withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: dim.w(12),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Filter chips
// ─────────────────────────────────────────────
class _FilterChips extends StatelessWidget {
  final AppDimensionData        dim;
  final NightBiteSearchController ctrl;
  const _FilterChips({required this.dim, required this.ctrl});

 @override
Widget build(BuildContext context) {
  final filters = [
    SearchFilter.all,
    SearchFilter.food,
    SearchFilter.restaurant,
  ];
  final labels = ['All', 'Food', 'Restaurants'];

  // NO Obx wrapper here — parent already rebuilds this widget reactively
  return SizedBox(
    height: dim.h(42),
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding, 0, dim.pagePadding, dim.h(6),
      ),
      itemCount: filters.length,
      separatorBuilder: (_, __) => SizedBox(width: dim.w(8)),
      itemBuilder: (_, i) {
        // Each chip has its own Obx — correct and isolated
        return Obx(() {
          final isActive = ctrl.activeFilter.value == filters[i];
          return GestureDetector(
            onTap: () => ctrl.setFilter(filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: dim.w(16),
                vertical: dim.h(7),
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.glassBorder,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.textSecondary,
                  fontSize: dim.f(12),
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        });
      },
    ),
  );
}}

// ─────────────────────────────────────────────
// Idle state — recent + trending
// ─────────────────────────────────────────────
class _IdleState extends StatelessWidget {
  final AppDimensionData        dim;
  final NightBiteSearchController ctrl;
  const _IdleState({required this.dim, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding, dim.h(8),
        dim.pagePadding, dim.h(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Recent searches
          Obx(() {
            if (ctrl.recentSearches.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dim.f(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: ctrl.clearAllRecent,
                      child: Text(
                        'Clear all',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: dim.f(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: dim.h(14)),

                Wrap(
                  spacing: dim.w(8),
                  runSpacing: dim.h(8),
                  children: ctrl.recentSearches.map((term) =>
                    GestureDetector(
                      onTap: () => ctrl.selectRecent(term),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: dim.w(14),
                          vertical: dim.h(8),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history_rounded,
                              color: AppColors.textHint,
                              size: dim.w(13),
                            ),
                            SizedBox(width: dim.w(6)),
                            Text(
                              term,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: dim.f(12),
                              ),
                            ),
                            SizedBox(width: dim.w(6)),
                            GestureDetector(
                              onTap: () => ctrl.removeRecent(term),
                              child: Icon(
                                Icons.close_rounded,
                                color: AppColors.textHint,
                                size: dim.w(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).toList(),
                ),

                SizedBox(height: dim.h(28)),
              ],
            );
          }),

          // Trending
          Text(
            'Trending Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: dim.f(16),
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: dim.h(14)),

          ...ctrl.trendingSearches.asMap().entries.map((e) {
            final i    = e.key;
            final term = e.value;
            return GestureDetector(
              onTap: () => ctrl.selectTrending(term),
              child: Container(
                margin: EdgeInsets.only(bottom: dim.h(10)),
                padding: EdgeInsets.symmetric(
                  horizontal: dim.w(14),
                  vertical: dim.h(13),
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(dim.w(14)),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: dim.w(28),
                      height: dim.w(28),
                      decoration: BoxDecoration(
                        color: i < 3
                            ? AppColors.primaryGlow
                            : AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: i < 3
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : AppColors.glassBorder,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: i < 3
                                ? AppColors.primary
                                : AppColors.textHint,
                            fontSize: dim.f(11),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: dim.w(12)),

                    Expanded(
                      child: Text(
                        term,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: dim.f(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Icon(
                      Icons.north_east_rounded,
                      color: AppColors.textHint,
                      size: dim.w(16),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Search results
// ─────────────────────────────────────────────
class _SearchResults extends StatelessWidget {
  final AppDimensionData        dim;
  final NightBiteSearchController ctrl;
  const _SearchResults({required this.dim, required this.ctrl});

  @override
Widget build(BuildContext context) {
  return Obx(() {
    final filter    = ctrl.activeFilter.value;
    final foods     = ctrl.foodResults;
    final rests     = ctrl.restaurantResults;
    final showFoods = filter == SearchFilter.all ||
                      filter == SearchFilter.food;
    final showRests = filter == SearchFilter.all ||
                      filter == SearchFilter.restaurant;

    final totalVisible =
        (showFoods ? foods.length : 0) +
        (showRests ? rests.length : 0);

    if (totalVisible == 0) {
      return _EmptyResults(dim: dim, query: ctrl.query.value);
    }

    // CustomScrollView handles keyboard + overflow correctly
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            dim.pagePadding, dim.h(12),
            dim.pagePadding, dim.h(40),
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([

              // Results count
              Padding(
                padding: EdgeInsets.only(bottom: dim.h(16)),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$totalVisible',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: dim.f(13),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' results for  ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: dim.f(13),
                        ),
                      ),
                      TextSpan(
                        text: '"${ctrl.query.value}"',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: dim.f(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Food results
              if (showFoods && foods.isNotEmpty) ...[
                _ResultsLabel(
                  dim: dim, label: 'Food', count: foods.length,
                ),
                SizedBox(height: dim.h(10)),
                ...foods.map((food) => _FoodResultCard(
                  dim: dim, food: food, query: ctrl.query.value,
                )),
                SizedBox(height: dim.h(20)),
              ],

              // Restaurant results
              if (showRests && rests.isNotEmpty) ...[
                _ResultsLabel(
                  dim: dim,
                  label: 'Restaurants',
                  count: rests.length,
                ),
                SizedBox(height: dim.h(10)),
                ...rests.map((r) => _RestaurantResultCard(
                  dim: dim, restaurant: r, query: ctrl.query.value,
                )),
              ],

            ]),
          ),
        ),
      ],
    );
  });
}}

// ─────────────────────────────────────────────
// Results section label
// ─────────────────────────────────────────────
class _ResultsLabel extends StatelessWidget {
  final AppDimensionData dim;
  final String           label;
  final int              count;
  const _ResultsLabel({
    required this.dim,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: dim.f(15),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: dim.w(8)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: dim.w(8),
            vertical: dim.h(3),
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryGlow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: dim.f(10),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Food result card
// ─────────────────────────────────────────────
class _FoodResultCard extends StatelessWidget {
  final AppDimensionData dim;
  final FoodModel        food;
  final String           query;
  const _FoodResultCard({
    required this.dim,
    required this.food,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.foodDetail, arguments: food),
      child: Container(
        margin: EdgeInsets.only(bottom: dim.h(10)),
        padding: EdgeInsets.all(dim.w(12)),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(dim.w(16)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(dim.w(12)),
              child: AppImage(
                path: food.imagePath,
                width: dim.w(70),
                height: dim.w(70),
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: dim.w(12)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightText(
                    text: food.name,
                    query: query,
                    dim: dim,
                    baseStyle: TextStyle(
                      color: Colors.white,
                      fontSize: dim.f(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: dim.h(4)),
                  Text(
                    food.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: dim.f(11),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: dim.h(6)),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: const Color(0xFFFFB400),
                        size: dim.w(13),
                      ),
                      SizedBox(width: dim.w(3)),
                      Text(
                        food.rating.toString(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: dim.f(11),
                        ),
                      ),
                      SizedBox(width: dim.w(8)),
                      Icon(
                        Icons.access_time_rounded,
                        color: AppColors.textHint,
                        size: dim.w(12),
                      ),
                      SizedBox(width: dim.w(3)),
                      Text(
                        '${food.deliveryMinutes} min',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: dim.f(11),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹${food.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: dim.f(14),
                          fontWeight: FontWeight.w700,
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
// Restaurant result card
// ─────────────────────────────────────────────
class _RestaurantResultCard extends StatelessWidget {
  final AppDimensionData dim;
  final RestaurantModel  restaurant;
  final String           query;
  const _RestaurantResultCard({
    required this.dim,
    required this.restaurant,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: dim.h(10)),
      padding: EdgeInsets.all(dim.w(12)),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(dim.w(16)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(dim.w(12)),
            child: AppImage(
              path: restaurant.imagePath,
              width: dim.w(70),
              height: dim.w(70),
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: dim.w(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _HighlightText(
                        text: restaurant.name,
                        query: query,
                        dim: dim,
                        baseStyle: TextStyle(
                          color: Colors.white,
                          fontSize: dim.f(14),
                          fontWeight: FontWeight.w600,
                        ),
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
                          fontSize: dim.f(9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: dim.h(3)),
                _HighlightText(
                  text: restaurant.cuisine,
                  query: query,
                  dim: dim,
                  baseStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: dim.f(12),
                  ),
                ),
                SizedBox(height: dim.h(7)),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFFFB400),
                      size: dim.w(13),
                    ),
                    SizedBox(width: dim.w(3)),
                    Text(
                      restaurant.rating.toString(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: dim.f(11),
                      ),
                    ),
                    SizedBox(width: dim.w(10)),
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.textHint,
                      size: dim.w(12),
                    ),
                    SizedBox(width: dim.w(3)),
                    Text(
                      '${restaurant.deliveryMinutes} min',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: dim.f(11),
                      ),
                    ),
                    SizedBox(width: dim.w(10)),
                    Text(
                      restaurant.deliveryFee == 'Free'
                          ? '🚀 Free delivery'
                          : restaurant.deliveryFee,
                      style: TextStyle(
                        color: restaurant.deliveryFee == 'Free'
                            ? const Color(0xFF4CAF50)
                            : AppColors.textHint,
                        fontSize: dim.f(11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Highlight matching text
// ─────────────────────────────────────────────
class _HighlightText extends StatelessWidget {
  final String           text;
  final String           query;
  final TextStyle        baseStyle;
  final AppDimensionData dim;
  const _HighlightText({
    required this.text,
    required this.query,
    required this.baseStyle,
    required this.dim,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: baseStyle, maxLines: 1,
          overflow: TextOverflow.ellipsis);
    }
    final lower = text.toLowerCase();
    final q     = query.toLowerCase();
    final idx   = lower.indexOf(q);
    if (idx == -1) {
      return Text(text, style: baseStyle, maxLines: 1,
          overflow: TextOverflow.ellipsis);
    }
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: baseStyle,
        children: [
          if (idx > 0)
            TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + query.length),
            style: baseStyle.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (idx + query.length < text.length)
            TextSpan(text: text.substring(idx + query.length)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty results state
// ─────────────────────────────────────────────
class _EmptyResults extends StatelessWidget {
  final AppDimensionData dim;
  final String           query;
  const _EmptyResults({required this.dim, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dim.w(80),
            height: dim.w(80),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Center(
              child: Text(
                '🔍',
                style: TextStyle(fontSize: dim.w(36)),
              ),
            ),
          ),
          SizedBox(height: dim.h(20)),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.white,
              fontSize: dim.f(18),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: dim.h(8)),
          Text(
            'We couldn\'t find anything for\n"$query"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: dim.f(13),
              height: 1.5,
            ),
          ),
          SizedBox(height: dim.h(24)),
          GestureDetector(
            onTap: () =>
                Get.find<NightBiteSearchController>().clearSearch(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: dim.w(24),
                vertical: dim.h(12),
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryGlow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'Clear Search',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: dim.f(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}