import 'dart:convert';
import 'package:cafe_deja_vu/Widgets/category_item.dart';
import 'package:cafe_deja_vu/utilities/cartScreenNavigate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<dynamic> categoryList = [];

  Future<void> getCategories() async {
    const url = 'http://localhost:3000/getcategories';
    final uri = Uri.parse(url);

    final categoryResponse = await http.get(uri);
    if (categoryResponse.statusCode == 200) {
      //print("Request recieved!");
      final categoryData = jsonDecode(categoryResponse.body);
      print(categoryData);
      setState(() {
        categoryList = categoryData;
      });
      //print(categoryList);
      //print("Categories fetched !");
    } else {
      print("Failed to recieve data! ${categoryResponse.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screensizewidth = screenSize.width;
    double screensizeheight = screenSize.height;
    //print(categoryList);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CATEGORIES",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: screensizeheight / 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  ...categoryList
                      .map((e) => CategoryItem(category: e))
                      .toList(),
                ],
              ),
            ),
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
