import 'package:to_do_app_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:to_do_app_flutter/core/common/entities/user.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_reset_password.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_sign_in_usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_sign_out_usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_update_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// TODO : STEP 10 - Create Auth Bloc for the feature
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final UserSignOut _userSignOut;
  final CurrentUser _currentUser;
  final UserResetPassword _userResetPassword;
  final UserUpdatePassword _userUpdatePassword;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required UserSignOut userSignOut,
    required CurrentUser currentUser,
    required UserResetPassword userResetPassword,
    required UserUpdatePassword userUpdatePassword,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _userSignOut = userSignOut,
        _currentUser = currentUser,
        _userResetPassword = userResetPassword,
        _userUpdatePassword = userUpdatePassword,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    // Default Loader State for all events
    on<AuthEvent>((_, emit) => emit(AuthLoading()));

    // Sign Up Bloc Implementation
    on<AuthSignUp>(_onAuthSignUp);

    // Sign In Bloc Implementation
    on<AuthSignIn>(_onAuthSignIn);

    // Sign Out Bloc Implementation
    on<AuthSignOut>(_onAuthSignOut);

    // Reset Password Bloc Implementation
    on<AuthForgotPassword>(_onAuthForgotPassword);

    // Update Password Bloc Implementation
    on<AuthUpdatePassword>(_onAuthUpdatePassword);

    // Current User Bloc Implementation
    on<AuthIsUserLoggedIn>(_onAuthIsUserLoggedIn);
  }

  //
  // Custom Bloc Functions
  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit), // AuthSuccess(user),
    );
  }

  //
  void _onAuthSignIn(
    AuthSignIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userSignIn(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit), // AuthSuccess(user),
    );
  }

  void _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userSignOut(NoParams());

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (r) => emit(AuthSignOutSuccess()),
    );
  }

  //
  void _onAuthIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _currentUser(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthForgotPassword(
      AuthForgotPassword event, Emitter<AuthState> emit) async {
    final response = await _userResetPassword(
      ResetPasswordParams(
        email: event.email,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (r) => emit(AuthForgotPasswordSuccess(r)),
    );
  }

  void _onAuthUpdatePassword(
      AuthUpdatePassword event, Emitter<AuthState> emit) async {
    final response = await _userUpdatePassword(
      UserUpdatePasswordParams(
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (r) => emit(
        AuthUpdatePasswordSuccess(),
      ),
    );
  }

  //
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
