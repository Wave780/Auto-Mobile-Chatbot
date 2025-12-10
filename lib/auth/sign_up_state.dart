import 'package:firebase_auth/firebase_auth.dart';

class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final User user;
  SignUpSuccess(this.user);
}

class SignUpError extends SignUpState {
  final String message;
  SignUpError(this.message);
}
