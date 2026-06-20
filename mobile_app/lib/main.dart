import 'package:flutter/material.dart';
import 'package:mobile_app/features/wallpapers/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpaper App',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
      home: const HomePage(),
    );
  }
}
