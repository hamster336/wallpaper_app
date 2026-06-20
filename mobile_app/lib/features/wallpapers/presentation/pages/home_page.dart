import 'package:flutter/material.dart';
import 'package:mobile_app/constants/global_variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpapers', style: GlobalVariables.titleText),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchBar(
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 20),
              ),
              elevation: WidgetStatePropertyAll(1),
              backgroundColor: WidgetStatePropertyAll(Colors.grey.shade100),
              leading: Icon(Icons.search, color: Colors.grey.shade600),
              hintText: "Search People, Mood, Fashion",
            ),
          ),
          const SizedBox(height: 20),
          const Text('Favorites'),
        ],
      ),
    );
  }
}
