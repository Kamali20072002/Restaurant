import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

enum OrderStatus { confirmed, preparing, picked, onTheWay, delivered }

class OrderTrackingController extends GetxController {

  final Rx<OrderStatus> currentStatus            = OrderStatus.confirmed.obs;
  final RxInt           etaSeconds               = (22 * 60).obs;
  final RxDouble        bikeProgress             = 0.0.obs;
  final RxBool          orderSummaryExpanded     = false.obs;
  final RxBool          routeLoaded              = false.obs;

  // Real Bengaluru coords
  final LatLng restaurantLocation = const LatLng(12.9352, 77.6245);
  final LatLng deliveryLocation   = const LatLng(12.9784, 77.6408);

  // Route from OSRM — road-following
  final RxList<LatLng> routePoints = <LatLng>[].obs;

  // Live bike position
  final Rx<LatLng> bikeLocation =
      const LatLng(12.9352, 77.6245).obs;

  // Driver
  final String driverName    = 'Arjun Kumar';
  final String driverRating  = '4.9';
  final String driverPhone   = '+91 98765 43210';
  final String vehicleNumber = 'TN 09 AB 1234';
  final String vehicleModel  = 'TVS Apache 160';

  final List<Map<String, dynamic>> steps = [
    {
      'title':   'Confirmed',
      'subtitle':'Restaurant accepted',
      'icon':    Icons.check_circle_outline_rounded,
      'status':  OrderStatus.confirmed,
    },
    {
      'title':   'Preparing',
      'subtitle':'Chef is cooking',
      'icon':    Icons.restaurant_rounded,
      'status':  OrderStatus.preparing,
    },
    {
      'title':   'Picked Up',
      'subtitle':'Driver has order',
      'icon':    Icons.two_wheeler_rounded,
      'status':  OrderStatus.picked,
    },
    {
      'title':   'On Way',
      'subtitle':'Heading to you',
      'icon':    Icons.navigation_rounded,
      'status':  OrderStatus.onTheWay,
    },
    {
      'title':   'Delivered',
      'subtitle':'Enjoy your meal!',
      'icon':    Icons.celebration_rounded,
      'status':  OrderStatus.delivered,
    },
  ];

  Timer? _etaTimer;
  Timer? _bikeTimer;

  @override
  void onInit() {
    super.onInit();
    _fetchRoute();
    _startEtaTimer();
    _startStatusSimulation();
  }

  // Fetch real road route from OSRM
  Future<void> _fetchRoute() async {
    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${restaurantLocation.longitude},${restaurantLocation.latitude};'
        '${deliveryLocation.longitude},${deliveryLocation.latitude}'
        '?overview=full&geometries=geojson&steps=false',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data   = jsonDecode(response.body);
        final coords = data['routes'][0]['geometry']['coordinates'] as List;

        // OSRM returns [longitude, latitude]
        final points = coords
            .map((c) => LatLng(
                  (c[1] as num).toDouble(),
                  (c[0] as num).toDouble(),
                ))
            .toList();

        routePoints.assignAll(points);
        bikeLocation.value = points.first;
        routeLoaded.value  = true;
        _startBikeMovement();
      } else {
        _useFallbackRoute();
      }
    } catch (_) {
      _useFallbackRoute();
    }
  }

  // Fallback if OSRM fails
  void _useFallbackRoute() {
    final fallback = [
      const LatLng(12.9352, 77.6245),
      const LatLng(12.9380, 77.6260),
      const LatLng(12.9420, 77.6280),
      const LatLng(12.9480, 77.6310),
      const LatLng(12.9530, 77.6330),
      const LatLng(12.9580, 77.6355),
      const LatLng(12.9630, 77.6370),
      const LatLng(12.9700, 77.6390),
      const LatLng(12.9750, 77.6400),
      const LatLng(12.9784, 77.6408),
    ];
    routePoints.assignAll(fallback);
    bikeLocation.value = fallback.first;
    routeLoaded.value  = true;
    _startBikeMovement();
  }

  void _startBikeMovement() {
    _bikeTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) {
        if (bikeProgress.value < 1.0 && routePoints.isNotEmpty) {
          bikeProgress.value =
              (bikeProgress.value + 0.0012).clamp(0.0, 1.0);
          _updateBikeLocation();
        }
      },
    );
  }

  void _updateBikeLocation() {
    if (routePoints.isEmpty) return;
    final total = routePoints.length - 1;
    final pos   = bikeProgress.value * total;
    final idx   = pos.floor().clamp(0, total - 1);
    final frac  = pos - idx;
    final a     = routePoints[idx];
    final b     = routePoints[(idx + 1).clamp(0, total)];
    bikeLocation.value = LatLng(
      a.latitude  + (b.latitude  - a.latitude)  * frac,
      a.longitude + (b.longitude - a.longitude) * frac,
    );
  }

  void _startEtaTimer() {
    _etaTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (etaSeconds.value > 0) etaSeconds.value--;
    });
  }

  void _startStatusSimulation() {
    Timer(const Duration(seconds: 4), () {
      currentStatus.value = OrderStatus.preparing;
      Timer(const Duration(seconds: 8), () {
        currentStatus.value = OrderStatus.picked;
        Timer(const Duration(seconds: 8), () {
          currentStatus.value = OrderStatus.onTheWay;
          Timer(const Duration(seconds: 30), () {
            currentStatus.value = OrderStatus.delivered;
            bikeProgress.value  = 1.0;
            etaSeconds.value    = 0;
            _etaTimer?.cancel();
            _bikeTimer?.cancel();
          });
        });
      });
    });
  }

  List<LatLng> get completedRoute {
    if (routePoints.isEmpty) return [];
    final total = routePoints.length - 1;
    final pos   = bikeProgress.value * total;
    final idx   = pos.floor().clamp(0, total - 1);
    final frac  = pos - idx;
    final done  = routePoints.sublist(0, idx + 1).toList();
    if (idx < total) {
      final a = routePoints[idx];
      final b = routePoints[idx + 1];
      done.add(LatLng(
        a.latitude  + (b.latitude  - a.latitude)  * frac,
        a.longitude + (b.longitude - a.longitude) * frac,
      ));
    }
    return done;
  }

  int get currentStepIndex {
    switch (currentStatus.value) {
      case OrderStatus.confirmed:  return 0;
      case OrderStatus.preparing:  return 1;
      case OrderStatus.picked:     return 2;
      case OrderStatus.onTheWay:   return 3;
      case OrderStatus.delivered:  return 4;
    }
  }

  String get etaFormatted {
    if (etaSeconds.value <= 0) return '00:00';
    final m = etaSeconds.value ~/ 60;
    final s = etaSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get statusLabel {
    switch (currentStatus.value) {
      case OrderStatus.confirmed:  return 'Order Confirmed';
      case OrderStatus.preparing:  return 'Preparing Your Food';
      case OrderStatus.picked:     return 'Order Picked Up';
      case OrderStatus.onTheWay:   return 'On the Way';
      case OrderStatus.delivered:  return 'Delivered! 🎉';
    }
  }

  bool get isDelivered =>
      currentStatus.value == OrderStatus.delivered;

  void toggleSummary() =>
      orderSummaryExpanded.value = !orderSummaryExpanded.value;

  @override
  void onClose() {
    _etaTimer?.cancel();
    _bikeTimer?.cancel();
    super.onClose();
  }
}