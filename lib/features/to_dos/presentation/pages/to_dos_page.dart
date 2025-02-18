import 'package:to_do_app_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:to_do_app_flutter/core/common/cubits/theme/theme_cubit.dart';
import 'package:to_do_app_flutter/core/common/widgets/loader.dart';
import 'package:to_do_app_flutter/core/constants.dart';
import 'package:to_do_app_flutter/core/theme/app_pallete.dart';
import 'package:to_do_app_flutter/core/utils.dart';
import 'package:to_do_app_flutter/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:to_do_app_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:to_do_app_flutter/features/auth/presentation/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/bloc/bloc/todo_bloc.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/pages/create_todo_page.dart';
import 'package:to_do_app_flutter/features/to_dos/presentation/widgets/todo_card.dart';

class ToDosPage extends StatefulWidget {
  /// route function to navigate to this page,
  static route() => MaterialPageRoute(builder: (context) => const ToDosPage());
  const ToDosPage({super.key});

  @override
  State<ToDosPage> createState() => _ToDosPageState();
}

class _ToDosPageState extends State<ToDosPage> {
  @override
  void initState() {
    super.initState();
    final posterId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<TodoBloc>().add(TodoReadEvent(posterId: posterId));

    print('////// THEMEEE -${context.read<ThemeCubit>().readTheme()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('To-Do\'s'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Utils.singleBtnPopAlertDialogBox(
            context: context,
            title: 'Confirm Log Out?',
            desc: '',
            onTap1: () {
              context.read<AuthBloc>().add(AuthSignOut());
              Utils.showSnackBar(context, 'Logged out Successfully');

              Navigator.pushAndRemoveUntil(
                context,
                SignInPage.route(),
                (route) => false,
              );
            },
          ),
          icon: const Icon(Icons.logout_rounded, color: AppPallete.gradient2),
        ),
        actions: [
          BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: SizedBox(
                  width: 42.0,
                  height: 32.0,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      value: context.read<ThemeCubit>().readTheme(),
                      onChanged: (value) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoFailure) {
            Utils.showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Loader();
          } else if (state is AuthSignOutSuccess) {
            Utils.showSnackBar(context, 'Logged out Successfully');
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   SignInPage.route(),
            //   (route) => false,
            // );
          }

          if (state is TodoReadSuccess) {
            return RefreshIndicator(
              color: AppPallete.blue,
              onRefresh: () async {
                final posterId =
                    (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        .user
                        .id;
                context.read<TodoBloc>().add(TodoReadEvent(posterId: posterId));
              },
              child: Column(
                children: [
                  Text(
                    'To Do\'s',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader = textGradient,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.todos.length,
                      itemBuilder: (context, index) {
                        // final loggedInUserId =
                        //     (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        //         .user
                        //         .id;
                        final todos = state.todos[index];

                        // print('//// USER ID $loggedInUserId');
                        return TodoCard(
                          // userId: loggedInUserId,
                          todo: todos,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppPallete.gradient1,
                AppPallete.gradient2,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.add, color: AppPallete.whiteColor),
        ),
        onPressed: () => Navigator.push(
          context,
          CreateTodoPage.route(),
        ),
      ),
    );
  }
}
