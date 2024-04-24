import 'package:cafe_deja_vu/Screens/cartScreen.dart';
import 'package:flutter/material.dart';

void navigateToTargetScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const CartScreen(),
    ),
  );
}

String getAddonName(List<dynamic> addOns, String addonId) {
  String addOnName = "null";
  for (int i = 0; i < addOns.length; i++) {
    if (addonId == addOns[i]["_id"]) {
      addOnName = addOns[i]["displayName"];
      break;
    }
  }
  return addOnName;
}

String extractMealString(String mealString, Map<String, dynamic> mealItem) {
  String addons = "";
  String addonFinal = " ";
  int index = 0;
  for (int i = 0; i < mealString.length; i++) {
    if (mealString[i] == '.') {
      index = (i + 1);
      break;
    }
  }
  print(index);
  for (int i = index; i < mealString.length; i++) {
    if (mealString[i] == '-') {
      addonFinal += getAddonName(mealItem["addOns"], addons);
      print("this is the ith addon");
      print(addons);
      addonFinal += ", ";
      addons = "";
    } else if (mealString[i] == '.') {
      if (addons.length > 1) {
        addonFinal += getAddonName(mealItem["addOns"], addons);
        print("this is the ith addon");
        print(addons);
        addonFinal += ", ";
        addons = "";
      }
      break;
    } else {
      addons += mealString[i];
    }
  }
  return addonFinal;
}

String extractInstructions(String mealString) {
  String instructions = "";
  int index = 0;
  for (int i = 0; i < mealString.length; i++) {
    if (mealString[i] == '.') {
      index = (i + 1);
    }
  }
  for (int i = index; i < mealString.length; i++) {
    instructions += mealString[i];
  }
  return instructions;
}

String extractPrice(String mealString) {
  String priceString = "";
  int index = mealString.length - 1;
  for (int i = index; i >= 0; i--) {
    if (mealString[i] == '.') {
      break;
    } else {
      priceString += mealString[i];
    }
  }
  String finalPrice = "";
  for (int i = priceString.length - 1; i >= 0; i--) {
    finalPrice += priceString[i];
  }
  return finalPrice;
}
