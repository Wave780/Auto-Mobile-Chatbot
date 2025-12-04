import 'package:auto_mobile_chatbot/theme/theme.dart';
import 'package:flutter/material.dart';

class NavBarButton extends StatelessWidget {
  final bool isCollasped;
  final String label;
  final IconData icon;
  final Function()? widget;

  const NavBarButton(
      {super.key,
      required this.isCollasped,
      required this.label,
      required this.icon,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget,
      child: Row(
        mainAxisAlignment:
            isCollasped ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Icon(
              icon,
              color: AppColors.secondaryVariantDark,
              size: 22,
            ),
          ),
          // FIX: prevent overflow
          if (!isCollasped)
            Expanded(
              child: Text(
                label.isNotEmpty ? label : "Untitled",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
