import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_image.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dim  = AppDimensions.of(context);
    final ctrl = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header sliver
          SliverToBoxAdapter(
            child: _ProfileHeader(dim: dim, ctrl: ctrl),
          ),

          // ── Stats row
          SliverToBoxAdapter(
            child: _StatsRow(dim: dim, ctrl: ctrl),
          ),

          SliverToBoxAdapter(child: SizedBox(height: dim.h(20))),

          // ── Past orders
          SliverToBoxAdapter(
            child: _SectionLabel(dim: dim, label: 'Recent Orders'),
          ),
          SliverToBoxAdapter(
            child: _PastOrders(dim: dim, ctrl: ctrl),
          ),

          SliverToBoxAdapter(child: SizedBox(height: dim.h(20))),

          // ── Account settings
          SliverToBoxAdapter(
            child: _SectionLabel(dim: dim, label: 'Account'),
          ),
          SliverToBoxAdapter(
            child: _SettingsCard(
              dim: dim,
              items: ctrl.accountSettings,
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: dim.h(16))),

          // ── Preferences
          SliverToBoxAdapter(
            child: _SectionLabel(dim: dim, label: 'Preferences'),
          ),
          SliverToBoxAdapter(
            child: _PreferencesCard(dim: dim, ctrl: ctrl),
          ),

          SliverToBoxAdapter(child: SizedBox(height: dim.h(16))),

          // ── Support
          SliverToBoxAdapter(
            child: _SectionLabel(dim: dim, label: 'Support'),
          ),
          SliverToBoxAdapter(
            child: _SettingsCard(
              dim: dim,
              items: ctrl.supportSettings,
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: dim.h(20))),

          // ── Logout
          SliverToBoxAdapter(
            child: _LogoutButton(dim: dim, ctrl: ctrl),
          ),

          // ── Version
          SliverToBoxAdapter(
            child: _VersionInfo(dim: dim),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: dim.h(40) + dim.bottomPadding),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Profile header
// ─────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final AppDimensionData dim;
  final ProfileController ctrl;
  const _ProfileHeader({required this.dim, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding,
        dim.topPadding + dim.h(16),
        dim.pagePadding,
        dim.h(28),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF15152A),
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        children: [
          // Top row — title + edit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: dim.f(22),
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => Get.snackbar(
                  'Edit Profile',
                  'Coming soon!',
                  backgroundColor: const Color(0xFF15152A),
                  colorText: Colors.white,
                  borderRadius: 12,
                  margin: EdgeInsets.all(dim.w(16)),
                  snackPosition: SnackPosition.TOP,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: dim.w(14),
                    vertical: dim.h(7),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGlow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: dim.w(14),
                      ),
                      SizedBox(width: dim.w(5)),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: dim.f(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: dim.h(24)),

          // Avatar row
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: dim.w(80),
                    height: dim.w(80),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF2A1A05), Color(0xFF1A0F03)],
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Obx(() => Text(
                        ctrl.avatar.value,
                        style: TextStyle(fontSize: dim.w(38)),
                      )),
                    ),
                  ),
                  // Online indicator
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: dim.w(18),
                      height: dim.w(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: dim.w(18)),

              // Name + info
              Expanded(
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ctrl.name.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dim.f(20),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: dim.h(4)),
                    Text(
                      ctrl.email.value,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: dim.f(13),
                      ),
                    ),
                    SizedBox(height: dim.h(4)),
                    Text(
                      ctrl.phone.value,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: dim.f(12),
                      ),
                    ),
                    SizedBox(height: dim.h(8)),
                    // Member since pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: dim.w(10),
                        vertical: dim.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB400).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFFB400)
                              .withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.workspace_premium_rounded,
                            color: Color(0xFFFFB400),
                            size: 12,
                          ),
                          SizedBox(width: dim.w(4)),
                          Text(
                            'Member since ${ctrl.memberSince.value}',
                            style: const TextStyle(
                              color: Color(0xFFFFB400),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stats row
// ─────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final AppDimensionData dim;
  final ProfileController ctrl;
  const _StatsRow({required this.dim, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: dim.pagePadding),
      child: Row(
        children: [
          _StatCard(
            dim: dim,
            value: '${ctrl.totalOrders.value}',
            label: 'Orders',
            icon: Icons.receipt_long_rounded,
            color: AppColors.primary,
          ),
          SizedBox(width: dim.w(10)),
          _StatCard(
            dim: dim,
            value: '₹${ctrl.totalSaved.value.toStringAsFixed(0)}',
            label: 'Saved',
            icon: Icons.savings_outlined,
            color: const Color(0xFF4CAF50),
          ),
          SizedBox(width: dim.w(10)),
          _StatCard(
            dim: dim,
            value: ctrl.favCuisine.value,
            label: 'Favourite',
            icon: Icons.favorite_rounded,
            color: const Color(0xFFFFB400),
          ),
        ],
      ),
    ));
  }
}

class _StatCard extends StatelessWidget {
  final AppDimensionData dim;
  final String           value;
  final String           label;
  final IconData         icon;
  final Color            color;
  const _StatCard({
    required this.dim,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: dim.h(14),
          horizontal: dim.w(10),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF15152A),
          borderRadius: BorderRadius.circular(dim.w(16)),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: dim.w(32),
              height: dim.w(32),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: dim.w(16)),
            ),
            SizedBox(height: dim.h(8)),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: dim.f(15),
                fontWeight: FontWeight.w700,
                height: 1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: dim.h(3)),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: dim.f(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final AppDimensionData dim;
  final String           label;
  const _SectionLabel({required this.dim, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        dim.pagePadding, 0, dim.pagePadding, dim.h(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: dim.f(11),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Past orders
// ─────────────────────────────────────────────
class _PastOrders extends StatelessWidget {
  final AppDimensionData dim;
  final ProfileController ctrl;
  const _PastOrders({required this.dim, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dim.pagePadding),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF15152A),
          borderRadius: BorderRadius.circular(dim.w(20)),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: List.generate(ctrl.pastOrders.length, (i) {
            final order = ctrl.pastOrders[i];
            final isLast = i == ctrl.pastOrders.length - 1;
            return _OrderRow(
              dim: dim,
              order: order,
              isLast: isLast,
            );
          }),
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final AppDimensionData       dim;
  final Map<String, dynamic>   order;
  final bool                   isLast;
  const _OrderRow({
    required this.dim,
    required this.order,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(dim.w(14)),
          child: Row(
            children: [
              // Food image
              ClipRRect(
                borderRadius: BorderRadius.circular(dim.w(10)),
                child: AppImage(
                  path: order['image'] as String,
                  width: dim.w(50),
                  height: dim.w(50),
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: dim.w(12)),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            order['name'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: dim.f(13),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          order['total'] as String,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: dim.f(13),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: dim.h(3)),
                    Row(
                      children: [
                        Text(
                          '${order['id']}  ·  ${order['items']} items',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: dim.f(11),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: dim.h(3)),
                    Row(
                      children: [
                        Text(
                          order['date'] as String,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: dim.f(10),
                          ),
                        ),
                        const Spacer(),
                        // Status pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: dim.w(8),
                            vertical: dim.h(3),
                          ),
                          decoration: BoxDecoration(
                            color: (order['color'] as Color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (order['color'] as Color)
                                  .withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            order['status'] as String,
                            style: TextStyle(
                              color: order['color'] as Color,
                              fontSize: dim.f(9),
                              fontWeight: FontWeight.w600,
                            ),
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

        // Reorder button + divider
        if (!isLast) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(
              dim.w(14), 0, dim.w(14), dim.h(14),
            ),
            child: GestureDetector(
              onTap: () => Get.snackbar(
                'Reorder',
                '${order['name']} added to cart!',
                backgroundColor: const Color(0xFF15152A),
                colorText: Colors.white,
                borderRadius: 12,
                margin: EdgeInsets.all(dim.w(16)),
                snackPosition: SnackPosition.TOP,
              ),
              child: Container(
                height: dim.h(36),
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow,
                  borderRadius: BorderRadius.circular(dim.w(10)),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.replay_rounded,
                        color: AppColors.primary,
                        size: dim.w(14),
                      ),
                      SizedBox(width: dim.w(5)),
                      Text(
                        'Reorder',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: dim.f(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.white.withValues(alpha: 0.05),
            height: 1,
          ),
        ] else ...[
          Padding(
            padding: EdgeInsets.fromLTRB(
              dim.w(14), 0, dim.w(14), dim.h(14),
            ),
            child: GestureDetector(
              onTap: () => Get.snackbar(
                'Reorder',
                '${order['name']} added to cart!',
                backgroundColor: const Color(0xFF15152A),
                colorText: Colors.white,
                borderRadius: 12,
                margin: EdgeInsets.all(dim.w(16)),
                snackPosition: SnackPosition.TOP,
              ),
              child: Container(
                height: dim.h(36),
                decoration: BoxDecoration(
                  color: AppColors.primaryGlow,
                  borderRadius: BorderRadius.circular(dim.w(10)),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.replay_rounded,
                        color: AppColors.primary,
                        size: dim.w(14),
                      ),
                      SizedBox(width: dim.w(5)),
                      Text(
                        'Reorder',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: dim.f(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Settings card
// ─────────────────────────────────────────────
class _SettingsCard extends StatelessWidget {
  final AppDimensionData           dim;
  final List<Map<String, dynamic>> items;
  const _SettingsCard({required this.dim, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dim.pagePadding),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF15152A),
          borderRadius: BorderRadius.circular(dim.w(20)),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: List.generate(items.length, (i) {
            final item   = items[i];
            final isLast = i == items.length - 1;
            return _SettingsRow(
              dim: dim,
              item: item,
              isLast: isLast,
            );
          }),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final AppDimensionData     dim;
  final Map<String, dynamic> item;
  final bool                 isLast;
  const _SettingsRow({
    required this.dim,
    required this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.snackbar(
            item['label'] as String,
            'Coming soon!',
            backgroundColor: const Color(0xFF15152A),
            colorText: Colors.white,
            borderRadius: 12,
            margin: EdgeInsets.all(dim.w(16)),
            snackPosition: SnackPosition.TOP,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: dim.w(16),
              vertical: dim.h(14),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: dim.w(36),
                  height: dim.w(36),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          (item['color'] as Color).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: dim.w(18),
                  ),
                ),

                SizedBox(width: dim.w(14)),

                // Label + sub
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: dim.f(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (item['sub'] != null) ...[
                        SizedBox(height: dim.h(2)),
                        Text(
                          item['sub'] as String,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: dim.f(11),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.2),
                  size: dim.w(20),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            color: Colors.white.withValues(alpha: 0.04),
            height: 1,
            indent: dim.w(66),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Preferences card — toggles
// ─────────────────────────────────────────────
class _PreferencesCard extends StatelessWidget {
  final AppDimensionData dim;
  final ProfileController ctrl;
  const _PreferencesCard({required this.dim, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dim.pagePadding),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF15152A),
          borderRadius: BorderRadius.circular(dim.w(20)),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Obx(() => Column(
          children: [
            _ToggleRow(
              dim: dim,
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              sub: 'Order updates, offers',
              color: AppColors.primary,
              value: ctrl.notificationsOn.value,
              onChanged: ctrl.toggleNotifications,
              isLast: false,
            ),
            _ToggleRow(
              dim: dim,
              icon: Icons.dark_mode_outlined,
              label: 'Dark Mode',
              sub: 'Always on dark theme',
              color: const Color(0xFF7B7BFF),
              value: ctrl.darkModeOn.value,
              onChanged: ctrl.toggleDarkMode,
              isLast: false,
            ),
            _ToggleRow(
              dim: dim,
              icon: Icons.location_on_outlined,
              label: 'Location',
              sub: 'For accurate delivery',
              color: const Color(0xFF4CAF50),
              value: ctrl.locationOn.value,
              onChanged: ctrl.toggleLocation,
              isLast: true,
            ),
          ],
        )),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final AppDimensionData dim;
  final IconData         icon;
  final String           label;
  final String           sub;
  final Color            color;
  final bool             value;
  final Function(bool)   onChanged;
  final bool             isLast;
  const _ToggleRow({
    required this.dim,
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.value,
    required this.onChanged,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dim.w(16),
            vertical: dim.h(14),
          ),
          child: Row(
            children: [
              Container(
                width: dim.w(36),
                height: dim.w(36),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(icon, color: color, size: dim.w(18)),
              ),
              SizedBox(width: dim.w(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dim.f(14),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: dim.h(2)),
                    Text(
                      sub,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: dim.f(11),
                      ),
                    ),
                  ],
                ),
              ),
              // Custom toggle
              GestureDetector(
                onTap: () => onChanged(!value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: dim.w(44),
                  height: dim.w(24),
                  decoration: BoxDecoration(
                    color: value
                        ? color.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(dim.w(12)),
                    border: Border.all(
                      color: value
                          ? color
                          : Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: value
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.all(dim.w(3)),
                      width: dim.w(16),
                      height: dim.w(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: Colors.white.withValues(alpha: 0.04),
            height: 1,
            indent: dim.w(66),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Logout button
// ─────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  final AppDimensionData dim;
  final ProfileController ctrl;
  const _LogoutButton({required this.dim, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dim.pagePadding),
      child: GestureDetector(
        onTap: ctrl.showLogoutDialog,
        child: Container(
          height: dim.h(54),
          decoration: BoxDecoration(
            color: const Color(0xFF2A0A0A),
            borderRadius: BorderRadius.circular(dim.w(16)),
            border: Border.all(
              color: const Color(0xFFFF3D00).withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFF6B35),
                size: 20,
              ),
              SizedBox(width: dim.w(10)),
              const Text(
                'Log Out',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Version info
// ─────────────────────────────────────────────
class _VersionInfo extends StatelessWidget {
  final AppDimensionData dim;
  const _VersionInfo({required this.dim});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dim.h(20)),
      child: Column(
        children: [
          Text(
            'NightBite',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: dim.f(13),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: dim.h(4)),
          Text(
            'Version 1.0.0  ·  Made with ❤️',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.15),
              fontSize: dim.f(11),
            ),
          ),
        ],
      ),
    );
  }
}