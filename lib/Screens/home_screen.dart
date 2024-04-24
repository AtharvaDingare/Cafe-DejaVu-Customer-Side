import 'dart:convert';

import 'package:cafe_deja_vu/Providers/appcyclestate_provider.dart';
import 'package:cafe_deja_vu/Providers/deliveredmeals_provider.dart';
import 'package:cafe_deja_vu/Providers/placedmeals_provider.dart';
import 'package:cafe_deja_vu/Screens/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size screenSize = MediaQuery.of(context).size;
    double screensizewidth = screenSize.width;
    double screensizeheight = screenSize.height;

    bool appStartState = ref.read(appCycleStateProvider);

    void setInitialListConfigurations() async {
      const url =
          'http://localhost:5000/tableCRUD/tableOrderStatus/66229654b09ef639d80d05c3';
      final uri = Uri.parse(url);
      final mealsResponse = await http.get(uri);
      if (mealsResponse.statusCode == 200) {
        final mealData = jsonDecode(mealsResponse.body);
        print(mealData);
        List<dynamic> initialMealsList = mealData["items"];
        List<dynamic> placedMealsProviderUpdate = [];
        List<dynamic> deliveredMealsProviderUpdate = [];
        for (int i = 0; i < initialMealsList.length; i++) {
          if (initialMealsList[i]["status"] == 0) {
            placedMealsProviderUpdate.add(initialMealsList[i]["detail"]);
          } else if (initialMealsList[i]["status"] == 1) {
            deliveredMealsProviderUpdate.add(initialMealsList[i]["detail"]);
          }
        }
        ref
            .read(placedMealsProvider.notifier)
            .changeState(placedMealsProviderUpdate);
        ref
            .read(deliveredMealsProvider.notifier)
            .changeState(deliveredMealsProviderUpdate);
      } else {
        print(
          "Communication with the server has failed !! ${mealsResponse.statusCode}",
        );
      }
      //List<dynamic> placedMeals = ref.read(placedMealsProvider);
      //List<dynamic> deliveredMeals = ref.read(deliveredMealsProvider);
      //print(placedMeals);
      //print(deliveredMeals);
    }

    if (appStartState) {
      ref.read(appCycleStateProvider.notifier).changeState(true);
      setInitialListConfigurations();
    }

    void onPressOrder() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const CategoriesScreen(),
        ),
      );
    }

    void onCallWaiter() {}

    void onCallBill() {}

    void onPlaySong() {}

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/light_brown.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Center(
              child: Text(
                "WELCOME",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/Deja_Vu_logo.png',
                width: 350,
                height: 350,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                //const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton.icon(
                    onPressed: onPressOrder,
                    style: ElevatedButton.styleFrom(
                      elevation: 7,
                      backgroundColor: Colors.black,
                      fixedSize: const Size(180, 45),
                      shadowColor: Colors.grey,
                    ),
                    icon: const Icon(
                      Icons.fastfood,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "PLACE AN ORDER",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 7,
                    backgroundColor: Colors.black,
                    fixedSize: const Size(180, 45),
                  ),
                  icon: const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "CALL A WAITER",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //const Spacer(),
              ],
            ),
            Row(
              children: [
                //const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 7,
                      backgroundColor: Colors.black,
                      fixedSize: const Size(180, 45),
                    ),
                    icon: const Icon(
                      Icons.receipt,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "CALL FOR BILL",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 7,
                    backgroundColor: Colors.black,
                    fixedSize: const Size(180, 45),
                  ),
                  icon: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "PLAY A SONG",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //const Spacer(),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
