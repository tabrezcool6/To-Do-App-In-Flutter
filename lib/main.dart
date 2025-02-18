import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:to_do_app_flutter/core/common/cubits/theme/theme_cubit.dart';
import 'package:to_do_app_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_do_app_flutter/features/auth/presentation/pages/signin_page.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/bloc/bloc/todo_bloc.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/pages/to_dos_page.dart';
import 'package:to_do_app_flutter/init_dependencies.dart';

void main() async {
  // default method to call bindings and future methods
  WidgetsFlutterBinding.ensureInitialized();

  // initialize dependencies
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<ThemeCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<TodoBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, state) {
        final isDark = context.read<ThemeCubit>().readTheme();
        return MaterialApp(
          title:
              "Todo's Application using SOLID Principles and Clean Archietecture",
          theme: isDark ? ThemeData.dark() : ThemeData.light(),
          home: BlocSelector<AppUserCubit, AppUserState, bool>(
            selector: (state) {
              return state is AppUserLoggedIn;
            },
            builder: (context, isLoggedIn) {
              print("/// LOGGED IN STATUS: $isLoggedIn");
              if (isLoggedIn) {
                return const ToDosPage();
              }

              return const SignInPage();
            },
          ),
        );
      },
    );
  }
}
