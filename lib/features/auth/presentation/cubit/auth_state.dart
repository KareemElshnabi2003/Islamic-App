import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSendingOtpLoading extends AuthState {}

class AuthOtpSentSuccess extends AuthState {
  final String verificationId;
  final String phoneNumber;
  final int? resendToken;

  const AuthOtpSentSuccess({
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  });

  @override
  List<Object?> get props => [verificationId, phoneNumber, resendToken];
}

class AuthVerifyingOtpLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthAutoVerified extends AuthState {
  final PhoneAuthCredential credential;

  const AuthAutoVerified({required this.credential});

  @override
  List<Object?> get props => [credential];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSignedOut extends AuthState {}
