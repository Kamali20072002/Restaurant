import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final String path;
  final double size;
  final Color color;

  const AppIcon({
    super.key,
    required this.path,
    this.size = 24,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      color: color,         // tints the PNG to any color you want
      colorBlendMode: BlendMode.srcIn,
      errorBuilder: (_, __, ___) => Icon(
        Icons.broken_image_outlined,
        size: size,
        color: color,
      ),
    );
  }
}