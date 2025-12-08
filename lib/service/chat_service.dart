import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:web_socket_client/web_socket_client.dart';

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

  WebSocket? _socket;

  void connect() {
    _socket = WebSocket(
      Uri.parse("wss://inherent-kathie-wave780-57107277.koyeb.app/ws/query"),
      headers: {
        // TODO: Replace with your actual auth token
        'Authorization':
            'Bearer 6xe7ppznk9xguv7qvule7rqetcrz1r2z6cmpup881yy8wefhd9mm5hf0yj41ue9e'
      },
    );
    print("Connected!");

    _socket!.messages.listen((message) {
      final data = jsonDecode(message);
      if (data.containsKey("results")) {
        _searchResultController.add(data);
      } else {
        _chatController.add(data);
      }
      print(message);
    });
  }

  void chat(String query) {
    final payload = {"question": query, "n_results": 2};
    _socket?.send(jsonEncode(payload));
  }

  void dispose() {
    print("Closing WebSocket...");
    _socket?.close();
    _chatController.close();
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
