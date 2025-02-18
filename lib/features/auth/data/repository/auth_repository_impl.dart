import 'dart:math';

import 'package:to_do_app_flutter/core/constants.dart';
import 'package:to_do_app_flutter/core/error/exceptions.dart';
import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/features/auth/data/datasources/auth_supabase_data_source.dart';
import 'package:to_do_app_flutter/core/common/entities/user.dart';
import 'package:to_do_app_flutter/features/auth/data/models/user_model.dart';
import 'package:to_do_app_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// TODO : STEP 6 - Implementation of Auth Repository of Domain Layer in Data Layer
//
class AuthRepositoryImplementation implements AuthRepository {
  // asking "AuthSupabaseDataSource" from a constructor
  // We are not initializing "AuthSupabaseDataSource" here beacause by doing so, it creates a dependancy between impl class and "AuthSupabaseDataSource" which we don't want
  // so that if we change "AuthSupabaseDataSource" in future, we just get that "DataSource" from a cunstructor but not initializing the whole stuff again
  // This is here what called as "Depemdemcy Injection",
  final AuthSupabaseDataSource authSupabaseDataSource;
  final InternetConnection internetConnection;

  AuthRepositoryImplementation(
    this.authSupabaseDataSource,
    this.internetConnection,
  );

  // "AuthRepositoryImplementation" sign in class which is implemented from the "AuthRepository" class
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    return _getUserCommonFunc(
      () async => await authSupabaseDataSource.login(
        email: email,
        password: password,
      ),
    );
  }

  // "AuthRepositoryImplementation" sign up class which is implemented from the "AuthRepository" class
  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUserCommonFunc(
      () async => await authSupabaseDataSource.signUp(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

// Common Funnction For Sign In And Login,
// Since only difference between them is the accepting parameters,
// keeping the params rest function is merged into one
  Future<Either<Failure, User>> _getUserCommonFunc(
    Future<User> Function() function,
  ) async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        return left(Failure(Constants.noInternetConnectionMessage));
      }
      // passing parameters to the signup class
      final user = await function();
      // fp_dart standard procedure or syntax
      // if result is success, use success param within right
      return right(user);
    } on ServerExceptions catch (e) {
      // if result is failure, use failure param within left
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        final userSession = authSupabaseDataSource.getCurrentUserSession;
        if (userSession == null) {
          return left(Failure('User is not logged in'));
        }
        return right(
          UserModel(
            id: userSession.user.id,
            name: '',
            email: userSession.user.email ?? '',
          ),
        );
      }

      final user = await authSupabaseDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User is not logged in'));
      }

      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> signOut() async {
    try {
      await authSupabaseDataSource.signOut();
      return right('logout');
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
  }) async {
    // TODO: implement resetPassword
    try {
      await authSupabaseDataSource.resetPassword(email: email);
      return right('reset password');
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> updatePassword(
      {required String password}) async {
    // TODO: implement updatePassword
    try {
      await authSupabaseDataSource.updatePassword(password: password);
      return right('update password');
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  ///
}

/// Advanced Functiom for code optimization to be implemnted in future
/*

// Login Expanded Method
    try {
      final user = await authSupabaseDataSource.login(
        email: email,
        password: password,
      );
      return right(user);

      // Auth Expcetion error handling
    } on supabase.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExceptions catch (e) {
      return left(Failure(e.toString()));
    }


    
    // SignUp Expanded MEthod
    try {
      // passing parameters to the signup class
      final user = await authSupabaseDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      // fp_dart standard procedure or syntax
      // if result is success, use success param within right
      return right(user);

      // Auth Expcetion error handling
    } on supabase.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExceptions catch (e) {
      // if result is failure, use failure param within left
      return left(Failure(e.message));
    }
    
    
  Future<Either<Failure, User>> _authRepoImplCommon(
      Future<User> Function() function) async {
    try {
      // passing parameters to the signup class
      final user = await function();
      // fp_dart standard procedure or syntax
      // if result is success, use success param within right
      return right(user);
    } on ServerExceptions catch (e) {
      // if result is failure, use failure param within left
      return left(Failure(e.message));
    }
  }
   */
