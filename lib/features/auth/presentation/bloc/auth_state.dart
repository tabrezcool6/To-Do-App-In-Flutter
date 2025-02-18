part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

final class AuthForgotPasswordSuccess extends AuthState {
  final String message;
  AuthForgotPasswordSuccess(this.message);
}

final class AuthUpdatePasswordSuccess extends AuthState {
  // final String message;
  AuthUpdatePasswordSuccess(); //this.message
}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

final class AuthSignOutSuccess extends AuthState {}
