import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:islamic_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:islamic_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String errorMessage) onVerificationFailed,
    required Function(PhoneAuthCredential credential) onVerificationCompleted,
    int? resendToken,
  }) async {
    try {
      await remoteDataSource.sendOtp(
        phoneNumber: phoneNumber,
        resendToken: resendToken,
        onCodeSent: onCodeSent,
        onVerificationCompleted: onVerificationCompleted,
        onVerificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(_getFriendlyErrorMessage(e));
        },
      );
    } on FirebaseAuthException catch (e) {
      onVerificationFailed(_getFriendlyErrorMessage(e));
    } catch (e) {
      onVerificationFailed("حدث خطأ غير متوقع، يرجى المحاولة لاحقاً");
    }
  }

  @override
  Future<Either<String, UserCredential>> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final result = await remoteDataSource.verifyOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(_getFriendlyErrorMessage(e));
    } catch (e) {
      return const Left("فشل التحقق من الكود، يرجى المحاولة لاحقاً");
    }
  }

  @override
  bool isLoggedIn() {
    return remoteDataSource.isLoggedIn();
  }

  @override
  User? getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  String _getFriendlyErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'رقم الهاتف غير صالح، يرجى التأكد من الرقم وكود الدولة';
      case 'too-many-requests':
        return 'تم إرسال طلبات كثيرة جداً، يرجى الانتظار قليلاً والمحاولة لاحقاً';
      case 'invalid-verification-code':
        return 'رمز التحقق غير صحيح، يرجى التأكد من الرمز المدخل';
      case 'session-expired':
        return 'انتهت صلاحية رمز التحقق، يرجى طلب كود جديد';
      case 'quota-exceeded':
        return 'تم تجاوز الحد المسموح لإرسال الرسائل لليوم';
      case 'network-request-failed':
        return 'تعذر الاتصال، يرجى التأكد من اتصالك بالإنترنت';
      case 'app-not-authorized':
        return 'التطبيق غير مصرح له باستخدام هذه الخدمة، تأكد من إعدادات Firebase والـ SHA-1';
      default:
        return e.message ?? 'حدث خطأ في عملية التحقق، يرجى المحاولة لاحقاً';
    }
  }
}
