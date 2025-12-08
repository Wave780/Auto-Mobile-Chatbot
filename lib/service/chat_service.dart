import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../model/chat_message.dart';
import '../model/chat_session.dart';

class ChatService {
  static final _instance = ChatService._internal();

  factory ChatService() => _instance;

  ChatService._internal();
  final _searchResultController = StreamController<Map<String, dynamic>>();
  final _chatController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingController = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get searchResultStream =>
      _searchResultController.stream;

  Stream<Map<String, dynamic>> get chatStream => _chatController.stream;

  final sessionsBox = Hive.box<ChatSession>('sessions');
  final messagesBox = Hive.box<ChatMessage>('messages');

  Future<void> chat(String query) async {
    final url =
        Uri.parse("https://inherent-kathie-wave780-57107277.koyeb.app/query");
    final headers = {
      'Content-Type': 'application/json',
      // TODO: Replace with your actual auth token
      'Authorization':
          'Bearer b02ywtw5b1d9ifq9b6ofhq1v2gfxz56h8k61vk91viovqwaykhkkwghpucjumyat'
    };
    final payload = {"question": query, "n_results": 2};
    final response =
        await http.post(url, headers: headers, body: jsonEncode(payload));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey("results")) {
        _searchResultController.add(data);
      } else {
        _chatController.add(data);
      }
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
    }
  }

  ChatSession startSession({String? title}) {
    if (sessionsBox.isNotEmpty) {
      final latestSession = sessionsBox.values.last;
      if (getMessages(latestSession.id).isEmpty) {
        return latestSession;
      }
    }

    final session = ChatSession()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..title = title ?? "Untitled Chat"
      ..createdAt = DateTime.now();

    sessionsBox.put(session.id, session);
    return session;
  }

  Future<void> saveMessage(ChatMessage message) async {
    await messagesBox.add(message);
  }

  List<ChatMessage> getMessages(String sessionId) {
    return messagesBox.values.where((m) => m.sessionId == sessionId).toList();
  }

  List<ChatSession> getSessions() {
    return sessionsBox.values.toList();
  }

  Future<void> deleteSession(String sessionId) async {
    await sessionsBox.delete(sessionId);
    final messagesToDelete =
        messagesBox.values.where((m) => m.sessionId == sessionId);
    for (var message in messagesToDelete) {
      await message.delete();
    }
  }
}
