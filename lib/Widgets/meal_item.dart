import 'package:flutter/material.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal});
  final Map<String, dynamic> meal;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: Row(
        children: [
          Column(
            children: [
              Text(
                '${meal["name"]}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${meal["description"]}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 9,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )
            ],
          ),
          const Spacer(),
          Column(
            children: [
              const Text(
                "Starts From",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 7,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                'Rs. ${meal["price"].toString()}.00',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 224, 113, 105),
                  ),
                ),
                child: const Text(
                  'Add +',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Text(
                'Customizable',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 5,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
