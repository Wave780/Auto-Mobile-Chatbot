import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../model/chat_message.dart';
import '../service/chat_service.dart';
import '../utils/widegt /nav_bar.dart';

class ChatPage extends StatefulWidget {
  final String sessionId;
  final String title;
  final String? question;

  ChatPage({
    super.key,
    required this.sessionId,
    required this.title,
    this.question,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ChatService chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    messages = chatService.getMessages(widget.sessionId);

    if (widget.question != null && widget.question!.isNotEmpty) {
      final userMsg = ChatMessage(
        sessionId: widget.sessionId,
        text: widget.question!,
        isUser: true,
        timestamp: DateTime.now(),
      );
      chatService.saveMessage(userMsg);
      messages.add(userMsg);
      isTyping = true;
      chatService.chat(widget.question!);
    }

    chatService.chatStream.listen((data) {
      final aiText = data["context"] != null
          ? "**Answer:**\n${data["answer"]}\n\n**Context:**\n${data["context"]}"
          : data["answer"];

      if (aiText == null || aiText.isEmpty) {
        setState(() {
          isTyping = false;
        });
        return;
      }

      final aiMsg = ChatMessage(
        sessionId: widget.sessionId,
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      chatService.saveMessage(aiMsg);

      setState(() {
        messages.add(aiMsg);
        isTyping = false;
      });

      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    if (isMobile) {
      return NavBar(
        body: Column(
          children: [
            Expanded(child: _buildChatArea()),
            _buildInputArea(),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavBar(),
            const SizedBox(width: 80),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _buildChatArea()),
                  _buildInputArea(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (isTyping && index == messages.length) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(14),
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text("Typing..."),
            ),
          );
        }
        final msg = messages[index];

        return Align(
          alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(14),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: msg.isUser ? Colors.blue[600] : Colors.grey[800],
              borderRadius: BorderRadius.circular(16),
            ),
            child: MarkdownBody(
              data: msg.text,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ask another question...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.send, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final userMsg = ChatMessage(
      sessionId: widget.sessionId,
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    chatService.saveMessage(userMsg);

    setState(() {
      messages.add(userMsg);
      isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    chatService.chat(text);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }
}
