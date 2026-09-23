import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:islamic_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:islamic_app/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  int? _resendToken;
  String? _lastPhoneNumber;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  int? get resendToken => _resendToken;
  String? get lastPhoneNumber => _lastPhoneNumber;

  Future<void> sendOtp({required String phoneNumber, bool isResend = false}) async {
    _lastPhoneNumber = phoneNumber;
    emit(AuthSendingOtpLoading());

    await authRepository.sendOtp(
      phoneNumber: phoneNumber,
      resendToken: isResend ? _resendToken : null,
      onCodeSent: (String verificationId, int? resendToken) {
        _resendToken = resendToken;
        emit(AuthOtpSentSuccess(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
          resendToken: resendToken,
        ));
      },
      onVerificationFailed: (String errorMessage) {
        emit(AuthError(message: errorMessage));
      },
      onVerificationCompleted: (PhoneAuthCredential credential) async {
        // Auto verification on some Android devices
        try {
          final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          if (userCredential.user != null) {
            emit(AuthSuccess(user: userCredential.user!));
          }
        } catch (e) {
          emit(AuthAutoVerified(credential: credential));
        }
      },
    );
  }

  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    emit(AuthVerifyingOtpLoading());

    final result = await authRepository.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    result.fold(
      (error) => emit(AuthError(message: error)),
      (userCredential) {
        if (userCredential.user != null) {
          emit(AuthSuccess(user: userCredential.user!));
        } else {
          emit(const AuthError(message: "فشل التحقق من المستخدم"));
        }
      },
    );
  }

  bool isLoggedIn() {
    return authRepository.isLoggedIn();
  }

  User? getCurrentUser() {
    return authRepository.getCurrentUser();
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    emit(AuthSignedOut());
  }

  void resetState() {
    emit(AuthInitial());
  }
}
