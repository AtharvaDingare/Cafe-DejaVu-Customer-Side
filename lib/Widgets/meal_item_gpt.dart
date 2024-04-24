import 'package:cafe_deja_vu/Providers/cartmeals_provider.dart';
import 'package:cafe_deja_vu/Widgets/counter_button.dart';
import 'package:cafe_deja_vu/Widgets/veg_or_nonveg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MealCard extends ConsumerWidget {
  const MealCard({super.key, required this.mealItem});
  final Map<String, dynamic> mealItem;
  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<dynamic> adons = mealItem["addOns"];
    print(mealItem);
    int _quantityController = 0;
    void onUpdateCounterButton(int newCounter) {
      _quantityController = newCounter;
    }

    void addingMealtoCartsPage(
        Map<String, dynamic> pickedMealItem,
        List<bool> pickedAdons,
        String pickedInstructions,
        int quantityController) {
      String mealOrderString =
          pickedMealItem["_id"]; // formatting the id using delimitters
      mealOrderString +=
          '.'; // delimiter format --> item1.adon1-adon2-adon3.instructions
      bool entered =
          false; // i want to handle the problem of getting a extra dash at the end

      num totalPrice = pickedMealItem["price"];
      for (int i = 0; i < pickedAdons.length; i++) {
        if (pickedAdons[i]) {
          entered = true;
          mealOrderString += adons[i]["_id"];
          totalPrice += adons[i]["price"];
          mealOrderString += '-';
        }
      }
      if (entered) {
        mealOrderString =
            mealOrderString.substring(0, mealOrderString.length - 1);
      }
      mealOrderString += '.';
      mealOrderString += pickedInstructions;
      mealOrderString += '.';
      mealOrderString += (totalPrice.toString());
      Map<String, dynamic> cartMap = pickedMealItem;
      cartMap["mealString"] = mealOrderString;
      print(quantityController);
      for (int i = 0; i < quantityController; i++) {
        ref.read(cartMealsProvider).add(cartMap);
      }
      Navigator.of(context).pop();
    }

    void showCustomizableMealOption() {
      List<bool> toggleStates = List.filled(adons.length, false);
      String _textController = "No instructions specified";
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: ((context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Container(
                height: (MediaQuery.of(context).size.height * 0.6),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 235, 214, 214),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VegorNonveg(veg: mealItem["isVeg"], size: 30),
                          Center(
                            child: Text(
                              "${mealItem["name"]}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: adons.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile.adaptive(
                              value: toggleStates[index],
                              onChanged: (value) {
                                mystate(
                                  () {
                                    toggleStates[index] = value!;
                                  },
                                );
                              },
                              title: Text(
                                "${adons[index]["displayName"]} - (Rs. ${adons[index]["price"]})",
                              ),
                            );
                          },
                        ),
                      ),
                      TextField(
                        onChanged: (text) {
                          _textController = text;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Enter instructions for cooking',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          CounterButton(
                            onUpdate: onUpdateCounterButton,
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              addingMealtoCartsPage(
                                mealItem,
                                toggleStates,
                                _textController.isEmpty
                                    ? "No instructions specified"
                                    : _textController,
                                _quantityController,
                              );
                            },
                            style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.orange),
                            ),
                            child: const Text(
                              "Place Order!",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      );
    }

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
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                mealItem["description"],
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${mealItem["price"].toString()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: showCustomizableMealOption,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      'Add +',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
