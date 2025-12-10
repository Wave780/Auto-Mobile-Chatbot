import 'package:auto_mobile_chatbot/provider/auth_controller_provider.dart';
import 'package:auto_mobile_chatbot/provider/theme_provider.dart';
import 'package:auto_mobile_chatbot/screen/home_screen.dart';
import 'package:auto_mobile_chatbot/screen/login_screen.dart';
import 'package:auto_mobile_chatbot/service/preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

import 'firebase_options.dart';
import 'model/chat_message.dart';
import 'model/chat_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PreferenceService.init();
  await Hive.initFlutter();

  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(ChatSessionAdapter());

  await Hive.openBox<ChatMessage>('messages');
  await Hive.openBox<ChatSession>('sessions');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    final appTheme = ref.watch(themeProvider);
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Auto Mobile Chatbot',
      debugShowCheckedModeBanner: false,
      theme: appTheme.toThemeData(),
      home: authState.when(
        data: (user) => user != null ? const HomeScreen() : LoginScreen(),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}
