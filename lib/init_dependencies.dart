import 'package:to_do_app_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:to_do_app_flutter/core/common/cubits/theme/theme_cubit.dart';
import 'package:to_do_app_flutter/core/common/services/connection_checker.dart';
import 'package:to_do_app_flutter/core/keys/app_keys.dart';
import 'package:to_do_app_flutter/features/auth/data/datasources/auth_supabase_data_source.dart';
import 'package:to_do_app_flutter/features/auth/data/repository/auth_repository_impl.dart';
import 'package:to_do_app_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_reset_password.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_sign_in_usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_sign_out_usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/user_update_password.dart';
import 'package:to_do_app_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_app_flutter/features/to_dos/data/datasource/todo_local_data_source.dart';
import 'package:to_do_app_flutter/features/to_dos/data/datasource/todo_supabase_data_source.dart';
import 'package:to_do_app_flutter/features/to_dos/data/repository/todo_repository_impl.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/repositories/todo_repository.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/usecases/create_todo_usecase.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/usecases/delete_todo_usecase.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/usecases/read_todo_usecase.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/usecases/update_todo_usecase.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/bloc/bloc/todo_bloc.dart';

// initialize Service Locator globally
// This is the variable where we register all our dependicies to getIt

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // initiailize Auth Dependencies
  _initAuth();

  // initiailize Todo Dependencies
  _initTodo();

  // initializing the SUPABASE Database and also Server
  // to do so we require a "Project URL" and a "Anon Key" which is provided by the project created in the supabase
  final subapase = await Supabase.initialize(
    url: Keys.supabaseProjectUrl,
    anonKey: Keys.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => subapase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'todos'));

  // serviceLocator.registerLazySingleton(() => Hive.box(name: 'themeData'));

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // core
  serviceLocator.registerLazySingleton(() => ThemeCubit(box: serviceLocator()));

  ///
  // serviceLocator.registerLazySingleton(() => ThemeBloc());

  // internet connection checker
  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImplementation(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  ///
  // registering "AuthSupabaseDataSourceImplementation" Dependency
  serviceLocator
    ..registerFactory<AuthSupabaseDataSource>(
      () => AuthSupabaseDataSourceImplementation(
        serviceLocator(),
      ),
    )

    // registering "AuthRepositoryImplementation" Dependency
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImplementation(
        serviceLocator(),
        serviceLocator(),
      ),
    )

    // registering "UserSignUp" UseCase Dependency
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )

    // registering "UserSignIn" UseCase Dependency
    ..registerFactory(
      () => UserSignIn(
        serviceLocator(),
      ),
    )

    // registering "UserSignOut UseCase Dependency
    ..registerFactory(
      () => UserSignOut(
        serviceLocator(),
      ),
    )

    // registering "CurrentUser" UseCase Dependency
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )

    // registering "UserResetPassword" UseCase Dependency
    ..registerFactory(
      () => UserResetPassword(
        serviceLocator(),
      ),
    )

    // registering "UserResetPassword" UseCase Dependency
    ..registerFactory(
      () => UserUpdatePassword(
        serviceLocator(),
      ),
    )

    // registering "AuthBloc" Dependency
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        userSignOut: serviceLocator(),
        currentUser: serviceLocator(),
        userResetPassword: serviceLocator(),
        userUpdatePassword: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initTodo() {
  serviceLocator
    // registering "TodoSupabaseDataSourceImplementation" Dependency
    ..registerFactory<TodoSupabaseDataSource>(
      () => TodoSupabaseDataSourceImplementation(
        serviceLocator(),
      ),
    )

    // registering "TodoLocalDataSourceImplementation" Dependency
    ..registerFactory<TodoLocalDataSource>(
      () => TodoLocalDataSourceImplementation(
        serviceLocator(),
      ),
    )

    // registering "TodoRepositoryImplementation" Dependency
    ..registerFactory<TodoRepository>(
      () => TodoRepositoryImplementation(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )

    // registering "UploadTodo" Dependency
    ..registerFactory(
      () => CreateTodoUsecase(
        serviceLocator(),
      ),
    )

    // registering "FetchTodo" Dependency
    ..registerFactory(
      () => ReadTodoUsecase(
        serviceLocator(),
      ),
    )

    // registering "UploadTodo" Dependency
    ..registerFactory(
      () => UpdateTodoUsecase(
        serviceLocator(),
      ),
    )

    // registering "Delete Todo" Dependency
    ..registerFactory(
      () => DeleteTodoUsecase(
        serviceLocator(),
      ),
    )

    // registering "TodoBloc" Dependency
    ..registerLazySingleton(
      () => TodoBloc(
        createTodoUsecase: serviceLocator(),
        readTodoUsecase: serviceLocator(),
        updateTodoUsecase: serviceLocator(),
        deleteTodoUsecase: serviceLocator(),
      ),
    );
}
