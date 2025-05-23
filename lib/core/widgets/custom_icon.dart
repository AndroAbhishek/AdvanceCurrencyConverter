import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;

  const CustomIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: size);
  }
}
