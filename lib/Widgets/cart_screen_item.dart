import 'package:cafe_deja_vu/Widgets/veg_or_nonveg.dart';
import 'package:cafe_deja_vu/utilities/cartScreenNavigate.dart';
import 'package:flutter/material.dart';

class CartScreenItem extends StatelessWidget {
  const CartScreenItem({super.key, required this.mealItem});
  final Map<String, dynamic> mealItem;
  @override
  Widget build(BuildContext context) {
    String addonsString = extractMealString(mealItem["mealString"], mealItem);
    print("these are the addons");
    print(addonsString);
    print(mealItem["mealString"]);
    String instructions = extractInstructions(mealItem["mealString"]);
    String totalPrice = extractPrice(mealItem["mealString"]);
    print("THIS ARE THE INSTRUCTIONS");
    print(instructions);
    print("TOTAL PRICE OF THE ENTIRE MEAL IS THIS :");
    print(totalPrice);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 238, 221, 215),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  VegorNonveg(veg: mealItem["isVeg"], size: 25),
                  Text(
                    mealItem["name"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(mealItem["imageUrl"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Your Addons : $addonsString",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "Your Instructions : $instructions",
                style: const TextStyle(fontSize: 14),
              ),
              const Text("Quantity : "),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rs. $totalPrice',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
