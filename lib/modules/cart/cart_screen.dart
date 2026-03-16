import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_image.dart';
import '../../core/app_icons.dart';
import '../../core/app_icon_widget.dart';
import '../../data/models/cart_item_model.dart';
import 'cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dim = AppDimensions.of(context);
    final controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(dim: dim),
            Expanded(
              child: Obx(() => controller.isEmpty
                  ? _EmptyCart(dim: dim)
                  : _CartContent(dim: dim, controller: controller)),
            ),
          ],
        ),
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
    final controller = Get.find<CartController>();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding, dim.h(16),
        dim.pagePadding, dim.h(8),
      ),
      child: Row(
        children: [
          // Back
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: dim.w(40),
              height: dim.w(40),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
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

          SizedBox(width: dim.w(16)),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Cart',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: dim.f(22),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Obx(() => Text(
                  '${controller.itemCount} items',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: dim.f(12),
                  ),
                )),
              ],
            ),
          ),

          // Clear all
          Obx(() => controller.isEmpty
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () => _showClearDialog(controller),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: dim.w(12),
                      vertical: dim.h(7),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1AFF5252),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0x33FF5252),
                      ),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: const Color(0xFFFF5252),
                        fontSize: dim.f(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  void _showClearDialog(CartController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Clear Cart?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'All items will be removed.',
          style: TextStyle(color: Colors.white54),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel',
              style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            child: const Text('Clear',
              style: TextStyle(color: Color(0xFFFF5252))),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty cart state
// ─────────────────────────────────────────────
class _EmptyCart extends StatelessWidget {
  final AppDimensionData dim;
  const _EmptyCart({required this.dim});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated empty bag
          Container(
            width: dim.w(120),
            height: dim.w(120),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Center(
              child: AppIcon(
                path: AppIcons.cart,
                size: dim.w(48),
                color: AppColors.textHint,
              ),
            ),
          ),

          SizedBox(height: dim.h(24)),

          Text(
            'Your cart is empty',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: dim.f(20),
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: dim.h(8)),

          Text(
            'Add some delicious food\nto get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: dim.f(14),
              height: 1.5,
            ),
          ),

          SizedBox(height: dim.h(32)),

          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: dim.w(32),
                vertical: dim.h(14),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(dim.w(16)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                'Browse Food',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: dim.f(15),
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

// ─────────────────────────────────────────────
// Cart content — items + summary
// ─────────────────────────────────────────────
class _CartContent extends StatelessWidget {
  final AppDimensionData dim;
  final CartController controller;
  const _CartContent({
    required this.dim,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrollable items + summary
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: dim.h(120)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Items list
              Obx(() => Column(
                children: List.generate(
                  controller.items.length,
                  (i) => _CartItemCard(
                    dim: dim,
                    item: controller.items[i],
                    index: i,
                    controller: controller,
                  ),
                ),
              )),

              SizedBox(height: dim.h(8)),

              // Promo code
              _PromoSection(dim: dim, controller: controller),

              SizedBox(height: dim.h(16)),

              // Price breakdown
              _PriceSummary(dim: dim, controller: controller),

              SizedBox(height: dim.h(16)),
            ],
          ),
        ),

        // Sticky place order button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _PlaceOrderBar(dim: dim, controller: controller),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Cart item card — swipe to delete
// ─────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final AppDimensionData dim;
  final CartItemModel item;
  final int index;
  final CartController controller;

  const _CartItemCard({
    required this.dim,
    required this.item,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('${item.food.id}_${item.selectedSize}_$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.removeItem(index),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: dim.w(20)),
        margin: EdgeInsets.fromLTRB(
          dim.pagePadding, 0, dim.pagePadding, dim.h(12),
        ),
        decoration: BoxDecoration(
          color: const Color(0x1AFF5252),
          borderRadius: BorderRadius.circular(dim.w(18)),
          border: Border.all(color: const Color(0x33FF5252)),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Color(0xFFFF5252),
          size: 24,
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(
          dim.pagePadding, 0, dim.pagePadding, dim.h(12),
        ),
        padding: EdgeInsets.all(dim.w(12)),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(dim.w(18)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            // Food image
            ClipRRect(
              borderRadius: BorderRadius.circular(dim.w(12)),
              child: AppImage(
                path: item.food.imagePath,
                width: dim.w(72),
                height: dim.w(72),
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: dim.w(12)),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.food.name,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: dim.f(14),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: dim.h(4)),

                  // Size + spice chips
                  Row(
                    children: [
                      _MiniChip(
                        dim: dim,
                        label: item.selectedSize,
                      ),
                      SizedBox(width: dim.w(6)),
                      _MiniChip(
                        dim: dim,
                        label: item.selectedSpice,
                        color: const Color(0xFFFF6B35),
                      ),
                    ],
                  ),

                  SizedBox(height: dim.h(8)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '₹${item.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: dim.f(15),
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      // Qty control
                      _QuantityControl(
                        dim: dim,
                        item: item,
                        index: index,
                        controller: controller,
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
// Mini chip for size/spice
// ─────────────────────────────────────────────
class _MiniChip extends StatelessWidget {
  final AppDimensionData dim;
  final String label;
  final Color? color;
  const _MiniChip({required this.dim, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dim.w(8),
        vertical: dim.h(3),
      ),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: c,
          fontSize: dim.f(10),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Quantity control inside cart card
// ─────────────────────────────────────────────
class _QuantityControl extends StatelessWidget {
  final AppDimensionData dim;
  final CartItemModel item;
  final int index;
  final CartController controller;

  const _QuantityControl({
    required this.dim,
    required this.item,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(dim.w(10)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus
          GestureDetector(
            onTap: () => controller.decrementItem(index),
            child: Container(
              width: dim.w(30),
              height: dim.w(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dim.w(8)),
              ),
              child: Icon(
                item.quantity == 1
                    ? Icons.delete_outline_rounded
                    : Icons.remove_rounded,
                color: item.quantity == 1
                    ? const Color(0xFFFF5252)
                    : AppColors.textSecondary,
                size: dim.w(14),
              ),
            ),
          ),

          // Count
          SizedBox(
            width: dim.w(24),
            child: Center(
              child: Text(
                '${item.quantity}',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: dim.f(13),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Plus
          GestureDetector(
            onTap: () => controller.incrementItem(index),
            child: Container(
              width: dim.w(30),
              height: dim.w(30),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(dim.w(8)),
              ),
              child: Icon(
                Icons.add_rounded,
                color: AppColors.primary,
                size: dim.w(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Promo code section
// ─────────────────────────────────────────────
class _PromoSection extends StatelessWidget {
  final AppDimensionData dim;
  final CartController controller;
  const _PromoSection({
    required this.dim,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textCtrl = TextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dim.pagePadding),
      child: Obx(() {
        if (controller.promoApplied.value) {
          // Applied state
          return Container(
            padding: EdgeInsets.all(dim.w(14)),
            decoration: BoxDecoration(
              color: const Color(0x1A4CAF50),
              borderRadius: BorderRadius.circular(dim.w(14)),
              border: Border.all(color: const Color(0x334CAF50)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
                SizedBox(width: dim.w(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Promo applied: ${controller.promoCode.value}',
                        style: TextStyle(
                          color: const Color(0xFF4CAF50),
                          fontSize: dim.f(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${controller.discountPercent.toInt()}% discount applied',
                        style: TextStyle(
                          color: const Color(0xFF4CAF50)
                              .withValues(alpha: 0.7),
                          fontSize: dim.f(11),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: controller.removePromo,
                  child: Icon(
                    Icons.close_rounded,
                    color: const Color(0xFF4CAF50),
                    size: dim.w(18),
                  ),
                ),
              ],
            ),
          );
        }

        // Input state
        return Container(
          height: dim.h(52),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(dim.w(14)),
            border: Border.all(
              color: controller.promoError.value.isNotEmpty
                  ? const Color(0x66FF5252)
                  : AppColors.glassBorder,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: dim.w(14)),
              const Icon(
                Icons.local_offer_outlined,
                color: AppColors.textHint,
                size: 18,
              ),
              SizedBox(width: dim.w(10)),
              Expanded(
                child: TextField(
                  controller: textCtrl,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: dim.f(13),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: controller.promoError.value.isNotEmpty
                        ? controller.promoError.value
                        : 'Enter promo code',
                    hintStyle: TextStyle(
                      color: controller.promoError.value.isNotEmpty
                          ? const Color(0xFFFF5252)
                          : AppColors.textHint,
                      fontSize: dim.f(13),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => controller.applyPromo(textCtrl.text),
                child: Container(
                  margin: EdgeInsets.all(dim.w(7)),
                  padding: EdgeInsets.symmetric(
                    horizontal: dim.w(14),
                    vertical: dim.h(6),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(dim.w(10)),
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dim.f(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// Price summary card
// ─────────────────────────────────────────────
class _PriceSummary extends StatelessWidget {
  final AppDimensionData dim;
  final CartController controller;
  const _PriceSummary({
    required this.dim,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: EdgeInsets.symmetric(horizontal: dim.pagePadding),
      padding: EdgeInsets.all(dim.w(18)),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(dim.w(18)),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          _PriceRow(
            dim: dim,
            label: 'Subtotal',
            value: controller.fmt(controller.subtotal),
          ),

          if (controller.promoApplied.value) ...[
            SizedBox(height: dim.h(10)),
            _PriceRow(
              dim: dim,
              label: 'Discount (${controller.discountPercent.toInt()}%)',
              value: '- ${controller.fmt(controller.discountAmount)}',
              valueColor: const Color(0xFF4CAF50),
            ),
          ],

          SizedBox(height: dim.h(10)),
          _PriceRow(
            dim: dim,
            label: 'Delivery Fee',
            value: controller.deliveryFee == 0
                ? 'FREE'
                : controller.fmt(controller.deliveryFee),
            valueColor: controller.deliveryFee == 0
                ? const Color(0xFF4CAF50)
                : null,
          ),

          SizedBox(height: dim.h(10)),
          _PriceRow(
            dim: dim,
            label: 'Taxes (5%)',
            value: controller.fmt(controller.taxes),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: dim.h(12)),
            child: Container(
              height: 0.5,
              color: AppColors.glassBorder,
            ),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: dim.f(16),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                controller.fmt(controller.total),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: dim.f(20),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          // Free delivery note
          if (controller.deliveryFee > 0) ...[
            SizedBox(height: dim.h(10)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: dim.w(12),
                vertical: dim.h(8),
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryGlow,
                borderRadius: BorderRadius.circular(dim.w(8)),
              ),
              child: Text(
                'Add ₹${(200 - controller.subtotal).toStringAsFixed(0)} more for free delivery!',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: dim.f(11),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    ));
  }
}

class _PriceRow extends StatelessWidget {
  final AppDimensionData dim;
  final String label;
  final String value;
  final Color? valueColor;

  const _PriceRow({
    required this.dim,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: dim.f(13),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: dim.f(13),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Place order sticky bar
// ─────────────────────────────────────────────
class _PlaceOrderBar extends StatelessWidget {
  final AppDimensionData dim;
  final CartController controller;
  const _PlaceOrderBar({
    required this.dim,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding,
        dim.h(12),
        dim.pagePadding,
        dim.h(20) + dim.bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.glassBorder,
            width: 0.5,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          // Will wire to order tracking in next step
          Get.snackbar(
            'Order Placed! 🎉',
            'Your food is being prepared',
            backgroundColor: AppColors.surfaceLight,
            colorText: AppColors.textPrimary,
            borderRadius: 12,
            margin: EdgeInsets.all(dim.w(16)),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
          );
        },
        child: Obx(() => Container(
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
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Place Order',
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
                  controller.fmt(controller.total),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: dim.f(13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}