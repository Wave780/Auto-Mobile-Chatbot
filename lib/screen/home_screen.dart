import 'package:auto_mobile_chatbot/utils/widegt%20/nav_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          //Nav bar
          NavBar(),
          Column(
            children: [
              //Search section

              //Footer
            ],
          )
        ],
      ),
    );
  }
}
