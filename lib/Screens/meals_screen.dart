import 'dart:convert';

import 'package:cafe_deja_vu/Widgets/meal_item_gpt.dart';
import 'package:cafe_deja_vu/utilities/cartScreenNavigate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key, required this.category});

  final Map<String, dynamic> category;

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<dynamic> mealsList = [];

  Future<void> getMeals() async {
    final url = 'http://localhost:3000/getitems/${widget.category["objectId"]}';
    final uri = Uri.parse(url);

    final mealResponse = await http.get(uri);
    if (mealResponse.statusCode == 200) {
      print("Meals request recieved");
      final mealData = jsonDecode(mealResponse.body);
      print(mealData);
      setState(() {
        mealsList = mealData["items"];
        print(mealsList);
      });
      print("Data recieved , calls successful");
    } else {
      print("Failed to recieve response! ${mealResponse.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    getMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category["name"].toString().toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/final_background.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            ...mealsList.map((e) => MealCard(mealItem: e)).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToTargetScreen(context);
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.shopping_cart_checkout_sharp,
          color: Colors.black,
        ),
      ),
    );
  }
}
