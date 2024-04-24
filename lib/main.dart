import 'package:cafe_deja_vu/Screens/home_screen.dart';
import 'package:cafe_deja_vu/Themes/theme.dart';
import 'package:cafe_deja_vu/scrolling/scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

int main() {
  runApp(const ProviderScope(child: App()));
  return 0;
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      scrollBehavior: AppScrollBehavior(),
      home: const HomeScreen(),
    );
  }
}
