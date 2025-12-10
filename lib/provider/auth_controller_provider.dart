import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth/auth_repository.dart';

final authControllerProvider = Provider<AuthRepository>((ref) {
  final auth = FirebaseAuth.instance;

  //it will be change
  const iosClientId =
      '920249960003-o44fdta7738dlpk0la40j9sc9udjjeok.apps.googleusercontent.com';

  final google = (kIsWeb)
      ? GoogleSignIn(scopes: const ['email', 'profile'])
      : (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)
          ? GoogleSignIn(
              scopes: const ['email', 'profile'],
              clientId: iosClientId,
            )
          : GoogleSignIn(scopes: const ['email', 'profile']);
  return AuthRepository(auth, google);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Expose the raw AsyncValue so UI can show a loader instead of "not logged in".
final currentUserAsyncProvider = Provider<AsyncValue<User?>>((ref) {
  return ref.watch(authStateProvider);
});

/// Simple helpers
final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoading;
});

final isLoggedInProvider = Provider<bool>((ref) {
  final asyncUser = ref.watch(authStateProvider);
  return asyncUser.hasValue && asyncUser.value != null;
});

/// Track text input (example: email, name fields)
final textProvider = StateProvider<String>((ref) => "");

/// Track password visibility
final passwordVisibleProvider = StateProvider<bool>((ref) => false);
