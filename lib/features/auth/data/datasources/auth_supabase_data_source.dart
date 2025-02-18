import 'dart:io';

import 'package:to_do_app_flutter/core/error/exceptions.dart';
import 'package:to_do_app_flutter/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TODO : STEP 3 - Data layer

// creating a interface for the datasource
// so that when ever we shift to other database, only this funtion must bear the changes and not other
// this interface returns a STRING
abstract interface class AuthSupabaseDataSource {
  //
  Session? get getCurrentUserSession;

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> signOut();

  Future<void> resetPassword({required String email});

  Future<void> updatePassword({required String password});
}

// TODO : STEP 4
// creating a general implements class which implements above "DATA SOURCE" class
// So that that it must contain the above two methods
class AuthSupabaseDataSourceImplementation implements AuthSupabaseDataSource {
  // asking "SUPABASECLIENT" from a constructor
  // We are not initializing supabase client here beacause by doing so, it creates a dependancy between impl class and supabase which we don't want
  // so that if we change database in future, we just get that database client from a cunstructor but not initializing the whole stuff again
  final SupabaseClient supabaseClient;
  AuthSupabaseDataSourceImplementation(this.supabaseClient);

  //
  @override
  Session? get getCurrentUserSession => supabaseClient.auth.currentSession;

  // User sign in method using supabase server api call
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // if the user is null, returning this exception
      if (response.user == null) {
        throw ServerExceptions('User is null');
      }
      // returning user model with data
      return UserModel.fromJson(response.user!.toJson());
    }
    // handeling various exceptions
    on AuthException catch (e) {
      throw ServerExceptions(e.message);
    } on ServerExceptions catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  // User signUp method using supabase server api call
  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // supabase signup call
      // passing all the parameters to the server
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {"name": name},
      );

      // if server response is null, throw exception
      if (response.user == null) {
        throw ServerExceptions('User is null');
      }

      // return USER ID on success server connection
      return UserModel.fromJson(response.user!.toJson());
    }
    // handeling various exceptions
    on AuthException catch (e) {
      print("/// Auth Exception: $e");
      throw ServerExceptions(e.message);
    } catch (e) {
      print("/// Catch Exception: $e");

      throw ServerExceptions(e.toString());
    }
  }

  // fetching User data from Supabase server API call
  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (getCurrentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', getCurrentUserSession!.user.id);

        return UserModel.fromJson(userData.first);
      }

      return null;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

// sign out function using supabase server api call
  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  // Reset Password function using supabase server api call
  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    print("//// print email:$email");
    try {
      await supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: 'com.app.todo://reset_password',
      );
    }
    // handeling various exceptions
    on AuthException catch (e) {
      throw ServerExceptions(e.message);
    } on ServerExceptions catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  // Update Password function using supabase server api call
  @override
  Future<void> updatePassword({
    required String password,
  }) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(password: password),
      );
    }
    // handeling various exceptions
    on AuthException catch (e) {
      throw ServerExceptions(e.message);
    } on ServerExceptions catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  ///
}
