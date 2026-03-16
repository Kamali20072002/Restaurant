import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_assets.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final bool fullLogo; // uses logo_full.png if true

  const AppLogo({
    super.key,
    this.size = 1.0,
    this.showWordmark = true,
    this.fullLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    // If fullLogo — just show the full PNG as-is
    if (fullLogo) {
      return Image.asset(
        AppAssets.logoFull,
        width: 220 * size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon box with real PNG
        Container(
          width: 72 * size,
          height: 72 * size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22 * size),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF8C42), Color(0xFFFF3D00)],
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 24 * size,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22 * size),
            child: Image.asset(
              AppAssets.logoIcon,
              width: 72 * size,
              height: 72 * size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Text('🍽️',
                  style: TextStyle(fontSize: 34 * size),
                ),
              ),
            ),
          ),
        ),

        if (showWordmark) ...[
          SizedBox(height: 12 * size),

          // Wordmark
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Night',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30 * size,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                TextSpan(
                  text: 'Bite',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30 * size,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFallback() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72 * size,
          height: 72 * size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22 * size),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8C42), Color(0xFFFF3D00)],
            ),
          ),
          child: Center(
            child: Text('🍽️', style: TextStyle(fontSize: 34 * size)),
          ),
        ),
        SizedBox(height: 12 * size),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Night',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 30 * size,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'Bite',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 30 * size,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}