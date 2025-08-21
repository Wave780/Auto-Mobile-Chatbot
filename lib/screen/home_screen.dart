import 'package:auto_mobile_chatbot/utils/widegt%20/chat_section.dart';
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
    return Scaffold(
      body: Row(
        children: [
          //Nav bar
          const NavBar(),
          Expanded(
            child: Column(
              children: [
                //Chat section
                const Expanded(
                  child: ChatSection(),
                ),
                //Footer
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'MobilityChat can make mistakes. Check important info.',
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
