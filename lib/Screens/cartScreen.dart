import 'dart:async';
import 'dart:convert';

import 'package:cafe_deja_vu/Providers/cartmeals_provider.dart';
import 'package:cafe_deja_vu/Providers/deliveredmeals_provider.dart';
import 'package:cafe_deja_vu/Providers/placedmeals_provider.dart';
import 'package:cafe_deja_vu/Widgets/cart_screen_item.dart';
import 'package:cafe_deja_vu/Widgets/cart_screen_page.dart';
import 'package:cafe_deja_vu/Widgets/triple_dot_navigation.dart';
import 'package:cafe_deja_vu/utilities/cartscreennavigate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartMealsList = ref.watch(cartMealsProvider);
    final placedMealsList = ref.watch(placedMealsProvider);
    final deliveredMealsList = ref.watch(deliveredMealsProvider);
    print("These are the cart meals currently in queue");
    print(cartMealsList);
    print("These are meals that have been placed --> status = 0");
    print(placedMealsList);
    print("These are meals that have been delivered --> status = 1");
    print(deliveredMealsList);

    TextEditingController _nameController = TextEditingController();
    TextEditingController _mobileController = TextEditingController();

    void startFetchingOrders() {
      Timer.periodic(
        const Duration(minutes: 0, seconds: 20),
        (timer) async {
          var uri = Uri.parse(
              'http://localhost:5000/tableCRUD/tableOrderStatus/66229654b09ef639d80d05c3');

          final periodicResponse = await http.get(uri);

          if (periodicResponse.statusCode == 200) {
            print("Periodic update check recieved !");
            final periodicResponseData = jsonDecode(periodicResponse.body);
            print(periodicResponseData);
            List<dynamic> periodicList = periodicResponseData["items"];
            List<dynamic> periodicPlacedMealsList = [];
            List<dynamic> periodicDeliveredMealsList = [];
            for (int i = 0; i < periodicList.length; i++) {
              if (periodicList[i]["status"] == 0) {
                periodicPlacedMealsList.add(periodicList[i]["detail"]);
              } else {
                periodicDeliveredMealsList.add(periodicList[i]["detail"]);
              }
            }
            ref
                .read(placedMealsProvider.notifier)
                .changeState(periodicPlacedMealsList);
            ref
                .read(deliveredMealsProvider.notifier)
                .changeState(periodicDeliveredMealsList);
          } else {
            print(
              "Error occured while contacting the server !! ${periodicResponse.statusCode}",
            );
          }
        },
      );
    }

    int calculateTotalPrice(List<dynamic> cartMealsList) {
      int totalPrice = 0;
      for (int i = 0; i < cartMealsList.length; i++) {
        String currentItemPrice = extractPrice(cartMealsList[i]["mealString"]);
        int currentPrice = int.parse(currentItemPrice);
        totalPrice += currentPrice;
      }
      return totalPrice;
    }

    String? _validateMobileNumber(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your mobile number';
      }
      if (value.length != 10) {
        return 'Mobile number must be 10 digits';
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'Please enter only digits';
      }
      return null;
    }

    void onFinalOrderPlaced(String userName, String userMobileNumber) async {
      List<String> items = [];
      for (int i = 0; i < cartMealsList.length; i++) {
        items.add(cartMealsList[i]["mealString"]);
      }
      String contact = userName;
      bool isTable = true;
      String tableId = "66229654b09ef639d80d05c3";
      String takeout = "Zomato";
      Map<String, dynamic> finalPostRequest = {
        "items": items,
        "contact": contact,
        "isTable": isTable,
        "tableId": tableId,
        "takeout": takeout
      };
      var url = Uri.parse('http://localhost:5000/orderCRUD/create/subOrder');
      print(finalPostRequest);
      var body = jsonEncode(finalPostRequest);
      try {
        var response = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print("Response worked successfully following data output : $data");
        } else {
          print("Request failed with status : ${response.statusCode}");
        }
      } catch (error) {
        print("Error : $error");
      }

      var uri = Uri.parse(
          'http://localhost:5000/tableCRUD/tableOrderStatus/66229654b09ef639d80d05c3');

      final statusUpdateResponse = await http.get(uri);
      if (statusUpdateResponse.statusCode == 200) {
        print("Status Requests Recieved");
        final statusData = jsonDecode(statusUpdateResponse.body);
        print(statusData);
        List<dynamic> updatedOrdersList = statusData["items"];
        List<dynamic> updatedPlacedOrders = [];
        List<dynamic> updatedDeliveredOrders = [];
        for (int i = 0; i < updatedOrdersList.length; i++) {
          if (updatedOrdersList[i]["status"] == 0) {
            updatedPlacedOrders.add(updatedOrdersList[i]["detail"]);
          } else {
            updatedDeliveredOrders.add(updatedOrdersList[i]["detail"]);
          }
        }
        ref.read(cartMealsProvider.notifier).changeState([]);
        ref.read(placedMealsProvider.notifier).changeState(updatedPlacedOrders);
        ref
            .read(deliveredMealsProvider.notifier)
            .changeState(updatedDeliveredOrders);
      } else {
        print(
            "Some error occured while making communication with the server! ${statusUpdateResponse.statusCode}");
      }
    }

    void userAuthenticationModalSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 235, 214, 214),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "USER AUTHENTICATION",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name :',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.always,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Mobile Number :',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateMobileNumber,
                    autovalidateMode: AutovalidateMode.always,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        onFinalOrderPlaced(
                            _nameController.text, _mobileController.text);
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
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      );
    }

    String pageTitle = currentPageIndex == 0
        ? "QUEUED ORDERS"
        : currentPageIndex == 1
            ? "PLACED ORDERS"
            : "DELIVERED ORDERS";

    bool showFAB = currentPageIndex == 0 ? true : false;

    startFetchingOrders();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            pageTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: PageView(
          physics: const BouncingScrollPhysics(),
          children: [
            CartScreenPage(
              currentList: cartMealsList,
              currentIndex: currentPageIndex,
            ),
            CartScreenPage(
              currentList: placedMealsList,
              currentIndex: currentPageIndex,
            ),
            CartScreenPage(
              currentList: deliveredMealsList,
              currentIndex: currentPageIndex,
            ),
          ],
          onPageChanged: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
        ),
        floatingActionButton: showFAB
            ? FloatingActionButton(
                onPressed: () {
                  userAuthenticationModalSheet();
                },
                child: const Icon(
                  Icons.arrow_circle_right,
                  color: Colors.black,
                  size: 40,
                ),
              )
            : null
        //floatingActionButton: GestureDetector(
        //  onTap: () {
        //    userAuthenticationModalSheet();
        //  },
        //  child: Padding(
        //    padding: const EdgeInsets.all(15.0),
        //    child: Container(
        //      width: double.infinity, // Adjust width as needed
        //      height: 50,
        //      decoration: BoxDecoration(
        //        color: Colors.orange,
        //        boxShadow: [
        //          BoxShadow(
        //            color: Colors.black.withOpacity(0.3), // Add shadow for depth
        //            spreadRadius: 2,
        //            blurRadius: 5,
        //            offset: const Offset(0, 3), // Offset of shadow
        //          ),
        //        ],
        //      ),
        //      child: const Text("PLACE ORDER"),
        //    ),
        //  ),
        //),
        //floatingActionButtonLocation: FloatingActionButtonLocation
        //    .centerFloat, // Center the FAB horizontally
        );
  }
}
