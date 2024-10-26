import 'package:flutter/material.dart';
import 'package:little_light_v01/core/constants/app_constants.dart';
import 'package:little_light_v01/store/bottom_nav_store.dart';
import 'feature/llc_screen.dart';

final bottomNavStore = BottomNavStore();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LLCConstant.APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home:  LLCScreen(),
    );
  }
}
