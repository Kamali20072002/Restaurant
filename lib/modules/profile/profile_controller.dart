import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../cart/cart_controller.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {

  // User info
  final RxString name      = 'Kamali Dev'.obs;
  final RxString email     = 'kamali@nightbite.app'.obs;
  final RxString phone     = '+91 98765 43210'.obs;
  final RxString memberSince = 'March 2024'.obs;
  final RxString avatar    = '👩‍💻'.obs;

  // Stats
  final RxInt    totalOrders   = 24.obs;
  final RxDouble totalSaved    = 340.0.obs;
  final RxString favCuisine    = 'Biryani'.obs;

  // Toggles
  final RxBool notificationsOn = true.obs;
  final RxBool darkModeOn      = true.obs;
  final RxBool locationOn      = true.obs;

  // Past orders
  final List<Map<String, dynamic>> pastOrders = [
    {
      'id':     '#NB2341',
      'name':   'Chicken Biryani',
      'items':  3,
      'total':  '₹342',
      'date':   'Today, 10:25 AM',
      'status': 'Delivered',
      'image':  'assets/images/food/biryani.jpg',
      'color':  const Color(0xFF4CAF50),
    },
    {
      'id':     '#NB2298',
      'name':   'Margherita Pizza',
      'items':  2,
      'total':  '₹520',
      'date':   'Yesterday, 8:10 PM',
      'status': 'Delivered',
      'image':  'assets/images/food/pizza.jpg',
      'color':  const Color(0xFF4CAF50),
    },
    {
      'id':     '#NB2201',
      'name':   'Pasta Alfredo',
      'items':  1,
      'total':  '₹210',
      'date':   '14 Mar, 1:30 PM',
      'status': 'Delivered',
      'image':  'assets/images/food/pasta.jpg',
      'color':  const Color(0xFF4CAF50),
    },
  ];

  final List<Map<String, dynamic>> accountSettings = [
    {
      'icon':  Icons.person_outline_rounded,
      'label': 'Edit Profile',
      'sub':   'Name, email, phone',
      'color': const Color(0xFF7B7BFF),
    },
    {
      'icon':  Icons.location_on_outlined,
      'label': 'Saved Addresses',
      'sub':   '2 addresses saved',
      'color': const Color(0xFF4CAF50),
    },
    {
      'icon':  Icons.credit_card_rounded,
      'label': 'Payment Methods',
      'sub':   'UPI, cards, wallets',
      'color': const Color(0xFFFFB400),
    },
    {
      'icon':  Icons.favorite_border_rounded,
      'label': 'Favourites',
      'sub':   '8 saved items',
      'color': const Color(0xFFFF6B6B),
    },
  ];

  final List<Map<String, dynamic>> supportSettings = [
    {
      'icon':  Icons.help_outline_rounded,
      'label': 'Help Centre',
      'sub':   'FAQs and support',
      'color': const Color(0xFF7B7BFF),
    },
    {
      'icon':  Icons.star_outline_rounded,
      'label': 'Rate NightBite',
      'sub':   'Love the app? Let us know',
      'color': const Color(0xFFFFB400),
    },
    {
      'icon':  Icons.share_outlined,
      'label': 'Share App',
      'sub':   'Invite friends',
      'color': const Color(0xFF4CAF50),
    },
    {
      'icon':  Icons.info_outline_rounded,
      'label': 'About',
      'sub':   'Version 1.0.0',
      'color': const Color(0xFF888888),
    },
  ];

  void showLogoutDialog() {
    Get.dialog(
      _LogoutDialog(),
      barrierColor: Colors.black.withValues(alpha: 0.6),
    );
  }

  void logout() {
    Get.back(); // close dialog
    Get.find<CartController>().clearCart();
    Get.offAllNamed(AppRoutes.onboarding);
  }

  void toggleNotifications(bool val) => notificationsOn.value = val;
  void toggleDarkMode(bool val)      => darkModeOn.value      = val;
  void toggleLocation(bool val)      => locationOn.value      = val;
}

// ─────────────────────────────────────────────
// Logout dialog widget
// ─────────────────────────────────────────────
class _LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfileController>();
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF15152A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFF3D00).withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF3D00).withValues(alpha: 0.25),
                ),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFF6B35),
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Log out?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You will need to sign in again to place orders.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: ctrl.logout,
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFFF3D00)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF3D00)
                                .withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Log out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}