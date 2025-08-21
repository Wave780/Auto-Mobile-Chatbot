import 'package:auto_mobile_chatbot/theme/theme.dart';
import 'package:flutter/material.dart';

class NavBarButton extends StatelessWidget {
  final bool isCollasped;
  final String label;
  final IconData icon;

  const NavBarButton(
      {super.key,
      required this.isCollasped,
      required this.label,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCollasped ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Icon(
            icon,
            color: AppColors.secondaryVariantDark,
            size: 22,
          ),
        ),
        isCollasped
            ? SizedBox()
            : Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
      ],
    );
  }
}
