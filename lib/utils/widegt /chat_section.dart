import 'package:auto_mobile_chatbot/theme/theme.dart';
import 'package:auto_mobile_chatbot/utils/widegt%20/chat_bar_button.dart';
import 'package:flutter/material.dart';

import '../../screen/chat_page.dart';
import '../../service/chat_service.dart';

class ChatSection extends StatefulWidget {
  const ChatSection({super.key});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final queryController = TextEditingController();

  final chatService = ChatService();

  @override
  void dispose() {
    super.dispose();
    queryController.dispose();
  }

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
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: queryController,
                  decoration: const InputDecoration(
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
                    GestureDetector(
                      onTap: () {
                        final question = queryController.text.trim();
                        if (question.isEmpty) return;

                        final session =
                            chatService.startSession(title: question);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  question: question,
                                  sessionId: session.id,
                                  title: session.title,
                                )));
                      },
                      child: Container(
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
