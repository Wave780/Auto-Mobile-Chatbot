import 'package:auto_mobile_chatbot/utils/widegt%20/chat_section.dart';
import 'package:auto_mobile_chatbot/utils/widegt%20/nav_bar.dart';
import 'package:flutter/material.dart';

import '../service/chat_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // You can adjust the width threshold as needed (e.g., 700 or 800)
          bool isMobile = constraints.maxWidth < 700;

          if (isMobile) {
            // ✅ Mobile Layout: Use the NavBar with the ChatSection as the body
            return const NavBar(body: ChatSection());
          } else {
            // 💻 Desktop / Tablet Layout: Side-by-side
            return Row(
              children: [
                const NavBar(),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(
                        child: ChatSection(),
                      ),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
