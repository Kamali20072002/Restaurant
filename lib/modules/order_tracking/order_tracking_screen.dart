import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui' as ui;
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_image.dart';
import '../cart/cart_controller.dart';
import '../../routes/app_routes.dart';
import 'order_tracking_controller.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dim        = AppDimensions.of(context);
    final controller = Get.find<OrderTrackingController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Map top 52%
          Positioned(
            top: 0, left: 0, right: 0,
            height: dim.screenHeight * 0.52,
            child: _OSMMapView(dim: dim, controller: controller),
          ),

          // Top bar over map
          Positioned(
            top: dim.topPadding + dim.h(10),
            left: dim.w(16),
            right: dim.w(16),
            child: _TopBar(dim: dim),
          ),

          // Bottom sheet 53%
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: dim.screenHeight * 0.53,
            child: _PremiumBottomSheet(dim: dim, controller: controller),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// OSM Map
// ─────────────────────────────────────────────
class _OSMMapView extends StatefulWidget {
  final AppDimensionData dim;
  final OrderTrackingController controller;
  const _OSMMapView({required this.dim, required this.controller});

  @override
  State<_OSMMapView> createState() => _OSMMapViewState();
}

class _OSMMapViewState extends State<_OSMMapView> {
  late final MapController _mapController;
  bool _followBike = true;
  late LatLng _bikePos;
  late List<LatLng> _completedRoute;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _bikePos        = widget.controller.bikeLocation.value;
    _completedRoute = widget.controller.completedRoute;

    // Bike position updates
    ever(widget.controller.bikeLocation, (LatLng loc) {
      if (mounted) {
        setState(() {
          _bikePos        = loc;
          _completedRoute = widget.controller.completedRoute;
          if (_followBike) {
            _mapController.move(loc, _mapController.camera.zoom);
          }
        });
      }
    });

    // Route loaded from OSRM
    ever(widget.controller.routePoints, (_) {
      if (mounted) setState(() {
        _completedRoute = widget.controller.completedRoute;
      });
    });

    // Progress updates
    ever(widget.controller.bikeProgress, (double _) {
      if (mounted) setState(() {
        _completedRoute = widget.controller.completedRoute;
      });
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Widget _darkTile(BuildContext ctx, Widget tile, TileImage img) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.22, 0.22, 0.22, 0, -30,
        0.22, 0.22, 0.22, 0, -30,
        0.22, 0.22, 0.22, 0, -30,
        0,    0,    0,    1,   0,
      ]),
      child: tile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dim        = widget.dim;
    final controller = widget.controller;

    return ClipRect(
      child: Stack(
        children: [

          // ── Real OSM Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                (controller.restaurantLocation.latitude +
                        controller.deliveryLocation.latitude) / 2,
                (controller.restaurantLocation.longitude +
                        controller.deliveryLocation.longitude) / 2,
              ),
              initialZoom: 14.0,
              minZoom: 10,
              maxZoom: 18,
              onPositionChanged: (_, hasGesture) {
                if (hasGesture) setState(() => _followBike = false);
              },
            ),
            children: [
              // Dark OSM tiles
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.restaurant',
                tileBuilder: _darkTile,
                maxZoom: 19,
              ),

              // Grey remaining route
              PolylineLayer(
                polylines: [
                  if (controller.routePoints.isNotEmpty)
                    Polyline(
                      points: controller.routePoints.toList(),
                      color: const Color(0x663A3A70),
                      strokeWidth: 6,
                    ),
                ],
              ),

              // Orange completed route
              PolylineLayer(
                polylines: [
                  if (_completedRoute.isNotEmpty)
                    Polyline(
                      points: _completedRoute,
                      color: AppColors.primary,
                      strokeWidth: 6,
                      borderStrokeWidth: 3,
                      borderColor:
                          AppColors.primary.withValues(alpha: 0.25),
                    ),
                ],
              ),

              // Markers
              MarkerLayer(
                markers: [
                  Marker(
                    point: controller.restaurantLocation,
                    width: dim.w(80),
                    height: dim.w(72),
                    child: _MapPin(
                      dim: dim,
                      color: AppColors.primary,
                      icon: Icons.restaurant_rounded,
                      label: 'Restaurant',
                    ),
                  ),
                  Marker(
                    point: controller.deliveryLocation,
                    width: dim.w(64),
                    height: dim.w(64),
                    child: _MapPin(
                      dim: dim,
                      color: const Color(0xFF4CAF50),
                      icon: Icons.home_rounded,
                      label: 'You',
                    ),
                  ),
                  Marker(
                    point: _bikePos,
                    width: dim.w(52),
                    height: dim.w(52),
                    child: _BikeMarker(dim: dim),
                  ),
                ],
              ),
            ],
          ),

          // ── Bottom fade
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: 90,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.8),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          // ── Route loading overlay
          Obx(() => controller.routeLoaded.value
              ? const SizedBox.shrink()
              : Positioned(
                  top: 0, left: 0, right: 0, bottom: 0,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.35),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Loading route...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

          // ── Zoom controls
          Positioned(
            right: dim.w(12),
            bottom: dim.h(100),
            child: Column(
              children: [
                _MapBtn(
                  icon: Icons.add_rounded,
                  dim: dim,
                  onTap: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                ),
                SizedBox(height: dim.h(6)),
                _MapBtn(
                  icon: Icons.remove_rounded,
                  dim: dim,
                  onTap: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                ),
                SizedBox(height: dim.h(6)),
                _MapBtn(
                  icon: _followBike
                      ? Icons.my_location_rounded
                      : Icons.location_searching_rounded,
                  color: _followBike ? AppColors.primary : Colors.white,
                  dim: dim,
                  onTap: () {
                    setState(() => _followBike = true);
                    _mapController.move(
                      controller.bikeLocation.value,
                      15.0,
                    );
                  },
                ),
              ],
            ),
          ),

          // ── Route % chip
          Positioned(
            left: dim.w(12),
            bottom: dim.h(100),
            child: Obx(() {
              final pct =
                  (controller.bikeProgress.value * 100).toInt();
              return _PercentChip(dim: dim, pct: pct);
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Map control button
// ─────────────────────────────────────────────
class _MapBtn extends StatelessWidget {
  final IconData     icon;
  final VoidCallback onTap;
  final AppDimensionData dim;
  final Color?       color;
  const _MapBtn({
    required this.icon,
    required this.onTap,
    required this.dim,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: dim.w(38),
        height: dim.w(38),
        decoration: BoxDecoration(
          color: const Color(0xEE13131A),
          borderRadius: BorderRadius.circular(dim.w(10)),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color ?? Colors.white, size: dim.w(18)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Route percent chip
// ─────────────────────────────────────────────
class _PercentChip extends StatelessWidget {
  final AppDimensionData dim;
  final int pct;
  const _PercentChip({required this.dim, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dim.w(12),
        vertical: dim.h(7),
      ),
      decoration: BoxDecoration(
        color: const Color(0xEE0A0A0F),
        borderRadius: BorderRadius.circular(dim.w(20)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dim.w(6),
            height: dim.w(6),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: dim.w(6)),
          Text(
            '$pct% covered',
            style: TextStyle(
              color: Colors.white,
              fontSize: dim.f(10),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Map pin
// ─────────────────────────────────────────────
class _MapPin extends StatelessWidget {
  final AppDimensionData dim;
  final Color            color;
  final IconData         icon;
  final String           label;
  const _MapPin({
    required this.dim,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: dim.w(6),
            vertical: dim.h(2),
          ),
          decoration: BoxDecoration(
            color: const Color(0xF00A0A0F),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: dim.f(9),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: dim.h(2)),
        Container(
          width: dim.w(28),
          height: dim.w(28),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: dim.w(14)),
        ),
        CustomPaint(
          painter: _TrianglePainter(color: color),
          size: Size(dim.w(10), dim.h(5)),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }
  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────
// Pulsing bike marker
// ─────────────────────────────────────────────
class _BikeMarker extends StatefulWidget {
  final AppDimensionData dim;
  const _BikeMarker({required this.dim});

  @override
  State<_BikeMarker> createState() => _BikeMarkerState();
}

class _BikeMarkerState extends State<_BikeMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.8, end: 1.15).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final dim = widget.dim;
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: _pulse.value,
            child: Container(
              width: dim.w(44),
              height: dim.w(44),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.18),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
          ),
          Container(
            width: dim.w(34),
            height: dim.w(34),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF8C42), Color(0xFFFF3D00)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text('🛵',
                style: TextStyle(fontSize: dim.w(16)),
              ),
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
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.offAllNamed(AppRoutes.home),
          child: Container(
            width: dim.w(42),
            height: dim.w(42),
            decoration: BoxDecoration(
              color: const Color(0xCC0A0A0F),
              borderRadius: BorderRadius.circular(dim.w(14)),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
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
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: dim.w(14),
            vertical: dim.h(8),
          ),
          decoration: BoxDecoration(
            color: const Color(0xCC0A0A0F),
            borderRadius: BorderRadius.circular(dim.w(20)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: dim.w(7),
                height: dim.w(7),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: dim.w(7)),
              Text(
                'Order #NB2341',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: dim.f(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Premium bottom sheet
// ─────────────────────────────────────────────
class _PremiumBottomSheet extends StatelessWidget {
  final AppDimensionData dim;
  final OrderTrackingController controller;
  const _PremiumBottomSheet({
    required this.dim,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F18),
        borderRadius: BorderRadius.only(
          topLeft:  Radius.circular(dim.w(28)),
          topRight: Radius.circular(dim.w(28)),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: dim.h(10)),
            width: dim.w(36),
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: dim.h(14)),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                dim.pagePadding, 0,
                dim.pagePadding,
                dim.h(20) + dim.bottomPadding,
              ),
              child: Column(
                children: [
                  _ETAStatusRow(dim: dim, controller: controller),
                  SizedBox(height: dim.h(12)),
                  _DriverCard(dim: dim, controller: controller),
                  SizedBox(height: dim.h(12)),
                  _Timeline(dim: dim, controller: controller),
                  SizedBox(height: dim.h(12)),
                  _OrderSummary(dim: dim, controller: controller),
                  SizedBox(height: dim.h(14)),
                  _Actions(dim: dim, controller: controller),
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
// ETA + Status row
// ─────────────────────────────────────────────
class _ETAStatusRow extends StatelessWidget {
  final AppDimensionData dim;
  final OrderTrackingController controller;
  const _ETAStatusRow({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final delivered = controller.isDelivered;
      return Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(dim.w(14)),
              decoration: BoxDecoration(
                color: const Color(0xFF15152A),
                borderRadius: BorderRadius.circular(dim.w(16)),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: dim.w(6),
                        height: dim.w(6),
                        decoration: BoxDecoration(
                          color: delivered
                              ? const Color(0xFF4CAF50)
                              : AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: dim.w(5)),
                      Text(
                        delivered ? 'Delivered' : 'Arriving in',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: dim.f(10),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: dim.h(6)),
                  Text(
                    delivered ? '✓ Done' : controller.etaFormatted,
                    style: TextStyle(
                      color: delivered
                          ? const Color(0xFF4CAF50)
                          : AppColors.primary,
                      fontSize: dim.f(30),
                      fontWeight: FontWeight.w800,
                      height: 1,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (!delivered)
                    Text(
                      'min remaining',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: dim.f(10),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(width: dim.w(10)),

          Expanded(
            child: Container(
              padding: EdgeInsets.all(dim.w(14)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: delivered
                      ? [
                          const Color(0xFF0E2A18),
                          const Color(0xFF0A1F12),
                        ]
                      : [
                          const Color(0xFF2A1505),
                          const Color(0xFF1A0D03),
                        ],
                ),
                borderRadius: BorderRadius.circular(dim.w(16)),
                border: Border.all(
                  color: (delivered
                          ? const Color(0xFF4CAF50)
                          : AppColors.primary)
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Status',
                    style: TextStyle(
                      color: (delivered
                              ? const Color(0xFF4CAF50)
                              : AppColors.primary)
                          .withValues(alpha: 0.7),
                      fontSize: dim.f(10),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: dim.h(6)),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      controller.statusLabel,
                      key: ValueKey(controller.currentStatus.value),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dim.f(13),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: dim.h(6)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: controller.bikeProgress.value,
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        delivered
                            ? const Color(0xFF4CAF50)
                            : AppColors.primary,
                      ),
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────
// Driver card
// ─────────────────────────────────────────────
class _DriverCard extends StatelessWidget {
  final AppDimensionData dim;
  final OrderTrackingController controller;
  const _DriverCard({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(dim.w(14)),
      decoration: BoxDecoration(
        color: const Color(0xFF15152A),
        borderRadius: BorderRadius.circular(dim.w(16)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: dim.w(48),
                height: dim.w(48),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A1505), Color(0xFF1A0D03)],
                  ),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text('👨',
                    style: TextStyle(fontSize: dim.w(24)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: dim.w(12),
                  height: dim.w(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF15152A),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: dim.w(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.driverName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: dim.f(14),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: dim.h(2)),
                Row(
                  children: [
                    Icon(Icons.star_rounded,
                      color: const Color(0xFFFFB400),
                      size: dim.w(12),
                    ),
                    SizedBox(width: dim.w(3)),
                    Text(
                      controller.driverRating,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: dim.f(11),
                      ),
                    ),
                    Text(
                      '  ·  ${controller.vehicleNumber}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: dim.f(10),
                      ),
                    ),
                  ],
                ),
                Text(
                  controller.vehicleModel,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: dim.f(10),
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              _ActionBtn(
                dim: dim,
                icon: Icons.call_rounded,
                color: const Color(0xFF4CAF50),
                onTap: () => Get.snackbar(
                  'Calling',
                  controller.driverPhone,
                  backgroundColor: const Color(0xFF15152A),
                  colorText: Colors.white,
                  borderRadius: 12,
                  margin: EdgeInsets.all(dim.w(16)),
                  snackPosition: SnackPosition.TOP,
                ),
              ),
              SizedBox(width: dim.w(8)),
              _ActionBtn(
                dim: dim,
                icon: Icons.chat_bubble_outline_rounded,
                color: AppColors.primary,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final AppDimensionData dim;
  final IconData         icon;
  final Color            color;
  final VoidCallback     onTap;
  const _ActionBtn({
    required this.dim,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: dim.w(38),
        height: dim.w(38),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, color: color, size: dim.w(16)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Horizontal timeline
// ─────────────────────────────────────────────
class _Timeline extends StatelessWidget {
  final AppDimensionData dim;
  final OrderTrackingController controller;
  const _Timeline({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dim.w(14),
        vertical: dim.h(14),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF15152A),
        borderRadius: BorderRadius.circular(dim.w(16)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Obx(() {
        final stepIdx = controller.currentStepIndex;
        return Row(
          children: List.generate(controller.steps.length, (i) {
            final isDone   = i <= stepIdx;
            final isActive = i == stepIdx;
            final isLast   = i == controller.steps.length - 1;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          width: dim.w(isActive ? 34 : 26),
                          height: dim.w(isActive ? 34 : 26),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? AppColors.primary
                                : isDone
                                    ? const Color(0xFF1A3A1A)
                                    : const Color(0xFF1A1A2E),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.primary
                                  : isDone
                                      ? const Color(0xFF4CAF50)
                                      : Colors.white
                                          .withValues(alpha: 0.1),
                              width: isActive ? 0 : 1.5,
                            ),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.5),
                                      blurRadius: 12,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: isActive
                                ? Icon(
                                    controller.steps[i]['icon'] as IconData,
                                    color: Colors.white,
                                    size: dim.w(14),
                                  )
                                : isDone
                                    ? Icon(
                                        Icons.check_rounded,
                                        color: const Color(0xFF4CAF50),
                                        size: dim.w(13),
                                      )
                                    : Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.3),
                                          fontSize: dim.f(9),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                          ),
                        ),
                        SizedBox(height: dim.h(5)),
                        Text(
                          controller.steps[i]['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : isDone
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : Colors.white.withValues(alpha: 0.2),
                            fontSize: dim.f(8),
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: EdgeInsets.only(bottom: dim.h(16)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: i < stepIdx
                              ? const Color(0xFF4CAF50)
                              : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// Order summary
// ─────────────────────────────────────────────
class _OrderSummary extends StatelessWidget {
  final AppDimensionData dim;
  final OrderTrackingController controller;
  const _OrderSummary({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    final cartCtrl = Get.find<CartController>();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF15152A),
        borderRadius: BorderRadius.circular(dim.w(16)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.toggleSummary,
            child: Padding(
              padding: EdgeInsets.all(dim.w(14)),
              child: Row(
                children: [
                  Container(
                    width: dim.w(30),
                    height: dim.w(30),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.primary,
                      size: dim.w(14),
                    ),
                  ),
                  SizedBox(width: dim.w(10)),
                  Expanded(
                    child: Text(
                      'Order Summary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dim.f(13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    cartCtrl.fmt(cartCtrl.total),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: dim.f(13),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: dim.w(6)),
                  Obx(() => AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: controller.orderSummaryExpanded.value
                        ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 18,
                    ),
                  )),
                ],
              ),
            ),
          ),
          Obx(() => AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: controller.orderSummaryExpanded.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: EdgeInsets.fromLTRB(
                dim.w(14), 0, dim.w(14), dim.h(14),
              ),
              child: Column(
                children: [
                  Divider(
                    color: Colors.white.withValues(alpha: 0.06),
                    height: 1,
                  ),
                  SizedBox(height: dim.h(10)),
                  ...cartCtrl.items.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: dim.h(8)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AppImage(
                            path: item.food.imagePath,
                            width: dim.w(36),
                            height: dim.w(36),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: dim.w(10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.food.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: dim.f(12),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${item.selectedSize} · ${item.selectedSpice}',
                                style: TextStyle(
                                  color: Colors.white
                                      .withValues(alpha: 0.3),
                                  fontSize: dim.f(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'x${item.quantity}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: dim.f(11),
                          ),
                        ),
                        SizedBox(width: dim.w(8)),
                        Text(
                          '₹${item.totalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: dim.f(12),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Action buttons
// ─────────────────────────────────────────────
class _Actions extends StatelessWidget {
  final AppDimensionData dim;
  final OrderTrackingController controller;
  const _Actions({required this.dim, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final delivered = controller.isDelivered;
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Get.offAllNamed(AppRoutes.home),
              child: Container(
                height: dim.h(50),
                decoration: BoxDecoration(
                  color: const Color(0xFF15152A),
                  borderRadius: BorderRadius.circular(dim.w(14)),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: dim.f(13),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: dim.w(10)),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                if (delivered) {
                  Get.find<CartController>().clearCart();
                  Get.offAllNamed(AppRoutes.home);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: dim.h(50),
                decoration: BoxDecoration(
                  gradient: delivered
                      ? const LinearGradient(
                          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFFFF8C42), Color(0xFFFF3D00)],
                        ),
                  borderRadius: BorderRadius.circular(dim.w(14)),
                  boxShadow: [
                    BoxShadow(
                      color: (delivered
                              ? const Color(0xFF4CAF50)
                              : AppColors.primary)
                          .withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    delivered
                        ? '🎉  Rate Experience'
                        : '🛵  Tracking Live',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dim.f(13),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}