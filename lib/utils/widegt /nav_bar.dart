import 'package:auto_mobile_chatbot/theme/theme.dart';
import 'package:flutter/material.dart';

import 'nav_bar_button.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isCollasped = true;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: isCollasped ? 60 : 150,
      color: AppColors.secondaryLight,
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Icon(
            Icons.auto_awesome_mosaic,
            color: AppColors.surfaceLight,
            size: isCollasped ? 30 : 60,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: isCollasped
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                NavBarButton(
                  isCollasped: isCollasped,
                  label: 'Search',
                  icon: Icons.search,
                ),
                NavBarButton(
                  isCollasped: isCollasped,
                  label: 'New',
                  icon: Icons.add,
                ),
                NavBarButton(
                  isCollasped: isCollasped,
                  label: 'Library',
                  icon: Icons.cloud,
                ),
                NavBarButton(
                  isCollasped: isCollasped,
                  label: 'Spaces',
                  icon: Icons.language,
                ),
                NavBarButton(
                  isCollasped: isCollasped,
                  label: 'Discover',
                  icon: Icons.auto_awesome,
                ),
                const Spacer(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isCollasped = !isCollasped;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 14),
              child: Icon(
                isCollasped
                    ? Icons.keyboard_arrow_right
                    : Icons.keyboard_arrow_left,
                color: AppColors.secondaryVariantDark,
                size: 22,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
