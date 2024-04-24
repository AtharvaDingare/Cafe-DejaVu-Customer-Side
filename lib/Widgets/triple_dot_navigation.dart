import 'package:flutter/material.dart';

class TripleDotNavigator extends StatelessWidget {
  const TripleDotNavigator({super.key, required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        currentIndex == 0
            ? const Icon(
                Icons.shopping_cart,
                size: 40,
                color: Colors.orange,
              )
            : const Icon(
                Icons.shopping_cart,
                size: 40,
                color: Colors.grey,
              ),
        const SizedBox(
          width: 15,
        ),
        currentIndex == 1
            ? const Icon(
                Icons.local_dining,
                size: 40,
                color: Colors.orange,
              )
            : const Icon(
                Icons.local_dining,
                size: 40,
                color: Colors.grey,
              ),
        const SizedBox(
          width: 15,
        ),
        currentIndex == 2
            ? const Icon(
                Icons.check_box,
                size: 40,
                color: Colors.orange,
              )
            : const Icon(
                Icons.check,
                size: 40,
                color: Colors.grey,
              ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
