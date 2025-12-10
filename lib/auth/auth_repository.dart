import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  AuthRepository(this._auth, this.googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn googleSignIn;

  Stream<User?> get authStateChange => _auth.idTokenChanges();

  User? get currentUser => _auth.currentUser;

  factory AuthRepository.create() {
    return AuthRepository(
      FirebaseAuth.instance,
      GoogleSignIn(
        scopes: <String>['email', 'profile'],
        //to be change
        clientId:
            "728781880491-c3bvuslhms831jejgdrm8lc1e8d3dust.apps.googleusercontent.com",
      ),
    );
  }
  //SignIn with email
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'User NOT FOUND') {
        throw AuthException('User NOT FOUND');
      } else if (e.code == 'wrong Password') {
        throw AuthException('wrong Password');
      } else {
        throw AuthException('An error occured. please try again later ');
      }
    }
  }

  // //Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
  }

  //SignUp
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  //Google
  Future<bool?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web uses FirebaseAuth directly
        final googleProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleProvider);
        return true;
      } else {
        //  Mobile uses google_sign_in
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();

        if (googleSignInAccount == null) {
          return false; // user cancelled
        }
        // get auth tokens
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Create firebase credential
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in to firebase using google credential
        await _auth.signInWithCredential(authCredential);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      debugPrint("FirebaseAuthException: ${e.message}");
      return null;
    } catch (e) {
      debugPrint("General sign-in error: $e");
      return null;
    }
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException error) =>
            throw Exception(error.message),
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (_) {});
  }

  Future<void> signInWithEmail(String email) async {
    await _auth.signInWithEmailAndPassword(email: email, password: 'password');
  }
}

//Error handler
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}
