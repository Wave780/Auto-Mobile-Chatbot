import 'package:flutter/material.dart';

class ChatBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const ChatBarButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
