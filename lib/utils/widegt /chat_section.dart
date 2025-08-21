import 'package:auto_mobile_chatbot/theme/theme.dart';
import 'package:auto_mobile_chatbot/utils/widegt%20/chat_bar_button.dart';
import 'package:flutter/material.dart';

class ChatSection extends StatelessWidget {
  const ChatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Chat about your car',
          style: TextStyle(
            fontSize: 40,
            height: 1.2,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Container(
          width: 700,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Ask about your car...',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryVariantLight,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const ChatBarButton(
                      icon: Icons.auto_awesome_outlined,
                      label: 'Focus',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const ChatBarButton(
                      icon: Icons.language,
                      label: 'Thinking',
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.onPrimaryLight,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
