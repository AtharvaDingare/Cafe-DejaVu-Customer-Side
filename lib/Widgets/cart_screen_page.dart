import 'package:cafe_deja_vu/Widgets/cart_screen_item.dart';
import 'package:cafe_deja_vu/Widgets/triple_dot_navigation.dart';
import 'package:flutter/material.dart';

class CartScreenPage extends StatelessWidget {
  const CartScreenPage({
    super.key,
    required this.currentList,
    required this.currentIndex,
  });
  final List<dynamic> currentList;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    int currentListLength = currentList.length;

    final displayContentIfListEmpty = currentIndex == 0
        ? const Center(
            child: Text(
              "Uh Oh, No orders added to queue yet!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          )
        : currentIndex == 1
            ? const Center(
                child: Text(
                  "Uh Oh, No orders placed yet!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : const Center(
                child: Text(
                  "Uh Oh, No orders delivered yet!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/final_background.PNG'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              ...currentList.map((e) => CartScreenItem(mealItem: e)).toList(),
              currentListLength == 0
                  ? displayContentIfListEmpty
                  : const Text("."),
            ],
          ),
          Positioned(
            bottom: screenheight / 20,
            left: (screenwidth / 2) - 70,
            child: TripleDotNavigator(
              currentIndex: currentIndex,
            ),
          ),
        ],
      ),
    );
  }
}
