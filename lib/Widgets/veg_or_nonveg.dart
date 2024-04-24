import 'package:flutter/material.dart';

class VegorNonveg extends StatelessWidget {
  const VegorNonveg({super.key, required this.veg, required this.size});
  final bool veg;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          Icons.crop_square,
          color: veg ? Colors.green : Colors.red,
          size: size,
        ),
        Positioned(
          left: size * (15 / 50),
          top: size * (15 / 50),
          child: Icon(
            Icons.circle,
            color: veg ? Colors.green : Colors.red,
            size: size * (20 / 50),
          ),
        ),
      ],
    );
  }
}
