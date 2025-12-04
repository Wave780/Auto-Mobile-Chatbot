import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final bool isUser;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final DateTime timestamp;

  ChatMessage({
    required this.sessionId,
    required this.isUser,
    required this.text,
    required this.timestamp,
  });
}
