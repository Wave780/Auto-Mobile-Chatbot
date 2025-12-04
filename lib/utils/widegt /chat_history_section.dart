import 'package:auto_mobile_chatbot/service/chat_service.dart';
import 'package:flutter/material.dart';

import '../../screen/chat_page.dart';

class ChatHistoryPage extends StatelessWidget {
  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final sessions = chatService.getSessions();

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final s = sessions[index];
        return ListTile(
          title: Text(s.title),
          subtitle: Text(s.createdAt.toString()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatPage(
                  sessionId: s.id,
                  title: s.title,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
