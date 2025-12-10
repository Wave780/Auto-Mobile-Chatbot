import 'package:auto_mobile_chatbot/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_controller_provider.dart';

class AuthChecker extends ConsumerWidget {
  final Widget Function(BuildContext) authenticatedBuilder;
  final Widget Function(BuildContext) unauthenticatedBuilder;

  const AuthChecker({
    Key? key,
    required this.authenticatedBuilder,
    required this.unauthenticatedBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return unauthenticatedBuilder(context);
        } else {
          return authenticatedBuilder(context);
        }
      },
      error: (e, trace) => LoginScreen(),
      loading: () => LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
