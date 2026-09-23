import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
    int? resendToken,
  });

  Future<Either<String, UserCredential>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  bool isLoggedIn();
  User? getCurrentUser();
  Future<void> signOut();
}
