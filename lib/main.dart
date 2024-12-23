import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/albums_screen.dart';
import 'pages/home.dart';
import 'pages/playlist_screen.dart';
import 'widgets/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Audira',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'regular',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const Scaffold(
        body: Stack(
          children: [
            DrawerScreen(),
            Home(),
          ],
        ),
      ),
    );
  }
}