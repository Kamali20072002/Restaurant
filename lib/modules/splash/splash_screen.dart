import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../../core/app_assets.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Phase 1: background pulse
  late AnimationController _bgCtrl;
  late Animation<double> _bgScale;

  // ── Phase 2: logo container drop-in
  late AnimationController _logoCtrl;
  late Animation<double> _logoY;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  // ── Phase 3: ring expand
  late AnimationController _ringCtrl;
  late Animation<double> _ring1Scale;
  late Animation<double> _ring1Fade;
  late Animation<double> _ring2Scale;
  late Animation<double> _ring2Fade;

  // ── Phase 4: wordmark slide up
  late AnimationController _wordCtrl;
  late Animation<double> _wordY;
  late Animation<double> _wordFade;

  // ── Phase 5: tagline + loader
  late AnimationController _tagCtrl;
  late Animation<double> _tagFade;

  // ── Phase 6: exit
  late AnimationController _exitCtrl;
  late Animation<double> _exitFade;

  // ── Continuous: orbit ring
  late AnimationController _orbitCtrl;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _runSequence();
  }

  void _setupAnimations() {
    // Background pulse
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bgScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgCtrl, curve: Curves.easeOut),
    );

    // Logo drop
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoY = Tween<double>(begin: -40, end: 0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutCubic),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );

    // Rings expand
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _ring1Scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _ringCtrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _ring1Fade = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(
        parent: _ringCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    _ring2Scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _ringCtrl,
        curve: const Interval(0.15, 0.85, curve: Curves.easeOut),
      ),
    );
    _ring2Fade = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _ringCtrl,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );

    // Wordmark
    _wordCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _wordY = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _wordCtrl, curve: Curves.easeOutCubic),
    );
    _wordFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _wordCtrl, curve: Curves.easeIn),
    );

    // Tagline
    _tagCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _tagFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _tagCtrl, curve: Curves.easeIn),
    );

    // Orbit
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Exit
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeInCubic),
    );
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));

    // 1 — bg glow expands
    _bgCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    // 2 — logo drops in
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));

    // 3 — ripple rings burst out
    _ringCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    // 4 — wordmark slides up
    _wordCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 250));

    // 5 — tagline fades in
    _tagCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1600));

    // 6 — exit fade
    await _exitCtrl.forward();
    Get.offAllNamed(AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _logoCtrl.dispose();
    _ringCtrl.dispose();
    _wordCtrl.dispose();
    _tagCtrl.dispose();
    _orbitCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dim = AppDimensions.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _exitFade,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── 1. Radial background glow
            AnimatedBuilder(
              animation: _bgScale,
              builder: (_, __) => Transform.scale(
                scale: _bgScale.value,
                child: Container(
                  width: dim.screenWidth * 1.2,
                  height: dim.screenWidth * 1.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        // ignore: deprecated_member_use
                        AppColors.primary.withOpacity(0.18),
                        // ignore: deprecated_member_use
                        AppColors.primary.withOpacity(0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // ── 2. Slow orbit ring (continuous)
            AnimatedBuilder(
              animation: _orbitCtrl,
              builder: (_, __) => Transform.rotate(
                angle: _orbitCtrl.value * 2 * math.pi,
                child: Container(
                  width: dim.w(260),
                  height: dim.w(260),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      // ignore: deprecated_member_use
                      color: AppColors.primary.withOpacity(0.07),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // orbit dot top
                      Positioned(
                        top: 0,
                        child: Container(
                          width: dim.w(6),
                          height: dim.w(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // ignore: deprecated_member_use
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                      ),
                      // orbit dot bottom
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: dim.w(4),
                          height: dim.w(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // ignore: deprecated_member_use
                            color: AppColors.gold.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Counter orbit ring
            AnimatedBuilder(
              animation: _orbitCtrl,
              builder: (_, __) => Transform.rotate(
                angle: -_orbitCtrl.value * 2 * math.pi * 0.6,
                child: Container(
                  width: dim.w(210),
                  height: dim.w(210),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      // ignore: deprecated_member_use
                      color: AppColors.gold.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

            // ── 3. Ripple rings burst
            AnimatedBuilder(
              animation: _ringCtrl,
              builder: (_, __) => Stack(
                alignment: Alignment.center,
                children: [
                  // Ring 1 — larger
                  Opacity(
                    opacity: _ring1Fade.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: _ring1Scale.value,
                      child: Container(
                        width: dim.w(200),
                        height: dim.w(200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: AppColors.primary.withOpacity(0.6),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Ring 2 — smaller
                  Opacity(
                    opacity: _ring2Fade.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: _ring2Scale.value,
                      child: Container(
                        width: dim.w(160),
                        height: dim.w(160),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: AppColors.primary.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── 4. Main content column
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo icon
                AnimatedBuilder(
                  animation: _logoCtrl,
                  builder: (_, __) => FadeTransition(
                    opacity: _logoFade,
                    child: Transform.translate(
                      offset: Offset(0, _logoY.value),
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: _LogoIcon(dim: dim),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: dim.h(28)),

                // Wordmark
                AnimatedBuilder(
                  animation: _wordCtrl,
                  builder: (_, __) => FadeTransition(
                    opacity: _wordFade,
                    child: Transform.translate(
                      offset: Offset(0, _wordY.value),
                      child: _Wordmark(dim: dim),
                    ),
                  ),
                ),

                SizedBox(height: dim.h(10)),

                // Tagline
                FadeTransition(
                  opacity: _tagFade,
                  child: Text(
                    'CRAVINGS. DELIVERED.',
                    style: TextStyle(
                      fontSize: dim.f(11),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textHint,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
              ],
            ),

            // ── 5. Bottom loading bar
            Positioned(
              bottom: dim.h(52) + dim.bottomPadding,
              left: dim.w(80),
              right: dim.w(80),
              child: FadeTransition(
                opacity: _tagFade,
                child: _LoadingBar(dim: dim),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Logo icon box
// ─────────────────────────────────────────────
class _LogoIcon extends StatelessWidget {
  final AppDimensionData dim;
  const _LogoIcon({required this.dim});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dim.w(100),
      height: dim.w(100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dim.w(28)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8C42), Color(0xFFFF3D00)],
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.55),
            blurRadius: 36,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 60,
            spreadRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shine overlay top-left
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: dim.w(60),
              height: dim.w(60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(dim.w(28)),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.white.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Try loading PNG logo, fallback to custom painted icon
          // Replace the Image.asset block inside _LogoIcon Stack with:

          Image.asset(
            AppAssets.logoIcon,
            width: dim.w(60),
            height: dim.w(60),
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _PaintedIcon(dim: dim),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Painted fork + flame icon fallback
// ─────────────────────────────────────────────
class _PaintedIcon extends StatelessWidget {
  final AppDimensionData dim;
  const _PaintedIcon({required this.dim});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dim.w(56),
      height: dim.w(56),
      child: CustomPaint(
        painter: _ForkFlamePainter(),
      ),
    );
  }
}

class _ForkFlamePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final flamePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Colors.white, Colors.white70],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Fork left — tines
    canvas.drawLine(
        Offset(w * 0.28, h * 0.18), Offset(w * 0.28, h * 0.42), paint);
    final forkPath = Path()
      ..moveTo(w * 0.22, h * 0.18)
      ..quadraticBezierTo(w * 0.22, h * 0.38, w * 0.28, h * 0.40)
      ..quadraticBezierTo(w * 0.34, h * 0.38, w * 0.34, h * 0.18);
    canvas.drawPath(forkPath, paint);
    // Fork handle
    canvas.drawLine(
        Offset(w * 0.28, h * 0.40), Offset(w * 0.28, h * 0.80), paint);

    // Knife right
    final knifePath = Path()
      ..moveTo(w * 0.72, h * 0.18)
      ..quadraticBezierTo(w * 0.76, h * 0.30, w * 0.72, h * 0.42)
      ..lineTo(w * 0.72, h * 0.80);
    canvas.drawPath(knifePath, paint);

    // Flame center
    final flameOutline = Path()
      ..moveTo(w * 0.50, h * 0.16)
      ..cubicTo(w * 0.50, h * 0.16, w * 0.38, h * 0.32, w * 0.41, h * 0.46)
      ..cubicTo(w * 0.43, h * 0.54, w * 0.50, h * 0.58, w * 0.50, h * 0.58)
      ..cubicTo(w * 0.50, h * 0.58, w * 0.57, h * 0.54, w * 0.59, h * 0.46)
      ..cubicTo(w * 0.62, h * 0.32, w * 0.50, h * 0.16, w * 0.50, h * 0.16)
      ..close();
    canvas.drawPath(flameOutline, flamePaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────
// Wordmark — NightBite
// ─────────────────────────────────────────────
class _Wordmark extends StatelessWidget {
  final AppDimensionData dim;
  const _Wordmark({required this.dim});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Night',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: dim.f(36),
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -1,
              height: 1,
            ),
          ),
          TextSpan(
            text: 'Bite',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: dim.f(36),
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: -1,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated loading bar
// ─────────────────────────────────────────────
class _LoadingBar extends StatefulWidget {
  final AppDimensionData dim;
  const _LoadingBar({required this.dim});

  @override
  State<_LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<_LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    // Small delay so bar starts after logo appears
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dim = widget.dim;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bar track
        Container(
          height: dim.h(4),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(4),
          ),
          child: AnimatedBuilder(
            animation: _progress,
            builder: (_, __) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _progress.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8C42), Color(0xFFFF3D00)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.7),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: dim.h(12)),

        // Percentage text
        AnimatedBuilder(
          animation: _progress,
          builder: (_, __) => Text(
            '${(_progress.value * 100).toInt()}%',
            style: TextStyle(
              fontSize: dim.f(11),
              color: AppColors.textHint,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}