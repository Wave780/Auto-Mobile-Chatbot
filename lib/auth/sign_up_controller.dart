import 'package:auto_mobile_chatbot/auth/sign_up_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

class SignUpController extends StateNotifier<SignUpState> {
  final AuthRepository _authRepository;

  SignUpController(this._authRepository) : super(SignUpState());

  Future<void> signUp(
    String email,
  ) async {
    state = SignUpLoading();
    try {
      final user = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: 'Password',
      );
      state = SignUpSuccess(user!);
    } on FirebaseAuthException catch (e) {
      state = SignUpError(e.toString());
    }
  }

  Future<void> signUpWithGoogle() async {
    state = SignUpLoading();
    try {
      final result = await _authRepository.signInWithGoogle();
      if (result == true) {
        state = SignUpSuccess(_authRepository.currentUser!);
      } else if (result == false) {
        state = SignUpError('User cancelled the sign in');
      } else {
        state = SignUpError('An error occurred');
      }
    } catch (e) {
      state = SignUpError(e.toString());
    }
  }

  Future<void> signUpWithPhoneNumber(String phoneNumber) async {
    state = SignUpLoading();
    try {
      await _authRepository.signInWithPhone(phoneNumber);
      // The UI should handle the verification code input and then complete the sign-in.
    } catch (e) {
      state = SignUpError(e.toString());
    }
  }
}
